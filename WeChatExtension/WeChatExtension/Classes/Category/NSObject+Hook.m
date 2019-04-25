//
//  NSObject+Hook.m
//  WeChatExtension
//
//  Created by MustangYM on 2019/4/25.
//  Copyright © 2019 MustangYM. All rights reserved.
//

#import "NSObject+Hook.h"

@implementation NSObject (Hook)
+ (void)loadHook {
    SEL revokeMsgMethod = LargerOrEqualVersion(@"2.3.22") ? @selector(FFToNameFavChatZZ:) : @selector(onRevokeMsg:);
    YM_hookMethod(objc_getClass("MessageService"), revokeMsgMethod, [self class], @selector(hook_onRevokeMsg:));
}

- (void)hook_onRevokeMsg:(id)msgData {
//    if (![[TKWeChatPluginConfig sharedConfig] preventRevokeEnable]) {
//        [self hook_onRevokeMsg:msgData];
//        return;
//    }
    id msg = msgData;
    if ([msgData isKindOfClass:objc_getClass("MessageData")]) {
        msg = [msgData valueForKey:@"msgContent"];
    }
    if ([msg rangeOfString:@"<sysmsg"].length <= 0) return;
    
    //      转换群聊的 msg
    NSString *msgContent = [msg substringFromIndex:[msg rangeOfString:@"<sysmsg"].location];
    
    //      xml 转 dict
    XMLDictionaryParser *xmlParser = [objc_getClass("XMLDictionaryParser") sharedInstance];
    NSDictionary *msgDict = [xmlParser dictionaryWithString:msgContent];
    
    if (msgDict && msgDict[@"revokemsg"]) {
        NSString *newmsgid = msgDict[@"revokemsg"][@"newmsgid"];
        NSString *session =  msgDict[@"revokemsg"][@"session"];
        msgDict = nil;
        
        NSMutableSet *revokeMsgSet = [[YMConfig shareInstance] revokeMsgSet];
        //      该消息已进行过防撤回处理
        if ([revokeMsgSet containsObject:newmsgid] || !newmsgid) {
            return;
        }
        [revokeMsgSet addObject:newmsgid];
        
        //      获取原始的撤回提示消息
        MessageService *msgService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MessageService")];
        MessageData *revokeMsgData = [msgService GetMsgData:session svrId:[newmsgid integerValue]];
        if ([revokeMsgData isSendFromSelf] ) {
            [self hook_onRevokeMsg:msgData];
            return;
        }
        NSString *msgContent = [[YMMessageManager shareInstance] getMessageContentWithData:revokeMsgData];
        NSString *newMsgContent = [NSString stringWithFormat:@"拦截到一条撤回消息: \n%@", msgContent];
        MessageData *newMsgData = ({
            MessageData *msg = [[objc_getClass("MessageData") alloc] initWithMsgType:0x2710];
            [msg setFromUsrName:revokeMsgData.toUsrName];
            [msg setToUsrName:revokeMsgData.fromUsrName];
            [msg setMsgStatus:4];
            [msg setMsgContent:newMsgContent];
            [msg setMsgCreateTime:[revokeMsgData msgCreateTime]];
            
            msg;
        });
        
        [msgService AddLocalMsg:session msgData:newMsgData];
    }
}
@end
