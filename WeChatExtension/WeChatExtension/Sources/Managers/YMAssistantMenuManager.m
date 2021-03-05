//
//  YMAssistantMenuManager.m
//  WeChatExtension
//
//  Created by WeChatExtension on 2018/4/24.
//  Copyright © 2018年 WeChatExtension. All rights reserved.
//

#import "YMAssistantMenuManager.h"
#import "YMRemoteControlManager.h"
#import "TKAutoReplyWindowController.h"
#import "VAutoForwardingWindowController.h"
#import "TKRemoteControlWindowController.h"
#import "YMVersionManager.h"
#import "NSMenuItem+Action.h"
#import "TKDownloadWindowController.h"
#import "TKAboutWindowController.h"
#import "YMWebServerManager.h"
#import "YMMessageManager.h"
#import "YMAIReplyWindowController.h"
#import "YMIMContactsManager.h"
#import "YMStrangerCheckWindowController.h"
#import "YMZGMPWindowController.h"

static char kAutoReplyWindowControllerKey;          //自动回复窗口的关联 key
static char kAutoForwardingWindowControllerKey;     //自动转发窗口的关联 key
static char kAIAutoReplyWindowControllerKey;        //AI回复窗口的关联 key
static char kRemoteControlWindowControllerKey;      //远程控制窗口的关联 key
static char kAboutWindowControllerKey;              //关于窗口的关联 key
static char kStrangerCheckWindowControllerKey;      //僵尸粉检测 key
static char kZGMPWindowControllerKey;               //群管理 key

@implementation YMAssistantMenuManager

+ (instancetype)shareManager
{
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

#pragma mark - 监听 WeChatPluginConfig
- (void)addObserverWeChatConfig
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPluginConfigAutoReplyChange) name:NOTIFY_AUTO_REPLY_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPluginConfigAutoForwardingChange) name:NOTIFY_AUTO_FORWARDING_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPluginConfigAutoForwardingAllChange) name:NOTIFY_AUTO_FORWARDING_ALL_FRIEND_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPluginConfigPreventRevokeChange) name:NOTIFY_PREVENT_REVOKE_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPluginConfigAutoAuthChange) name:NOTIFY_AUTO_AUTH_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPluginConfigAIReplyChange) name:NOTIFY_AI_REPLY_CHANGE object:nil];
}

#pragma mark - MainItems
- (void)initAssistantMenuItems
{
    //登录新微信
    NSMenuItem *newWeChatItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.newWeChat")
                                                       action:@selector(onNewWechatInstance:)
                                                       target:self
                                                keyEquivalent:@"N"
                                                        state:NO];
    NSMenuItem *miniProgramItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"允许打开小程序", @"Allow MiniProgram to open")
                                                        action:@selector(onMiniProgramItem:)
                                                        target:self
                                                 keyEquivalent:@""
                                                         state:![YMWeChatPluginConfig sharedConfig].isAllowMoreOpenBaby];
    
    //远程控制
    NSMenuItem *commandItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.remoteControl")
                                                     action:@selector(onRemoteControl:)
                                                     target:self
                                              keyEquivalent:@"C"
                                                      state:0];
    //微信窗口置顶
    NSMenuItem *onTopItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.windowSticky")
                                                   action:@selector(onWechatOnTopControl:)
                                                   target:self
                                            keyEquivalent:@"D"
                                                    state:[[YMWeChatPluginConfig sharedConfig] onTop]];
    //免认证登录
    NSMenuItem *autoAuthItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.freeLogin")
                                                      action:@selector(onAutoAuthControl:)
                                                      target:self
                                               keyEquivalent:@""
                                                       state:[[YMWeChatPluginConfig sharedConfig] autoAuthEnable]];
    
    //使用自带浏览器
    NSMenuItem *enableSystemBrowserItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.systemBrowser")
                                                                action:@selector(onEnableSystemBrowser:)
                                                                target:self
                                                         keyEquivalent:@"B"
                                                                 state:[[YMWeChatPluginConfig sharedConfig] systemBrowserEnable]];
    //是否禁止微信开启时检测新版本
    NSMenuItem *forbidCheckUpdateItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.forbidCheck")
                                                                 action:@selector(onForbidWeChatCheckUpdate:)
                                                                 target:self
                                                          keyEquivalent:@""
                                                                  state:![[YMWeChatPluginConfig sharedConfig] checkUpdateWechatEnable]];
    
    NSMenuItem *aboutPluginItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.aboutAssistant")
                                                         action:@selector(onAboutPluginControl:)
                                                         target:self
                                                  keyEquivalent:@""
                                                          state:0];
    
    NSMenuItem *pluginItem = [self creatAboutAssistantMenu];
    NSMenuItem *groupMgrMenu = [self creatQuitGroupMenu];
    NSMenuItem *backGroundItem = [self creatThemeMenu];
    NSMenuItem *preventRevokeItem = [self creatRevokeMenuItem];
    NSMenuItem *forwardAndReplyItem = [self creatAutoReplyMenuItem];
    
    NSMenuItem *checkZombieItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"检测僵尸粉", @"Check Stranger")
           action:@selector(onCheckZombie:)
           target:self
    keyEquivalent:@""
            state:0];
    
    NSMenu *subMenu = [[NSMenu alloc] initWithTitle:YMLocalizedString(@"assistant.menu.title")];
    [subMenu addItems:@[preventRevokeItem,
                        autoAuthItem,
                        groupMgrMenu,
                        newWeChatItem,
                        forwardAndReplyItem,
                        enableSystemBrowserItem,
                        commandItem,
                        onTopItem,
                        forbidCheckUpdateItem,
                        pluginItem,
                        aboutPluginItem,
//                        checkZombieItem
                        ]];
    //此版本微信官方包已将小程序独立
    if (LargerOrEqualLongVersion(@"2.4.2.148") == NO) {
        [subMenu insertItem:miniProgramItem atIndex:4];
    }
    
    //低于10.14不适配皮肤
    if (@available(macOS 10.14, *)) {
        [subMenu insertItem:backGroundItem atIndex:2];
    }
    
    NSMenuItem *menuItem = [[NSMenuItem alloc] init];
    menuItem.target = self;
    menuItem.enabled = NO;
    [menuItem setTitle:YMLocalizedString(@"assistant.menu.title")];
    [menuItem setSubmenu:subMenu];
    [[[NSApplication sharedApplication] mainMenu] addItem:menuItem];
    [self addObserverWeChatConfig];
}

