//
//  TKWeChatPluginConfig.m
//  WeChatExtension
//
//  Created by WeChatExtension on 2017/4/19.
//  Copyright © 2017年 WeChatExtension. All rights reserved.
//

#import "TKWeChatPluginConfig.h"
#import "TKRemoteControlModel.h"
#import "YMAutoReplyModel.h"
#import "TKIgnoreSessonModel.h"
#import "WeChatPlugin.h"

static NSString * const kTKPreventRevokeEnableKey = @"kTKPreventRevokeEnableKey";
static NSString * const kTKPreventSelfRevokeEnableKey = @"kTKPreventSelfRevokeEnableKey";
static NSString * const kTKPreventAsyncRevokeKey = @"kTKPreventAsyncRevokeKey";
static NSString * const KPreventAsyncRevokeSignal = @"KPreventAsyncRevokeSignal";
static NSString * const KPreventAsyncRevokeChatRoom = @"KPreventAsyncRevokeChatRoom";
static NSString * const kTKAutoReplyEnableKey = @"kTKAutoReplyEnableKey";
static NSString * const kTKAutoAuthEnableKey = @"kTKAutoAuthEnableKey";
static NSString * const kTKAutoLoginEnableKey = @"kTKAutoLoginEnableKey";
static NSString * const kTKOnTopKey = @"kTKOnTopKey";
static NSString * const kTKForbidCheckVersionKey = @"kTKForbidCheckVersionKey";
static NSString * const kTKAlfredEnableKey = @"kTKAlfredEnableKey";
static NSString * const kTKCheckUpdateWechatEnableKey = @"kTKCheckUpdateWechatEnableKey";
static NSString * const kTKSystemBrowserEnableKey = @"kTKSystemBrowserEnableKey";
static NSString * const kTKWeChatResourcesPath = @"/Applications/WeChat.app/Contents/MacOS/WeChatExtension.framework/Resources/";
static NSString * const kTKWeChatRemotePlistPath = @"https://raw.githubusercontent.com/MustangYM/WeChatExtension-ForMac/master/WeChatExtension/WeChatExtension/Base.lproj/Info.plist";

@interface TKWeChatPluginConfig ()

@property (nonatomic, copy) NSString *remoteControlPlistFilePath;
@property (nonatomic, copy) NSString *autoReplyPlistFilePath;
@property (nonatomic, copy) NSString *ignoreSessionPlistFilePath;

@property (nonatomic, copy) NSDictionary *localInfoPlist;
@property (nonatomic, copy) NSDictionary *romoteInfoPlist;

@end

@implementation TKWeChatPluginConfig

+ (instancetype)sharedConfig {
    static TKWeChatPluginConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[TKWeChatPluginConfig alloc] init];
    });
    return config;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _preventRevokeEnable = [[NSUserDefaults standardUserDefaults] boolForKey:kTKPreventRevokeEnableKey];
        _preventSelfRevokeEnable = [[NSUserDefaults standardUserDefaults] boolForKey:kTKPreventSelfRevokeEnableKey];
        _autoReplyEnable = [[NSUserDefaults standardUserDefaults] boolForKey:kTKAutoReplyEnableKey];
        _autoAuthEnable = [[NSUserDefaults standardUserDefaults] boolForKey:kTKAutoAuthEnableKey];
        _autoLoginEnable = [[NSUserDefaults standardUserDefaults] boolForKey:kTKAutoLoginEnableKey];
        _onTop = [[NSUserDefaults standardUserDefaults] boolForKey:kTKOnTopKey];
        _forbidCheckVersion = [[NSUserDefaults standardUserDefaults] boolForKey:kTKForbidCheckVersionKey];
        _alfredEnable = [[NSUserDefaults standardUserDefaults] boolForKey:kTKAlfredEnableKey];
        _checkUpdateWechatEnable = [[NSUserDefaults standardUserDefaults] boolForKey:kTKCheckUpdateWechatEnableKey];
        _systemBrowserEnable = [[NSUserDefaults standardUserDefaults] boolForKey:kTKSystemBrowserEnableKey];
        _preventAsyncRevokeToPhone = [[NSUserDefaults standardUserDefaults] boolForKey:kTKPreventAsyncRevokeKey];
        _preventAsyncRevokeSignal = [[NSUserDefaults standardUserDefaults] boolForKey:KPreventAsyncRevokeSignal];
        _preventAsyncRevokeChatRoom = [[NSUserDefaults standardUserDefaults] boolForKey:KPreventAsyncRevokeChatRoom];
    }
    return self;
}

