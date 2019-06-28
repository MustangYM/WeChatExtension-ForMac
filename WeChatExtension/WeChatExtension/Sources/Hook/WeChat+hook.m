//
//  WeChat+hook.m
//  WeChatExtension
//
//  Created by WeChatExtension on 2017/4/19.
//  Copyright © 2017年 WeChatExtension. All rights reserved.
//

#import "WeChat+hook.h"
#import "WeChatPlugin.h"
#import "fishhook.h"
#import "TKIgnoreSessonModel.h"
#import "TKWebServerManager.h"
#import "YMMessageManager.h"
#import "TKAssistantMenuManager.h"
#import "TKAutoReplyModel.h"
#import "TKVersionManager.h"
#import "TKRemoteControlManager.h"
#import "TKDownloadWindowController.h"
#import "YMMessageTool.h"
#import "YMMessageModel.h"
#import "YMUpdateManager.h"
#import "ANYMethodLog.h"

@implementation NSObject (WeChatHook)
/*
 IMessageExt 上传下载的协议
 MMMessageCacheMgr 消息的缓存
 */
+ (void)hookWeChat {
  
    //      微信撤回消息
    SEL revokeMsgMethod = LargerOrEqualVersion(@"2.3.22") ? @selector(FFToNameFavChatZZ:) : @selector(onRevokeMsg:);
    tk_hookMethod(objc_getClass("MessageService"), revokeMsgMethod, [self class], @selector(hook_onRevokeMsg:));
    //      微信消息同步
    SEL syncBatchAddMsgsMethod = LargerOrEqualVersion(@"2.3.22") ? @selector(FFImgToOnFavInfoInfoVCZZ:isFirstSync:) : @selector(OnSyncBatchAddMsgs:isFirstSync:);
    tk_hookMethod(objc_getClass("MessageService"), syncBatchAddMsgsMethod, [self class], @selector(hook_OnSyncBatchAddMsgs:isFirstSync:));
    //      微信多开
    SEL hasWechatInstanceMethod = LargerOrEqualVersion(@"2.3.22") ? @selector(FFSvrChatInfoMsgWithImgZZ) : @selector(HasWechatInstance);
    tk_hookClassMethod(objc_getClass("CUtility"), hasWechatInstanceMethod, [self class], @selector(hook_HasWechatInstance));
    
    //多开
    tk_hookClassMethod(objc_getClass("NSRunningApplication"), @selector(runningApplicationsWithBundleIdentifier:), [self class], @selector(hook_runningApplicationsWithBundleIdentifier:));
    
    //      免认证登录
    tk_hookMethod(objc_getClass("MMLoginOneClickViewController"), @selector(onLoginButtonClicked:), [self class], @selector(hook_onLoginButtonClicked:));
    
    SEL sendLogoutCGIWithCompletionMethod = LargerOrEqualVersion(@"2.3.22") ? @selector(FFVCRecvDataAddDataToMsgChatMgrRecvZZ:) : @selector(sendLogoutCGIWithCompletion:);
    tk_hookMethod(objc_getClass("LogoutCGI"), sendLogoutCGIWithCompletionMethod, [self class], @selector(hook_sendLogoutCGIWithCompletion:));
    
    SEL manualLogoutMethod = LargerOrEqualVersion(@"2.3.22") ? @selector(FFAddSvrMsgImgVCZZ) : @selector(ManualLogout);
    tk_hookMethod(objc_getClass("AccountService"), manualLogoutMethod, [self class], @selector(hook_ManualLogout));

    //      自动登录
    tk_hookMethod(objc_getClass("MMLoginOneClickViewController"), @selector(viewWillAppear), [self class], @selector(hook_viewWillAppear));
    //      置底
    SEL sortSessionsMethod = LargerOrEqualVersion(@"2.3.22") ? @selector(FFDataSvrMgrSvrFavZZ) : @selector(sortSessions);
    tk_hookMethod(objc_getClass("MMSessionMgr"), sortSessionsMethod, [self class], @selector(hook_sortSessions));
    //      窗口置顶
    tk_hookMethod(objc_getClass("NSWindow"), @selector(makeKeyAndOrderFront:), [self class], @selector(hook_makeKeyAndOrderFront:));
    //      快捷回复
    tk_hookMethod(objc_getClass("_NSConcreteUserNotificationCenter"), @selector(deliverNotification:), [self class], @selector(hook_deliverNotification:));
    tk_hookMethod(objc_getClass("MMNotificationService"), @selector(userNotificationCenter:didActivateNotification:), [self class], @selector(hook_userNotificationCenter:didActivateNotification:));
    tk_hookMethod(objc_getClass("MMNotificationService"), @selector(getNotificationContentWithMsgData:), [self class], @selector(hook_getNotificationContentWithMsgData:));
    //      登录逻辑
    tk_hookMethod(objc_getClass("MMMainViewController"), @selector(viewDidLoad), [self class], @selector(hook_mainViewControllerDidLoad));

    //      自带浏览器打开链接
    LargerOrEqualVersion(@"2.3.22") ? tk_hookClassMethod(objc_getClass("MMWebViewHelper"), @selector(handleWebViewDataItem:windowId:), [self class], @selector(hook_handleWebViewDataItem:windowId:)) :  tk_hookClassMethod(objc_getClass("MMWebViewHelper"), @selector(preHandleWebUrlStr:withMessage:), [self class], @selector(hook_preHandleWebUrlStr:withMessage:));
    
    tk_hookMethod(objc_getClass("MMURLHandler"), @selector(startGetA8KeyWithURL:), [self class], @selector(hook_startGetA8KeyWithURL:));
    tk_hookMethod(objc_getClass("WeChat"), @selector(applicationDidFinishLaunching:), [self class], @selector(hook_applicationDidFinishLaunching:));
    
    tk_hookMethod(objc_getClass("UserDefaultsService"), @selector(stringForKey:), [self class], @selector(hook_stringForKey:));
    
    //    设置标记未读
    tk_hookMethod(objc_getClass("MMChatMessageViewController"), @selector(onClickSession), [self class], @selector(hook_onClickSession));
    tk_hookMethod(objc_getClass("MMSessionMgr"), @selector(onUnReadCountChange:), [self class], @selector(hook_onUnReadCountChange:));

    //      替换沙盒路径
    rebind_symbols((struct rebinding[2]) {
        { "NSSearchPathForDirectoriesInDomains", swizzled_NSSearchPathForDirectoriesInDomains, (void *)&original_NSSearchPathForDirectoriesInDomains },
        { "NSHomeDirectory", swizzled_NSHomeDirectory, (void *)&original_NSHomeDirectory }
    }, 2);
    
    [self setup];
    
    tk_hookMethod(objc_getClass("LazyExtensionAgent"), @selector(ensureLazyListenerInitedForExtension: withSelector:), [self class], @selector(hook_ensureLazyListenerInitedForExtension:withSelector:));
    
//    [ANYMethodLog logMethodWithClass:[objc_getClass("ContactStorage") class] condition:^BOOL(SEL sel) {
//        return YES;
//    } before:^(id target, SEL sel, NSArray *args, int deep) {
//        NSLog(@"\n🐸类名:%@ 👍方法:%@\n%@", target, NSStringFromSelector(sel),args);
//    } after:^(id target, SEL sel, NSArray *args, NSTimeInterval interval, int deep, id retValue) {
//        NSLog(@"\n🚘类名:%@ 👍方法:%@\n%@\n↪️%@", target, NSStringFromSelector(sel),args,retValue);
//    }];
}


