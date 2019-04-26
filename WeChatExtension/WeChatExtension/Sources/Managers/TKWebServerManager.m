//
//  TKWebServerManager.m
//  WeChatPlugin
//
//  Created by TK on 2018/3/18.
//  Copyright © 2018年 tk. All rights reserved.
//

#import "TKWebServerManager.h"
#import "WeChatPlugin.h"
#import <GCDWebServer.h>
#import <GCDWebServerDataResponse.h>
#import <GCDWebServerURLEncodedFormRequest.h>
#import "TKMessageManager.h"
#import "TKCacheManager.h"

@interface TKWebServerManager ()

@property (nonatomic, strong) GCDWebServer *webServer;
@property (nonatomic, strong) MMContactSearchLogic *searchLogic;

@end

@implementation TKWebServerManager

static int port=52700;

+ (instancetype)shareManager {
    static TKWebServerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TKWebServerManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.searchLogic = [[objc_getClass("MMContactSearchLogic") alloc] init];
    }
    return self;
}

- (void)startServer {
    if (self.webServer) {
        return;
    }
    NSDictionary *options = @{GCDWebServerOption_Port: [NSNumber numberWithInt:port],
                              GCDWebServerOption_BindToLocalhost: @YES,
                              GCDWebServerOption_ConnectedStateCoalescingInterval: @2,
                              };
    
    self.webServer = [[GCDWebServer alloc] init];
    [self addHandleForSearchUser];
    [self addHandleForOpenSession];
    [self addHandleForSendMsg];
    [self addHandleForSearchUserChatLog];
    [self.webServer startWithOptions:options error:nil];
}

- (void)endServer {
    if( [self.webServer isRunning] ) {
        [self.webServer stop];
        [self.webServer removeAllHandlers];
        self.webServer = nil;
    }
}

- (void)addHandleForSearchUser {
    __weak typeof(self) weakSelf = self;
    
    [self.webServer addHandlerForMethod:@"GET" path:@"/wechat-plugin/user" requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerRequest * _Nonnull request) {

        if (![weakSelf isLocalhost:request.headers[@"Host"]]) {
             return [GCDWebServerResponse responseWithStatusCode:404];
        }
        
        NSString *keyword = request.query ? request.query[@"keyword"] ? request.query[@"keyword"] : @"" : @"";
        __block NSMutableArray *sessionList = [NSMutableArray array];
        
        //        返回最近聊天列表
        if ([keyword isEqualToString:@""]) {
            MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
            NSMutableArray <MMSessionInfo *> *arrSession = sessionMgr.m_arrSession;
            [arrSession enumerateObjectsUsingBlock:^(MMSessionInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.m_packedInfo.m_contact.m_nsUsrName isEqualToString:@"brandsessionholder"]) {
                    return ;
                }
                [sessionList addObject:[weakSelf dictFromSessionInfo:obj]];
            }];
            return [GCDWebServerDataResponse responseWithJSONObject:sessionList];
        }
        
        //        返回搜索结果
        __block BOOL hasResult = NO;
        
        MMContactSearchLogic *logic = weakSelf.searchLogic;
        [logic doSearchWithKeyword:keyword searchScene:31 resultIsShownBlock:nil completion:^ {
            if ([logic respondsToSelector:@selector(reloadSearchResultDataWithKeyword:completionBlock:)]) {
                [logic reloadSearchResultDataWithKeyword:keyword completionBlock:^ {
                    hasResult = YES;
                }];
            } else if ([logic respondsToSelector:@selector(reloadSearchResultDataWithKeyword:resultContainer:completionBlock:)]) {
                [logic reloadSearchResultDataWithKeyword:keyword resultContainer:nil completionBlock:^ {
                    if (logic.searchResultContainer.logicSearchResultFlag == 7) {
                        hasResult = YES;
                    }
                }];
            } else if ([logic respondsToSelector:@selector(reloadSearchResultDataWithCompletionBlock:)]) {
                [logic reloadSearchResultDataWithCompletionBlock:^ {
                    hasResult = YES;
                }];
            }
        }];
        
        if ([logic respondsToSelector:@selector(isContactSearched)]) {
            while (!(hasResult && logic.isContactSearched && logic.isGroupContactSearched && logic.isBrandContactSearched)) {};
        } else if ([logic respondsToSelector:@selector(clearAllResults)]) {
             while (!(hasResult && [[logic valueForKey:@"_logicSearchResultFlag"] longLongValue])) {};
        } else {
             while (!(hasResult)) {};
        }
        
        MMChatMangerSearchReportMgr *reportMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMChatMangerSearchReportMgr")];
        
        [reportMgr.contactSearchResults enumerateObjectsUsingBlock:^(id contact, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([contact isKindOfClass:objc_getClass("MMComplexContactSearchResult")]) {
                [sessionList addObject:[weakSelf dictFromContactSearchResult:(MMComplexContactSearchResult *)contact]];
            } else if([contact isKindOfClass:objc_getClass("MMComplexGroupContactSearchResult")]) {
                [sessionList addObject:[weakSelf dictFromGroupSearchResult:(MMComplexGroupContactSearchResult *)contact]];
            }
        }];
        [reportMgr.groupContactSearchResults enumerateObjectsUsingBlock:^(MMComplexGroupContactSearchResult *group, NSUInteger idx, BOOL * _Nonnull stop) {
            [sessionList addObject:[weakSelf dictFromGroupSearchResult:group]];
        }];
        [reportMgr.brandContactSearchResults enumerateObjectsUsingBlock:^(MMComplexContactSearchResult *contact, NSUInteger idx, BOOL * _Nonnull stop) {
            [sessionList addObject:[weakSelf dictFromContactSearchResult:contact]];
        }];
        
        if ([logic respondsToSelector:@selector(clearAllResults)]) {
            [logic clearAllResults];
        } else if ([logic respondsToSelector:@selector(clearDataWhenSearchEnd)]) {
            [logic clearDataWhenSearchEnd];
        }

        return [GCDWebServerDataResponse responseWithJSONObject:sessionList];
        
    }];
}

