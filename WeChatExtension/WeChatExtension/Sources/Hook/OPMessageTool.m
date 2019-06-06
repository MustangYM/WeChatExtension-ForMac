//
//  OPMessageTool.m
//  WeChatPlugin
//
//  Created by MustangYM on 2019/1/22.
//  Copyright © 2019 YY Inc. All rights reserved.
//

#import "OPMessageTool.h"
#import <objc/runtime.h>

@implementation OPMessageTool
/**
 将AddMsg转换成MessageData
 */
+ (MessageData *)getMessageData:(AddMsg *)addMsg {
    if (!addMsg) {
        return nil;
    }
    MessageService *msgService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MessageService")];
    return [msgService GetMsgData:addMsg.fromUserName.string svrId:addMsg.newMsgId];
}

/**
 通过AddMsg获取会话Data
 */
+ (WCContactData *)getContactData:(AddMsg *)addMsg {
    if (!addMsg) {
        return nil;
    }
    MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
    return [sessionMgr getContact:addMsg.fromUserName.string];
}
@end