//主控制器的生命周期
- (void)hook_mainViewControllerDidLoad {
    [self hook_mainViewControllerDidLoad];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([[TKWeChatPluginConfig sharedConfig] alfredEnable]) {
            [[TKWebServerManager shareManager] startServer];
        }
        NSMenu *mainMenu = [[NSApplication sharedApplication] mainMenu];
        NSMenuItem *pluginMenu = mainMenu.itemArray.lastObject;
        pluginMenu.enabled = YES;
        NSMenuItem *preventMenu = pluginMenu.submenu.itemArray.firstObject;
        preventMenu.enabled = YES;
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       [[YMUpdateManager shareInstance] checkWeChatExtensionUpdate];
    });
}

- (void)hook_ensureLazyListenerInitedForExtension:(id)arg1 withSelector:(SEL)arg2 {
    NSString *sel = NSStringFromSelector(arg2);
    if (![sel isEqualToString:@"onLongLinkConnectionChanged:"]
        &&![sel isEqualToString:@"onProgress:"]
        &&![sel isEqualToString:@"onUploadResult:"]
        &&![sel isEqualToString:@"onUnReadCountChange:"]
        &&![sel isEqualToString:@"onSyncFinishWithStatus:withOnlineVersion:"]
        &&![sel isEqualToString:@"onSyncSuccess"]
        &&![sel isEqualToString:@"onRecvChatSyncMsg:"]
        &&![sel isEqualToString:@"AskSessionByUserName:isHandled:"]
        &&![sel isEqualToString:@"onModMsg:msgData:"]
        &&![sel isEqualToString:@"onAppMsgSendFinish:msgData:"]
        &&![sel isEqualToString:@"messageFileService:didFinishUploadWithMessage:"]
        &&![sel isEqualToString:@"onGetNewXmlMsg:type:msgData:"]
        ) {
        NSLog(@"方法:%@",sel);
    }
    [self hook_ensureLazyListenerInitedForExtension:arg1 withSelector:arg2];
}