- (void)addHandleForSearchUserChatLog {
    __weak typeof(self) weakSelf = self;
    [self.webServer addHandlerForMethod:@"GET" path:@"/wechat-plugin/chatlog" requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerRequest * _Nonnull request) {

        if (![weakSelf isLocalhost:request.headers[@"Host"]]) {
            return [GCDWebServerResponse responseWithStatusCode:404];
        }
        
        NSString *userId = request.query ? request.query[@"userId"] ? request.query[@"userId"] : nil : nil;
        NSInteger count = request.query ? request.query[@"count"] ? [request.query[@"count"] integerValue] : 30 : 30;
        
        if (userId) {
            NSMutableArray *chatLogList = [NSMutableArray array];
            
            NSArray *msgDataList = [[TKMessageManager shareManager] getMsgListWithChatName:userId minMesLocalId:0 limitCnt:count];
            [msgDataList enumerateObjectsUsingBlock:^(MessageData * _Nonnull msgData, NSUInteger idx, BOOL * _Nonnull stop) {
                [chatLogList addObject:[weakSelf dictFromMessageData:msgData]];
            }];
            
            MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
            WCContactData *toUserContact = [sessionMgr getContact:userId];
            NSString *wechatId = [toUserContact getContactDisplayUsrName];
            NSString *title = [weakSelf getUserNameWithContactData:toUserContact showOriginName:YES];
            NSString *imgPath = [[TKCacheManager shareManager] cacheAvatarWithContact:toUserContact];
            NSDictionary *toUserContactDict = @{@"title": [NSString stringWithFormat:@"To: %@", title],
                                                @"subTitle": chatLogList.count > 0 ? TKLocalizedString(@"assistant.search.chatlog") : @"",
                                                @"icon": imgPath ?: @"",
                                                @"userId": userId,
                                                @"url": @"",
                                                @"copyText": wechatId ?: @"",
                                                @"srvId": @(0)
                                                };
            [chatLogList insertObject:toUserContactDict atIndex:0];
            
            return [GCDWebServerDataResponse responseWithJSONObject:chatLogList];
        }
        
        return [GCDWebServerResponse responseWithStatusCode:404];
    }];
}

- (void)addHandleForOpenSession {
    __weak typeof(self) weakSelf = self;
    
    [self.webServer addHandlerForMethod:@"POST" path:@"/wechat-plugin/open-session" requestClass:[GCDWebServerURLEncodedFormRequest class] processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerURLEncodedFormRequest * _Nonnull request) {

        if (![weakSelf isLocalhost:request.headers[@"Host"]]) {
            return [GCDWebServerResponse responseWithStatusCode:404];
        }
        
        NSDictionary *requestBody = [request arguments];
        
        if (requestBody && requestBody[@"userId"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
                WCContactData *selectContact = [sessionMgr getContact:requestBody[@"userId"]];
                
                WeChat *wechat = [objc_getClass("WeChat") sharedInstance];
                if ([selectContact isBrandContact]) {
                    WCContactData *brandsessionholder  = [sessionMgr getContact:@"brandsessionholder"];
                    if (brandsessionholder) {
                        [wechat startANewChatWithContact:brandsessionholder];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            MMBrandChatsViewController *brandChats = wechat.chatsViewController.brandChatsViewController;
                            [brandChats startChatWithContact:selectContact];
                        });
                    }
                } else {
                    [wechat startANewChatWithContact:selectContact];
                }
                [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
            });
            return [GCDWebServerResponse responseWithStatusCode:200];
        }
        
        return [GCDWebServerResponse responseWithStatusCode:404];
    }];
}