#pragma mark - AutoReplyMenuItem
- (NSMenuItem *)creatAutoReplyMenuItem
{
    NSMenuItem *forwardAndReplyItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"转发与回复", @"Auto Chat")
                                                             action:nil
                                                             target:self
                                                      keyEquivalent:@""
                                                              state:NO];
    
    //自动回复
    NSMenuItem *autoReplyItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.autoReply")
                                                       action:@selector(onAutoReply:)
                                                       target:self
                                                keyEquivalent:@"k"
                                                        state:[[YMWeChatPluginConfig sharedConfig] autoReplyEnable]];
    //自动转发
    NSMenuItem *autoForwardingItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.autoForwarding")
                                                            action:@selector(onAutoForwarding:)
                                                            target:self
                                                     keyEquivalent:@"K"
                                                             state:[[YMWeChatPluginConfig sharedConfig] autoForwardingEnable]];
    
    //自动回复
    NSMenuItem *autoAIReplyItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"AI回复设置", @"AI-ReplySetting")
                                                         action:@selector(onAutoAIReply:)
                                                         target:self
                                                  keyEquivalent:@"k"
                                                          state:[[YMWeChatPluginConfig sharedConfig] AIReplyEnable]];
    NSMenu *autoChatMenu = [[NSMenu alloc] initWithTitle:YMLanguage(@"转发与回复", @"Auto Chat")];
    [autoChatMenu addItems:@[autoReplyItem, autoForwardingItem, autoAIReplyItem]];
    forwardAndReplyItem.submenu = autoChatMenu;
    return forwardAndReplyItem;
}

#pragma mark - RevokeMenuItem
- (NSMenuItem *)creatRevokeMenuItem
{
    NSMenuItem *preventRevokeItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"开启消息防撤回", @"Revoke")
                                                           action:@selector(onPreventRevoke:)
                                                           target:self
                                                    keyEquivalent:@"T"
                                                            state:[[YMWeChatPluginConfig sharedConfig] preventRevokeEnable]];
    if ([[YMWeChatPluginConfig sharedConfig] preventRevokeEnable]) {
        NSMenuItem *preventSelfRevokeItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"拦截自己撤回的消息", @"Revoke Self")
                                                                   action:@selector(onPreventSelfRevoke:)
                                                                   target:self
                                                            keyEquivalent:@""
                                                                    state:[[YMWeChatPluginConfig sharedConfig] preventSelfRevokeEnable]];
        
        NSMenuItem *preventAsyncRevokeItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"防撤回同步到手机", @"Revoke Sync To Phone")
                                                                    action:@selector(onPreventAsyncRevokeToPhone:)
                                                                    target:self
                                                             keyEquivalent:@""
                                                                     state:[[YMWeChatPluginConfig sharedConfig] preventAsyncRevokeToPhone]];
        
        if ([[YMWeChatPluginConfig sharedConfig] preventAsyncRevokeToPhone]) {
            NSMenuItem *asyncRevokeSignalItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"同步单聊", @"Sync Single Chat")
                                                                       action:@selector(onAsyncRevokeSignal:)
                                                                       target:self
                                                                keyEquivalent:@""
                                                                        state:[[YMWeChatPluginConfig sharedConfig] preventAsyncRevokeSignal]];
            NSMenuItem *asyncRevokeChatRoomItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"同步群聊", @"Sync Group Chat")
                                                                         action:@selector(onAsyncRevokeChatRoom:)
                                                                         target:self
                                                                  keyEquivalent:@""
                                                                          state:[[YMWeChatPluginConfig sharedConfig] preventAsyncRevokeChatRoom]];
            NSMenu *subAsyncMenu = [[NSMenu alloc] initWithTitle:@""];
            [subAsyncMenu addItems:@[asyncRevokeSignalItem, asyncRevokeChatRoomItem]];
            preventAsyncRevokeItem.submenu = subAsyncMenu;
        }
        
        
        NSMenu *subPreventMenu = [[NSMenu alloc] initWithTitle:YMLocalizedString(@"assistant.menu.revoke")];
        [subPreventMenu addItems:@[preventSelfRevokeItem, preventAsyncRevokeItem]];
        preventRevokeItem.submenu = subPreventMenu;
    }
    
    return preventRevokeItem;
}

