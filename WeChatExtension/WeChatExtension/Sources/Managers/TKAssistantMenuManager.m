//
//  TKAssistantMenuManager.m
//  WeChatPlugin
//
//  Created by TK on 2018/4/24.
//  Copyright © 2018年 tk. All rights reserved.
//

#import "TKAssistantMenuManager.h"
#import "TKRemoteControlManager.h"
#import "TKAutoReplyWindowController.h"
#import "TKRemoteControlWindowController.h"
#import "TKVersionManager.h"
#import "NSMenuItem+Action.h"
#import "TKDownloadWindowController.h"
#import "TKAboutWindowController.h"
#import "TKWebServerManager.h"
#import "TKMessageManager.h"

static char tkAutoReplyWindowControllerKey;         //  自动回复窗口的关联 key
static char tkRemoteControlWindowControllerKey;     //  远程控制窗口的关联 key
static char tkAboutWindowControllerKey;             //  关于窗口的关联 key

@implementation TKAssistantMenuManager

+ (instancetype)shareManager {
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)initAssistantMenuItems {
    //        消息防撤回
    NSMenuItem *preventRevokeItem = [NSMenuItem menuItemWithTitle:TKLocalizedString(@"assistant.menu.revoke")
                                                           action:@selector(onPreventRevoke:)
                                                           target:self
                                                    keyEquivalent:@"t"
                                                            state:[[TKWeChatPluginConfig sharedConfig] preventRevokeEnable]];
    if ([[TKWeChatPluginConfig sharedConfig] preventRevokeEnable]) {
        //        防撤回自己
        NSMenuItem *preventSelfRevokeItem = [NSMenuItem menuItemWithTitle:TKLocalizedString(@"assistant.menu.revokeSelf")
                                                                   action:@selector(onPreventSelfRevoke:)
                                                                   target:self
                                                            keyEquivalent:@""
                                                                    state:[[TKWeChatPluginConfig sharedConfig] preventSelfRevokeEnable]];
        
        NSMenuItem *preventAsyncRevokeItem = [NSMenuItem menuItemWithTitle:@"防撤回同步到手机"
                                                                   action:@selector(onPreventAsyncRevokeToPhone:)
                                                                   target:self
                                                            keyEquivalent:@""
                                                                    state:[[TKWeChatPluginConfig sharedConfig] preventAsyncRevokeToPhone]];
        
        NSMenu *subPreventMenu = [[NSMenu alloc] initWithTitle:TKLocalizedString(@"assistant.menu.revoke")];
        [subPreventMenu addItems:@[preventSelfRevokeItem, preventAsyncRevokeItem]];
        preventRevokeItem.submenu = subPreventMenu;
    }
    
    //        自动回复
    NSMenuItem *autoReplyItem = [NSMenuItem menuItemWithTitle:TKLocalizedString(@"assistant.menu.autoReply")
                                                       action:@selector(onAutoReply:)
                                                       target:self
                                                keyEquivalent:@"k"
                                                        state:[[TKWeChatPluginConfig sharedConfig] autoReplyEnable]];
    //        登录新微信
    NSMenuItem *newWeChatItem = [NSMenuItem menuItemWithTitle:TKLocalizedString(@"assistant.menu.newWeChat")
                                                       action:@selector(onNewWechatInstance:)
                                                       target:self
                                                keyEquivalent:@"N"
                                                        state:0];
    //        远程控制
    NSMenuItem *commandItem = [NSMenuItem menuItemWithTitle:TKLocalizedString(@"assistant.menu.remoteControl")
                                                     action:@selector(onRemoteControl:)
                                                     target:self
                                              keyEquivalent:@"C"
                                                      state:0];
    //        微信窗口置顶
    NSMenuItem *onTopItem = [NSMenuItem menuItemWithTitle:TKLocalizedString(@"assistant.menu.windowSticky")
                                                   action:@selector(onWechatOnTopControl:)
                                                   target:self
                                            keyEquivalent:@"D"
                                                    state:[[TKWeChatPluginConfig sharedConfig] onTop]];
    //        免认证登录
    NSMenuItem *autoAuthItem = [NSMenuItem menuItemWithTitle:TKLocalizedString(@"assistant.menu.freeLogin")
                                                      action:@selector(onAutoAuthControl:)
                                                      target:self
                                               keyEquivalent:@""
                                                       state:[[TKWeChatPluginConfig sharedConfig] autoAuthEnable]];
    
    //        使用自带浏览器
    NSMenuItem *enableSystemBrowserItem = [NSMenuItem menuItemWithTitle:TKLocalizedString(@"assistant.menu.systemBrowser")
                                                                action:@selector(onEnableSystemBrowser:)
                                                                target:self
                                                         keyEquivalent:@"B"
                                                                 state:[[TKWeChatPluginConfig sharedConfig] systemBrowserEnable]];
    //        是否禁止微信开启时检测新版本
    NSMenuItem *forbidCheckUpdateItem = [NSMenuItem menuItemWithTitle:TKLocalizedString(@"assistant.menu.forbidCheck")
                                                                 action:@selector(onForbidWeChatCheckUpdate:)
                                                                 target:self
                                                          keyEquivalent:@""
                                                                  state:![[TKWeChatPluginConfig sharedConfig] checkUpdateWechatEnable]];
    
    //        开启 Alfred
    NSMenuItem *enableAlfredItem = [NSMenuItem menuItemWithTitle:TKLocalizedString(@"assistant.menu.enableAlfred")
                                                          action:@selector(onEnableaAlfred:)
                                                          target:self
                                                   keyEquivalent:@""
                                                           state:[[TKWeChatPluginConfig sharedConfig] alfredEnable]];

    //        更新小助手
    NSMenuItem *updatePluginItem = [NSMenuItem menuItemWithTitle:TKLocalizedString(@"assistant.menu.updateAssistant")
                                                          action:@selector(onUpdatePluginControl:)
                                                          target:self
                                                   keyEquivalent:@""
                                                           state:0];
    //        关于小助手
    NSMenuItem *abountPluginItem = [NSMenuItem menuItemWithTitle:TKLocalizedString(@"assistant.menu.aboutAssistant")
                                                          action:@selector(onAboutPluginControl:)
                                                          target:self
                                                   keyEquivalent:@""
                                                           state:0];
    
    //        关于小助手
    NSMenuItem *pluginItem = [NSMenuItem menuItemWithTitle:TKLocalizedString(@"assistant.menu.other")
                                                          action:@selector(onAboutPluginControl:)
                                                          target:self
                                                   keyEquivalent:@""
                                                           state:0];
    
    //测试发送消息
    NSMenuItem *currentVersionItem = [NSMenuItem menuItemWithTitle:[NSString stringWithFormat:@"当前版本%@",[TKVersionManager shareManager].currentVersion]
                                                    action:@selector(onCurrentVersion:)
                                                    target:self
                                             keyEquivalent:@""
                                                     state:0];
    
    NSMenu *subPluginMenu = [[NSMenu alloc] initWithTitle:TKLocalizedString(@"assistant.menu.other")];
    [subPluginMenu addItems:@[enableAlfredItem,
                             updatePluginItem,
                             abountPluginItem]];
    
    NSMenu *subMenu = [[NSMenu alloc] initWithTitle:TKLocalizedString(@"assistant.menu.title")];

    [subMenu addItems:@[preventRevokeItem,
                        autoReplyItem,
                        commandItem,
                        newWeChatItem,
                        onTopItem,
                        autoAuthItem,
                        enableSystemBrowserItem,
                        pluginItem,
                        currentVersionItem
                        ]];

    id wechat = LargerOrEqualVersion(@"2.3.24") ? [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMUpdateMgr")] : [objc_getClass("WeChat") sharedInstance];
    if ([wechat respondsToSelector:@selector(checkForUpdatesInBackground)]) {
        [subMenu insertItem:forbidCheckUpdateItem atIndex:6];
    }
    [subMenu setSubmenu:subPluginMenu forItem:pluginItem];
    NSMenuItem *menuItem = [[NSMenuItem alloc] init];
    [menuItem setTitle:TKLocalizedString(@"assistant.menu.title")];
    [menuItem setSubmenu:subMenu];
    menuItem.target = self;
    [[[NSApplication sharedApplication] mainMenu] addItem:menuItem];
    menuItem.enabled = NO;
    
    [self addObserverWeChatConfig];
}

#pragma mark - 监听 WeChatPluginConfig

- (void)addObserverWeChatConfig {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPluginConfigAutoReplyChange) name:NOTIFY_AUTO_REPLY_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPluginConfigPreventRevokeChange) name:NOTIFY_PREVENT_REVOKE_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPluginConfigAutoAuthChange) name:NOTIFY_AUTO_AUTH_CHANGE object:nil];
}

