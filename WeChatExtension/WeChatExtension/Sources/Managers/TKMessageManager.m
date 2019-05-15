//
//  TKMessageManager.m
//  WeChatPlugin
//
//  Created by TK on 2018/4/23.
//  Copyright © 2018年 tk. All rights reserved.
//

#import "TKMessageManager.h"
#import "WeChatPlugin.h"
#import <MediaPlayer/MediaPlayer.h>
#import "TKCacheManager.h"
#import "YMDownloadMgr.h"

@interface TKMessageManager()
@property (nonatomic, strong) MessageService *service;
@end

@implementation TKMessageManager

+ (instancetype)shareManager {
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)sendTextMessageToSelf:(id)msgContent {
    NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
    [self sendTextMessage:msgContent toUsrName:currentUserName delay:0];
}

- (void)sendTextMessage:(id)msgContent toUsrName:(id)toUser delay:(NSInteger)delayTime {
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

- (void)sendImageMessage:(id)msgContent toUserName:(id)toUser {
    NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:@"/Users/mustangym/Desktop/231548072054_.pic.jpg"];
    NSData *originalData = [image TIFFRepresentation];
    NSData *thumData = [self getCompressImageDataWithImg:image rate:0.07];
    SendImageInfo *info = [[objc_getClass("SendImageInfo") alloc] init];
    info.m_uiThumbWidth = 120;
    info.m_uiThumbHeight = 67;
    info.m_uiOriginalWidth  = 1920;
    info.m_uiOriginalHeight = 1080;
    [self.service SendImgMessage:currentUserName toUsrName:toUser thumbImgData:thumData midImgData:thumData imgData:originalData imgInfo:info];
}

- (void)sendVideoMessage:(id)msgContent toUserName:(id)toUser {
    NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
    NSString *path = @"/Users/mustangym/Library/Containers/com.tencent.xinWeChat/Data/Library/Application Support/com.tencent.xinWeChat/2.0b4.0.9/674ee0d7348d38ffe4c08885f4bafe11/Message/MessageTemp/82fbc4af3eb8d0ec7a94741888c5d56d/Video/1548316408491888_1548316686660991_1548319384284652.mp4";
    SendVideoinfo *videoInfo = [[objc_getClass("SendVideoInfo") alloc] init];
    NSData *data = [NSData dataWithContentsOfFile:path];
    videoInfo.video_path = path;
    NSImage *face = [objc_getClass("MMFileTypeHelper") firstFrameImageOfVideoWithFilePath:path];
    NSData *imgDt = [face TIFFRepresentation];
    NSString *thumPath = [[TKCacheManager shareManager] cacheImageData:imgDt withFileName:@"sdswqq" completion:nil];
    videoInfo.video_size = (int)[data length];
    videoInfo.thumb_path = thumPath;
    [self.service SendVideoMessage:currentUserName toUsrName:toUser videoInfo:videoInfo msgType:43 refMesageData:nil];
}

- (void)sendLocationMessage:(NSString *)toUser latitude:(double)latitude longitude:(double)longitude poiName:(id)poiName label:(id)label {
    NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
    
    [self.service SendLocationMsgFromUser:currentUserName toUser:toUser withLatitude:latitude longitude:longitude poiName:@"北京朝阳区潘家园" label:@"我就测试"];
}

- (void)sendUserCardMessage:(NSString *)toUser contact:(WCContactData *)contact {
    NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
    [self.service SendNamecardMsgFromUser:currentUserName toUser:toUser containingContact:contact];
}

- (void)sendEmoticonMessage:(NSString *)toUser emoticonMD5:(NSString *)MD5 {
    NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
    [self.service SendEmoticonMsgFromUsr:currentUserName toUsrName:toUser md5:MD5 emoticonType:1];
}

- (void)sendURLMessage:(NSString *)toUser title:(NSString *)title url:(NSString *)url description:(NSString *)description thumImgData:(NSData *)imgData {
    NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
    [self.service SendAppURLMessageFromUser:currentUserName toUsrName:toUser withTitle:title url:url description:description thumbnailData:imgData];
}

- (NSData *)getCompressImageDataWithImg:(NSImage *)img
                                   rate:(CGFloat)rate{
    NSData *imgDt = [img TIFFRepresentation];
    if (!imgDt) {
        return nil;
    }

    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imgDt];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:rate] forKey:NSImageCompressionFactor];
    imgDt = [imageRep representationUsingType:NSJPEGFileType properties:imageProps];
    return imgDt;
    
}