#pragma mark - CreatMenuItem
- (NSMenuItem *)creatQuitGroupMenu
{
    NSMenuItem *quitMonitorItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"退群监控", @"Group-Quitting Monitor")
                                                         action:@selector(onQuitMonitorItem:)
                                                         target:self
                                                  keyEquivalent:@""
                                                          state:[YMWeChatPluginConfig sharedConfig].quitMonitorEnable];
    NSMenuItem *ZGMPItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"群员监控", @"ZGMP")
                                                  action:@selector(onZGMPItem:)
                                                  target:self
                                           keyEquivalent:@""
                                                   state:NO];
    
    NSMenuItem *groupMrgItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"群助手", @"Group Assistant")
                                                      action:nil
                                                      target:self
                                               keyEquivalent:@""
                                                       state:NO];
    
    NSMenu *groupMrgMenu = [[NSMenu alloc] initWithTitle:YMLanguage(@"群助手", @"Group Assistant")];
    NSMutableArray *groupArray = [NSMutableArray array];
    [groupArray addObject:quitMonitorItem];
    if (LargerOrEqualLongVersion(@"2.4.2.148")) {
        [groupArray addObject:ZGMPItem];
    }
    [groupMrgMenu addItems:groupArray];
    groupMrgItem.submenu = groupMrgMenu;
    return groupMrgItem;
}

- (NSMenuItem *)creatAboutAssistantMenu
{
    NSMenuItem *enableAlfredItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.enableAlfred")
                                                          action:@selector(onEnableaAlfred:)
                                                          target:self
                                                   keyEquivalent:@""
                                                           state:[[YMWeChatPluginConfig sharedConfig] alfredEnable]];
    
    NSMenuItem *updatePluginItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.updateAssistant")
                                                          action:@selector(onUpdatePluginControl:)
                                                          target:self
                                                   keyEquivalent:@""
                                                           state:0];
    
    NSMenuItem *uninstallPluginItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"卸载小助手", @"Uninstall Assistant")
                                                             action:@selector(onUninstallPluginControl:)
                                                             target:self
                                                      keyEquivalent:@""
                                                              state:0];
    NSMenuItem *pluginItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.other")
                                                    action:@selector(onAboutPluginControl:)
                                                    target:self
                                             keyEquivalent:@""
                                                     state:0];
    NSMenu *subPluginMenu = [[NSMenu alloc] initWithTitle:YMLocalizedString(@"assistant.menu.other")];
    [subPluginMenu addItems:@[enableAlfredItem,
                              updatePluginItem,
                              uninstallPluginItem]];
    pluginItem.submenu = subPluginMenu;
    return pluginItem;
}

- (NSMenuItem *)creatThemeMenu
{
    NSMenuItem *backGroundItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"主题模式", @"Themes")
                                                        action:nil
                                                        target:self
                                                 keyEquivalent:@""
                                                         state:YMWeChatPluginConfig.sharedConfig.usingTheme];
    
    NSMenuItem *fuzzyModeItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"迷离模式", @"Fuzzy Mode")
                                                       action:@selector(onChangeFuzzyMode:)
                                                       target:self
                                                keyEquivalent:@""
                                                        state:[YMWeChatPluginConfig sharedConfig].fuzzyMode];
    
    NSMenuItem *darkModeItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"黑夜模式", @"Dark Mode")
                                                      action:@selector(onChangeDarkMode:)
                                                      target:self
                                               keyEquivalent:@""
                                                       state:[YMWeChatPluginConfig sharedConfig].darkMode];
    
    NSMenuItem *blackModeItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"深邃模式", @"Black Mode")
                                                       action:@selector(onChangeBlackMode:)
                                                       target:self
                                                keyEquivalent:@""
                                                        state:YMWeChatPluginConfig.sharedConfig.blackMode];
    
    NSMenuItem *pinkColorItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"少女模式", @"Pink Mode")
                                                       action:@selector(onChangePinkModel:)
                                                       target:self
                                                keyEquivalent:@""
                                                        state:[YMWeChatPluginConfig sharedConfig].pinkMode];
    
    NSMenuItem *closeThemeItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"关闭皮肤", @"Close")
                                                        action:@selector(onCloseThemeModel:)
                                                        target:self
                                                 keyEquivalent:@""
                                                         state:NO];
    
    NSMenu *subBackgroundMenu = [[NSMenu alloc] initWithTitle:@""];
    [subBackgroundMenu addItems:@[fuzzyModeItem, darkModeItem, blackModeItem, pinkColorItem,closeThemeItem]];
    backGroundItem.submenu = subBackgroundMenu;
    return backGroundItem;
}

