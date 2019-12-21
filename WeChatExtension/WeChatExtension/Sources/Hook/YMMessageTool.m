//
//  YMMessageTool.m
//  WeChatExtension
//
//  Created by MustangYM on 2019/1/22.
//  Copyright © 2019 MustangYM. All rights reserved.
//

#import "YMMessageTool.h"
#import <objc/runtime.h>
#import "XMLReader.h"

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

+ (void)parseMiniProgramMsg:(AddMsg *)addMsg
{
    // 显示小程序信息
    if(addMsg.msgType == 49){
        
        //      xml 转 dict
        NSString *msgContentStr = nil;
        if ([addMsg.fromUserName.string containsString:@"@chatroom"]) {
            NSArray *msgAry = [addMsg.content.string componentsSeparatedByString:@":\n<?xml"];
            if (msgAry.count > 1) {
                msgContentStr = [NSString stringWithFormat:@"<?xml %@",msgAry[1]];
            }
        } else {
            msgContentStr = addMsg.content.string;
        }
        NSError *error;
        NSDictionary *xmlDict = [XMLReader dictionaryForXMLString:msgContentStr error:&error];
        NSDictionary *msgDict = [xmlDict valueForKey:@"msg"];
        NSDictionary *appMsgDict = [msgDict valueForKey:@"appmsg"];
        NSDictionary *weappInfoDict = [appMsgDict valueForKey:@"weappinfo"];
        NSDictionary *typeDict = [appMsgDict valueForKey:@"type"];
        NSString *type = [typeDict valueForKey:@"text"];
        
        NSString *session = addMsg.fromUserName.string;
        
        NSString *title = @"";
        NSString *url = @"";
        NSString *appid = @"";
        NSString *pagepath = @"";
        NSString *sourcedisplayname = @"";
        if (type.intValue == 33) {
            NSDictionary *titleDict = [appMsgDict valueForKey:@"title"];
            title = [titleDict valueForKey:@"text"];
            
            NSDictionary *urlDict = [appMsgDict valueForKey:@"url"];
            url = [urlDict valueForKey:@"text"];
            
            NSDictionary *appidDict = [weappInfoDict valueForKey:@"appid"];
            appid = [appidDict valueForKey:@"text"];
            
            NSDictionary *pagepathDict = [weappInfoDict valueForKey:@"pagepath"];
            pagepath = [pagepathDict valueForKey:@"text"];
            
            NSDictionary *sourcedisplaynameDict = [appMsgDict valueForKey:@"sourcedisplayname"];
            sourcedisplayname = [sourcedisplaynameDict valueForKey:@"text"];
            
            MessageService *msgService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MessageService")];
            
            if (title.length > 20) {
                title = [title substringToIndex:19];
                title = [NSString stringWithFormat:@"%@...",title];
            }
            
            NSString *newMsgContent = [NSString stringWithFormat:@"%@ \n小程序名称：%@ \n标题：%@ \n",@"收到小程序消息",sourcedisplayname,title];
            MessageData *newMsgData = ({
                MessageData *msg = [[objc_getClass("MessageData") alloc] initWithMsgType:0x2710];
                [msg setFromUsrName:session];
                [msg setToUsrName:session];
                [msg setMsgStatus:4];
                [msg setMsgContent:newMsgContent];
                [msg setMsgCreateTime:[[NSDate date] timeIntervalSince1970]];
                msg;
            });
            
            [msgService AddLocalMsg:session msgData:newMsgData];
                   
        }
    }
}
@end
