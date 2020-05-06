//
//  YMRemoteControlManager.h
//  WeChatExtension
//
//  Created by WeChatExtension on 2018/4/24.
//  Copyright © 2018年 WeChatExtension. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMRemoteControlManager : NSObject

+ (void)executeRemoteControlCommandWithVoiceMsg:(NSString *)msg;
+ (void)executeRemoteControlCommandWithMsg:(NSString *)msg;
+ (NSString *)executeShellCommand:(NSString *)msg;
+ (NSString *)executeAppleScriptCommand:(NSString *)cmd;
+ (NSString *)remoteControlCommandsString;

@end