- (void)weChatPluginConfigAIReplyChange
{
    [self changePluginMenuItemWithIndex:5 subIndex:2 state:[YMWeChatPluginConfig sharedConfig].AIReplyEnable];
}

- (void)weChatPluginConfigAutoReplyChange
{
    YMWeChatPluginConfig *shareConfig = [YMWeChatPluginConfig sharedConfig];
    shareConfig.autoReplyEnable = !shareConfig.autoReplyEnable;
    [self changePluginMenuItemWithIndex:5 subIndex:0 state:shareConfig.autoReplyEnable];
}

- (void)weChatPluginConfigAutoForwardingChange
{
    YMWeChatPluginConfig *shareConfig = [YMWeChatPluginConfig sharedConfig];
    shareConfig.autoForwardingEnable = !shareConfig.autoForwardingEnable;
    [self changePluginMenuItemWithIndex:5 subIndex:1 state:shareConfig.autoForwardingEnable];
}

- (void)weChatPluginConfigAutoForwardingAllChange
{
    YMWeChatPluginConfig *shareConfig = [YMWeChatPluginConfig sharedConfig];
    shareConfig.autoForwardingAllFriend = !shareConfig.autoForwardingAllFriend;
    [self changePluginMenuItemWithIndex:2 state:shareConfig.autoForwardingAllFriend];
}

- (void)weChatPluginConfigPreventRevokeChange
{
    YMWeChatPluginConfig *shareConfig = [YMWeChatPluginConfig sharedConfig];
    shareConfig.preventRevokeEnable = !shareConfig.preventRevokeEnable;
    [self changePluginMenuItemWithIndex:0 state:shareConfig.preventRevokeEnable];
}

- (void)weChatPluginConfigAutoAuthChange
{
    YMWeChatPluginConfig *shareConfig = [YMWeChatPluginConfig sharedConfig];
    shareConfig.autoAuthEnable = !shareConfig.autoAuthEnable;
    [self changePluginMenuItemWithIndex:5 state:shareConfig.autoAuthEnable];
}

- (void)changePluginMenuItemWithIndex:(NSInteger)index state:(NSControlStateValue)state
{
    NSMenuItem *pluginMenuItem = [[[[NSApplication sharedApplication] mainMenu] itemArray] lastObject];
    NSMenuItem *item = pluginMenuItem.submenu.itemArray[index];
    item.state = state;
}

- (void)changePluginMenuItemWithIndex:(NSInteger)index subIndex:(NSInteger)subIndex  state:(NSControlStateValue)state
{
    NSMenuItem *pluginMenuItem = [[[[NSApplication sharedApplication] mainMenu] itemArray] lastObject];
    NSMenuItem *item = pluginMenuItem.submenu.itemArray[index];
    NSMenuItem *subItem = item.submenu.itemArray[subIndex];
    subItem.state = state;
}

#pragma mark - onMenuItemTap
- (void)onCheckZombie:(NSMenuItem *)item
{
    WeChat *wechat = [objc_getClass("WeChat") sharedInstance];
    YMStrangerCheckWindowController *autoReplyWC = objc_getAssociatedObject(wechat, &kStrangerCheckWindowControllerKey);

    if (!autoReplyWC) {
        autoReplyWC = [[YMStrangerCheckWindowController alloc] initWithWindowNibName:@"YMStrangerCheckWindowController"];
        objc_setAssociatedObject(wechat, &kStrangerCheckWindowControllerKey, autoReplyWC, OBJC_ASSOCIATION_RETAIN);
    }
    [autoReplyWC show];
}

- (void)onPreventRevoke:(NSMenuItem *)item
{
    item.state = !item.state;
    [[YMWeChatPluginConfig sharedConfig] setPreventRevokeEnable:item.state];
    if (item.state) {
        //防撤回自己
        NSMenuItem *preventSelfRevokeItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.revokeSelf")
                                                                   action:@selector(onPreventSelfRevoke:)
                                                                   target:self
                                                            keyEquivalent:@""
                                                                    state:[[YMWeChatPluginConfig sharedConfig] preventSelfRevokeEnable]];
        
        NSMenuItem *preventAsyncRevokeItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.revokeSelfToPhone")
                                                                    action:@selector(onPreventAsyncRevokeToPhone:)
                                                                    target:self
                                                             keyEquivalent:@""
                                                                     state:[[YMWeChatPluginConfig sharedConfig] preventAsyncRevokeToPhone]];
        
        if (preventAsyncRevokeItem.state) {
            NSMenuItem *asyncRevokeSignalItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.revokeSyncSingleChat")
                                                                       action:@selector(onAsyncRevokeSignal:)
                                                                       target:self
                                                                keyEquivalent:@""
                                                                        state:[[YMWeChatPluginConfig sharedConfig] preventAsyncRevokeSignal]];
            NSMenuItem *asyncRevokeChatRoomItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.revokeSyncGroupChat")
                                                                         action:@selector(onAsyncRevokeChatRoom:)
                                                                         target:self
                                                                  keyEquivalent:@""
                                                                          state:[[YMWeChatPluginConfig sharedConfig] preventAsyncRevokeChatRoom]];
            NSMenu *subAsyncMenu = [[NSMenu alloc] initWithTitle:@""];
            [subAsyncMenu addItems:@[asyncRevokeSignalItem, asyncRevokeChatRoomItem]];
            preventAsyncRevokeItem.submenu = subAsyncMenu;
        } else {
            preventAsyncRevokeItem.submenu = nil;
        }
        
        NSMenu *subPreventMenu = [[NSMenu alloc] initWithTitle:YMLocalizedString(@"assistant.menu.revoke")];
        [subPreventMenu addItems:@[preventSelfRevokeItem, preventAsyncRevokeItem]];
        item.submenu = subPreventMenu;
    } else {
        item.submenu = nil;
    }
    
}