- (void)clearUnRead:(id)arg1 {
    MessageService *service = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MessageService")];
    if ([service respondsToSelector:@selector(ClearUnRead:FromCreateTime:ToCreateTime:)]) {
        [service ClearUnRead:arg1 FromCreateTime:0 ToCreateTime:0];
    } else if ([service respondsToSelector:@selector(ClearUnRead:FromID:ToID:)]) {
        [service ClearUnRead:arg1 FromID:0 ToID:0];
    }
}

- (NSString *)getMessageContentWithData:(MessageData *)msgData {
    if (!msgData) return @"";
    
    NSString *msgContent = [msgData summaryString:NO] ?: @"";
    if (msgData.m_nsTitle && (msgData.isAppBrandMsg || [msgContent isEqualToString:WXLocalizedString(@"Message_type_unsupport")])){
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

- (NSArray <MessageData *> *)getMsgListWithChatName:(id)arg1 minMesLocalId:(unsigned int)arg2 limitCnt:(NSInteger)arg3 {
    MessageService *service = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MessageService")];
    char hasMore = '1';
    NSArray *array = @[];
    if ([service respondsToSelector:@selector(GetMsgListWithChatName:fromLocalId:limitCnt:hasMore:sortAscend:)]) {
        array = [service GetMsgListWithChatName:arg1 fromLocalId:arg2 limitCnt:arg3 hasMore:&hasMore sortAscend:YES];
    } else if ([service respondsToSelector:@selector(GetMsgListWithChatName:fromCreateTime:limitCnt:hasMore:sortAscend:)]) {
         array = [service GetMsgListWithChatName:arg1 fromCreateTime:arg2 limitCnt:arg3 hasMore:&hasMore sortAscend:YES];
    }
    
    return [[array reverseObjectEnumerator] allObjects];
}

- (void)playVoiceWithMessageData:(MessageData *)msgData {
    if (!msgData.isVoiceMsg) return;
    
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

- (void)asyncRevokeMessage:(MessageData *)revokeMsgData {
    if (![TKWeChatPluginConfig sharedConfig].preventAsyncRevokeToPhone) {
        return;
    }
    
    MessageService *msgService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MessageService")];
    
    NSArray *pushMsgAry = [revokeMsgData.msgPushContent componentsSeparatedByString:@":"];
    NSString *msgFromNickName = pushMsgAry.count > 1 ? pushMsgAry[0] : revokeMsgData.fromUsrName;
    MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
    WCContactData *msgContact = [sessionMgr getContact:revokeMsgData.fromUsrName];
    
    
    NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
    if (revokeMsgData.messageType == 1) {
        if ([revokeMsgData.fromUsrName containsString:@"@chatroom"]) {
            NSArray *msgAry = [revokeMsgData.msgContent componentsSeparatedByString:@":"];
            NSString *msgContent = msgAry.count > 1 ? msgAry[1] : revokeMsgData.msgContent;
            [msgService SendTextMessage:currentUserName toUsrName:currentUserName msgText:[NSString stringWithFormat:@"拦截到一条撤回消息\n%@\n%@:%@", msgContact.m_nsNickName, msgFromNickName, msgContent] atUserList:nil];
        } else {
            [msgService SendTextMessage:currentUserName toUsrName:currentUserName msgText:[NSString stringWithFormat:@"拦截到一条撤回消息\n%@:%@", msgFromNickName,revokeMsgData.msgContent] atUserList:nil];
        }
    } else if (revokeMsgData.messageType == 3) {
        if ([revokeMsgData.fromUsrName containsString:@"@chatroom"]) {
            [msgService SendTextMessage:currentUserName toUsrName:currentUserName msgText:[NSString stringWithFormat:@"拦截到一条撤回消息\n%@\n%@", msgContact.m_nsNickName, revokeMsgData.msgPushContent] atUserList:nil];
        } else {
            [msgService SendTextMessage:currentUserName toUsrName:currentUserName msgText:[NSString stringWithFormat:@"拦截到一条撤回消息\n%@",revokeMsgData.msgPushContent] atUserList:nil];
        }
        
        MMMessageCacheMgr *mgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMMessageCacheMgr")];
        
        [[YMDownloadMgr new] downloadImageWithMsg:revokeMsgData];
        
        __weak __typeof (self) wself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
        }
}

- (MessageService *)service {
    if (!_service) {
        _service = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MessageService")];
    }
    return _service;
}
@end