- (void)setPreventRevokeEnable:(BOOL)preventRevokeEnable {
    _preventRevokeEnable = preventRevokeEnable;
    [[NSUserDefaults standardUserDefaults] setBool:preventRevokeEnable forKey:kTKPreventRevokeEnableKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setPreventSelfRevokeEnable:(BOOL)preventSelfRevokeEnable {
    _preventSelfRevokeEnable = preventSelfRevokeEnable;
    [[NSUserDefaults standardUserDefaults] setBool:preventSelfRevokeEnable forKey:kTKPreventSelfRevokeEnableKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setAutoReplyEnable:(BOOL)autoReplyEnable {
    _autoReplyEnable = autoReplyEnable;
    [[NSUserDefaults standardUserDefaults] setBool:autoReplyEnable forKey:kTKAutoReplyEnableKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setAutoAuthEnable:(BOOL)autoAuthEnable {
    _autoAuthEnable = autoAuthEnable;
    [[NSUserDefaults standardUserDefaults] setBool:autoAuthEnable forKey:kTKAutoAuthEnableKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setAutoLoginEnable:(BOOL)autoLoginEnable {
    _autoLoginEnable = autoLoginEnable;
    [[NSUserDefaults standardUserDefaults] setBool:autoLoginEnable forKey:kTKAutoLoginEnableKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setOnTop:(BOOL)onTop {
    _onTop = onTop;
    [[NSUserDefaults standardUserDefaults] setBool:_onTop forKey:kTKOnTopKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setForbidCheckVersion:(BOOL)forbidCheckVersion {
    _forbidCheckVersion = forbidCheckVersion;
    [[NSUserDefaults standardUserDefaults] setBool:_forbidCheckVersion forKey:kTKForbidCheckVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setAlfredEnable:(BOOL)alfredEnable {
    _alfredEnable = alfredEnable;
    [[NSUserDefaults standardUserDefaults] setBool:_alfredEnable forKey:kTKAlfredEnableKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setCheckUpdateWechatEnable:(BOOL)checkUpdateWechatEnable {
    _checkUpdateWechatEnable = checkUpdateWechatEnable;
    [[NSUserDefaults standardUserDefaults] setBool:_checkUpdateWechatEnable forKey:kTKCheckUpdateWechatEnableKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setSystemBrowserEnable:(BOOL)systemBrowserEnable {
    _systemBrowserEnable = systemBrowserEnable;
    [[NSUserDefaults standardUserDefaults] setBool:_systemBrowserEnable forKey:kTKSystemBrowserEnableKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setPreventAsyncRevokeToPhone:(BOOL)preventAsyncRevokeToPhone {
    _preventAsyncRevokeToPhone = preventAsyncRevokeToPhone;
    [[NSUserDefaults standardUserDefaults] setBool:_preventAsyncRevokeToPhone forKey:kTKPreventAsyncRevokeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setPreventAsyncRevokeSignal:(BOOL)preventAsyncRevokeSignal {
    _preventAsyncRevokeSignal = preventAsyncRevokeSignal;
    [[NSUserDefaults standardUserDefaults] setBool:_preventAsyncRevokeSignal forKey:KPreventAsyncRevokeSignal];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setPreventAsyncRevokeChatRoom:(BOOL)preventAsyncRevokeChatRoom {
    _preventAsyncRevokeChatRoom = preventAsyncRevokeChatRoom;
    [[NSUserDefaults standardUserDefaults] setBool:_preventAsyncRevokeChatRoom forKey:KPreventAsyncRevokeChatRoom];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 自动回复
- (NSArray *)autoReplyModels {
    if (!_autoReplyModels) {
        _autoReplyModels = [self getModelsWithClass:[YMAutoReplyModel class] filePath:self.autoReplyPlistFilePath];
    }
    return _autoReplyModels;
}

- (YMAIAutoModel *)AIReplyModel {
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"AIAutoReply.data"];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

- (void)saveAIAutoReplyModel:(YMAIAutoModel *)model
{
    if (!model) {
        return;
    }
    NSString *temp = NSTemporaryDirectory();
     NSString *filePath = [temp stringByAppendingPathComponent:@"AIAutoReply.data"];
     [NSKeyedArchiver archiveRootObject:model toFile:filePath];
}

- (void)saveAutoReplyModels {
    NSMutableArray *needSaveModels = [NSMutableArray array];
    [_autoReplyModels enumerateObjectsUsingBlock:^(YMAutoReplyModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (model.hasEmptyKeywordOrReplyContent) {
            model.enable = NO;
            model.enableGroupReply = NO;
        }
        model.replyContent = model.replyContent == nil ? @"" : model.replyContent;
        model.keyword = model.keyword == nil ? @"" : model.keyword;
        [needSaveModels addObject:model.dictionary];
    }];
    [needSaveModels writeToFile:self.autoReplyPlistFilePath atomically:YES];
}

#pragma mark - 远程控制
- (NSArray *)remoteControlModels {
    if (!_remoteControlModels) {
        __block BOOL needSaveRemoteControlModels = NO;
        _remoteControlModels = ({
            NSArray *originModels = [NSArray arrayWithContentsOfFile:self.remoteControlPlistFilePath];
            NSMutableArray *newRemoteControlModels = [NSMutableArray array];
            [originModels enumerateObjectsUsingBlock:^(NSArray *subModels, NSUInteger idx, BOOL * _Nonnull stop) {
                NSMutableArray *newSubModels = [NSMutableArray array];
                [subModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    TKRemoteControlModel *model = [[TKRemoteControlModel alloc] initWithDict:obj];
                    if ([model.executeCommand isEqualToString:@"restartWeChat"]) {
                        model.executeCommand = @"killWeChat";
                        needSaveRemoteControlModels = YES;
                    }
                    [newSubModels addObject:model];
                }];
                [newRemoteControlModels addObject:newSubModels];
            }];
            newRemoteControlModels;
        });
        if (needSaveRemoteControlModels) {
            [self saveRemoteControlModels];
        }
    }
    return _remoteControlModels;
}

- (void)saveRemoteControlModels {
    NSMutableArray *needSaveModels = [NSMutableArray array];
    [_remoteControlModels enumerateObjectsUsingBlock:^(NSArray *subModels, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *newSubModels = [NSMutableArray array];
        [subModels enumerateObjectsUsingBlock:^(TKRemoteControlModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [newSubModels addObject:obj.dictionary];
        }];
        [needSaveModels addObject:newSubModels];
    }];
    [needSaveModels writeToFile:self.remoteControlPlistFilePath atomically:YES];
}

#pragma mark - 置底
- (NSArray *)ignoreSessionModels {
    if (!_ignoreSessionModels) {
        _ignoreSessionModels = [self getModelsWithClass:[TKIgnoreSessonModel class] filePath:self.ignoreSessionPlistFilePath];
    }
    return _ignoreSessionModels;
}

- (void)saveIgnoreSessionModels {
    NSMutableArray *needSaveArray = [NSMutableArray array];
    [self.ignoreSessionModels enumerateObjectsUsingBlock:^(YMBaseModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [needSaveArray addObject:obj.dictionary];
    }];
    
    [needSaveArray writeToFile:self.ignoreSessionPlistFilePath atomically:YES];
    
}

#pragma mark - 选中的会话
- (NSMutableArray *)selectSessions {
    if (!_selectSessions) {
        _selectSessions = [NSMutableArray array];
    }
    return _selectSessions;
}

#pragma mark - 撤回的消息集合
- (NSMutableSet *)revokeMsgSet {
    if (!_revokeMsgSet) {
        _revokeMsgSet = [NSMutableSet set];
    }
    return _revokeMsgSet;
}

- (NSMutableSet *)unreadSessionSet {
    if (!_unreadSessionSet) {
        _unreadSessionSet = [NSMutableSet set];
    }
    return _unreadSessionSet;
}

#pragma mark - 获取沙盒上的 plist 文件，包括：远程控制，自动回复，置底列表。
- (NSString *)remoteControlPlistFilePath {
    if (!_remoteControlPlistFilePath) {
        _remoteControlPlistFilePath = [self getSandboxFilePathWithPlistName:@"TKRemoteControlCommands.plist"];
    }
    return _remoteControlPlistFilePath;
}

- (NSString *)ignoreSessionPlistFilePath {
    if (!_ignoreSessionPlistFilePath) {
        _ignoreSessionPlistFilePath = [self getSandboxFilePathWithPlistName:@"TKIgnoreSessons.plist"];
    }
    return _ignoreSessionPlistFilePath;
}

- (NSString *)autoReplyPlistFilePath {
    if (!_autoReplyPlistFilePath) {
        _autoReplyPlistFilePath = [self getSandboxFilePathWithPlistName:@"YMAutoReplyModels.plist"];
    }
    return _autoReplyPlistFilePath;
}

#pragma mark - 获取本地 & github 上的小助手 info 信息
- (NSDictionary *)localInfoPlist {
    if (!_localInfoPlist) {
        NSString *localInfoPath = [kTKWeChatResourcesPath stringByAppendingString:@"info.plist"];
        _localInfoPlist = [NSDictionary dictionaryWithContentsOfFile:localInfoPath];
    }
    return _localInfoPlist;
}

- (NSDictionary *)romoteInfoPlist {
    if (!_romoteInfoPlist) {
        NSURL *url = [NSURL URLWithString:kTKWeChatRemotePlistPath];
        _romoteInfoPlist = [NSDictionary dictionaryWithContentsOfURL:url];
    }
    return _romoteInfoPlist;
}

#pragma mark - common
- (NSMutableArray *)getModelsWithClass:(Class)class filePath:(NSString *)filePath {
    NSArray *originModels = [NSArray arrayWithContentsOfFile:filePath];
    NSMutableArray *newModels = [NSMutableArray array];
    
    __weak Class weakClass = class;
    [originModels enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TKIgnoreSessonModel *model = [[weakClass alloc] initWithDict:obj];
        [newModels addObject:model];
    }];
    return newModels;
}

- (NSString *)getSandboxFilePathWithPlistName:(NSString *)plistName {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
    
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *wechatPluginDirectory = [documentDirectory stringByAppendingFormat:@"/TKWeChatPlugin/%@/",currentUserName];
    NSString *plistFilePath = [wechatPluginDirectory stringByAppendingPathComponent:plistName];
    if ([manager fileExistsAtPath:plistFilePath]) {
        return plistFilePath;
    }
    
    [manager createDirectoryAtPath:wechatPluginDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *resourcesFilePath = [kTKWeChatResourcesPath stringByAppendingString:plistName];
    if (![manager fileExistsAtPath:resourcesFilePath]) {
        return plistFilePath;
    }
    
    NSError *error = nil;
    [manager copyItemAtPath:resourcesFilePath toPath:plistFilePath error:&error];
    if (!error) {
        return plistFilePath;
    }
    return resourcesFilePath;
}


-(PluginLanguageType)languageType
{
    NSArray *languages = [NSLocale preferredLanguages];
    PluginLanguageType type = PluginLanguageTypeEN;;
    if (languages.count > 0) {
        NSString *language = languages.firstObject;
        if ([language hasPrefix:@"zh"]) {
            type = PluginLanguageTypeZH;
        }
    }
    return type;
}
@end

