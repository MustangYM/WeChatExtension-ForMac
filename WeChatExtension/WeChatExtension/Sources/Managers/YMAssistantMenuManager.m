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

static char kAutoReplyWindowControllerKey;         //  自动回复窗口的关联 key
static char kAIAutoReplyWindowControllerKey;         //  AI回复窗口的关联 key
static char kRemoteControlWindowControllerKey;     //  远程控制窗口的关联 key
static char kAboutWindowControllerKey;             //  关于窗口的关联 key
static char kStrangerCheckWindowControllerKey;         //  僵尸粉检测 key

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

- (void)initAssistantMenuItems
{
    //        消息防撤回
    NSMenuItem *preventRevokeItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"开启消息防撤回", @"Revoke")
                                                           action:@selector(onPreventRevoke:)
                                                           target:self
                                                    keyEquivalent:@"T"
                                                            state:[[TKWeChatPluginConfig sharedConfig] preventRevokeEnable]];
    if ([[TKWeChatPluginConfig sharedConfig] preventRevokeEnable]) {
        //        防撤回自己
        NSMenuItem *preventSelfRevokeItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"拦截自己撤回的消息", @"Revoke Self")
                                                                   action:@selector(onPreventSelfRevoke:)
                                                                   target:self
                                                            keyEquivalent:@""
                                                                    state:[[TKWeChatPluginConfig sharedConfig] preventSelfRevokeEnable]];
        
        NSMenuItem *preventAsyncRevokeItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"防撤回同步到手机", @"Revoke Sync To Phone")
                                                                   action:@selector(onPreventAsyncRevokeToPhone:)
                                                                   target:self
                                                            keyEquivalent:@""
                                                                    state:[[TKWeChatPluginConfig sharedConfig] preventAsyncRevokeToPhone]];
        
        if ([[TKWeChatPluginConfig sharedConfig] preventAsyncRevokeToPhone]) {
            NSMenuItem *asyncRevokeSignalItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"同步单聊", @"Sync Single Chat")
                                                                       action:@selector(onAsyncRevokeSignal:)
                                                                       target:self
                                                                keyEquivalent:@""
                                                                        state:[[TKWeChatPluginConfig sharedConfig] preventAsyncRevokeSignal]];
            NSMenuItem *asyncRevokeChatRoomItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"同步群聊", @"Sync Group Chat")
                                                                         action:@selector(onAsyncRevokeChatRoom:)
                                                                         target:self
                                                                  keyEquivalent:@""
                                                                          state:[[TKWeChatPluginConfig sharedConfig] preventAsyncRevokeChatRoom]];
            NSMenu *subAsyncMenu = [[NSMenu alloc] initWithTitle:@""];
            [subAsyncMenu addItems:@[asyncRevokeSignalItem, asyncRevokeChatRoomItem]];
            preventAsyncRevokeItem.submenu = subAsyncMenu;
        }
        
        
        NSMenu *subPreventMenu = [[NSMenu alloc] initWithTitle:YMLocalizedString(@"assistant.menu.revoke")];
        [subPreventMenu addItems:@[preventSelfRevokeItem, preventAsyncRevokeItem]];
        preventRevokeItem.submenu = subPreventMenu;
    }
    
    //        自动回复
    NSMenuItem *autoReplyItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.autoReply")
                                                       action:@selector(onAutoReply:)
                                                       target:self
                                                keyEquivalent:@"k"
                                                        state:[[TKWeChatPluginConfig sharedConfig] autoReplyEnable]];
    //        自动回复
       NSMenuItem *autoAIReplyItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"AI自动回复设置", @"AI-ReplySetting")
                                                          action:@selector(onAutoAIReply:)
                                                          target:self
                                                   keyEquivalent:@"k"
                                                           state:NO];
    
    //        退群监控
        NSMenuItem *quitMonitorItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"退群监控", @"Group-Quitting Monitor")
                                                             action:@selector(onQuitMonitorItem:)
                                                             target:self
                                                      keyEquivalent:@""
                                                              state:[TKWeChatPluginConfig sharedConfig].quitMonitorEnable];
    
    //        登录新微信
    NSMenuItem *newWeChatItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.newWeChat")
                                                       action:@selector(onNewWechatInstance:)
                                                       target:self
                                                keyEquivalent:@"N"
                                                        state:[TKWeChatPluginConfig sharedConfig].isAllowMoreOpenBaby];
    NSMenuItem *miniProgramItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"允许打开小程序", @"Allow MiniProgram to open")
                                                        action:@selector(onMiniProgramItem:)
                                                        target:self
                                                 keyEquivalent:@""
                                                         state:![TKWeChatPluginConfig sharedConfig].isAllowMoreOpenBaby];
    
    //        远程控制
    NSMenuItem *commandItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.remoteControl")
                                                     action:@selector(onRemoteControl:)
                                                     target:self
                                              keyEquivalent:@"C"
                                                      state:0];
    //        微信窗口置顶
    NSMenuItem *onTopItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.windowSticky")
                                                   action:@selector(onWechatOnTopControl:)
                                                   target:self
                                            keyEquivalent:@"D"
                                                    state:[[TKWeChatPluginConfig sharedConfig] onTop]];
    //        免认证登录
    NSMenuItem *autoAuthItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.freeLogin")
                                                      action:@selector(onAutoAuthControl:)
                                                      target:self
                                               keyEquivalent:@""
                                                       state:[[TKWeChatPluginConfig sharedConfig] autoAuthEnable]];
    
    //        使用自带浏览器
    NSMenuItem *enableSystemBrowserItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.systemBrowser")
                                                                action:@selector(onEnableSystemBrowser:)
                                                                target:self
                                                         keyEquivalent:@"B"
                                                                 state:[[TKWeChatPluginConfig sharedConfig] systemBrowserEnable]];
    //        是否禁止微信开启时检测新版本
    NSMenuItem *forbidCheckUpdateItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.forbidCheck")
                                                                 action:@selector(onForbidWeChatCheckUpdate:)
                                                                 target:self
                                                          keyEquivalent:@""
                                                                  state:![[TKWeChatPluginConfig sharedConfig] checkUpdateWechatEnable]];
    
    //        开启 Alfred
    NSMenuItem *enableAlfredItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.enableAlfred")
                                                          action:@selector(onEnableaAlfred:)
                                                          target:self
                                                   keyEquivalent:@""
                                                           state:[[TKWeChatPluginConfig sharedConfig] alfredEnable]];

    //        更新小助手
    NSMenuItem *updatePluginItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.updateAssistant")
                                                          action:@selector(onUpdatePluginControl:)
                                                          target:self
                                                   keyEquivalent:@""
                                                           state:0];
    //        关于小助手
    NSMenuItem *aboutPluginItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.aboutAssistant")
                                                          action:@selector(onAboutPluginControl:)
                                                          target:self
                                                   keyEquivalent:@""
                                                           state:0];
    
    //        关于小助手
    NSMenuItem *pluginItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.other")
                                                          action:@selector(onAboutPluginControl:)
                                                          target:self
                                                   keyEquivalent:@""
                                                           state:0];
    
    NSString *versionStr = YMLanguage(@"当前版本", @"Version");
    NSMenuItem *currentVersionItem = [NSMenuItem menuItemWithTitle:[NSString stringWithFormat:@"%@%@",versionStr,[YMVersionManager shareManager].currentVersion]
                                                    action:@selector(onCurrentVersion:)
                                                    target:self
                                             keyEquivalent:@""
                                                     state:0];
    
    NSMenuItem *backGroundItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"主题模式", @"Themes")
                                                        action:nil
                                                        target:self
                                                 keyEquivalent:@""
                                                         state:TKWeChatPluginConfig.sharedConfig.usingTheme];
    
    NSMenuItem *darkModeItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"黑夜模式", @"Dark Mode")
                                                      action:@selector(onChangeDarkMode:)
                                                      target:self
                                               keyEquivalent:@"N"
                                                       state:[TKWeChatPluginConfig sharedConfig].darkMode];
    
    NSMenuItem *blackModeItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"深邃模式", @"Black Mode")
                                                       action:@selector(onChangeBlackMode:)
                                                       target:self
                                                keyEquivalent:@"N"
                                                        state:TKWeChatPluginConfig.sharedConfig.blackMode];
    
    NSMenuItem *pinkColorItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"少女模式", @"Pink Mode")
                                                       action:@selector(onChangePinkModel:)
                                                       target:self
                                                keyEquivalent:@""
                                                        state:[TKWeChatPluginConfig sharedConfig].pinkMode];
    
    NSMenuItem *groupMulticolorItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"群成员彩色", @"Group Member Multicolor")
                                                             action:@selector(onGroupMultiColorModel:)
                                                             target:self
                                                      keyEquivalent:@""
                                                              state:[TKWeChatPluginConfig sharedConfig].groupMultiColorMode];
    
    NSMenu *subBackgroundMenu = [[NSMenu alloc] initWithTitle:@""];
    [subBackgroundMenu addItems:@[darkModeItem, blackModeItem, pinkColorItem, groupMulticolorItem]];
    backGroundItem.submenu = subBackgroundMenu;
    
    
    NSMenuItem *checkZombieItem = [NSMenuItem menuItemWithTitle:YMLanguage(@"检测僵尸粉", @"Check Stranger")
           action:@selector(onCheckZombie:)
           target:self
    keyEquivalent:@""
            state:0];
    
    NSMenu *subPluginMenu = [[NSMenu alloc] initWithTitle:YMLocalizedString(@"assistant.menu.other")];
    [subPluginMenu addItems:@[enableAlfredItem,
                             updatePluginItem]];
    
    NSMenu *subMenu = [[NSMenu alloc] initWithTitle:YMLocalizedString(@"assistant.menu.title")];

    [subMenu addItems:@[preventRevokeItem,
                        autoReplyItem,
                        autoAIReplyItem,
                        quitMonitorItem,
                        commandItem,
                        miniProgramItem,
                        newWeChatItem,
                        onTopItem,
                        autoAuthItem,
                        enableSystemBrowserItem,
                        backGroundItem,
                        checkZombieItem,
                        pluginItem,
                        aboutPluginItem,
                        currentVersionItem,
                        ]];

    id wechat = LargerOrEqualVersion(@"2.3.24") ? [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMUpdateMgr")] : [objc_getClass("WeChat") sharedInstance];
    [subMenu insertItem:forbidCheckUpdateItem atIndex:7];
    [subMenu setSubmenu:subPluginMenu forItem:pluginItem];
    NSMenuItem *menuItem = [[NSMenuItem alloc] init];
    [menuItem setTitle:YMLocalizedString(@"assistant.menu.title")];
    [menuItem setSubmenu:subMenu];
    menuItem.target = self;
    [[[NSApplication sharedApplication] mainMenu] addItem:menuItem];
    menuItem.enabled = NO;
    
    [self addObserverWeChatConfig];
}