- (void)weChatPluginConfigAutoReplyChange {
    TKWeChatPluginConfig *shareConfig = [TKWeChatPluginConfig sharedConfig];
    shareConfig.autoReplyEnable = !shareConfig.autoReplyEnable;
    [self changePluginMenuItemWithIndex:1 state:shareConfig.autoReplyEnable];
}

- (void)weChatPluginConfigPreventRevokeChange {
    TKWeChatPluginConfig *shareConfig = [TKWeChatPluginConfig sharedConfig];
    shareConfig.preventRevokeEnable = !shareConfig.preventRevokeEnable;
    [self changePluginMenuItemWithIndex:0 state:shareConfig.preventRevokeEnable];
}

- (void)weChatPluginConfigAutoAuthChange {
    TKWeChatPluginConfig *shareConfig = [TKWeChatPluginConfig sharedConfig];
    shareConfig.autoAuthEnable = !shareConfig.autoAuthEnable;
    [self changePluginMenuItemWithIndex:5 state:shareConfig.autoAuthEnable];
}

- (void)changePluginMenuItemWithIndex:(NSInteger)index state:(NSControlStateValue)state {
    NSMenuItem *pluginMenuItem = [[[[NSApplication sharedApplication] mainMenu] itemArray] lastObject];
    NSMenuItem *item = pluginMenuItem.submenu.itemArray[index];
    item.state = state;
}

