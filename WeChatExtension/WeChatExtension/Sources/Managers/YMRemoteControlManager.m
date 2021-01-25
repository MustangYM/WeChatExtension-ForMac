//
//  YMRemoteControlManager.m
//  WeChatExtension
//
//  Created by WeChatExtension on 2018/4/24.
//  Copyright © 2018年 WeChatExtension. All rights reserved.
//

#import "YMRemoteControlManager.h"
#import "YMWeChatPluginConfig.h"
#import "TKRemoteControlModel.h"
#import "YMMessageManager.h"

typedef NS_ENUM(NSUInteger, MessageDataType) {
    MessageDataTypeText,
    MessageDataTypeVoice
};

//      执行 AppleScript
static NSString * const kRemoteControlAppleScript = @"osascript /Applications/WeChat.app/Contents/MacOS/WeChatExtension.framework/Resources/TKRemoteControlScript.scpt";

@implementation YMRemoteControlManager

+ (void)executeRemoteControlCommandWithVoiceMsg:(NSString *)msg
{
    NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
    NSString *callBack = [NSString stringWithFormat:@"%@\n\n\n%@", YMLocalizedString(@"assistant.remoteControl.voiceRecall"), msg];
    MessageService *service = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MessageService")];
    [service SendTextMessage:currentUserName toUsrName:currentUserName msgText:callBack atUserList:nil];
    
    [self executeRemoteControlCommandWithMsg:msg msgType:MessageDataTypeVoice];
}

+ (void)executeRemoteControlCommandWithMsg:(NSString *)msg
{
    [self executeRemoteControlCommandWithMsg:msg msgType:MessageDataTypeText];
}

+ (void)executeRemoteControlCommandWithMsg:(NSString *)msg msgType:(MessageDataType)type
{
    NSArray *remoteControlModels = [YMWeChatPluginConfig sharedConfig].remoteControlModels;
    [remoteControlModels enumerateObjectsUsingBlock:^(NSArray *subModels, NSUInteger index, BOOL * _Nonnull stop) {
        [subModels enumerateObjectsUsingBlock:^(TKRemoteControlModel *model, NSUInteger idx, BOOL * _Nonnull subStop) {
            if ([self shouldExecuteRemoteControlWithModel:model msg:msg msgType:type]) {
                switch (model.type) {
                    case TKRemoteControlTypeShell: {
                        //      屏幕保护 & 锁屏 通过 Shell 命令来执行即可
                        [self executeShellCommand:model.executeCommand];
                        break;
                    }
                    case TKRemoteControlTypeScript: {
                        NSString *errorMsg = [self executeAppleScriptCommand:model.executeCommand];
                        if ([errorMsg containsString:@"TKRemoteControlScript.scpt:"]) {
                            NSString *result = [errorMsg substringFromString:@"TKRemoteControlScript.scpt:"];
                            [[YMMessageManager shareManager] sendTextMessageToSelf:result];
                        }
                        //      bug: 有些程序在第一次时会无法关闭，需要再次关闭
                        if ([model.function isEqualToString:@"Assistant.Directive.KillAll"]) {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self executeAppleScriptCommand:model.executeCommand];
                            });
                        }
                        break;
                    }
                    case TKRemoteControlTypePlugin: {
                        [self executePluginCommand:model.executeCommand];
                        break;
                    }
                    default:
                        break;
                }
                
                if (model.type != TKRemoteControlTypePlugin) {
                    NSString *callBack = [NSString stringWithFormat:@"%@%@", YMLocalizedString(@"assistant.remoteControl.recall"), YMLocalizedString(model.function)];
                    [[YMMessageManager shareManager] sendTextMessageToSelf:callBack];
                    [[YMMessageManager shareManager] clearUnRead:[objc_getClass("CUtility") GetCurrentUserName]];
                }
                *stop = YES;
                *subStop = YES;
            }
        }];
    }];
}

