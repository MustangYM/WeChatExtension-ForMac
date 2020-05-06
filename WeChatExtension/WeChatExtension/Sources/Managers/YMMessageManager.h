//
//  YMMessageManager.h
//  WeChatExtension
//
//  Created by WeChatExtension on 2018/4/23.
//  Copyright © 2018年 WeChatExtension. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMMessageManager : NSObject

+ (instancetype)shareManager;
- (void)sendTextMessageToSelf:(id)msgContent;
- (void)sendTextMessage:(id)msgContent toUsrName:(id)toUser delay:(NSInteger)delayTime;
- (void)clearUnRead:(id)arg1;
- (NSString *)getMessageContentWithData:(MessageData *)msgData;
- (NSArray *)getMsgListWithChatName:(id)arg1 minMesLocalId:(unsigned int)arg2 limitCnt:(NSInteger)arg3;
- (void)playVoiceWithMessageData:(MessageData *)msgData;

- (void)asyncRevokeMessage:(MessageData *)revokeMsgData;
@end