- (void)onPreventSelfRevoke:(NSMenuItem *)item
{
    item.state = !item.state;
    [[YMWeChatPluginConfig sharedConfig] setPreventSelfRevokeEnable:item.state];
}

- (void)onPreventAsyncRevokeToPhone:(NSMenuItem *)item
{
    item.state = !item.state;
    [[YMWeChatPluginConfig sharedConfig] setPreventAsyncRevokeToPhone:item.state];
    [[YMWeChatPluginConfig sharedConfig] setPreventAsyncRevokeSignal:item.state];
    [[YMWeChatPluginConfig sharedConfig] setPreventAsyncRevokeChatRoom:item.state];
    if (item.state) {
        NSMenuItem *asyncRevokeSignalItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.revokeSyncSingleChat")
                                                                   action:@selector(onAsyncRevokeSignal:)
                                                                   target:self
                                                            keyEquivalent:@""
                                                                    state:[[YMWeChatPluginConfig sharedConfig] preventAsyncRevokeSignal]];
        NSMenuItem *asyncRevokeChatRoomItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.revokeSyncGroupChat")
                                                                     action:@selector(onAsyncRevokeChatRoom:)
                                                                     target:self
                                                              keyEquivalent:@""
                                                                      state:[[YMWeChatPluginConfig sharedConfig] preventAsyncRevokeChatRoom]];
        NSMenu *subAsyncMenu = [[NSMenu alloc] initWithTitle:@""];
        [subAsyncMenu addItems:@[asyncRevokeSignalItem, asyncRevokeChatRoomItem]];
        item.submenu = subAsyncMenu;
    } else {
        item.submenu = nil;
    }
}

- (void)onAsyncRevokeSignal:(NSMenuItem *)item
{
    item.state = !item.state;
    [[YMWeChatPluginConfig sharedConfig] setPreventAsyncRevokeSignal:item.state];
}

- (void)onAsyncRevokeChatRoom:(NSMenuItem *)item
{
    item.state = !item.state;
    [[YMWeChatPluginConfig sharedConfig] setPreventAsyncRevokeChatRoom:item.state];
}

- (void)onAutoReply:(NSMenuItem *)item
{
    WeChat *wechat = [objc_getClass("WeChat") sharedInstance];
    TKAutoReplyWindowController *autoReplyWC = objc_getAssociatedObject(wechat, &kAutoReplyWindowControllerKey);

    if (!autoReplyWC) {
        autoReplyWC = [[TKAutoReplyWindowController alloc] initWithWindowNibName:@"TKAutoReplyWindowController"];
        objc_setAssociatedObject(wechat, &kAutoReplyWindowControllerKey, autoReplyWC, OBJC_ASSOCIATION_RETAIN);
    }
    [autoReplyWC show];
}

- (void)onAutoForwarding:(NSMenuItem *)item
{
    NSLog(@"Item clicked");
    WeChat *wechat = [objc_getClass("WeChat") sharedInstance];
    VAutoForwardingWindowController *autoForwardingWC = objc_getAssociatedObject(wechat, &kAutoForwardingWindowControllerKey);

    if (!autoForwardingWC) {
        autoForwardingWC = [[VAutoForwardingWindowController alloc] initWithWindowNibName:@"VAutoForwardingWindowController"];
        objc_setAssociatedObject(wechat, &kAutoForwardingWindowControllerKey, autoForwardingWC, OBJC_ASSOCIATION_RETAIN);
    }
    [autoForwardingWC show];
}

- (void)onAutoAIReply:(NSMenuItem *)item
{
    WeChat *wechat = [objc_getClass("WeChat") sharedInstance];
      YMAIReplyWindowController *autoReplyWC = objc_getAssociatedObject(wechat, &kAIAutoReplyWindowControllerKey);

      if (!autoReplyWC) {
          autoReplyWC = [[YMAIReplyWindowController alloc] initWithWindowNibName:@"YMAIReplyWindowController"];
          objc_setAssociatedObject(wechat, &kAIAutoReplyWindowControllerKey, autoReplyWC, OBJC_ASSOCIATION_RETAIN);
      }
      [autoReplyWC show];
}