#pragma mark - 僵尸粉
- (void)onCheckZombie:(NSMenuItem *)item
{
    
    WeChat *wechat = [objc_getClass("WeChat") sharedInstance];
    YMStrangerCheckWindowController *autoReplyWC = objc_getAssociatedObject(wechat, &kStrangerCheckWindowControllerKey);

    if (!autoReplyWC) {
        autoReplyWC = [[YMStrangerCheckWindowController alloc] initWithWindowNibName:@"YMStrangerCheckWindowController"];
        objc_setAssociatedObject(wechat, &kStrangerCheckWindowControllerKey, autoReplyWC, OBJC_ASSOCIATION_RETAIN);
    }
    [autoReplyWC show];
    
    
    //

    
    //
    
//    NSArray *contacts = [YMIMContactsManager getAllFriendContactsWithOutChatroom];
//
//    GroupStorage *groupStorage = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("GroupStorage")];
//
//    NSMutableArray *groupMembers = [NSMutableArray array];
//    [contacts enumerateObjectsUsingBlock:^(WCContactData *_Nonnull contactData, NSUInteger idx, BOOL * _Nonnull stop) {
//        GroupMember *member = [[objc_getClass("GroupMember") alloc] init];
//        member.m_nsMemberName = contactData.m_nsUsrName;
//        [groupMembers addObject:member];
//        if (idx == 2) {
//            *stop = YES;
//        }
//    }];
//
//    if (groupMembers.count == 0) {
//        return;
//    }
//
//    [groupStorage CreateGroupChatWithTopic:nil groupMembers:[NSArray arrayWithArray:groupMembers] completion:^(NSString *chatroom) {
//    }];
}

