//
//  YMMessageHelper.h
//  WeChatExtension
//
//  Created by MustangYM on 2019/1/22.
//  Copyright © 2019 MustangYM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeChatPlugin.h"

@interface YMMessageHelper : NSObject
+ (MessageData *)getMessageData:(AddMsg *)addMsg;
+ (WCContactData *)getContactData:(AddMsg *)addMsg;
+ (void)parseMiniProgramMsg:(AddMsg *)addMsg;
+ (void)addLocalWarningMsg:(NSString *)msg fromUsr:(NSString *)fromUsr;
@end

