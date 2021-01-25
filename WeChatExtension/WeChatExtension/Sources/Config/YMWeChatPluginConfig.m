//
//  YMWeChatPluginConfig.m
//  WeChatExtension
//
//  Created by WeChatExtension on 2019/4/19.
//  Copyright © 2019年 WeChatExtension. All rights reserved.
//

#import "YMWeChatPluginConfig.h"
#import "TKRemoteControlModel.h"
#import "YMAutoReplyModel.h"
#import "VAutoForwardingModel.h"
#import "TKIgnoreSessonModel.h"
#import "WeChatPlugin.h"
#import "YMIMContactsManager.h"
#import "YMZGMPBanModel.h"
#import "YMZGMPInfoHelper.h"

static NSString * const kTKWeChatResourcesPath = @"/Applications/WeChat.app/Contents/MacOS/WeChatExtension.framework/Resources/";
static NSString * const kTKWeChatRemotePlistPath = @"https://raw.githubusercontent.com/MustangYM/WeChatExtension-ForMac/master/WeChatExtension/WeChatExtension/Base.lproj/Info.plist";

@interface YMWeChatPluginConfig ()

@property (nonatomic, copy) NSString *remoteControlPlistFilePath;
@property (nonatomic, copy) NSString *autoReplyPlistFilePath;
@property (nonatomic, copy) NSString *ignoreSessionPlistFilePath;
@property (nonatomic, copy) NSString *bansPlistFilePath;
@property (nonatomic, copy) NSString *quitMemberPlistPath;
@property (nonatomic, copy) NSDictionary *localInfoPlist;
@property (nonatomic, copy) NSDictionary *romoteInfoPlist;

@end

@implementation YMWeChatPluginConfig

@dynamic preventRevokeEnable;
@dynamic preventSelfRevokeEnable;
@dynamic preventAsyncRevokeToPhone;
@dynamic preventAsyncRevokeSignal;
@dynamic preventAsyncRevokeChatRoom;
@dynamic autoReplyEnable;
@dynamic autoForwardingEnable;
@dynamic autoForwardingAllFriend;
@dynamic autoAuthEnable;
@dynamic launchFromNew;
@dynamic quitMonitorEnable;
@dynamic autoLoginEnable;
@dynamic onTop;
@dynamic multipleSelectionEnable;
@dynamic forbidCheckVersion;
@dynamic alfredEnable;
@dynamic checkUpdateWechatEnable;
@dynamic systemBrowserEnable;
@dynamic currentUserName;
@dynamic isAllowMoreOpenBaby;
@dynamic fuzzyMode;
@dynamic darkMode;
@dynamic blackMode;
@dynamic pinkMode;
@dynamic isThemeLoaded;
@dynamic AIReplyEnable;
@dynamic closeThemeMode;

+ (instancetype)sharedConfig
{
    static YMWeChatPluginConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [YMWeChatPluginConfig standardUserDefaults];
    });
    return config;
}

#pragma mark - 自动回复
- (NSArray *)autoReplyModels
{
    if (!_autoReplyModels) {
        _autoReplyModels = [self getModelsWithClass:[YMAutoReplyModel class] filePath:self.autoReplyPlistFilePath];
    }
    return _autoReplyModels;
}