#pragma mark - 监听 WeChatPluginConfig
- (void)addObserverWeChatConfig
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPluginConfigAutoReplyChange) name:NOTIFY_AUTO_REPLY_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPluginConfigPreventRevokeChange) name:NOTIFY_PREVENT_REVOKE_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPluginConfigAutoAuthChange) name:NOTIFY_AUTO_AUTH_CHANGE object:nil];
}

- (void)weChatPluginConfigAutoReplyChange
{
    TKWeChatPluginConfig *shareConfig = [TKWeChatPluginConfig sharedConfig];
    shareConfig.autoReplyEnable = !shareConfig.autoReplyEnable;
    [self changePluginMenuItemWithIndex:1 state:shareConfig.autoReplyEnable];
}

- (void)weChatPluginConfigPreventRevokeChange
{
    TKWeChatPluginConfig *shareConfig = [TKWeChatPluginConfig sharedConfig];
    shareConfig.preventRevokeEnable = !shareConfig.preventRevokeEnable;
    [self changePluginMenuItemWithIndex:0 state:shareConfig.preventRevokeEnable];
}

- (void)weChatPluginConfigAutoAuthChange
{
    TKWeChatPluginConfig *shareConfig = [TKWeChatPluginConfig sharedConfig];
    shareConfig.autoAuthEnable = !shareConfig.autoAuthEnable;
    [self changePluginMenuItemWithIndex:5 state:shareConfig.autoAuthEnable];
}

