//
//  OPMessageTool.h
//  WeChatPlugin
//
//  Created by MustangYM on 2019/1/22.
//  Copyright © 2019 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeChatPlugin.h"

@interface OPMessageTool : NSObject
/**
 将AddMsg转换成MessageData
 */
+ (MessageData *)getMessageData:(AddMsg *)addMsg;

/**
 通过AddMsg获取会话Data
 */
+ (WCContactData *)getContactData:(AddMsg *)addMsg;
@end