- (YMAIAutoModel *)AIReplyModel
{
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

- (void)saveAutoReplyModels
{
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

#pragma mark - 群员监控
- (void)saveBanModels
{
    NSMutableArray *bans = [NSMutableArray array];
    [_banModels enumerateObjectsUsingBlock:^(YMZGMPBanModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [bans addObject:model.dictionary];
    }];
    [bans writeToFile:self.bansPlistFilePath atomically:YES];
}

- (void)saveBanGroup:(YMZGMPGroupInfo *)info
{
    __weak __typeof (self) wself = self;
    __block BOOL flag = NO;
    [self.banModels enumerateObjectsUsingBlock:^(YMZGMPBanModel  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([info.wxid isEqualToString:obj.wxid]) {
            flag = YES;
            if (!info.isIgnore) [wself.banModels removeObject:obj];
        }
    }];
    if (info.isIgnore && !flag) {
        YMZGMPBanModel *ban = [[YMZGMPBanModel alloc] init];
        ban.wxid = info.wxid;
        ban.nick = info.nick;
        [self.banModels addObject:ban];
    }
    [self saveBanModels];
}

- (NSMutableArray *)banModels
{
    if (!_banModels) {
        _banModels = [self getModelsWithClass:[YMZGMPBanModel class] filePath:self.bansPlistFilePath];
    }
    return _banModels;
}

#pragma mark - 自动转发
- (NSArray *)VAutoForwardingModel
{
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"AutoForwarding.data"];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

- (void)saveAutoForwardingModel:(VAutoForwardingModel *)model
{
    if (!model) {
        return;
    }
    NSString *temp = NSTemporaryDirectory();
    NSString *filePath = [temp stringByAppendingPathComponent:@"AutoForwarding.data"];
    [NSKeyedArchiver archiveRootObject:model toFile:filePath];
}

#pragma mark - 远程控制
- (NSArray *)remoteControlModels
{
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

- (void)saveRemoteControlModels
{
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
- (NSArray *)ignoreSessionModels
{
    if (!_ignoreSessionModels) {
        _ignoreSessionModels = [self getModelsWithClass:[TKIgnoreSessonModel class] filePath:self.ignoreSessionPlistFilePath];
    }
    return _ignoreSessionModels;
}

- (void)saveIgnoreSessionModels
{
    NSMutableArray *needSaveArray = [NSMutableArray array];
    [self.ignoreSessionModels enumerateObjectsUsingBlock:^(YMBaseModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [needSaveArray addObject:obj.dictionary];
    }];
    
    [needSaveArray writeToFile:self.ignoreSessionPlistFilePath atomically:YES];
    
}

#pragma mark - 选中的会话
- (NSMutableArray *)selectSessions
{
    if (!_selectSessions) {
        _selectSessions = [NSMutableArray array];
    }
    return _selectSessions;
}

#pragma mark - 撤回的消息集合
- (NSMutableSet *)revokeMsgSet
{
    if (!_revokeMsgSet) {
        _revokeMsgSet = [NSMutableSet set];
    }
    return _revokeMsgSet;
}

- (NSMutableSet *)unreadSessionSet
{
    if (!_unreadSessionSet) {
        _unreadSessionSet = [NSMutableSet set];
    }
    return _unreadSessionSet;
}

#pragma mark - 获取沙盒上的 plist 文件，包括：远程控制，自动回复，置底列表。
- (NSString *)remoteControlPlistFilePath
{
    if (!_remoteControlPlistFilePath) {
        _remoteControlPlistFilePath = [self getSandboxFilePathWithPlistName:@"TKRemoteControlCommands.plist"];
    }
    return _remoteControlPlistFilePath;
}

- (NSString *)ignoreSessionPlistFilePath
{
    if (!_ignoreSessionPlistFilePath) {
        _ignoreSessionPlistFilePath = [self getSandboxFilePathWithPlistName:@"TKIgnoreSessons.plist"];
    }
    return _ignoreSessionPlistFilePath;
}

- (NSString *)autoReplyPlistFilePath
{
    if (!_autoReplyPlistFilePath) {
        _autoReplyPlistFilePath = [self getSandboxFilePathWithPlistName:@"YMAutoReplyModels.plist"];
    }
    return _autoReplyPlistFilePath;
}

- (NSString *)quitMemberPlistPath
{
    if (!_quitMemberPlistPath) {
        _quitMemberPlistPath = [self getSandboxFilePathWithPlistName:@"quitMembersPlist.plist"];
    }
    return _quitMemberPlistPath;
}

- (NSString *)bansPlistFilePath
{
    if (!_bansPlistFilePath) {
        _bansPlistFilePath = [self getSandboxFilePathWithPlistName:@"bansPlist.plist"];
    }
    return _bansPlistFilePath;
}

#pragma mark -
- (void)saveMonitorQuitMembers:(NSMutableArray *)members
{
    if (!members) {
        return;
    }
    
    NSMutableArray *needSaveArray = [NSMutableArray array];
    [members enumerateObjectsUsingBlock:^(YMMonitorChildInfo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [needSaveArray addObject:obj.dictionary];
    }];
    
    [needSaveArray writeToFile:self.quitMemberPlistPath atomically:YES];
}

- (NSMutableArray *)getMonitorQuitMembers
{
    NSMutableArray *arr = [self getMonitorQuitModelsWithClass:[YMMonitorChildInfo class] filePath:self.quitMemberPlistPath];
    return arr;
}

#pragma mark - 获取本地 & github 上的小助手 info 信息
- (NSDictionary *)localInfoPlist
{
    if (!_localInfoPlist) {
        NSString *localInfoPath = [kTKWeChatResourcesPath stringByAppendingString:@"info.plist"];
        _localInfoPlist = [NSDictionary dictionaryWithContentsOfFile:localInfoPath];
    }
    return _localInfoPlist;
}

- (NSDictionary *)romoteInfoPlist
{
    if (!_romoteInfoPlist) {
        NSURL *url = [NSURL URLWithString:kTKWeChatRemotePlistPath];
        _romoteInfoPlist = [NSDictionary dictionaryWithContentsOfURL:url];
    }
    return _romoteInfoPlist;
}

#pragma mark - common

- (NSMutableArray *)getMonitorQuitModelsWithClass:(Class)class filePath:(NSString *)filePath
{
    NSArray *originModels = [NSArray arrayWithContentsOfFile:filePath];
    NSMutableArray *newModels = [NSMutableArray array];
    
    __weak Class weakClass = class;
    [originModels enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YMMonitorChildInfo *model = [[weakClass alloc] initWithDict:obj];
        [newModels addObject:model];
    }];
    return newModels;
}

- (NSMutableArray *)getModelsWithClass:(Class)class filePath:(NSString *)filePath
{
    NSArray *originModels = [NSArray arrayWithContentsOfFile:filePath];
    NSMutableArray *newModels = [NSMutableArray array];
    
    __weak Class weakClass = class;
    [originModels enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TKIgnoreSessonModel *model = [[weakClass alloc] initWithDict:obj];
        [newModels addObject:model];
    }];
    return newModels;
}

- (NSString *)getSandboxFilePathWithPlistName:(NSString *)plistName
{
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


- (PluginLanguageType)languageType
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

- (NSString *)languageSetting:(NSString *)chinese english:(NSString *)english
{
    if ([YMWeChatPluginConfig sharedConfig].languageType == PluginLanguageTypeZH) {
        return chinese;
    }
    return english;
}

- (BOOL)usingTheme {
    return self.fuzzyMode || self.darkMode || self.blackMode || self.pinkMode;
}

- (BOOL)usingDarkTheme {
    return self.fuzzyMode || self.darkMode || self.blackMode;
}

- (NSColor *)mainTextColor {
    if (![self usingTheme]) {
        return kDefaultTextColor;
    }
    return self.fuzzyMode ? [NSColor whiteColor] : (self.darkMode ? kDarkModeTextColor : (self.blackMode ? kBlackModeTextColor : kPinkModeTextColor));
}

- (NSColor *)mainBackgroundColor {
    if (![self usingTheme]) {
        return NSColor.clearColor;
    }
    return self.fuzzyMode ? kFuzzyBacgroundColor : (self.darkMode ? kDarkBacgroundColor : (self.blackMode ? kBlackBackgroundColor : kPinkBacgroundColor));
}

- (NSColor *)mainIgnoredTextColor {
    if (![self usingTheme]) {
        return kDefaultIgnoredTextColor;
    }
    return self.fuzzyMode ? kDarkModeIgnoredTextColor : (self.darkMode ? kDarkModeIgnoredTextColor : (self.blackMode ? kBlackModeIgnoredTextColor : kPinkModeIgnoredTextColor));
}

- (NSColor *)mainIgnoredBackgroundColor {
    if (![self usingTheme]) {
        return kDefaultIgnoredBackgroundColor;
    }
    return self.fuzzyMode ? kDarkModeIgnoredBackgroundColor : (self.darkMode ? kDarkModeIgnoredBackgroundColor : (self.blackMode ? kBlackModeIgnoredBackgroundColor : kPinkModeIgnoredBackgroundColor));
}

- (NSColor *)mainSeperatorColor {
    return self.fuzzyMode ? kRGBColor(147, 148, 248, 0.2) : (self.darkMode ? kRGBColor(147, 148, 248, 0.2) : (self.blackMode ? kRGBColor(128,128,128, 0.5) : kRGBColor(147, 148, 248, 0.2)));
}

- (NSColor *)mainScrollerColor {
    return self.fuzzyMode ? kRGBColor(33, 48, 64, 1.0) : (self.darkMode ? kRGBColor(33, 48, 64, 1.0) : (self.blackMode ? kRGBColor(128,128,128, 0.5) : NSColor.clearColor));
}

- (NSColor *)mainDividerColor {
    return self.fuzzyMode ? kRGBColor(71, 69, 112, 0.5) : (self.darkMode ? kRGBColor(71, 69, 112, 0.5) : (self.blackMode ? kRGBColor(128,128,128, 0.7) : kRGBColor(71, 69, 112, 0.5)));
}

- (NSColor *)mainChatCellBackgroundColor {
    return self.fuzzyMode ? kRGBColor(33, 48, 64, 0.3) : (self.darkMode ? kRGBColor(33, 48, 64, 1.0) : (self.blackMode ? kRGBColor(38, 38, 38, 1.0) : nil));
}

@end