- (void)changePluginMenuItemWithIndex:(NSInteger)index state:(NSControlStateValue)state
{
    NSMenuItem *pluginMenuItem = [[[[NSApplication sharedApplication] mainMenu] itemArray] lastObject];
    NSMenuItem *item = pluginMenuItem.submenu.itemArray[index];
    item.state = state;
}

#pragma mark - menuItem 的点击事件
/**
 菜单栏-微信小助手-消息防撤回 设置
 
 @param item 消息防撤回的item
 */
- (void)onPreventRevoke:(NSMenuItem *)item
{
    item.state = !item.state;
    [[TKWeChatPluginConfig sharedConfig] setPreventRevokeEnable:item.state];
    if (item.state) {
        //        防撤回自己
        NSMenuItem *preventSelfRevokeItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.revokeSelf")
                                                                   action:@selector(onPreventSelfRevoke:)
                                                                   target:self
                                                            keyEquivalent:@""
                                                                    state:[[TKWeChatPluginConfig sharedConfig] preventSelfRevokeEnable]];
        
        NSMenuItem *preventAsyncRevokeItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.revokeSelfToPhone")
                                                                    action:@selector(onPreventAsyncRevokeToPhone:)
                                                                    target:self
                                                             keyEquivalent:@""
                                                                     state:[[TKWeChatPluginConfig sharedConfig] preventAsyncRevokeToPhone]];
        
        if (preventAsyncRevokeItem.state) {
            NSMenuItem *asyncRevokeSignalItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.revokeSyncSingleChat")
                                                                       action:@selector(onAsyncRevokeSignal:)
                                                                       target:self
                                                                keyEquivalent:@""
                                                                        state:[[TKWeChatPluginConfig sharedConfig] preventAsyncRevokeSignal]];
            NSMenuItem *asyncRevokeChatRoomItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.revokeSyncGroupChat")
                                                                         action:@selector(onAsyncRevokeChatRoom:)
                                                                         target:self
                                                                  keyEquivalent:@""
                                                                          state:[[TKWeChatPluginConfig sharedConfig] preventAsyncRevokeChatRoom]];
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

/**
 菜单栏-微信小助手-消息防撤回-拦截自己消息 设置
 
 @param item 消息防撤回的item
 */
- (void)onPreventSelfRevoke:(NSMenuItem *)item
{
    item.state = !item.state;
    [[TKWeChatPluginConfig sharedConfig] setPreventSelfRevokeEnable:item.state];
}

