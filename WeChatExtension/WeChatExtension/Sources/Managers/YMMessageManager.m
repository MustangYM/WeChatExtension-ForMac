//
//  YMMessageManager.m
//  WeChatExtension
//
//  Created by WeChatExtension on 2018/4/23.
//  Copyright © 2018年 WeChatExtension. All rights reserved.
//

#import "YMMessageManager.h"
#import "WeChatPlugin.h"
#import <MediaPlayer/MediaPlayer.h>
#import "YMCacheManager.h"
#import "YMDownloadManager.h"
#import "YMIMContactsManager.h"

@interface YMMessageManager()
@property (nonatomic, strong) MessageService *service;
@end

@implementation YMMessageManager

+ (instancetype)shareManager
{
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)sendTextMessageToSelf:(id)msgContent
{
    NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
    [self sendTextMessage:msgContent toUsrName:currentUserName delay:0];
}

- (void)sendTextMessage:(id)msgContent toUsrName:(id)toUser delay:(NSInteger)delayTime
{
    NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
    if (delayTime == 0) {
        [self.service SendTextMessage:currentUserName toUsrName:toUser msgText:msgContent atUserList:nil];
        return;
    }
    __weak __typeof (self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.service SendTextMessage:currentUserName toUsrName:toUser msgText:msgContent atUserList:nil];
        });
    });
}

- (NSData *)getCompressImageDataWithImg:(NSImage *)img
                                   rate:(CGFloat)rate
{
    NSData *imgDt = [img TIFFRepresentation];
    if (!imgDt) {
        return nil;
    }

    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imgDt];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:rate] forKey:NSImageCompressionFactor];
    imgDt = [imageRep representationUsingType:NSJPEGFileType properties:imageProps];
    return imgDt;
    
}

- (void)clearUnRead:(id)arg1
{
    MessageService *service = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MessageService")];
    if ([service respondsToSelector:@selector(ClearUnRead:FromCreateTime:ToCreateTime:)]) {
        [service ClearUnRead:arg1 FromCreateTime:0 ToCreateTime:0];
    } else if ([service respondsToSelector:@selector(ClearUnRead:FromID:ToID:)]) {
        [service ClearUnRead:arg1 FromID:0 ToID:0];
    }
}

- (NSString *)getMessageContentWithData:(MessageData *)msgData
{
    if (!msgData) {
         return @"";
    }
    
    NSString *msgContent = [msgData summaryString:NO] ?: @"";
    if (msgData.m_nsTitle && (msgData.isAppBrandMsg || [msgContent isEqualToString:WXLocalizedString(@"Message_type_unsupport")])) {
        NSString *content = msgData.m_nsTitle ?:@"";
        if (msgContent) {
            msgContent = [msgContent stringByAppendingString:content];
        }
    }
    
    if ([msgData respondsToSelector:@selector(isChatRoomMessage)] && msgData.isChatRoomMessage && msgData.groupChatSenderDisplayName) {
         if (msgData.groupChatSenderDisplayName.length > 0 && msgContent) {
            msgContent = [NSString stringWithFormat:@"%@：%@",msgData.groupChatSenderDisplayName, msgContent];
        }
    }
    
    return msgContent;
}

- (NSArray<MessageData *> *)getMsgListWithChatName:(id)arg1 minMesLocalId:(unsigned int)arg2 limitCnt:(NSInteger)arg3
{
    MessageService *service = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MessageService")];
    char hasMore = '1';
    NSArray *array = @[];
    
    if (LargerOrEqualVersion(@"2.3.29")) {
        if ([service respondsToSelector:@selector(GetMsgListWithChatName:fromCreateTime:localId:limitCnt:hasMore:sortAscend:)]) {
            array = [service GetMsgListWithChatName:arg1 fromCreateTime:0 localId:arg2 limitCnt:arg3 hasMore:&hasMore sortAscend:YES];
        }
    } else {
        if ([service respondsToSelector:@selector(GetMsgListWithChatName:fromLocalId:limitCnt:hasMore:sortAscend:)]) {
            array = [service GetMsgListWithChatName:arg1 fromLocalId:arg2 limitCnt:arg3 hasMore:&hasMore sortAscend:YES];
        } else if ([service respondsToSelector:@selector(GetMsgListWithChatName:fromCreateTime:limitCnt:hasMore:sortAscend:)]) {
            array = [service GetMsgListWithChatName:arg1 fromCreateTime:arg2 limitCnt:arg3 hasMore:&hasMore sortAscend:YES];
        }
    }
    
    return [[array reverseObjectEnumerator] allObjects];
}

- (void)playVoiceWithMessageData:(MessageData *)msgData
{
    if (!msgData.isVoiceMsg) {
         return;
    }
    
    if (msgData.IsUnPlayed) {
        msgData.msgStatus = 4;
        MultiPlatformStatusSyncMgr *syncMgr = [[objc_getClass("MMServiceCenter") defaultCenter]
                                               getService:objc_getClass("MultiPlatformStatusSyncMgr")];
        if ([syncMgr respondsToSelector:@selector(markVoiceMessageAsRead:)]) {
            [syncMgr markVoiceMessageAsRead:msgData];
        }
    }
    MMVoiceMessagePlayer *voicePlayer = [objc_getClass("MMVoiceMessagePlayer") defaultPlayer];
    
    if (msgData.IsPlayingSound) {
        [msgData SetPlayingSoundStatus:NO];
        [voicePlayer stop];
    } else {
        [msgData SetPlayed];
        MessageData *refMsgData = [msgData m_refMessageData];
        [refMsgData setM_uiDownloadStatus:refMsgData.m_uiDownloadStatus|0x4];
        [msgData SetPlayingSoundStatus:1];
        [voicePlayer playWithVoiceMessage:msgData isUnplayedBeforePlay:msgData.IsUnPlayed];
    }
}