#pragma mark - menuItem 的点击事件
/**
 菜单栏-微信小助手-消息防撤回 设置
 
 @param item 消息防撤回的item
 */
- (void)onPreventRevoke:(NSMenuItem *)item {
    item.state = !item.state;
    [[TKWeChatPluginConfig sharedConfig] setPreventRevokeEnable:item.state];
    if (item.state) {
        //        防撤回自己
        NSMenuItem *preventSelfRevokeItem = [NSMenuItem menuItemWithTitle:TKLocalizedString(@"assistant.menu.revokeSelf")
                                                                   action:@selector(onPreventSelfRevoke:)
                                                                   target:self
                                                            keyEquivalent:@""
                                                                    state:[[TKWeChatPluginConfig sharedConfig] preventSelfRevokeEnable]];
        
        NSMenuItem *preventAsyncRevokeItem = [NSMenuItem menuItemWithTitle:@"防撤回同步到手机"
                                                                    action:@selector(onPreventAsyncRevokeToPhone:)
                                                                    target:self
                                                             keyEquivalent:@""
                                                                     state:[[TKWeChatPluginConfig sharedConfig] preventAsyncRevokeToPhone]];
        
        NSMenu *subPreventMenu = [[NSMenu alloc] initWithTitle:TKLocalizedString(@"assistant.menu.revoke")];
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
- (void)onPreventSelfRevoke:(NSMenuItem *)item {
    item.state = !item.state;
    [[TKWeChatPluginConfig sharedConfig] setPreventSelfRevokeEnable:item.state];
}

- (void)onPreventAsyncRevokeToPhone:(NSMenuItem *)item {
    item.state = !item.state;
    [[TKWeChatPluginConfig sharedConfig] setPreventAsyncRevokeToPhone:item.state];
}

/**
 菜单栏-微信小助手-自动回复 设置
 
 @param item 自动回复设置的item
 */
- (void)onAutoReply:(NSMenuItem *)item {
    WeChat *wechat = [objc_getClass("WeChat") sharedInstance];
    TKAutoReplyWindowController *autoReplyWC = objc_getAssociatedObject(wechat, &tkAutoReplyWindowControllerKey);

    if (!autoReplyWC) {
        autoReplyWC = [[TKAutoReplyWindowController alloc] initWithWindowNibName:@"TKAutoReplyWindowController"];
        objc_setAssociatedObject(wechat, &tkAutoReplyWindowControllerKey, autoReplyWC, OBJC_ASSOCIATION_RETAIN);
    }
    [autoReplyWC show];
}

/**
 打开新的微信
 
 @param item 登录新微信的item
 */
- (void)onNewWechatInstance:(NSMenuItem *)item {
    [TKRemoteControlManager executeShellCommand:@"open -n /Applications/WeChat.app"];
}

/**
 菜单栏-帮助-远程控制 MAC OS 设置
 
 @param item 远程控制的item
 */
- (void)onRemoteControl:(NSMenuItem *)item {
    WeChat *wechat = [objc_getClass("WeChat") sharedInstance];
    TKRemoteControlWindowController *remoteControlWC = objc_getAssociatedObject(wechat, &tkRemoteControlWindowControllerKey);
    
    if (!remoteControlWC) {
        remoteControlWC = [[TKRemoteControlWindowController alloc] initWithWindowNibName:@"TKRemoteControlWindowController"];
        objc_setAssociatedObject(wechat, &tkRemoteControlWindowControllerKey, remoteControlWC, OBJC_ASSOCIATION_RETAIN);
    }
    
    [remoteControlWC show];
}

/**
 菜单栏-微信小助手-免认证登录 设置
 
 @param item 免认证登录的 item
 */
- (void)onAutoAuthControl:(NSMenuItem *)item {
    item.state = !item.state;
    [[TKWeChatPluginConfig sharedConfig] setAutoAuthEnable:item.state];
}

/**
 菜单栏-微信小助手-微信窗口置顶
 
 @param item 窗口置顶的 item
 */
- (void)onWechatOnTopControl:(NSMenuItem *)item {
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
- (void)onUpdatePluginControl:(NSMenuItem *)item {
    [[TKWeChatPluginConfig sharedConfig] setForbidCheckVersion:NO];
    [[TKVersionManager shareManager] checkVersionFinish:^(TKVersionStatus status, NSString *message) {
        if (status == TKVersionStatusNew) {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert addButtonWithTitle:TKLocalizedString(@"assistant.update.alret.confirm")];
            [alert addButtonWithTitle:TKLocalizedString(@"assistant.update.alret.cancle")];
            [alert setMessageText:TKLocalizedString(@"assistant.update.alret.title")];
            [alert setInformativeText:message];
            NSModalResponse respose = [alert runModal];
            if (respose == NSAlertFirstButtonReturn) {
                [[TKDownloadWindowController downloadWindowController] show];
            }
        } else {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setMessageText:TKLocalizedString(@"assistant.update.alret.latest")];
            [alert setInformativeText:message];
            [alert runModal];
        }
    }];
}

- (void)onEnableaAlfred:(NSMenuItem *)item {
    item.state = !item.state;
    if (item.state) {
        [[TKWebServerManager shareManager] startServer];
    } else {
        [[TKWebServerManager shareManager] endServer];
    }
    [[TKWeChatPluginConfig sharedConfig] setAlfredEnable:item.state];
}

- (void)onEnableSystemBrowser:(NSMenuItem *)item {
    item.state = !item.state;
    [[TKWeChatPluginConfig sharedConfig] setSystemBrowserEnable:item.state];
}

- (void)onForbidWeChatCheckUpdate:(NSMenuItem *)item {
    item.state = !item.state;
    [[TKWeChatPluginConfig sharedConfig] setCheckUpdateWechatEnable:!item.state];
}

- (void)onAboutPluginControl:(NSMenuItem *)item {
    WeChat *wechat = [objc_getClass("WeChat") sharedInstance];
    TKAboutWindowController *remoteControlWC = objc_getAssociatedObject(wechat, &tkAboutWindowControllerKey);
    
    if (!remoteControlWC) {
        remoteControlWC = [[TKAboutWindowController alloc] initWithWindowNibName:@"TKAboutWindowController"];
        objc_setAssociatedObject(wechat, &tkAboutWindowControllerKey, remoteControlWC, OBJC_ASSOCIATION_RETAIN);
    }
    
    [remoteControlWC show];
}

- (void)onCurrentVersion:(NSMenuItem *)item {
    
}
@end