- (void)addHandleForSendMsg {
    __weak typeof(self) weakSelf = self;
    
    [self.webServer addHandlerForMethod:@"POST" path:@"/wechat-plugin/send-message" requestClass:[GCDWebServerURLEncodedFormRequest class] processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerURLEncodedFormRequest * _Nonnull request) {

        if (![weakSelf isLocalhost:request.headers[@"Host"]]) {
            return [GCDWebServerResponse responseWithStatusCode:404];
        }

        NSDictionary *requestBody = [request arguments];
        NSString *userId = requestBody[@"userId"];
        
        if (requestBody && userId.length > 0) {
            NSString *content = requestBody[@"content"];
            
            MessageService *messageService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MessageService")];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (content.length > 0) {
                    NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
                    [messageService SendTextMessage:currentUserName
                                          toUsrName:requestBody[@"userId"]
                                            msgText:requestBody[@"content"]
                                         atUserList:nil];
                    [[TKMessageManager shareManager] clearUnRead:requestBody[@"userId"]];
                    
                } else if (content.length == 0 && requestBody[@"srvId"]) {
                    if (requestBody[@"srvId"]) {
                        NSInteger srvId = [requestBody[@"srvId"] integerValue];
                        if (srvId != 0) {
                            MessageData *msgData = [messageService GetMsgData:userId svrId:srvId];
                            [[TKMessageManager shareManager] playVoiceWithMessageData:msgData];
                        }
                    }
                    [[TKMessageManager shareManager] clearUnRead:userId];
                }
            });
            return [GCDWebServerResponse responseWithStatusCode:200];
        }
        
        return [GCDWebServerResponse responseWithStatusCode:404];
    }];
}

- (NSDictionary *)dictFromGroupSearchResult:(MMComplexGroupContactSearchResult *)result {
    if (![result isKindOfClass:objc_getClass("MMComplexGroupContactSearchResult")]) {
        return [self dictWithErrorMsg:result.className];
    }
    WCContactData *groupContact = result.groupContact;
    if (!groupContact) {
        return [self dictWithErrorMsg:@"搜索群组有误"];
    }
    NSMutableArray *subTitleArray = [NSMutableArray array];
    if (result.searchType == 2) {
        [result.groupMembersResult.membersSearchReults enumerateObjectsUsingBlock:^(MMComplexContactSearchResult * _Nonnull contact, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *matchStr =[self matchWithContactResult:contact];
            NSString *contactName;
            if(contact.contact.m_nsRemark && ![contact.contact.m_nsRemark isEqualToString:@""]) {
                contactName = contact.contact.m_nsRemark;
                if (contact.fieldType != 1) {
                    contactName = [NSString stringWithFormat:@"%@(%@)", contactName, matchStr];
                }
            } else {
                contactName = contact.contact.m_nsNickName;
                if (contact.fieldType != 3) {
                    contactName = [NSString stringWithFormat:@"%@(%@)", contactName, matchStr];
                }
            }
            [subTitleArray addObject:contactName];
        }];
    }
    NSString *subTitle = @"";
    if (subTitleArray.count > 0) {
        subTitle = [NSString stringWithFormat:@"%@%@",TKLocalizedString(@"assistant.search.member"),[subTitleArray componentsJoinedByString:@", "]];
    }
    NSString *imgPath = [[TKCacheManager shareManager] cacheAvatarWithContact:groupContact];
    NSString *wechatId = [groupContact getContactDisplayUsrName];
    
    return @{@"title": [NSString stringWithFormat:@"%@%@", TKLocalizedString(@"assistant.search.group"), groupContact.getGroupDisplayName],
             @"subTitle": subTitle,
             @"icon": imgPath,
             @"userId": groupContact.m_nsUsrName,
             @"copyText": wechatId ?: @"",
             @"url": groupContact.m_nsHeadHDImgUrl ?: @""
             };
}