- (void)onPreventAsyncRevokeToPhone:(NSMenuItem *)item
{
    item.state = !item.state;
    [[TKWeChatPluginConfig sharedConfig] setPreventAsyncRevokeToPhone:item.state];
    [[TKWeChatPluginConfig sharedConfig] setPreventAsyncRevokeSignal:item.state];
    [[TKWeChatPluginConfig sharedConfig] setPreventAsyncRevokeChatRoom:item.state];
    if (item.state) {
        NSMenuItem *asyncRevokeSignalItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.revokeSyncSingleChat")
                                                                   action:@selector(onAsyncRevokeSignal:)
                                                                   target:self
                                                            keyEquivalent:@""
                                                                    state:[[TKWeChatPluginConfig sharedConfig] preventAsyncRevokeSignal]];
        NSMenuItem *asyncRevokeChatRoomItem = [NSMenuItem menuItemWithTitle:YMLocalizedString(@"assistant.menu.revokeSyncGroupChat")
                                                                     action:@selector(onAsyncRevokeChatRoom:)
                                                                     target:self
                                                              keyEquivalent:@""
                                                                      state:[[TKWeChatPluginConfig sharedConfig] preventAsyncRevokeChatRoom]];
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
    [[TKWeChatPluginConfig sharedConfig] setPreventAsyncRevokeSignal:item.state];
}

- (void)onAsyncRevokeChatRoom:(NSMenuItem *)item
{
    item.state = !item.state;
    [[TKWeChatPluginConfig sharedConfig] setPreventAsyncRevokeChatRoom:item.state];
}

/**
 菜单栏-微信小助手-自动回复 设置
 
 @param item 自动回复设置的item
 */
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
    [[TKWeChatPluginConfig sharedConfig] setQuitMonitorEnable:item.state];
}


- (void)onMiniProgramItem:(NSMenuItem *)item
{
    if ([TKWeChatPluginConfig sharedConfig].isAllowMoreOpenBaby) {
        NSAlert *alert = [NSAlert alertWithMessageText:YMLanguage(@"警告", @"WARNING")
                                         defaultButton:YMLanguage(@"取消", @"cancel")                       alternateButton:YMLanguage(@"确定重启",@"restart")
                                           otherButton:nil                              informativeTextWithFormat:@"%@", YMLanguage(@"重启生效, 允许小程序打开, 会导致多开不可用!",@"Restart and take effect. Allowing MiniProgram to open will result in multiple open and unavailable!")];
        NSUInteger action = [alert runModal];
        if (action == NSAlertAlternateReturn) {
            __weak __typeof (self) wself = self;
            [[TKWeChatPluginConfig sharedConfig] setIsAllowMoreOpenBaby:NO];
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
    
    if ([TKWeChatPluginConfig sharedConfig].isAllowMoreOpenBaby) {
        [TKWeChatPluginConfig sharedConfig].launchFromNew = YES;
        [YMRemoteControlManager executeShellCommand:@"open -n /Applications/WeChat.app"];
    } else {
        NSAlert *alert = [NSAlert alertWithMessageText:YMLanguage(@"警告", @"WARNING")
                                         defaultButton:YMLanguage(@"取消", @"cancel")                       alternateButton:YMLanguage(@"确定重启",@"restart")
                                           otherButton:nil                              informativeTextWithFormat:@"%@", YMLanguage(@"多开需要重启微信一次, 且在某些Mac上会导致小程序不可用!",@"You need to restart wechat for multiple opening, And on some Macs, MiniProgram are not available!")];
        NSUInteger action = [alert runModal];
        if (action == NSAlertAlternateReturn ) {
            __weak __typeof (self) wself = self;
            [[TKWeChatPluginConfig sharedConfig] setIsAllowMoreOpenBaby:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [[NSApplication sharedApplication] terminate:wself];
                });
            });
        }  else if (action == NSAlertOtherReturn) {
        }
    }
}

/**
 菜单栏-帮助-远程控制 MAC OS 设置
 
 @param item 远程控制的item
 */
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

/**
 菜单栏-微信小助手-免认证登录 设置
 
 @param item 免认证登录的 item
 */
- (void)onAutoAuthControl:(NSMenuItem *)item
{
    item.state = !item.state;
    [[TKWeChatPluginConfig sharedConfig] setAutoAuthEnable:item.state];
}

/**
 菜单栏-微信小助手-微信窗口置顶
 
 @param item 窗口置顶的 item
 */
- (void)onWechatOnTopControl:(NSMenuItem *)item
{
    item.state = !item.state;
    [[TKWeChatPluginConfig sharedConfig] setOnTop:item.state];
    
    NSArray *windows = [[NSApplication sharedApplication] windows];
    [windows enumerateObjectsUsingBlock:^(NSWindow *window, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![window.className isEqualToString:@"NSStatusBarWindow"]) {
            window.level = item.state == NSControlStateValueOn ? NSNormalWindowLevel+2 : NSNormalWindowLevel;
        }
    }];
}

