//
//  YMMessageTool.m
//  WeChatExtension
//
//  Created by MustangYM on 2019/1/22.
//  Copyright © 2019 MustangYM. All rights reserved.
//

#import "YMMessageTool.h"
#import <objc/runtime.h>

@implementation YMMessageTool
+ (MessageData *)getMessageData:(AddMsg *)addMsg {
    if (!addMsg) {
        return nil;
    }
    MessageService *msgService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MessageService")];
    return [msgService GetMsgData:addMsg.fromUserName.string svrId:addMsg.newMsgId];
}

+ (WCContactData *)getContactData:(AddMsg *)addMsg {
    if (!addMsg) {
        return nil;
    }
    MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
    
    if (LargerOrEqualVersion(@"2.3.26")) {
        return [sessionMgr getSessionContact:addMsg.fromUserName.string];
    }

    return [sessionMgr getContact:addMsg.fromUserName.string];
}
@end