+ (void)setup {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //        窗口置顶初始化
        [self setupWindowSticky];
    });
    [self checkPluginVersion];
    //    监听 NSWindow 最小化通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowsWillMiniaturize:) name:NSWindowWillMiniaturizeNotification object:nil];
}

+ (void)setupWindowSticky {
    BOOL onTop = [[TKWeChatPluginConfig sharedConfig] onTop];
    WeChat *wechat = [objc_getClass("WeChat") sharedInstance];
    wechat.mainWindowController.window.level = onTop == NSControlStateValueOn ? NSNormalWindowLevel+2 : NSNormalWindowLevel;
}

+ (void)checkPluginVersion {
    if ([[TKWeChatPluginConfig sharedConfig] forbidCheckVersion]) return;
    
    [[TKVersionManager shareManager] checkVersionFinish:^(TKVersionStatus status, NSString *message) {
        if (status == TKVersionStatusNew) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSAlert *alert = [[NSAlert alloc] init];
                [alert addButtonWithTitle:TKLocalizedString(@"assistant.update.alret.confirm")];
                [alert addButtonWithTitle:TKLocalizedString(@"assistant.update.alret.forbid")];
                [alert addButtonWithTitle:TKLocalizedString(@"assistant.update.alret.cancle")];
                [alert setMessageText:TKLocalizedString(@"assistant.update.alret.title")];
                [alert setInformativeText:message];
                NSModalResponse respose = [alert runModal];
                if (respose == NSAlertFirstButtonReturn) {
                    [[TKDownloadWindowController downloadWindowController] show];
                } else if (respose == NSAlertSecondButtonReturn) {
                    [[TKWeChatPluginConfig sharedConfig] setForbidCheckVersion:YES];
                }
            });
        }
    }];
}

/**
 登录界面-自动登录
 
 @param btn 自动登录按钮
 */
- (void)selectAutoLogin:(NSButton *)btn {
    [[TKWeChatPluginConfig sharedConfig] setAutoLoginEnable:btn.state];
}

#pragma mark - hook 微信方法
/**
 hook 微信是否已启动
 
 */
+ (BOOL)hook_HasWechatInstance {
    return NO;
}

+ (NSArray *)hook_runningApplicationsWithBundleIdentifier:(id)arg1 {
    return @[];
}

//发送消息后, 用于刷新聊天页面
- (void)hook_notifyAddMsgOnMainThread:(id)arg1 msgData:(id)msgData {
    return [self hook_notifyAddMsgOnMainThread:arg1 msgData:msgData];
}

- (void)hook_originalImageDidLoadWithUniqueID:(id)arg1 image:(id)arg2; {
    
    
    return [self hook_originalImageDidLoadWithUniqueID:arg1 image:arg2];
}


/**
 hook 微信撤回消息
 
 */