/**
 菜单栏-微信小助手-更新小助手
 
 @param item 更新小助手的 item
 */
- (void)onUpdatePluginControl:(NSMenuItem *)item
{
    [[TKWeChatPluginConfig sharedConfig] setForbidCheckVersion:NO];
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
    [[TKWeChatPluginConfig sharedConfig] setAlfredEnable:item.state];
}

- (void)onEnableSystemBrowser:(NSMenuItem *)item
{
    item.state = !item.state;
    [[TKWeChatPluginConfig sharedConfig] setSystemBrowserEnable:item.state];
}

- (void)onForbidWeChatCheckUpdate:(NSMenuItem *)item
{
    item.state = !item.state;
    [[TKWeChatPluginConfig sharedConfig] setCheckUpdateWechatEnable:!item.state];
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

- (void)onCurrentVersion:(NSMenuItem *)item
{
    
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
        [[TKWeChatPluginConfig sharedConfig] setBlackMode:item.state];
        item.state ? [[TKWeChatPluginConfig sharedConfig] setDarkMode:NO] : nil;
        item.state ? [[TKWeChatPluginConfig sharedConfig] setPinkMode:NO] : nil;
        !item.state ? [[TKWeChatPluginConfig sharedConfig] setGroupMultiColorMode:NO] : nil;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[NSApplication sharedApplication] terminate:wself];
            });
        });
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
        [[TKWeChatPluginConfig sharedConfig] setDarkMode:item.state];
        item.state ? [[TKWeChatPluginConfig sharedConfig] setBlackMode:NO]: nil;
        item.state ? [[TKWeChatPluginConfig sharedConfig] setPinkMode:NO] : nil;
        !item.state ? [[TKWeChatPluginConfig sharedConfig] setGroupMultiColorMode:NO] : nil;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[NSApplication sharedApplication] terminate:wself];
            });
        });
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
        [[TKWeChatPluginConfig sharedConfig] setPinkMode:item.state];
        item.state ? [[TKWeChatPluginConfig sharedConfig] setDarkMode:NO] : nil;
        item.state ? [[TKWeChatPluginConfig sharedConfig] setBlackMode:NO]: nil;
        item.state ? [[TKWeChatPluginConfig sharedConfig] setGroupMultiColorMode:NO] : nil;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[NSApplication sharedApplication] terminate:wself];
            });
        });
    }  else if (action == NSAlertDefaultReturn) {
        item.state = !item.state;
    }
    
}

- (void)onGroupMultiColorModel:(NSMenuItem *)item
{
    item.state = !item.state;
    
    NSString *msg = nil;
    if ([[TKWeChatPluginConfig sharedConfig] pinkMode]) {
        msg = YMLanguage(@"只在黑暗和深邃模式有效",@"roupMultiColor mode only in dark mode and black mode has effect!");
    } else {
        if (item.state) {
            msg = YMLanguage(@"打开群成员昵称彩色, 只在黑暗/深邃有效, 重启生效!",@"Turn on GroupMultiColor mode only in dark mode and black mode and restart to take effect!");
        } else {
            msg = YMLanguage(@"关闭群成员昵称彩色, 重启生效!",@"Turn off GroupMultiColor mode and restart to take effect!");
        }
    }
    
    NSAlert *alert = [NSAlert alertWithMessageText:YMLanguage(@"警告", @"WARNING")
                                     defaultButton:YMLanguage(@"取消", @"cancel")
                                   alternateButton: TKWeChatPluginConfig.sharedConfig.usingDarkTheme ? YMLanguage(@"确定重启",@"restart") : nil
                                       otherButton:nil                              informativeTextWithFormat:@"%@", msg];
    NSUInteger action = [alert runModal];
    if (action == NSAlertAlternateReturn) {
        __weak __typeof (self) wself = self;
         [[TKWeChatPluginConfig sharedConfig] setGroupMultiColorMode:item.state];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[NSApplication sharedApplication] terminate:wself];
            });
        });
    }  else if (action == NSAlertDefaultReturn) {
        item.state = !item.state;
    }
}
@end
