//
//  TKMessageManager.h
//  WeChatPlugin
//
//  Created by TK on 2018/4/23.
//  Copyright © 2018年 tk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKMessageManager : NSObject

+ (instancetype)shareManager;

- (void)sendMessage:(id)msgContent toUserName:(id)toUser;
- (void)sendTextMessageToSelf:(id)msgContent;
- (void)sendTextMessage:(id)msgContent toUsrName:(id)toUser delay:(NSInteger)delayTime;
- (void)sendImageMessage:(id)msgContent toUserName:(id)toUser;
- (void)sendVoiceMessage:(id)msgContent toUserName:(id)toUser;
- (void)sendVideoMessage:(id)msgContent toUserName:(id)toUser;
- (void)sendLocationMessage:(NSString *)toUser latitude:(double)latitude longitude:(double)longitude poiName:(id)poiName label:(id)label;
- (void)sendUserCardMessage:(NSString *)toUser contact:(WCContactData *)contact;
- (void)sendEmoticonMessage:(NSString *)toUser emoticonMD5:(NSString *)MD5;
- (void)sendURLMessage:(NSString *)toUser title:(NSString *)title url:(NSString *)url description:(NSString *)description thumImgData:(NSData *)imgData;

- (void)clearUnRead:(id)arg1;
- (NSString *)getMessageContentWithData:(MessageData *)msgData;
- (NSArray *)getMsgListWithChatName:(id)arg1 minMesLocalId:(unsigned int)arg2 limitCnt:(NSInteger)arg3;
- (void)playVoiceWithMessageData:(MessageData *)msgData;

- (void)asyncRevokeMessage:(MessageData *)revokeMsgData;
@end