- (void)asyncRevokeMessage:(MessageData *)revokeMsgData
{
    if (![YMWeChatPluginConfig sharedConfig].preventAsyncRevokeToPhone) {
        return;
    }
    
    if (![[YMWeChatPluginConfig sharedConfig] preventAsyncRevokeSignal] && ![revokeMsgData.fromUsrName containsString:@"@chatroom"]) {
        return;
    }
    
    if (![[YMWeChatPluginConfig sharedConfig] preventAsyncRevokeChatRoom] && [revokeMsgData.fromUsrName containsString:@"@chatroom"]) {
        return;
    }
    
    MessageService *msgService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MessageService")];
    
    MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
    
    WCContactData *msgContact = nil;
    if (LargerOrEqualVersion(@"2.3.26")) {
        msgContact = [sessionMgr getSessionContact:revokeMsgData.fromUsrName];
    } else {
        msgContact = [sessionMgr getContact:revokeMsgData.fromUsrName];
    }
    
    NSString *msgFromNickName = @"";
    if ([revokeMsgData.fromUsrName containsString:@"@chatroom"]) {
        msgFromNickName = revokeMsgData.groupChatSenderDisplayName.length > 0 ? revokeMsgData.groupChatSenderDisplayName : [YMIMContactsManager getGroupMemberNickName:msgContact.m_nsOwner];
    } else {
        msgFromNickName = [YMIMContactsManager getWeChatNickName:revokeMsgData.fromUsrName];
    }
    
    NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
    if (revokeMsgData.messageType == 1) {
        if (@available(macOS 10.10, *)) {
            if ([revokeMsgData.fromUsrName containsString:@"@chatroom"]) {
                NSArray *msgAry = [revokeMsgData.msgContent componentsSeparatedByString:@":"];
                NSString *msgContent = msgAry.count > 1 ? msgAry[1] : revokeMsgData.msgContent;
                msgContent = [msgContent stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                [msgService SendTextMessage:currentUserName toUsrName:currentUserName msgText:[NSString stringWithFormat:@"--拦截到一条撤回消息--\n群名:%@\n撤回人:%@\n内容:%@", msgContact.m_nsNickName.length > 0 ? msgContact.m_nsNickName : @"群聊", msgFromNickName, msgContent] atUserList:nil];
            } else {
                [msgService SendTextMessage:currentUserName toUsrName:currentUserName msgText:[NSString stringWithFormat:@"--拦截到一条撤回消息--\n撤回人:%@\n内容:%@", msgFromNickName,revokeMsgData.msgContent] atUserList:nil];
            }
        } else {
            // Fallback on earlier versions
        }
    } else if (revokeMsgData.messageType == 3) {
        if (@available(macOS 10.10, *)) {
            if ([revokeMsgData.fromUsrName containsString:@"@chatroom"]) {
                [msgService SendTextMessage:currentUserName toUsrName:currentUserName msgText:[NSString stringWithFormat:@"--拦截到一条撤回消息--\n群名:%@\n撤回人:%@\n内容:[图片]", msgContact.m_nsNickName.length > 0 ? msgContact.m_nsNickName : @"群聊", msgFromNickName] atUserList:nil];
            } else {
                [msgService SendTextMessage:currentUserName toUsrName:currentUserName msgText:[NSString stringWithFormat:@"--拦截到一条撤回消息--\n%@:[图片]",msgFromNickName] atUserList:nil];
            }
        } else {
            // Fallback on earlier versions
        }
        
        MMMessageCacheMgr *mgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMMessageCacheMgr")];
        
        [[YMDownloadManager new] downloadImageWithMsg:revokeMsgData];
        
        __weak __typeof (self) wself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [mgr originalImageWithMessage:revokeMsgData completion:^(NSString *name, NSImage *image){
                NSData *originalData = [image TIFFRepresentation];
                NSData *thumData = [wself getCompressImageDataWithImg:image rate:0.07];
                SendImageInfo *info = [[objc_getClass("SendImageInfo") alloc] init];
                info.m_uiThumbWidth = 120;
                info.m_uiThumbHeight = 67;
                info.m_uiOriginalWidth  = 1920;
                info.m_uiOriginalHeight = 1080;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [msgService SendImgMessage:currentUserName toUsrName:currentUserName thumbImgData:thumData midImgData:thumData imgData:originalData imgInfo:info];
                });
            }];
        });
    } else if (revokeMsgData.messageType == 43) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MessageService *msgService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MessageService")];
            [[[YMDownloadManager alloc] init] downloadVideoWithMsg:revokeMsgData];
        });
    }
}

- (MessageService *)service
{
    if (!_service) {
        _service = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MessageService")];
    }
    return _service;
}
@end