- (void)hook_onRevokeMsg:(id)msgData {
    if (![[TKWeChatPluginConfig sharedConfig] preventRevokeEnable]) {
        [self hook_onRevokeMsg:msgData];
        return;
    }
    id msg = msgData;
    if ([msgData isKindOfClass:objc_getClass("MessageData")]) {
        msg = [msgData valueForKey:@"msgContent"];
    }
    if ([msg rangeOfString:@"<sysmsg"].length <= 0) return;
    
    //      转换群聊的 msg
    NSString *msgContent = [msg substringFromIndex:[msg rangeOfString:@"<sysmsg"].location];
    
    //      xml 转 dict
    XMLDictionaryParser *xmlParser = [objc_getClass("XMLDictionaryParser") sharedInstance];
    NSDictionary *msgDict = [xmlParser dictionaryWithString:msgContent];
    
    if (msgDict && msgDict[@"revokemsg"]) {
        NSString *newmsgid = msgDict[@"revokemsg"][@"newmsgid"];
        NSString *session =  msgDict[@"revokemsg"][@"session"];
        msgDict = nil;
        
        NSMutableSet *revokeMsgSet = [[TKWeChatPluginConfig sharedConfig] revokeMsgSet];
        //      该消息已进行过防撤回处理
        if ([revokeMsgSet containsObject:newmsgid] || !newmsgid) {
            return;
        }
        [revokeMsgSet addObject:newmsgid];
        
        //      获取原始的撤回提示消息
        MessageService *msgService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MessageService")];
        MessageData *revokeMsgData = [msgService GetMsgData:session svrId:[newmsgid integerValue]];
        
        [[YMMessageManager shareManager] asyncRevokeMessage:revokeMsgData];
        
        if ([revokeMsgData isSendFromSelf] && ![[TKWeChatPluginConfig sharedConfig] preventSelfRevokeEnable]) {
            [self hook_onRevokeMsg:msgData];
            return;
        }
        NSString *msgContent = [[YMMessageManager shareManager] getMessageContentWithData:revokeMsgData];
        NSString *newMsgContent = [NSString stringWithFormat:@"%@ \n%@",TKLocalizedString(@"assistant.revoke.otherMessage.tip"), msgContent];
        MessageData *newMsgData = ({
            MessageData *msg = [[objc_getClass("MessageData") alloc] initWithMsgType:0x2710];
            [msg setFromUsrName:revokeMsgData.toUsrName];
            [msg setToUsrName:revokeMsgData.fromUsrName];
            [msg setMsgStatus:4];
            [msg setMsgContent:newMsgContent];
            [msg setMsgCreateTime:[revokeMsgData msgCreateTime]];
            //   [msg setMesLocalID:[revokeMsgData mesLocalID]];
            
            msg;
        });
        
        [msgService AddLocalMsg:session msgData:newMsgData];
    }
}

                          
                               
/**
 hook 微信消息同步
 
 */
- (void)hook_OnSyncBatchAddMsgs:(NSArray *)msgs isFirstSync:(BOOL)arg2 {
    [self hook_OnSyncBatchAddMsgs:msgs isFirstSync:arg2];
    
    [msgs enumerateObjectsUsingBlock:^(AddMsg *addMsg, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *now = [NSDate date];
        NSTimeInterval nowSecond = now.timeIntervalSince1970;
        if (nowSecond - addMsg.createTime > 180) {      // 若是3分钟前的消息，则不进行自动回复与远程控制。
            return;
        }
        
        [self autoReplyWithMsg:addMsg];
        
        NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
        if ([addMsg.fromUserName.string isEqualToString:currentUserName] &&
            [addMsg.toUserName.string isEqualToString:currentUserName]) {
            [self remoteControlWithMsg:addMsg];
            [self replySelfWithMsg:addMsg];
        }
    }];
}

/**
 hook 微信通知消息
 
 */
- (id)hook_getNotificationContentWithMsgData:(MessageData *)arg1 {
    [[TKWeChatPluginConfig sharedConfig] setCurrentUserName:arg1.toUsrName];
    return [self hook_getNotificationContentWithMsgData:arg1];;
}

- (void)hook_deliverNotification:(NSUserNotification *)notification {
    NSMutableDictionary *dict = [notification.userInfo mutableCopy];
    dict[@"currnetName"] = [[TKWeChatPluginConfig sharedConfig] currentUserName];
    notification.userInfo = dict;
    notification.hasReplyButton = YES;
    [self hook_deliverNotification:notification];
}