- (void)onQuitMonitorItem:(NSMenuItem *)item
{
    item.state = !item.state;
    [[YMWeChatPluginConfig sharedConfig] setQuitMonitorEnable:item.state];
}

- (void)onZGMPItem:(NSMenuItem *)item
{
    WeChat *wechat = [objc_getClass("WeChat") sharedInstance];
    YMZGMPWindowController *ZGMPWC = objc_getAssociatedObject(wechat, &kZGMPWindowControllerKey);
    
    if (!ZGMPWC) {
        ZGMPWC = [[YMZGMPWindowController alloc] initWithWindowNibName:@"YMZGMPWindowController"];
        objc_setAssociatedObject(wechat, &kZGMPWindowControllerKey, ZGMPWC, OBJC_ASSOCIATION_RETAIN);
    }
    [ZGMPWC show];
}

- (void)onMiniProgramItem:(NSMenuItem *)item
{
    if ([YMWeChatPluginConfig sharedConfig].isAllowMoreOpenBaby) {
        NSAlert *alert = [NSAlert alertWithMessageText:YMLanguage(@"警告", @"WARNING")
                                         defaultButton:YMLanguage(@"取消", @"cancel")                       alternateButton:YMLanguage(@"确定重启",@"restart")
                                           otherButton:nil                              informativeTextWithFormat:@"%@", YMLanguage(@"重启生效, 允许小程序打开, 会导致多开不可用!",@"Restart and take effect. Allowing MiniProgram to open will result in multiple open and unavailable!")];
        NSUInteger action = [alert runModal];
        if (action == NSAlertAlternateReturn) {
            __weak __typeof (self) wself = self;
            [[YMWeChatPluginConfig sharedConfig] setIsAllowMoreOpenBaby:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [[NSApplication sharedApplication] terminate:wself];
                });
            });
        }  else if (action == NSAlertOtherReturn) {
        }
    } else {
 
    }
}

- (void)onNewWechatInstance:(NSMenuItem *)item
{
    
    if ([YMWeChatPluginConfig sharedConfig].isAllowMoreOpenBaby) {
        [YMWeChatPluginConfig sharedConfig].launchFromNew = YES;
        [YMRemoteControlManager executeShellCommand:@"open -n /Applications/WeChat.app"];
    } else {
        NSAlert *alert = [NSAlert alertWithMessageText:YMLanguage(@"警告", @"WARNING")
                                         defaultButton:YMLanguage(@"取消", @"cancel")                       alternateButton:YMLanguage(@"确定重启",@"restart")
                                           otherButton:nil                              informativeTextWithFormat:@"%@", YMLanguage(@"多开需要重启微信一次, 且在某些Mac上会导致小程序不可用!",@"You need to restart wechat for multiple opening, And on some Macs, MiniProgram are not available!")];
        NSUInteger action = [alert runModal];
        if (action == NSAlertAlternateReturn ) {
            __weak __typeof (self) wself = self;
            [[YMWeChatPluginConfig sharedConfig] setIsAllowMoreOpenBaby:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [[NSApplication sharedApplication] terminate:wself];
                });
            });
        }  else if (action == NSAlertOtherReturn) {
        }
    }
}

- (void)onRemoteControl:(NSMenuItem *)item
{
    WeChat *wechat = [objc_getClass("WeChat") sharedInstance];
    TKRemoteControlWindowController *remoteControlWC = objc_getAssociatedObject(wechat, &kRemoteControlWindowControllerKey);
    
    if (!remoteControlWC) {
        remoteControlWC = [[TKRemoteControlWindowController alloc] initWithWindowNibName:@"TKRemoteControlWindowController"];
        objc_setAssociatedObject(wechat, &kRemoteControlWindowControllerKey, remoteControlWC, OBJC_ASSOCIATION_RETAIN);
    }
    
    [remoteControlWC show];
}

- (void)onAutoAuthControl:(NSMenuItem *)item
{
    item.state = !item.state;
    [[YMWeChatPluginConfig sharedConfig] setAutoAuthEnable:item.state];
}

- (void)onWechatOnTopControl:(NSMenuItem *)item
{
    item.state = !item.state;
    [[YMWeChatPluginConfig sharedConfig] setOnTop:item.state];
    
    NSArray *windows = [[NSApplication sharedApplication] windows];
    [windows enumerateObjectsUsingBlock:^(NSWindow *window, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![window.className isEqualToString:@"NSStatusBarWindow"]) {
            window.level = item.state == NSControlStateValueOn ? NSNormalWindowLevel+2 : NSNormalWindowLevel;
        }
    }];
}

