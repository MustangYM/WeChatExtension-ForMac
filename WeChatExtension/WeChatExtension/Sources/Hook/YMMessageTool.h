//
//  YMMessageTool.h
//  WeChatExtension
//
//  Created by MustangYM on 2019/1/22.
//  Copyright © 2019 MustangYM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeChatPlugin.h"

@interface YMMessageTool : NSObject
/**
 将AddMsg转换成MessageData
 */
+ (MessageData *)getMessageData:(AddMsg *)addMsg;

/**
 通过AddMsg获取会话Data
 */
+ (WCContactData *)getContactData:(AddMsg *)addMsg;

+ (void)parseMiniProgramMsg:(AddMsg *)addMsg;
+ (void)addLocalWarningMsg:(NSString *)msg fromUsr:(NSString *)fromUsr;
@end