- (void)hook_userNotificationCenter:(id)notificationCenter didActivateNotification:(NSUserNotification *)notification {
    NSString *chatName = notification.userInfo[@"ChatName"];
    if (chatName && notification.response.string) {
        NSString *instanceUserName = [objc_getClass("CUtility") GetCurrentUserName];
        NSString *currentUserName = notification.userInfo[@"currnetName"];
        if ([instanceUserName isEqualToString:currentUserName]) {
            MessageService *service = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MessageService")];
            [service SendTextMessage:currentUserName toUsrName:chatName msgText:notification.response.string atUserList:nil];
            [[YMMessageManager shareManager] clearUnRead:chatName];
        }
    } else {
        [self hook_userNotificationCenter:notificationCenter didActivateNotification:notification];
    }
}

/**
 hook 自动登录
 
 */
- (void)hook_onLoginButtonClicked:(NSButton *)btn {
    AccountService *accountService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("AccountService")];
    BOOL autoAuthEnable = [[TKWeChatPluginConfig sharedConfig] autoAuthEnable];
    if (autoAuthEnable && [accountService canAutoAuth]) {
        [accountService AutoAuth];
        
        WeChat *wechat = [objc_getClass("WeChat") sharedInstance];
        MMLoginOneClickViewController *loginVC = wechat.mainWindowController.loginViewController.oneClickViewController;
        loginVC.loginButton.hidden = YES;
        ////        [wechat.mainWindowController onAuthOK];
        loginVC.descriptionLabel.stringValue = TKLocalizedString(@"assistant.autoAuth.tip");
        loginVC.descriptionLabel.textColor = TK_RGB(0x88, 0x88, 0x88);
        loginVC.descriptionLabel.hidden = NO;
    } else {
        [self hook_onLoginButtonClicked:btn];
    }
}

- (void)hook_sendLogoutCGIWithCompletion:(id)arg1 {
    BOOL autoAuthEnable = [[TKWeChatPluginConfig sharedConfig] autoAuthEnable];
    WeChat *wechat = [objc_getClass("WeChat") sharedInstance];
    if (autoAuthEnable && wechat.isAppTerminating) return;
    
    [self hook_sendLogoutCGIWithCompletion:arg1];
}

- (void)hook_ManualLogout {
    if ([[TKWeChatPluginConfig sharedConfig] alfredEnable]) {
        [[TKWebServerManager shareManager] endServer];
    }
    
    NSMenu *mainMenu = [[NSApplication sharedApplication] mainMenu];
    NSMenuItem *pluginMenu = mainMenu.itemArray.lastObject;
    pluginMenu.enabled = NO;
    BOOL autoAuthEnable = [[TKWeChatPluginConfig sharedConfig] autoAuthEnable];
    if (autoAuthEnable) return;
    
    [self hook_ManualLogout];
}

- (void)hook_viewWillAppear {
    [self hook_viewWillAppear];
    
    BOOL autoAuthEnable = [[TKWeChatPluginConfig sharedConfig] autoAuthEnable];
    if (![self.className isEqualToString:@"MMLoginOneClickViewController"] || !autoAuthEnable) return;

    NSButton *autoLoginButton = ({
        NSButton *btn = [NSButton tk_checkboxWithTitle:@"" target:self action:@selector(selectAutoLogin:)];
        btn.frame = NSMakeRect(110, 60, 80, 30);
        NSMutableParagraphStyle *pghStyle = [[NSMutableParagraphStyle alloc] init];
        pghStyle.alignment = NSTextAlignmentCenter;
        NSDictionary *dicAtt = @{NSForegroundColorAttributeName: kBG4, NSParagraphStyleAttributeName: pghStyle};
        btn.attributedTitle = [[NSAttributedString alloc] initWithString:TKLocalizedString(@"assistant.autoLogin.text") attributes:dicAtt];
        
        btn;
    });
    
    WeChat *wechat = [objc_getClass("WeChat") sharedInstance];
    MMLoginOneClickViewController *loginVC = wechat.mainWindowController.loginViewController.oneClickViewController;
    [loginVC.view addSubview:autoLoginButton];
    
    BOOL autoLogin = [[TKWeChatPluginConfig sharedConfig] autoLoginEnable];
    autoLoginButton.state = autoLogin;

    BOOL wechatHasRun = [self checkWeChatLaunched];
    AccountService *accountService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("AccountService")];
    if (autoLogin && wechatHasRun && [accountService canAutoAuth]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [loginVC onLoginButtonClicked:nil];
        });
    }
}

