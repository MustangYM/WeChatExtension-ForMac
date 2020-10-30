//
//  YMZGMPDetailLogic.m
//  WeChatExtension
//
//  Created by MustangYM on 2020/10/30.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import "YMZGMPDetailLogic.h"
#import "YMIMContactsManager.h"
#import "YMZGMPInfoHelper.h"
#import "YMZGMPBanModel.h"
#import "YMDFAFilter.h"

@interface YMZGMPDetailLogic ()
@property (nonatomic, copy) NSString *preChatroom;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isLoading;
@end

@implementation YMZGMPDetailLogic
- (void)updateSessionData:(void(^)(NSArray *ary))completion
{
    NSArray *array = [YMIMContactsManager getAllChatroomFromSessionList];
    NSMutableArray *dataArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YMZGMPGroupInfo *info = [[YMZGMPGroupInfo alloc] init];
        info.wxid = obj;
        [dataArray addObject:info];
    }];
    
    [[YMWeChatPluginConfig sharedConfig].banModels enumerateObjectsUsingBlock:^(YMZGMPBanModel * _Nonnull ban, NSUInteger idx, BOOL * _Nonnull stop1) {
        __block BOOL flag = NO;
        [dataArray enumerateObjectsUsingBlock:^(YMZGMPGroupInfo  *_Nonnull info, NSUInteger idx, BOOL * _Nonnull stop2) {
            if ([ban.wxid isEqualToString:info.wxid]) {//Cache命中禁言群
                info.isIgnore = YES;
                flag = YES;
                *stop2 = YES;
            }
        }];
        if (!flag) {//Cache命中，session列表没有，证明此群被删，从cache中取数据显示，否则永远收不到此群消息
            YMZGMPGroupInfo *info = [[YMZGMPGroupInfo alloc] init];
            info.wxid = ban.wxid;
            info.nick = ban.nick;
            info.isIgnore = YES;
            [dataArray insertObject:info atIndex:0];
        }
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
       completion ? completion(dataArray) : nil;
    });
}

- (void)updateDetailData:(NSString *)chatroom completion:(void(^)(NSArray *ary))completion finally:(void(^)(void))finally
{
    if (self.isLoading) {
        return;
    }
    
    if (chatroom.length == 0 || !chatroom) {
        return;
    }
    
    if (![chatroom isEqualToString:self.preChatroom]) {
        self.page = 0;
        self.preChatroom = chatroom;
    }
    
    GroupStorage *groupStorage = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("GroupStorage")];
    NSArray *list = [groupStorage GetGroupMemberListWithGroupUserName:chatroom limit:500 filterSelf:NO];
    NSInteger loc = self.page == 0 ? 0 : self.page * 20;
    NSUInteger length = 20;
    if (loc + 20 > list.count) {
        length = list.count - loc;
    }
    if (length <= 0 || loc >= list.count) {
        finally ? finally() : nil;
        return;
    }
    
    self.isLoading = YES;
    NSArray *limitArray = [list subarrayWithRange:NSMakeRange(loc, length)];
    MMChatFTSSearchLogic *logic = [[objc_getClass("MMChatFTSSearchLogic") alloc] init];
    NSMutableArray *array = [NSMutableArray array];
    __weak __typeof (self) wself = self;
    [limitArray enumerateObjectsUsingBlock:^(WCContactData *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [logic doSearchWithKeyword:obj.m_nsNickName chatName:chatroom realFromUser:0x0 messageType:0x0 minMsgCreateTime:0x0 maxMsgCreateTime:0x0 limitCount:0x0 isFromGlobalSearch:'1' completion:^(NSArray *msgs, NSString *chatroom) {
            //违规词汇
            __block int sensitive = 0;
            __block int pdd = 0;
            [msgs enumerateObjectsUsingBlock:^(MessageData *_Nonnull msgData, NSUInteger idx, BOOL * _Nonnull stop) {
                if (msgData.messageType == 1 && [[YMDFAFilter shareInstance] filterSensitiveWords:msgData.msgContent]) {
                    sensitive++;
                } else if (msgData.messageType == 49 && [msgData.extendInfoWithMsgType isKindOfClass:objc_getClass("CExtendInfoOfAPP")]) {
                    CExtendInfoOfAPP *app = (CExtendInfoOfAPP *)msgData.extendInfoWithMsgType;
                    if ([app.m_nsTitle containsString:@"拼多多"] || [app.m_nsDesc containsString:@"拼多多"]) {
                        pdd++;
                    }
                }
            }];

            YMZGMPInfo *info = [[YMZGMPInfo alloc] init];
            info.contact = obj;
            info.sensitive = sensitive;
            info.pdd = pdd;
            info.totalMsgs = msgs.count;
            if (msgs.count > 0) {
                MessageData *msg = msgs[0];
                info.timestamp = msg.msgCreateTime;
            }
            [array addObject:info];
            if (array.count == limitArray.count) {
              NSArray *temp = [NSArray arrayWithArray:[array sortedArrayUsingComparator:^NSComparisonResult(YMZGMPInfo*  _Nonnull obj1, YMZGMPInfo*  _Nonnull obj2) {
                   NSNumber *number1 = [NSNumber numberWithInt:obj1.timestamp];
                   NSNumber *number2 = [NSNumber numberWithInt:obj2.timestamp];
                   NSComparisonResult result = [number1 compare:number2];
                   return  result == NSOrderedAscending;
               }]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    wself.isLoading = NO;
                    completion ? completion(temp) : nil;
                });
                wself.page ++;
            }
        }];
    }];
}

@end


