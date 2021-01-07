//
//  YMIMContactsManager.m
//  WeChatExtension
//
//  Created by MustangYM on 2019/6/28.
//  Copyright © 2019 MustangYM. All rights reserved.
//

#import "YMIMContactsManager.h"
#import "YMMessageHelper.h"
#import "YMWeChatPluginConfig.h"

@implementation YMMonitorChildInfo
- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.usrName = dict[@"usrName"];
        self.group = dict[@"group"];
        self.quitTimestamp = [dict[@"quitTimestamp"] doubleValue];
    }
    return self;
}

- (NSDictionary *)dictionary
{
    return @{@"usrName": self.usrName?:@"",
             @"group": self.group?:@"",
             @"quitTimestamp": @(self.quitTimestamp)};
}

@end

@interface YMIMContactsManager()
@property (nonatomic, strong) NSMutableArray *cachePool;
@property (nonatomic, strong) NSMutableArray *taskQueue;
@property (nonatomic, strong) NSTimer *taskTimer;
@end

@implementation YMIMContactsManager

+ (instancetype)shareInstance
{
    static id share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[self alloc] init];
    });
    return share;
}

- (NSMutableArray *)cachePool
{
    if (!_cachePool) {
        _cachePool = [NSMutableArray array];
    }
    return _cachePool;
}

+ (NSString *)getGroupMemberNickNameFromCache:(NSString *)username
{
    if (!username) {
        return nil;
    }
    ContactStorage *contactStorage = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("ContactStorage")];
    WCContactData *data = [contactStorage getContactCache:username];
    
    return data.m_nsNickName;
}

+ (NSString *)getGroupMemberNickName:(NSString *)username
{
    if (!username) {
        return nil;
    }
    GroupStorage *groupStorage = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("GroupStorage")];
    WCContactData *data = [groupStorage GetGroupMemberContact:username];
    return data.m_nsNickName;
}

+ (NSString *)getWeChatNickName:(NSString *)username
{
    NSArray *arr = [self getAllFriendContacts];
    __block NSString *temp = nil;
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WCContactData *contactData = (WCContactData *)obj;
        if ([contactData.m_nsUsrName isEqualToString:username]) {
            temp = contactData.m_nsNickName;
        }
    }];
    
    return temp;
}

+ (WCContactData *)getMemberInfo:(NSString *)userName
{
    NSArray *arr = [self getAllFriendContacts];
    __block WCContactData *temp = nil;
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WCContactData *contactData = (WCContactData *)obj;
        if ([contactData.m_nsUsrName isEqualToString:userName]) {
            temp = contactData;
        }
    }];
    
    return temp;
}

+ (NSArray<WCContactData *> *)getAllFriendContacts
{
    ContactStorage *contactStorage = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("ContactStorage")];
    return [contactStorage GetAllFriendContacts];
}

+ (NSArray<WCContactData *> *)getAllFriendContactsWithOutChatroom
{
    NSArray *arr = [self getAllFriendContacts];
    NSMutableArray *temp = [NSMutableArray array];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WCContactData *contactData = (WCContactData *)obj;
        if (![contactData.m_nsUsrName containsString:@"@chatroom"] && contactData.m_uiSex != 0) {
            [temp addObject:contactData];
        }
    }];
    
    return temp;
}

+ (NSString *)getWeChatAvatar:(NSString *)userName
{
    NSArray *arr = [self getAllFriendContacts];
    __block NSString *temp = nil;
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WCContactData *contactData = (WCContactData *)obj;
        if ([contactData.m_nsUsrName isEqualToString:userName]) {
            temp = contactData.m_nsHeadImgUrl;
        }
    }];
    
    return temp;
}

+ (NSArray<NSString *> *)getAllChatroomFromSessionList
{
    MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
    NSMutableArray *temp = [NSMutableArray array];
    [sessionMgr.m_arrSession enumerateObjectsUsingBlock:^(MMSessionInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.m_nsUserName containsString:@"chatroom"]) {
            [temp addObject:obj.m_nsUserName];
        }
    }];
    return temp;
}

+ (MMSessionInfo *)getSessionInfo:(NSString *)userName
{
    MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
    __block MMSessionInfo *info = nil;
    [sessionMgr.m_arrSession enumerateObjectsUsingBlock:^(MMSessionInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.m_nsUserName isEqualToString:userName]) {
            info = obj;
        }
    }];
    return info;
}