- (BOOL)checkWeChatLaunched {
    NSArray *ary = [[NSWorkspace sharedWorkspace] launchedApplications];
    __block BOOL isWeChatLaunched = NO;
    [ary enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"启动微信");
        NSString *bundleID = [obj valueForKey:@"NSApplicationBundleIdentifier"];
        if ([bundleID isEqualToString:@"com.tencent.xinWeChat"]) {
            isWeChatLaunched = YES;
        }
    }];
    return isWeChatLaunched;
}

- (void)hook_sortSessions {
    [self hook_sortSessions];
    
    MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
    NSMutableArray *arrSession = sessionMgr.m_arrSession;
    NSMutableArray *ignoreSessions = [[[TKWeChatPluginConfig sharedConfig] ignoreSessionModels] mutableCopy];
    
    NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
    [ignoreSessions enumerateObjectsUsingBlock:^(TKIgnoreSessonModel *model, NSUInteger index, BOOL * _Nonnull stop) {
        __block NSInteger ignoreIdx = -1;
        [arrSession enumerateObjectsUsingBlock:^(MMSessionInfo *sessionInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.userName isEqualToString:sessionInfo.m_nsUserName] && [model.selfContact isEqualToString:currentUserName]) {
                ignoreIdx = idx;
                *stop = YES;
            }
        }];
        
        if (ignoreIdx != -1) {
            MMSessionInfo *sessionInfo = arrSession[ignoreIdx];
            [arrSession removeObjectAtIndex:ignoreIdx];
            [arrSession addObject:sessionInfo];
        }
    }];
    
    WeChat *wechat = [objc_getClass("WeChat") sharedInstance];
    [wechat.chatsViewController.tableView reloadData];
}


- (void)hook_startGetA8KeyWithURL:(id)arg1 {
    MMURLHandler *urlHandler = (MMURLHandler *)self;
    [urlHandler openURLWithDefault:arg1];
}

- (void)hook_applicationDidFinishLaunching:(id)arg1 {
    WeChat *wechat = [objc_getClass("WeChat") sharedInstance];
    if ([NSObject hook_HasWechatInstance]) {
        wechat.hasAuthOK = YES;
    }
    if ([wechat respondsToSelector:@selector(checkForUpdatesInBackground)]) {
        //      去除刚启动微信更新弹窗提醒

        LargerOrEqualVersion(@"2.3.24") ? tk_hookMethod(objc_getClass("MMUpdateMgr"), @selector(checkForUpdatesInBackground), [self class], @selector(hook_checkForUpdatesInBackground)) : tk_hookMethod(objc_getClass("WeChat"), @selector(checkForUpdatesInBackground), [self class], @selector(hook_checkForUpdatesInBackground));
    }
    
    [[TKAssistantMenuManager shareManager] initAssistantMenuItems];
    [self hook_applicationDidFinishLaunching:arg1];
}

//  强制用户退出时保存聊天记录
- (id)hook_stringForKey:(NSString *)key {
    if ([key isEqualToString:@"kMMUserDefaultsKey_SaveChatHistory"]) {
        return @"1";
    }
    return [self hook_stringForKey:key];
}

//  微信检测更新
- (void)hook_checkForUpdatesInBackground {
    if ([[TKWeChatPluginConfig sharedConfig] checkUpdateWechatEnable]) {
        [self hook_checkForUpdatesInBackground];
    }
}

//  是否使用微信浏览器
+ (BOOL)hook_preHandleWebUrlStr:(id)arg1 withMessage:(id)arg2 {
    if ([[TKWeChatPluginConfig sharedConfig] systemBrowserEnable]) {
        MMURLHandler *urlHander = [objc_getClass("MMURLHandler") defaultHandler];
        [urlHander openURLWithDefault:arg1];
        return YES;
    } else {
        return [self hook_preHandleWebUrlStr:arg1 withMessage:arg2];
    }
}