- (void)onUpdatePluginControl:(NSMenuItem *)item
{
    [[YMWeChatPluginConfig sharedConfig] setForbidCheckVersion:NO];
    [[YMVersionManager shareManager] checkVersionFinish:^(TKVersionStatus status, NSString *message) {
        if (status == TKVersionStatusNew) {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert addButtonWithTitle:YMLocalizedString(@"assistant.update.alret.confirm")];
            [alert addButtonWithTitle:YMLocalizedString(@"assistant.update.alret.cancle")];
            [alert setMessageText:YMLocalizedString(@"assistant.update.alret.title")];
            [alert setInformativeText:message];
            NSModalResponse respose = [alert runModal];
            if (respose == NSAlertFirstButtonReturn) {
                [[TKDownloadWindowController downloadWindowController] show];
            }
        } else {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setMessageText:YMLocalizedString(@"assistant.update.alret.latest")];
            [alert setInformativeText:message];
            [alert runModal];
        }
    }];
}

- (void)onEnableaAlfred:(NSMenuItem *)item
{
    item.state = !item.state;
    if (item.state) {
        [[YMWebServerManager shareManager] startServer];
    } else {
        [[YMWebServerManager shareManager] endServer];
    }
    [[YMWeChatPluginConfig sharedConfig] setAlfredEnable:item.state];
}

- (void)onEnableSystemBrowser:(NSMenuItem *)item
{
    item.state = !item.state;
    [[YMWeChatPluginConfig sharedConfig] setSystemBrowserEnable:item.state];
}

- (void)onForbidWeChatCheckUpdate:(NSMenuItem *)item
{
    item.state = !item.state;
    [[YMWeChatPluginConfig sharedConfig] setCheckUpdateWechatEnable:!item.state];
}

- (void)onAboutPluginControl:(NSMenuItem *)item
{
    WeChat *wechat = [objc_getClass("WeChat") sharedInstance];
    TKAboutWindowController *remoteControlWC = objc_getAssociatedObject(wechat, &kAboutWindowControllerKey);
    
    if (!remoteControlWC) {
        remoteControlWC = [[TKAboutWindowController alloc] initWithWindowNibName:@"TKAboutWindowController"];
        objc_setAssociatedObject(wechat, &kAboutWindowControllerKey, remoteControlWC, OBJC_ASSOCIATION_RETAIN);
    }
    
    [remoteControlWC show];
}

- (void)onUninstallPluginControl:(NSMenuItem *)item
{
    NSAlert *alert = [NSAlert alertWithMessageText:YMLanguage(@"警告", @"WARNING")
                                     defaultButton:YMLanguage(@"取消", @"cancel")                       alternateButton:YMLanguage(@"卸载",@"uninstall")
                                       otherButton:nil
                         informativeTextWithFormat:@"%@", YMLanguage(@"是否卸载小助手？重启生效。", @"Do you want to uninstall the assistant? Restart takes effect.")];
    NSUInteger action = [alert runModal];
    
    if (action == NSAlertAlternateReturn) {
        [YMRemoteControlManager executeShellCommand:@"bash <(curl -sL https://git.io/JUO6r)"];
        [self restartWeChat];
    }
}

- (void)onChangeBlackMode:(NSMenuItem *)item
{
    item.state = !item.state;
    NSString *msg = nil;
    if (item.state) {
        msg = YMLanguage(@"打开深邃模式, 重启生效!",@"Turn on BLACK MODE and restart to take effect!");
    } else {
        msg = YMLanguage(@"关闭深邃模式, 重启生效!",@"Turn off BLACK MODE and restart to take effect!");
    }
    NSAlert *alert = [NSAlert alertWithMessageText:YMLanguage(@"警告", @"WARNING")
                                     defaultButton:YMLanguage(@"取消", @"cancel")                       alternateButton:YMLanguage(@"确定重启",@"restart")
                                       otherButton:nil                              informativeTextWithFormat:@"%@", msg];
    NSUInteger action = [alert runModal];
    
    if (action == NSAlertAlternateReturn) {
        __weak __typeof (self) wself = self;
        [[YMWeChatPluginConfig sharedConfig] setBlackMode:item.state];
        item.state ? [[YMWeChatPluginConfig sharedConfig] setDarkMode:NO] : nil;
        item.state ? [[YMWeChatPluginConfig sharedConfig] setPinkMode:NO] : nil;
        item.state ? [[YMWeChatPluginConfig sharedConfig] setFuzzyMode:NO] : nil;
        [wself restartWeChat];
    }  else if (action == NSAlertDefaultReturn) {
        item.state = !item.state;
    }
   
}