- (void)monitorQuitGroup:(WCContactData *)groupData
{
    if (!groupData) {
        return;
    }
    
    __block BOOL flag = NO;
    [self.taskQueue enumerateObjectsUsingBlock:^(WCContactData  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.m_nsUsrName isEqualToString:groupData.m_nsUsrName]) {
            flag = YES;
            if (*stop) *stop = YES;
        }
    }];
    
    if (flag) return;
    
    [self.taskQueue addObject:groupData];
    
    if (!self.taskTimer) {
        self.taskTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(onDoQuitGroupTask) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.taskTimer forMode:NSDefaultRunLoopMode];
    }
}

- (void)onDoQuitGroupTask
{
    if (self.taskQueue.count == 0) {
        [self.taskTimer invalidate];
        self.taskTimer = nil;
        return;
    }
    
    @synchronized (self) {
        __weak __typeof (self) wself = self;
         [self.taskQueue enumerateObjectsUsingBlock:^(WCContactData  *_Nonnull groupData, NSUInteger idx, BOOL * _Nonnull stop) {
             NSArray *memListArray = [groupData.m_nsChatRoomMemList componentsSeparatedByString:@";"];
             NSDictionary *allDictionary = [(NSMutableDictionary *)groupData.m_chatRoomData valueForKey:@"m_dicData"];
             if (memListArray.count < allDictionary.allKeys.count) {
                 [allDictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSDictionary * _Nonnull obj, BOOL * _Nonnull stop) {
                     if (![memListArray containsObject:key]) {
                         NSString *nick = [YMIMContactsManager getGroupMemberNickName:key];
                         
                         if (nick) {
                             if ([wself queryQuitMsgFromPool:key group:groupData.m_nsUsrName]) {
                                 NSString *message = nil;
                                 if ([YMWeChatPluginConfig sharedConfig].languageType == PluginLanguageTypeZH) {
                                     message = [NSString stringWithFormat:@"⚠️退群监控⚠️\n@%@ 已退群",nick];
                                 } else {
                                     message = [NSString stringWithFormat:@"⚠️Group-Quitting Monitor⚠️\n@%@ has quit group chat",nick];
                                 }
                                 
                                 [YMMessageHelper addLocalWarningMsg:message fromUsr:groupData.m_nsUsrName];
                                 [self addQuitMsgToPool:key group:groupData.m_nsUsrName];
                             }
                         }
                     }
                 }];
             }
             [wself.taskQueue removeObject:groupData];
         }];
    }
}

- (void)addQuitMsgToPool:(NSString *)usrName group:(NSString *)group
{
    if (!usrName || !group) {
        return;
    }
    @synchronized (self) {
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        YMMonitorChildInfo *info = [[YMMonitorChildInfo alloc] init];
        info.quitTimestamp = time;
        info.usrName = usrName;
        info.group = group;
        
        NSMutableArray *array = [[YMWeChatPluginConfig sharedConfig] getMonitorQuitMembers];
        if (!array) {
            array = [NSMutableArray array];
        }
        [array addObject:info];
        if (array.count > 20000) {
            [array removeObjectAtIndex:0];
        }
        [[YMWeChatPluginConfig sharedConfig] saveMonitorQuitMembers:array];
    }
}

- (BOOL)queryQuitMsgFromPool:(NSString *)usrName group:(NSString *)group
{
    if (!usrName || !group) {
        return NO;
    }
    __block BOOL flag = YES;
    NSMutableArray *array = [[YMWeChatPluginConfig sharedConfig] getMonitorQuitMembers];
    [array enumerateObjectsUsingBlock:^(YMMonitorChildInfo *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //已经有退出记录
        if ([obj.usrName isEqualToString:usrName] && [obj.group isEqualToString:group]) {
            flag = NO;
        }
    }];
    return flag;
}

#pragma mark - 僵尸粉
- (void)checkStranger:(NSDictionary *)verifyDict chatroom:(NSString *)chatroom
{
    if (!verifyDict || !chatroom) {
        return;
    }
    
    NSArray *verifys = [verifyDict allKeys];
    __weak __typeof (self) wself = self;
    [verifys enumerateObjectsUsingBlock:^(NSString *_Nonnull usrName, NSUInteger idx, BOOL * _Nonnull stop) {
        wself.onVerifyMsgBlock ? wself.onVerifyMsgBlock(usrName) : nil;
        NSString *nickName = [YMIMContactsManager getWeChatNickName:usrName];
        NSLog(@"验证-%@",nickName);
    }];
}

#pragma mark - Private
- (NSMutableArray *)taskQueue
{
    if (!_taskQueue) {
        _taskQueue = [NSMutableArray array];
    }
    return _taskQueue;
}
@end