- (void)hook_handleWebViewDataItem:(id)arg1 windowId:(id)arg2 {
    WebViewDataItem *item = (WebViewDataItem *)arg1;
    if ([[TKWeChatPluginConfig sharedConfig] systemBrowserEnable]) {
        MMURLHandler *urlHander = [objc_getClass("MMURLHandler") defaultHandler];
        [urlHander openURLWithDefault:item.urlString];
    } else {
         [self hook_handleWebViewDataItem:arg1 windowId:arg2];
    }
}

//  设置标记未读
- (void)hook_onClickSession {
    [self hook_onClickSession];
    MMChatMessageViewController *chatMessageVC = (MMChatMessageViewController *)self;
    NSMutableSet *unreadSessionSet = [[TKWeChatPluginConfig sharedConfig] unreadSessionSet];
    if ([unreadSessionSet containsObject:chatMessageVC.chatContact.m_nsUsrName]) {
        [unreadSessionSet removeObject:chatMessageVC.chatContact.m_nsUsrName];
        [[YMMessageManager shareManager] clearUnRead:chatMessageVC.chatContact.m_nsUsrName];
    }
}

- (void)hook_onUnReadCountChange:(id)arg1 {
    NSMutableSet *unreadSessionSet = [[TKWeChatPluginConfig sharedConfig] unreadSessionSet];
    if ([unreadSessionSet containsObject:arg1]) {
        MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
        MMSessionInfo *sessionInfo = [sessionMgr sessionInfoByUserName:arg1];
        sessionInfo.m_uUnReadCount++;
    }
    [self hook_onUnReadCountChange:arg1];
}
#pragma mark - hook 系统方法
- (void)hook_makeKeyAndOrderFront:(nullable id)sender {
    BOOL top = [[TKWeChatPluginConfig sharedConfig] onTop];
    ((NSWindow *)self).level = top == NSControlStateValueOn ? NSNormalWindowLevel+2 : NSNormalWindowLevel;
    
    [self hook_makeKeyAndOrderFront:sender];
}

#pragma mark - Other
/**
 自动回复
 
 @param addMsg 接收的消息
 */
- (void)autoReplyWithMsg:(AddMsg *)addMsg {
    //    addMsg.msgType != 49
    if (![[TKWeChatPluginConfig sharedConfig] autoReplyEnable]) return;
    if (addMsg.msgType != 1 && addMsg.msgType != 3) return;
    
    NSString *userName = addMsg.fromUserName.string;
    
    MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
    WCContactData *msgContact = [sessionMgr getContact:userName];
    if ([msgContact isBrandContact] || [msgContact isSelf]) {
        //        该消息为公众号或者本人发送的消息
        return;
    }
    NSArray *autoReplyModels = [[TKWeChatPluginConfig sharedConfig] autoReplyModels];
    [autoReplyModels enumerateObjectsUsingBlock:^(TKAutoReplyModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!model.enable) return;
        if (!model.replyContent || model.replyContent.length == 0) return;
        
        if (model.enableSpecificReply) {
            if ([model.specificContacts containsObject:userName]) {
                [self replyWithMsg:addMsg model:model];
            }
            return;
        }
        if ([addMsg.fromUserName.string containsString:@"@chatroom"] && !model.enableGroupReply) return;
        if (![addMsg.fromUserName.string containsString:@"@chatroom"] && !model.enableSingleReply) return;
        
        [self replyWithMsg:addMsg model:model];
    }];
}

- (void)replyWithMsg:(AddMsg *)addMsg model:(TKAutoReplyModel *)model {
    NSString *msgContent = addMsg.content.string;
    if ([addMsg.fromUserName.string containsString:@"@chatroom"]) {
        NSRange range = [msgContent rangeOfString:@":\n"];
        if (range.length > 0) {
            msgContent = [msgContent substringFromIndex:range.location + range.length];
        }
    }
    
    NSArray *replyArray = [model.replyContent componentsSeparatedByString:@"|"];
    int index = arc4random() % replyArray.count;
    NSString *randomReplyContent = replyArray[index];
    NSInteger delayTime = model.enableDelay ? model.delayTime : 0;
    
    if (model.enableRegex) {
        NSString *regex = model.keyword;
        NSError *error;
        NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
        if (error) return;
        NSInteger count = [regular numberOfMatchesInString:msgContent options:NSMatchingReportCompletion range:NSMakeRange(0, msgContent.length)];
        if (count > 0) {
            [[YMMessageManager shareManager] sendTextMessage:randomReplyContent toUsrName:addMsg.fromUserName.string delay:delayTime];
        }
    } else {
        NSArray * keyWordArray = [model.keyword componentsSeparatedByString:@"|"];
        [keyWordArray enumerateObjectsUsingBlock:^(NSString *keyword, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([keyword isEqualToString:@"*"] || [msgContent isEqualToString:keyword]) {
                [[YMMessageManager shareManager] sendTextMessage:randomReplyContent toUsrName:addMsg.fromUserName.string delay:delayTime];
                *stop = YES;
            }
        }];
    }
}