- (NSString *)matchWithContactResult:(MMComplexContactSearchResult *)result {
    NSString *matchStr = @"";
    NSInteger type = result.fieldType;
    
    switch (type) {     //     1：备注 3：昵称 4：微信号 7：市 8：省份 9：国家
        case 1:
            matchStr = WXLocalizedString(@"Search.Remark");
            break;
        case 3:
            matchStr = WXLocalizedString(@"Search.Nickname");
            break;
        case 4:
            matchStr = WXLocalizedString(@"Search.Username");
            break;
        case 7:
            matchStr = WXLocalizedString(@"Search.City");
            break;
        case 8:
            matchStr = WXLocalizedString(@"Search.Province");
            break;
        case 9:
            matchStr = WXLocalizedString(@"Search.Country");
            break;
        default:
            matchStr = WXLocalizedString(@"Search.Include");
            break;
    }
    matchStr = [matchStr stringByAppendingString:result.fieldValue ?: @""];
    return matchStr;
}

- (NSDictionary *)dictFromContactSearchResult:(MMComplexContactSearchResult *)result {
    if (![result isKindOfClass:objc_getClass("MMComplexContactSearchResult")]) {
        return [self dictWithErrorMsg:result.className];
    }
    WCContactData *contact = result.contact;
    if (!contact) {
        return [self dictWithErrorMsg:@"搜索用户有误"];
    }
    if (contact.m_nsNickName.length == 0) {
        return [self dictWithErrorMsg:@"用户：找不到 m_nsNickName"];
    }
    NSString *title = [contact isBrandContact] ? [NSString stringWithFormat:@"%@%@",TKLocalizedString(@"assistant.search.official"), contact.m_nsNickName] : contact.m_nsNickName;
    if(contact.m_nsRemark && ![contact.m_nsRemark isEqualToString:@""]) {
        title = [NSString stringWithFormat:@"%@(%@)",contact.m_nsRemark, contact.m_nsNickName];
    }
    
    NSString *subTitle =[self matchWithContactResult:result];
    NSString *imgPath = [[TKCacheManager shareManager] cacheAvatarWithContact:contact];
    
    NSString *wechatId = [contact getContactDisplayUsrName];
    return @{@"title": title,
             @"subTitle": subTitle,
             @"icon": imgPath,
             @"userId": contact.m_nsUsrName,
             @"copyText": wechatId ?: @"",
             @"url": contact.m_nsHeadHDImgUrl ?: @""
             };
}

- (NSDictionary *)dictFromSessionInfo:(MMSessionInfo *)sessionInfo {
    if (!sessionInfo) return [self dictWithErrorMsg:@"最近聊天列表有误"];
    
    WCContactData *contact = sessionInfo.m_packedInfo.m_contact;
    MessageData *msgData = sessionInfo.m_packedInfo.m_msgData;
    
    NSString *title = [self getUserNameWithContactData:contact showOriginName:YES];
    NSString *msgContent = [[TKMessageManager shareManager] getMessageContentWithData:msgData];
    NSString *imgPath = [[TKCacheManager shareManager] cacheAvatarWithContact:contact];
    
    NSString *wechatId = [contact getContactDisplayUsrName];
    return @{@"title": title,
             @"subTitle": msgContent,
             @"icon": imgPath,
             @"userId": contact.m_nsUsrName,
             @"copyText": wechatId ?: @"",
             @"url": contact.m_nsHeadHDImgUrl ?: @""
             };
}


- (NSDictionary *)dictWithErrorMsg:(NSString *)msg {
    return @{@"title": msg,
             @"subTitle": @"",
             @"icon": @"",
             @"userId": @"",
             @"copyText": @"",
             @"url": @""
             };
}