- (void)onChangeFuzzyMode:(NSMenuItem *)item
{
    item.state = !item.state;
    NSString *msg = nil;
    if (item.state) {
        msg = YMLanguage(@"打开迷离模式, 重启生效!",@"Turn on fuzzy mode and restart to take effect!");
    } else {
        msg = YMLanguage(@"关闭迷离模式, 重启生效!",@"Turn off fuzzy mode and restart to take effect!");
    }
    NSAlert *alert = [NSAlert alertWithMessageText:YMLanguage(@"警告", @"WARNING")
                                     defaultButton:YMLanguage(@"取消", @"cancel")                       alternateButton:YMLanguage(@"确定重启",@"restart")
                                       otherButton:nil                              informativeTextWithFormat:@"%@", msg];
    NSUInteger action = [alert runModal];
    if (action == NSAlertAlternateReturn) {
        __weak __typeof (self) wself = self;
        [[YMWeChatPluginConfig sharedConfig] setFuzzyMode:item.state];
        item.state ? [[YMWeChatPluginConfig sharedConfig] setDarkMode:NO] : nil;
        item.state ? [[YMWeChatPluginConfig sharedConfig] setBlackMode:NO]: nil;
        item.state ? [[YMWeChatPluginConfig sharedConfig] setPinkMode:NO] : nil;
        [wself restartWeChat];
    }  else if (action == NSAlertDefaultReturn) {
        item.state = !item.state;
    }
}

- (void)onChangeDarkMode:(NSMenuItem *)item
{
    item.state = !item.state;
    NSString *msg = nil;
    if (item.state) {
        msg = YMLanguage(@"打开黑夜模式, 重启生效!",@"Turn on dark mode and restart to take effect!");
    } else {
        msg = YMLanguage(@"关闭黑夜模式, 重启生效!",@"Turn off dark mode and restart to take effect!");
    }
    NSAlert *alert = [NSAlert alertWithMessageText:YMLanguage(@"警告", @"WARNING")
                                     defaultButton:YMLanguage(@"取消", @"cancel")                       alternateButton:YMLanguage(@"确定重启",@"restart")
                                       otherButton:nil                              informativeTextWithFormat:@"%@", msg];
    NSUInteger action = [alert runModal];
    if (action == NSAlertAlternateReturn) {
        __weak __typeof (self) wself = self;
        [[YMWeChatPluginConfig sharedConfig] setDarkMode:item.state];
        item.state ? [[YMWeChatPluginConfig sharedConfig] setBlackMode:NO]: nil;
        item.state ? [[YMWeChatPluginConfig sharedConfig] setPinkMode:NO] : nil;
        item.state ? [[YMWeChatPluginConfig sharedConfig] setFuzzyMode:NO] : nil;
        [wself restartWeChat];
    }  else if (action == NSAlertDefaultReturn) {
        item.state = !item.state;
    }
   
}

- (void)onChangePinkModel:(NSMenuItem *)item
{
    item.state = !item.state;
    NSString *msg = nil;
    if (item.state) {
        msg = YMLanguage(@"打开少女模式, 重启生效!",@"Turn on Pink mode and restart to take effect!");
    } else {
        msg = YMLanguage(@"关闭少女模式, 重启生效!",@"Turn off Pink mode and restart to take effect!");
    }
    NSAlert *alert = [NSAlert alertWithMessageText:YMLanguage(@"警告", @"WARNING")
                                     defaultButton:YMLanguage(@"取消", @"cancel")                       alternateButton:YMLanguage(@"确定重启",@"restart")
                                       otherButton:nil                              informativeTextWithFormat:@"%@", msg];
    NSUInteger action = [alert runModal];
    if (action == NSAlertAlternateReturn) {
        __weak __typeof (self) wself = self;
        [[YMWeChatPluginConfig sharedConfig] setPinkMode:item.state];
        item.state ? [[YMWeChatPluginConfig sharedConfig] setDarkMode:NO] : nil;
        item.state ? [[YMWeChatPluginConfig sharedConfig] setBlackMode:NO]: nil;
        item.state ? [[YMWeChatPluginConfig sharedConfig] setFuzzyMode:NO] : nil;
        [wself restartWeChat];
    }  else if (action == NSAlertDefaultReturn) {
        item.state = !item.state;
    }
    
}

- (void)onCloseThemeModel:(NSMenuItem *)item
{
    if (![YMWeChatPluginConfig sharedConfig].usingTheme) {
        return;
    }
    
    NSString *msg = msg = YMLanguage(@"关闭皮肤模式, 重启生效!",@"Turn off Theme mode and restart to take effect!");;
    NSAlert *alert = [NSAlert alertWithMessageText:YMLanguage(@"警告", @"WARNING")
                                     defaultButton:YMLanguage(@"取消", @"cancel")                       alternateButton:YMLanguage(@"确定重启",@"restart")
                                       otherButton:nil                              informativeTextWithFormat:@"%@", msg];
    NSUInteger action = [alert runModal];
    if (action == NSAlertAlternateReturn) {
        __weak __typeof (self) wself = self;
        [[YMWeChatPluginConfig sharedConfig] setPinkMode:NO];
        [[YMWeChatPluginConfig sharedConfig] setDarkMode:NO];
        [[YMWeChatPluginConfig sharedConfig] setBlackMode:NO];
        [[YMWeChatPluginConfig sharedConfig] setFuzzyMode:NO];
        [wself restartWeChat];
    }
}

#pragma mark - restart
- (void)restartWeChat
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *cmd = @"killall WeChat && sleep 2s && open /Applications/WeChat.app";
        [YMRemoteControlManager executeShellCommand:cmd];
    });
}
@end