/**
 远程控制
 
 @param addMsg 接收的消息
 */
- (void)remoteControlWithMsg:(AddMsg *)addMsg {
    NSDate *now = [NSDate date];
    NSTimeInterval nowSecond = now.timeIntervalSince1970;
    if (nowSecond - addMsg.createTime > 10) {      // 若是10秒前的消息，则不进行远程控制。
        return;
    }
    if (addMsg.msgType == 1 || addMsg.msgType == 3) {
        [TKRemoteControlManager executeRemoteControlCommandWithMsg:addMsg.content.string];
    } else if (addMsg.msgType == 34) {
        //      此为语音消息
//        MessageService *msgService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MessageService")];
//        MMVoiceTranscribeCGI *cgi = [[objc_getClass("MMVoiceTranscribeCGI") alloc] init];
//        MessageData *msgData = [msgService GetMsgData:addMsg.fromUserName.string svrId:addMsg.newMsgId];
//        long long mesSvrID = msgData.mesSvrID;
//        NSString *sessionName = msgData.fromUsrName;
//        [cgi transcribeVoiceMessage:msgData completion:^ {
//            MessageData *callbackMsgData = [msgService GetMsgData:sessionName svrId:mesSvrID];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [TKRemoteControlManager executeRemoteControlCommandWithVoiceMsg:callbackMsgData.msgVoiceText];
//            });
//        }];
    }
}

- (void)replySelfWithMsg:(AddMsg *)addMsg {
    if (addMsg.msgType != 1 && addMsg.msgType != 3) return;
    
    if ([addMsg.content.string isEqualToString:TKLocalizedString(@"assistant.remoteControl.getList")]) {
        NSString *callBack = [TKRemoteControlManager remoteControlCommandsString];
        [[YMMessageManager shareManager] sendTextMessageToSelf:callBack];
    }
}

- (void)windowsWillMiniaturize:(NSNotification *)notification {
    NSObject *window = notification.object;
    ((NSWindow *)window).level =NSNormalWindowLevel;
}

#pragma mark - 替换 NSSearchPathForDirectoriesInDomains & NSHomeDirectory
static NSArray<NSString *> *(*original_NSSearchPathForDirectoriesInDomains)(NSSearchPathDirectory directory, NSSearchPathDomainMask domainMask, BOOL expandTilde);

NSArray<NSString *> *swizzled_NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory directory, NSSearchPathDomainMask domainMask, BOOL expandTilde) {
    NSMutableArray<NSString *> *paths = [original_NSSearchPathForDirectoriesInDomains(directory, domainMask, expandTilde) mutableCopy];
    NSString *sandBoxPath = [NSString stringWithFormat:@"%@/Library/Containers/com.tencent.xinWeChat/Data",original_NSHomeDirectory()];
    
    [paths enumerateObjectsUsingBlock:^(NSString *filePath, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = [filePath rangeOfString:original_NSHomeDirectory()];
        if (range.length > 0) {
            NSMutableString *newFilePath = [filePath mutableCopy];
            [newFilePath replaceCharactersInRange:range withString:sandBoxPath];
            paths[idx] = newFilePath;
        }
    }];
    
    return paths;
}

static NSString *(*original_NSHomeDirectory)(void);

NSString *swizzled_NSHomeDirectory(void) {
    return [NSString stringWithFormat:@"%@/Library/Containers/com.tencent.xinWeChat/Data",original_NSHomeDirectory()];
}

@end