- (NSDictionary *)dictFromMessageData:(MessageData *)msgData {
    if (!msgData) {
        return [self dictWithErrorMsg:@"消息不存在"];
    }
    MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
    WCContactData *msgContact = [sessionMgr getContact:msgData.fromUsrName];
    NSString *title = [[TKMessageManager shareManager] getMessageContentWithData:msgData];
    
    NSString *url;
    long long voiceMessSvrId = 0;
    if (msgData.messageType == 1) {
        //        文本消息，如果有链接，传到 copyText 复制
        NSRange range = [objc_getClass("MMLinkInfo") rangeOfUrlInString:title withRange:NSMakeRange(0, title.length)];
        if (range.length > 0) {
            url = [title substringWithRange:range];
            if(![objc_getClass("MMURLHandler") containsHTTPString:url]) {
                url = [NSString stringWithFormat:@"http://%@",url];
            }
        }
    } else if (msgData.isVideoMsg) {
        url = msgData.m_nsVideoPath;
        NSFileManager *manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:url]) {
            MMMessageVideoService *videoMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMMessageVideoService")];
            [videoMgr downloadVideoWithMessage:msgData];
        }
    } else if (msgData.isImgMsg) {
        url = [msgData originalImageFilePath];
        NSFileManager *manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:url]) {
            MMCDNDownloadMgr *imgMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMCDNDownloadMgr")];
            [imgMgr downloadImageWithMessage:msgData];
        }
    } else if (msgData.isCustomEmojiMsg || msgData.isEmojiAppMsg) {
        if ([[TKCacheManager shareManager] fileExistsWithName:msgData.m_nsEmoticonMD5]) {
            url = [[TKCacheManager shareManager] filePathWithName:msgData.m_nsEmoticonMD5];
        } else {
            url = [[TKCacheManager shareManager] cacheEmotionMessage:msgData];
        }
        //        }
        
    } else if(msgData.isVoiceMsg) {
        voiceMessSvrId = msgData.mesSvrID;
        if (msgData.msgVoiceText.length > 0) {
            title = [title stringByAppendingString:msgData.msgVoiceText];
        }
        if (msgData.IsUnPlayed) {
            title = [NSString stringWithFormat:@"%@(%@)",title,TKLocalizedString(@"assistant.search.message.unread")];
        }
    } else if (msgData.messageType == 49) {
        NSString *msgContact = [msgData summaryString:NO];
        if (!msgData.isAppBrandMsg && ![msgContact isEqualToString:WXLocalizedString(@"Message_type_unsupport")]) {
            url = [msgData m_nsAppMediaUrl];
        }
        if (url.length == 0 && msgData.m_nsFilePath.length > 0) {
            url = msgData.m_nsFilePath;
        }
    }
    
    NSString *subTitle = [self getDateStringWithTimeStr:msgData.msgCreateTime];

    NSString *imgPath;
    if ([msgContact isGroupChat]) {
        GroupStorage *contactStorage = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("GroupStorage")];
        WCContactData *fromContact = [contactStorage GetGroupMemberContact:[msgData getChatRoomUsrName]];
        imgPath = [[TKCacheManager shareManager] cacheAvatarWithContact:fromContact];
    } else {
        imgPath = [[TKCacheManager shareManager] cacheAvatarWithContact:msgContact];
    }

    if (!msgContact.isGroupChat) {
        subTitle = [NSString stringWithFormat:@"from: %@   %@",[self getUserNameWithContactData:msgContact showOriginName:NO], subTitle];
    }
    return @{@"title": title,
             @"subTitle": subTitle,
             @"icon": imgPath,
             @"userId": msgContact.m_nsUsrName,
             @"url": url ?: @"",
             @"copyText": url ?: title,
             @"srvId": @(voiceMessSvrId)
             };
}

- (NSString *)getDateStringWithTimeStr:(NSTimeInterval)time {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([date isToday]) {
        formatter.dateFormat = @"HH:mm:ss";
        return [formatter stringFromDate:date];
    } else {
        //昨天
        if ([date isYesterday]) {
            formatter.dateFormat = [NSString stringWithFormat:@"%@ HH:mm:ss", TKLocalizedString(@"assistant.search.yesterday")];
            return [formatter stringFromDate:date];
        } else {
            formatter.dateFormat = @"yy-MM-dd HH:mm:ss";
            return [formatter stringFromDate:date];
        }
    }
    return @"";
}

- (NSString *)getUserNameWithContactData:(WCContactData *)contact showOriginName:(BOOL)showOriginName {
    if (!contact) return @"";
    
    NSString *userName;
    if (contact.isGroupChat) {
        userName = [NSString stringWithFormat:@"%@%@", TKLocalizedString(@"assistant.search.group"), contact.getGroupDisplayName];
    } else if ([contact respondsToSelector:@selector(isBrandContact)]){
        userName = contact.isBrandContact ? [NSString stringWithFormat:@"%@%@",TKLocalizedString(@"assistant.search.official"), contact.m_nsNickName] : contact.m_nsNickName;
        if(contact.m_nsRemark && ![contact.m_nsRemark isEqualToString:@""]) {
            if (showOriginName) {
                userName = [NSString stringWithFormat:@"%@(%@)",contact.m_nsRemark, contact.m_nsNickName];
            } else {
                userName = contact.m_nsRemark;
            }
            
        }
    }
    return userName ?: @"";
}

- (BOOL)isLocalhost:(NSString *)host {
    NSArray *localhostUrls = @[[NSString stringWithFormat:@"127.0.0.1:%d", port],
                               [NSString stringWithFormat:@"localhost:%d", port]
                               ];
    return [localhostUrls containsObject:host];
}

@end
