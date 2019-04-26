//
//  TKRemoteControlManager.h
//  WeChatPlugin
//
//  Created by TK on 2018/4/24.
//  Copyright © 2018年 tk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKRemoteControlManager : NSObject

+ (void)executeRemoteControlCommandWithVoiceMsg:(NSString *)msg;
+ (void)executeRemoteControlCommandWithMsg:(NSString *)msg;
+ (NSString *)executeShellCommand:(NSString *)msg;
+ (NSString *)executeAppleScriptCommand:(NSString *)cmd;
+ (NSString *)remoteControlCommandsString;

@end