+ (BOOL)shouldExecuteRemoteControlWithModel:(TKRemoteControlModel *)model msg:(NSString *)msg msgType:(MessageDataType)type
{
    if (model.enable && ![model.keyword isEqualToString:@""]) {
        if ((type == MessageDataTypeText && [msg isEqualToString:model.keyword]) || (type == MessageDataTypeVoice && ([msg containsString:model.keyword] || [msg containsString:YMLocalizedString(model.function)]))) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

+ (NSString *)executeAppleScriptCommand:(NSString *)cmd
{
    NSString *command = [NSString stringWithFormat:@"%@ %@",kRemoteControlAppleScript, cmd];
    return [self executeShellCommand:command];
}

/**
 通过 NSTask 执行 Shell 命令
 
 @param cmd Terminal命令
 */
+ (NSString *)executeShellCommand:(NSString *)cmd
{
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/bin/bash"];
    [task setArguments:@[@"-c", cmd]];
    // 新建输出管道作为Task的错误输出
    NSPipe *errorPipe = [NSPipe pipe];
    [task setStandardError:errorPipe];
    NSFileHandle *file = [errorPipe fileHandleForReading];
    // 获取运行结果
    [task launch];
    NSData *data = [file readDataToEndOfFile];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (void)executePluginCommand:(NSString *)cmd
{
    NSString *callBack = @"";
    YMWeChatPluginConfig *config = [YMWeChatPluginConfig sharedConfig];
    if ([cmd isEqualToString:@"getDirectiveList"]) {
        callBack = [YMRemoteControlManager remoteControlCommandsString];
    } else if ([cmd isEqualToString:@"AutoReplySwitch"]) {
        NSString *status = config.autoReplyEnable ? YMLocalizedString(@"Assistant.Directive.SwitchOff") : YMLocalizedString(@"Assistant.Directive.SwitchOn");
        callBack = [NSString stringWithFormat:@"%@-%@",YMLocalizedString(@"Assistant.Directive.AutoReplySwitch"),status];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_AUTO_REPLY_CHANGE object:nil];
    } else if ([cmd isEqualToString:@"PreventRevokeSwitch"]) {
        NSString *status = config.preventRevokeEnable ? YMLocalizedString(@"Assistant.Directive.SwitchOff") : YMLocalizedString(@"Assistant.Directive.SwitchOn");
        callBack = [NSString stringWithFormat:@"%@-%@",YMLocalizedString(@"Assistant.Directive.PreventRevokeSwitch"),status];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_PREVENT_REVOKE_CHANGE object:nil];
    } else if ([cmd isEqualToString:@"AutoAuthSwitch"]) {
        NSString *status = config.autoAuthEnable ? YMLocalizedString(@"Assistant.Directive.SwitchOff") : YMLocalizedString(@"Assistant.Directive.SwitchOn");
        callBack = [NSString stringWithFormat:@"%@-%@",YMLocalizedString(@"Assistant.Directive.AutoAuthSwitch"),status];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_AUTO_AUTH_CHANGE object:nil];
    // } else if ([cmd isEqualToString:@"AutoForwardingSwitch"]) {
    //     NSString *status = config.autoForwardingEnable ? YMLocalizedString(@"Assistant.Directive.SwitchOff") : YMLocalizedString(@"Assistant.Directive.SwitchOn");
    //     callBack = [NSString stringWithFormat:@"%@-%@",YMLocalizedString(@"Assistant.Directive.AutoForwardingSwitch"),status];
    //     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_AUTO_FORWARDING_CHANGE object:nil];
    }
    
    [[YMMessageManager shareManager] sendTextMessageToSelf:callBack];
}

+ (NSString *)remoteControlCommandsString
{
    NSMutableString *replyContent = [NSMutableString stringWithString:YMLocalizedString(@"assistant.remoteControl.listTip")];
    
    NSArray *remoteControlModels = [YMWeChatPluginConfig sharedConfig].remoteControlModels;
    [remoteControlModels enumerateObjectsUsingBlock:^(NSArray *subModels, NSUInteger index, BOOL * _Nonnull stop) {
        switch (index) {
            case 0:
                [replyContent appendFormat:@"%@\n",YMLocalizedString(@"assistant.remoteControl.mac")];
                break;
            case 1:
                [replyContent appendFormat:@"%@\n",YMLocalizedString(@"assistant.remoteControl.app")];
                break;
            case 2:
                [replyContent appendFormat:@"%@\n",YMLocalizedString(@"assistant.remoteControl.neteaseMusic")];
                break;
            case 3:
                [replyContent appendFormat:@"%@\n",YMLocalizedString(@"assistant.remoteControl.assistant")];
                break;
            default:
                break;
        }
        [subModels enumerateObjectsUsingBlock:^(TKRemoteControlModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            [replyContent appendFormat:@"%@-%@-%@\n", YMLocalizedString(model.function), model.keyword, model.enable ? YMLocalizedString(@"assistant.remoteControl.open") : YMLocalizedString(@"assistant.remoteControl.close")];
        }];
        [replyContent appendString:@"\n"];
    }];
    return replyContent;
}

@end
