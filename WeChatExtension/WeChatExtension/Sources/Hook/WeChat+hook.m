//
//  WeChat+hook.m
//  WeChatExtension
//
//  Created by WeChatExtension on 2019/4/19.
//  Copyright © 2019年 WeChatExtension. All rights reserved.
//

#import "WeChat+hook.h"
#import "WeChatPlugin.h"
#import "fishhook.h"
#import "TKIgnoreSessonModel.h"
#import "YMWebServerManager.h"
#import "YMMessageManager.h"
#import "YMAssistantMenuManager.h"
#import "YMAutoReplyModel.h"
#import "VAutoForwardingModel.h"
#import "YMVersionManager.h"
#import "YMRemoteControlManager.h"
#import "TKDownloadWindowController.h"
#import "YMMessageHelper.h"
#import "YMUpdateManager.h"
#import "YMThemeManager.h"
#import "YMDownloadManager.h"
#import "YMNetWorkHelper.h"
#import<CommonCrypto/CommonDigest.h>
#import "YMIMContactsManager.h"
#import "ANYMethodLog.h"
#import "NSViewLayoutTool.h"
#import "YMZGMPBanModel.h"
#import "YMDFAFilter.h"
#import "YMPrinter.h"

@implementation NSObject (WeChatHook)

+ (void)hookWeChat
{
    //微信撤回消息
    if (LargerOrEqualVersion(@"2.3.29")) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        hookMethod(objc_getClass("AddMsgSyncCmdHandler"), @selector(handleSyncCmdId: withSyncCmdItems:onComplete:), [self class], @selector(hook_handleSyncCmdId: withSyncCmdItems:onComplete:));
#pragma clang diagnostic pop
        hookMethod(objc_getClass("MessageService"), @selector(FFToNameFavChatZZ:sessionMsgList:), [self class], @selector(hook_FFToNameFavChatZZ:sessionMsgList:));
      
    } else {
        SEL revokeMsgMethod = LargerOrEqualVersion(@"2.3.22") ? @selector(FFToNameFavChatZZ:) : @selector(onRevokeMsg:);
        hookMethod(objc_getClass("MessageService"), revokeMsgMethod, [self class], @selector(hook_onRevokeMsg:));
    }
    
    //微信消息同步
    SEL syncBatchAddMsgsMethod = LargerOrEqualVersion(@"2.3.22") ? @selector(FFImgToOnFavInfoInfoVCZZ:isFirstSync:) : @selector(OnSyncBatchAddMsgs:isFirstSync:);
    hookMethod(objc_getClass("MessageService"), syncBatchAddMsgsMethod, [self class], @selector(hook_receivedMsg:isFirstSync:));
    
    hookMethod(objc_getClass("MMChatMessageDataSource"), @selector(onAddMsg:msgData:), [self class], @selector(hook_onAddMsg:msgData:));
    
    //微信多开
    SEL hasWechatInstanceMethod = LargerOrEqualVersion(@"2.3.22") ? @selector(FFSvrChatInfoMsgWithImgZZ) : @selector(HasWechatInstance);
    hookClassMethod(objc_getClass("CUtility"), hasWechatInstanceMethod, [self class], @selector(hook_HasWechatInstance));

    //多开
    if ([YMWeChatPluginConfig sharedConfig].isAllowMoreOpenBaby) {
        hookClassMethod(objc_getClass("NSRunningApplication"), @selector(runningApplicationsWithBundleIdentifier:), [self class], @selector(hook_runningApplicationsWithBundleIdentifier:));
    }
    
    //免认证登录
    hookMethod(objc_getClass("MMLoginOneClickViewController"), @selector(onLoginButtonClicked:), [self class], @selector(hook_onLoginButtonClicked:));
    
    SEL sendLogoutCGIWithCompletionMethod = LargerOrEqualVersion(@"2.3.22") ? @selector(FFVCRecvDataAddDataToMsgChatMgrRecvZZ:) : @selector(sendLogoutCGIWithCompletion:);
    hookMethod(objc_getClass("LogoutCGI"), sendLogoutCGIWithCompletionMethod, [self class], @selector(hook_sendLogoutCGIWithCompletion:));
    
    SEL manualLogoutMethod = LargerOrEqualVersion(@"2.3.22") ? @selector(FFAddSvrMsgImgVCZZ) : @selector(ManualLogout);
    hookMethod(objc_getClass("AccountService"), manualLogoutMethod, [self class], @selector(hook_ManualLogout));

    //自动登录
    hookMethod(objc_getClass("MMLoginOneClickViewController"), @selector(viewWillAppear), [self class], @selector(hook_viewWillAppear));
    //置底
    SEL sortSessionsMethod = LargerOrEqualVersion(@"2.3.22") ? @selector(FFDataSvrMgrSvrFavZZ) : @selector(sortSessions);
    hookMethod(objc_getClass("MMSessionMgr"), sortSessionsMethod, [self class], @selector(hook_sortSessions));
    //窗口置顶
    hookMethod(objc_getClass("NSWindow"), @selector(makeKeyAndOrderFront:), [self class], @selector(hook_makeKeyAndOrderFront:));
    //快捷回复
    hookMethod(objc_getClass("_NSConcreteUserNotificationCenter"), @selector(deliverNotification:), [self class], @selector(hook_deliverNotification:));
    hookMethod(objc_getClass("MMNotificationService"), @selector(userNotificationCenter:didActivateNotification:), [self class], @selector(hook_userNotificationCenter:didActivateNotification:));
    hookMethod(objc_getClass("MMNotificationService"), @selector(getNotificationContentWithMsgData:), [self class], @selector(hook_getNotificationContentWithMsgData:));
    //登录逻辑
    hookMethod(objc_getClass("MMMainViewController"), @selector(viewDidLoad), [self class], @selector(hook_mainViewControllerDidLoad));

    //自带浏览器打开链接
    if (LargerOrEqualVersion(@"2.3.22")) {
        hookClassMethod(objc_getClass("MMWebViewHelper"), @selector(handleWebViewDataItem:windowId:), [self class], @selector(hook_handleWebViewDataItem:windowId:));
    } else {
        hookClassMethod(objc_getClass("MMWebViewHelper"), @selector(preHandleWebUrlStr:withMessage:), [self class], @selector(hook_preHandleWebUrlStr:withMessage:));
    }
    
    hookMethod(objc_getClass("MMURLHandler"), @selector(startGetA8KeyWithURL:), [self class], @selector(hook_startGetA8KeyWithURL:));
    hookMethod(objc_getClass("WeChat"), @selector(applicationDidFinishLaunching:), [self class], @selector(hook_applicationDidFinishLaunching:));
    
    hookMethod(objc_getClass("UserDefaultsService"), @selector(stringForKey:), [self class], @selector(hook_stringForKey:));
    
    //设置标记未读
    hookMethod(objc_getClass("MMChatMessageViewController"), @selector(onClickSession), [self class], @selector(hook_onClickSession));
    hookMethod(objc_getClass("MMSessionMgr"), @selector(onUnReadCountChange:), [self class], @selector(hook_onUnReadCountChange:));
    hookMethod(objc_getClass("GroupStorage"), @selector(UpdateGroupMemberDetailIfNeeded:withCompletion:), [self class], @selector(hook_UpdateGroupMemberDetailIfNeeded:withCompletion:));
    
    //左下角小手机
    hookMethod(objc_getClass("MMMainViewController"), @selector(viewDidLoad), [self class], @selector(hook_MainViewDidLoad));

     hookMethod(objc_getClass("MMMainViewController"), @selector(onUpdateHandoffExpt:), [self class], @selector(hook_onUpdateHandoffExpt:));
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    hookClassMethod(objc_getClass("MMCGIRequester"), @selector(requestCGI: Body:Response:), [self class], @selector(hook_requestCGI: Body:Response:));
#pragma clang diagnostic pop
    //替换沙盒路径
    rebind_symbols((struct rebinding[2]) {
        { "NSSearchPathForDirectoriesInDomains", swizzled_NSSearchPathForDirectoriesInDomains, (void *)&original_NSSearchPathForDirectoriesInDomains },
        { "NSHomeDirectory", swizzled_NSHomeDirectory, (void *)&original_NSHomeDirectory }
    }, 2);
    
    [self setup];
}

+ (id)hook_requestCGI:(unsigned int)arg1 Body:(id)arg2 Response:(id)arg3
{
    id result = [self hook_requestCGI:arg1 Body:arg2 Response:arg3];
    
    return result;
}

- (void)hook_onAddMsg:(id)arg1 msgData:(id)arg2 {
    
    [self hook_onAddMsg:arg1 msgData:arg2];
}

//主控制器的生命周期
- (void)hook_mainViewControllerDidLoad
{
    [self hook_mainViewControllerDidLoad];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([[YMWeChatPluginConfig sharedConfig] alfredEnable]) {
            [[YMWebServerManager shareManager] startServer];
        }
        NSMenu *mainMenu = [[NSApplication sharedApplication] mainMenu];
        NSMenuItem *pluginMenu = mainMenu.itemArray.lastObject;
        pluginMenu.enabled = YES;
        NSMenuItem *preventMenu = pluginMenu.submenu.itemArray.firstObject;
        preventMenu.enabled = YES;
    });
    
    //紧急适配2.4.2
    if (LargerOrEqualVersion(@"2.4.2")) {
        BOOL autoAuthEnable = [[YMWeChatPluginConfig sharedConfig] autoAuthEnable];
        if (autoAuthEnable) {
            MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
            [sessionMgr loadSessionData];
            [sessionMgr loadBrandSessionData];
        }
    }
    
    [YMDFAFilter shareInstance];
}


+ (void)setup
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //窗口置顶初始化
        [self setupWindowSticky];
    });
    [self checkPluginVersion];
    //监听 NSWindow 最小化通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowsWillMiniaturize:) name:NSWindowWillMiniaturizeNotification object:nil];
}

+ (void)setupWindowSticky
{
    BOOL onTop = [[YMWeChatPluginConfig sharedConfig] onTop];
    WeChat *wechat = [objc_getClass("WeChat") sharedInstance];
    wechat.mainWindowController.window.level = onTop == NSControlStateValueOn ? NSNormalWindowLevel+2 : NSNormalWindowLevel;
}

+ (void)checkPluginVersion
{
    if ([[YMWeChatPluginConfig sharedConfig] forbidCheckVersion]) {
         return;
    }
    
    [[YMVersionManager shareManager] checkVersionFinish:^(TKVersionStatus status, NSString *message) {
        if (status == TKVersionStatusNew) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSAlert *alert = [[NSAlert alloc] init];
                [alert addButtonWithTitle:YMLocalizedString(@"assistant.update.alret.confirm")];
                [alert addButtonWithTitle:YMLocalizedString(@"assistant.update.alret.forbid")];
                [alert addButtonWithTitle:YMLocalizedString(@"assistant.update.alret.cancle")];
                [alert setMessageText:YMLocalizedString(@"assistant.update.alret.title")];
                [alert setInformativeText:message];
                NSModalResponse respose = [alert runModal];
                if (respose == NSAlertFirstButtonReturn) {
                    [[TKDownloadWindowController downloadWindowController] show];
                } else if (respose == NSAlertSecondButtonReturn) {
                    [[YMWeChatPluginConfig sharedConfig] setForbidCheckVersion:YES];
                }
            });
        }
    }];
}

//登录界面-自动登录
- (void)selectAutoLogin:(NSButton *)btn
{
    [[YMWeChatPluginConfig sharedConfig] setAutoLoginEnable:btn.state];
}

#pragma mark - hook 微信方法
//hook 微信是否已启动
+ (BOOL)hook_HasWechatInstance
{
    return NO;
}

+ (NSArray *)hook_runningApplicationsWithBundleIdentifier:(id)arg1
{
    return @[];
}

//发送消息后, 用于刷新聊天页面
- (void)hook_notifyAddMsgOnMainThread:(id)arg1 msgData:(id)msgData
{
    return [self hook_notifyAddMsgOnMainThread:arg1 msgData:msgData];
}

- (void)hook_originalImageDidLoadWithUniqueID:(id)arg1 image:(id)arg2; {
    return [self hook_originalImageDidLoadWithUniqueID:arg1 image:arg2];
}


#pragma mark - 撤回
//- (void)hook_handleSyncCmdId:(id)arg1 withSyncCmdItems:(id)arg2 onComplete:(id)arg3
//{
//    NSArray <CmdItem *>*p_arg2 = (NSArray *)arg2;
//    __weak __typeof (self) wself = self;
//    [p_arg2 enumerateObjectsUsingBlock:^(CmdItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
//        AddMsg *addMsg = [objc_getClass("AddMsg") parseFromData:item.cmdBuf.buffer];
//        NSString *msg = addMsg.content.string;
//        if ([msg rangeOfString:@"<sysmsg"].length <= 0) {
//            if ([msg containsString:@"开始聊天了"]) {
//                return;
//            }
//          [wself hook_handleSyncCmdId:arg1 withSyncCmdItems:arg2 onComplete:arg3];
//          return;
//        }
        //备用撤回
//        [wself _doParseRevokeMsg:msg msgData:nil arg1:arg1 arg2:arg2 arg3:arg3];
//    }];
//}

- (void)hook_FFToNameFavChatZZ:(id)msgData sessionMsgList:(id)arg2
{
    if (![[YMWeChatPluginConfig sharedConfig] preventRevokeEnable]) {
        [self hook_FFToNameFavChatZZ:msgData sessionMsgList:arg2];
        return;
    }
    id msg = msgData;
    if ([msgData isKindOfClass:objc_getClass("MessageData")]) {
        msg = [msgData valueForKey:@"msgContent"];
    }
    
    if ([msg rangeOfString:@"<sysmsg"].length <= 0) {
         return;
    }
    
    [self _doParseRevokeMsg:msg msgData:msgData arg1:nil arg2:arg2 arg3:nil];
}

- (void)hook_onRevokeMsg:(id)msgData
{
    if (![[YMWeChatPluginConfig sharedConfig] preventRevokeEnable]) {
        [self hook_onRevokeMsg:msgData];
        return;
    }
    id msg = msgData;
    if ([msgData isKindOfClass:objc_getClass("MessageData")]) {
        msg = [msgData valueForKey:@"msgContent"];
    }
    
    if ([msg rangeOfString:@"<sysmsg"].length <= 0) {
         return;
    }
    
    [self _doParseRevokeMsg:msg msgData:msgData arg1:nil arg2:nil arg3:nil];
}

- (void)_doParseRevokeMsg:(NSString *)msg msgData:(id)msgData arg1:(id)arg1 arg2:(id)arg2 arg3:(id)arg3
{
    //转换群聊的 msg
    NSString *msgContent = [msg substringFromIndex:[msg rangeOfString:@"<sysmsg"].location];
    
    //xml 转 dict
    XMLDictionaryParser *xmlParser = [objc_getClass("XMLDictionaryParser") sharedInstance];
    NSDictionary *msgDict = [xmlParser dictionaryWithString:msgContent];
    
    if (msgDict && msgDict[@"revokemsg"]) {
        NSString *newmsgid = msgDict[@"revokemsg"][@"newmsgid"];
        NSString *session =  msgDict[@"revokemsg"][@"session"];
        msgDict = nil;
        
        NSMutableSet *revokeMsgSet = [[YMWeChatPluginConfig sharedConfig] revokeMsgSet];
        //该消息已进行过防撤回处理
        if ([revokeMsgSet containsObject:newmsgid] || !newmsgid) {
            return;
        }
        [revokeMsgSet addObject:newmsgid];
        
        //获取原始的撤回提示消息
        MessageService *msgService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MessageService")];
        MessageData *revokeMsgData = [msgService GetMsgData:session svrId:[newmsgid integerValue]];
        
        [[YMMessageManager shareManager] asyncRevokeMessage:revokeMsgData];
        
        if ([revokeMsgData isSendFromSelf] && ![[YMWeChatPluginConfig sharedConfig] preventSelfRevokeEnable]) {
            
            if (LargerOrEqualVersion(@"2.3.29")) {
                [self hook_FFToNameFavChatZZ:msgData sessionMsgList:arg2];
            } else {
                [self hook_onRevokeMsg:msgData];
            }
            return;
        }
        NSString *msgContent = [[YMMessageManager shareManager] getMessageContentWithData:revokeMsgData];
        NSString *newMsgContent = [NSString stringWithFormat:@"%@ \n%@",YMLocalizedString(@"assistant.revoke.otherMessage.tip"), msgContent];
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
                          
                               
//hook 微信消息同步
- (void)hook_receivedMsg:(NSArray *)msgs isFirstSync:(BOOL)arg2
{
    __block BOOL flag = NO;
    [msgs enumerateObjectsUsingBlock:^(AddMsg *addMsg, NSUInteger idx, BOOL * _Nonnull stop1) {
    
//        if ([addMsg.content.string containsString:@"可以开始聊天了"]) {
//            ContactStorage *contactStorage = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("ContactStorage")];
//            BOOL isFriend = [contactStorage IsFriendContact:addMsg.fromUserName.string];
//            if (isFriend) {
//                return;
//            }
//        }
        
        //群管理中阻止群消息
        [[YMWeChatPluginConfig sharedConfig].banModels enumerateObjectsUsingBlock:^(YMZGMPBanModel  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop2) {
            if ([addMsg.fromUserName.string isEqualToString:obj.wxid]) {
                flag = YES;
                *stop2 = YES;
                return;
            }
        }];
        
        NSDate *now = [NSDate date];
        NSTimeInterval nowSecond = now.timeIntervalSince1970;
        if (nowSecond - addMsg.createTime > 180) {//若是3分钟前的消息，则不进行自动回复与远程控制。
            return;
        }
        
        [self autoReplyWithMsg:addMsg];
        [self autoReplyByAI:addMsg];

        [self autoForwardingWithMsg:addMsg];
        
        NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
        if ([addMsg.fromUserName.string isEqualToString:currentUserName] &&
            [addMsg.toUserName.string isEqualToString:currentUserName]) {
            [self remoteControlWithMsg:addMsg];
            [self replySelfWithMsg:addMsg];
        }
        
        if (addMsg.msgType == 3) {
            MessageService *msgService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MessageService")];
            MessageData *msgData = [msgService GetMsgData:addMsg.fromUserName.string svrId:addMsg.newMsgId];
            [[YMDownloadManager new] downloadImageWithMsg:msgData];
        }
        
        if (addMsg.msgType == 49) {
            [YMMessageHelper parseMiniProgramMsg:addMsg];
        }
        
    }];
    
    if (flag) {
        return;
    }
    
    [self hook_receivedMsg:msgs isFirstSync:arg2];
}

//hook 微信通知消息
- (id)hook_getNotificationContentWithMsgData:(MessageData *)arg1
{
    [[YMWeChatPluginConfig sharedConfig] setCurrentUserName:arg1.toUsrName];
    return [self hook_getNotificationContentWithMsgData:arg1];;
}

- (void)hook_deliverNotification:(NSUserNotification *)notification
{
    NSMutableDictionary *dict = [notification.userInfo mutableCopy];
    dict[@"currnetName"] = [[YMWeChatPluginConfig sharedConfig] currentUserName];
    notification.userInfo = dict;
    notification.hasReplyButton = YES;
    [self hook_deliverNotification:notification];
}

- (void)hook_userNotificationCenter:(id)notificationCenter didActivateNotification:(NSUserNotification *)notification
{
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

//hook 自动登录
- (void)hook_onLoginButtonClicked:(NSButton *)btn
{
    AccountService *accountService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("AccountService")];
    BOOL autoAuthEnable = [[YMWeChatPluginConfig sharedConfig] autoAuthEnable];
    if (autoAuthEnable && [accountService canAutoAuth]) {
        if ([YMWeChatPluginConfig sharedConfig].launchFromNew) {
            [YMWeChatPluginConfig sharedConfig].launchFromNew = NO;
            return;
        }

        [accountService AutoAuth];
        
        WeChat *wechat = [objc_getClass("WeChat") sharedInstance];
        MMLoginOneClickViewController *loginVC = wechat.mainWindowController.loginViewController.oneClickViewController;
        loginVC.loginButton.hidden = YES;
        ////        [wechat.mainWindowController onAuthOK];
        loginVC.descriptionLabel.stringValue = YMLocalizedString(@"assistant.autoAuth.tip");
        loginVC.descriptionLabel.textColor = TK_RGB(0x88, 0x88, 0x88);
        loginVC.descriptionLabel.hidden = NO;
    } else {
        [self hook_onLoginButtonClicked:btn];
    }
}

- (void)hook_sendLogoutCGIWithCompletion:(id)arg1
{
    BOOL autoAuthEnable = [[YMWeChatPluginConfig sharedConfig] autoAuthEnable];
    WeChat *wechat = [objc_getClass("WeChat") sharedInstance];
    if (autoAuthEnable && wechat.isAppTerminating) {
         return;
    }
    
    [self hook_sendLogoutCGIWithCompletion:arg1];
}

- (void)hook_ManualLogout
{
    if ([[YMWeChatPluginConfig sharedConfig] alfredEnable]) {
        [[YMWebServerManager shareManager] endServer];
    }
    
    NSMenu *mainMenu = [[NSApplication sharedApplication] mainMenu];
    NSMenuItem *pluginMenu = mainMenu.itemArray.lastObject;
    pluginMenu.enabled = NO;
    BOOL autoAuthEnable = [[YMWeChatPluginConfig sharedConfig] autoAuthEnable];
    if (autoAuthEnable) {
         return;
    }
    
    [self hook_ManualLogout];
}

- (void)hook_viewWillAppear
{
    [self hook_viewWillAppear];
   
    WeChat *wechat = [objc_getClass("WeChat") sharedInstance];
     MMLoginOneClickViewController *loginVC = wechat.mainWindowController.loginViewController.oneClickViewController;
    
    if (![self.className isEqualToString:@"MMLoginOneClickViewController"]) {
        return;
    } else {
        if (YMWeChatPluginConfig.sharedConfig.usingTheme) {
            [[YMThemeManager shareInstance] changeTheme:loginVC.view];
        }
    }
    
    NSButton *autoLoginButton = ({
        NSButton *btn = [NSButton tk_checkboxWithTitle:@"" target:self action:@selector(selectAutoLogin:)];
        btn.frame = NSMakeRect(110, 60, 80, 30);
        NSMutableParagraphStyle *pghStyle = [[NSMutableParagraphStyle alloc] init];
        pghStyle.alignment = NSTextAlignmentCenter;
        NSDictionary *dicAtt = @{NSForegroundColorAttributeName: kBG4, NSParagraphStyleAttributeName: pghStyle};
        btn.attributedTitle = [[NSAttributedString alloc] initWithString:YMLocalizedString(@"assistant.autoLogin.text") attributes:dicAtt];
        
        btn;
    });
    
    [loginVC.view addSubview:autoLoginButton];
    
    BOOL autoLogin = [[YMWeChatPluginConfig sharedConfig] autoLoginEnable];
    autoLoginButton.state = autoLogin;

    BOOL wechatHasRun = [YMDeviceHelper checkWeChatLaunched];
    int wechatLaunchCount = [YMDeviceHelper checkWeChatLaunchedCount];
    BOOL autoAuthEnable = [[YMWeChatPluginConfig sharedConfig] autoAuthEnable];
    
    if (autoAuthEnable) {
        AccountService *accountService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("AccountService")];
        if (autoLogin && wechatHasRun && [accountService canAutoAuth]) {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [loginVC onLoginButtonClicked:nil];
            });
        }
    } else {
        if (autoLogin && wechatLaunchCount < 2) {
            [loginVC onLoginButtonClicked:nil];
        }
    }
}

//置底
- (void)hook_sortSessions
{
    [self hook_sortSessions];
    
    @synchronized (self) {
        MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
        NSMutableArray *arrSession = sessionMgr.m_arrSession;
        NSMutableArray *ignoreSessions = [[[YMWeChatPluginConfig sharedConfig] ignoreSessionModels] mutableCopy];
        
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
    }
}


- (void)hook_startGetA8KeyWithURL:(id)arg1
{
    MMURLHandler *urlHandler = (MMURLHandler *)self;
    [urlHandler openURLWithDefault:arg1];
}

- (void)hook_applicationDidFinishLaunching:(id)arg1
{
    WeChat *wechat = [objc_getClass("WeChat") sharedInstance];
    if ([NSObject hook_HasWechatInstance]) {
        wechat.hasAuthOK = YES;
    }
    
    if (LargerOrEqualVersion(@"2.3.24")) {
        hookMethod(objc_getClass("WeChat"), @selector(setupCheckUpdateIfNeeded), [self class], @selector(hook_checkForUpdatesInBackground));

        hookMethod(objc_getClass("MMUpdateMgr"), @selector(sparkleUpdater), [self class], @selector(hook_sparkleUpdater));
    } else {
        if ([wechat respondsToSelector:@selector(checkForUpdatesInBackground)]) {
            //去除刚启动微信更新弹窗提醒
            hookMethod(objc_getClass("WeChat"), @selector(checkForUpdatesInBackground), [self class], @selector(hook_checkForUpdatesInBackground));
        }
    }
    
    
    [[YMAssistantMenuManager shareManager] initAssistantMenuItems];
    [self hook_applicationDidFinishLaunching:arg1];
}

//强制用户退出时保存聊天记录
- (id)hook_stringForKey:(NSString *)key
{
    if ([key isEqualToString:@"kMMUserDefaultsKey_SaveChatHistory"]) {
        return @"1";
    }
    return [self hook_stringForKey:key];
}

//  微信检测更新
- (void)hook_checkForUpdatesInBackground
{
    if ([[YMWeChatPluginConfig sharedConfig] checkUpdateWechatEnable]) {
        [self hook_checkForUpdatesInBackground];
    }
}

- (id)hook_sparkleUpdater
{
    if (![[YMWeChatPluginConfig sharedConfig] checkUpdateWechatEnable]) {
        return nil;
    }
    return [self hook_sparkleUpdater];
}

//  是否使用微信浏览器
+ (BOOL)hook_preHandleWebUrlStr:(id)arg1 withMessage:(id)arg2
{
    if ([[YMWeChatPluginConfig sharedConfig] systemBrowserEnable]) {
        MMURLHandler *urlHander = [objc_getClass("MMURLHandler") defaultHandler];
        [urlHander openURLWithDefault:arg1];
        return YES;
    } else {
        return [self hook_preHandleWebUrlStr:arg1 withMessage:arg2];
    }
}

- (void)hook_handleWebViewDataItem:(id)arg1 windowId:(id)arg2
{
    WebViewDataItem *item = (WebViewDataItem *)arg1;
    if ([[YMWeChatPluginConfig sharedConfig] systemBrowserEnable]) {
        MMURLHandler *urlHander = [objc_getClass("MMURLHandler") defaultHandler];
        if (LargerOrEqualLongVersion(@"2.4.0.149")) {
            [urlHander openURLWithDefault:item.urlString];
        } else if (LargerOrEqualVersion(@"2.3.26")) {
            [urlHander openURLWithDefault:item.urlString useA8Key:NO];
        } else {
            [urlHander openURLWithDefault:item.urlString];
        }

    } else {
         [self hook_handleWebViewDataItem:arg1 windowId:arg2];
    }
}

//设置标记未读
- (void)hook_onClickSession
{
    [self hook_onClickSession];
    MMChatMessageViewController *chatMessageVC = (MMChatMessageViewController *)self;
    NSMutableSet *unreadSessionSet = [[YMWeChatPluginConfig sharedConfig] unreadSessionSet];
    if ([unreadSessionSet containsObject:chatMessageVC.chatContact.m_nsUsrName]) {
        [unreadSessionSet removeObject:chatMessageVC.chatContact.m_nsUsrName];
        [[YMMessageManager shareManager] clearUnRead:chatMessageVC.chatContact.m_nsUsrName];
    }
}

- (void)hook_onUnReadCountChange:(id)arg1
{
    NSMutableSet *unreadSessionSet = [[YMWeChatPluginConfig sharedConfig] unreadSessionSet];
    if ([unreadSessionSet containsObject:arg1]) {
        MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
        MMSessionInfo *sessionInfo = [sessionMgr sessionInfoByUserName:arg1];
        sessionInfo.m_uUnReadCount++;
    }
    [self hook_onUnReadCountChange:arg1];
}

#pragma mark - QuiteMonitor
- (void)hook_UpdateGroupMemberDetailIfNeeded:(id)arg1 withCompletion:(id)arg2
{
    if ([YMWeChatPluginConfig sharedConfig].quitMonitorEnable) {
        [[YMIMContactsManager shareInstance] monitorQuitGroup:arg1];
    }
    [self hook_UpdateGroupMemberDetailIfNeeded:arg1 withCompletion:arg2];
}

- (void)hook_onUpdateHandoffExpt:(BOOL)arg1
{
    [self hook_onUpdateHandoffExpt:YES];
}

- (void)hook_MainViewDidLoad
{
    [self hook_MainViewDidLoad];
    if (LargerOrEqualVersion(@"2.4.0")) {
        MMMainViewController *mainVC = (MMMainViewController *)self;
        [mainVC onUpdateHandoffExpt:YES];
    }
}

#pragma mark - hook 系统方法
- (void)hook_makeKeyAndOrderFront:(nullable id)sender
{
    BOOL top = [[YMWeChatPluginConfig sharedConfig] onTop];
    ((NSWindow *)self).level = top == NSControlStateValueOn ? NSNormalWindowLevel+2 : NSNormalWindowLevel;
    
    [self hook_makeKeyAndOrderFront:sender];
}

#pragma mark - Other
- (void)autoReplyByAI:(AddMsg *)addMsg
{
    if (addMsg.msgType != 1) {
         return;
    }
    
    NSString *userName = addMsg.fromUserName.string;
    
    MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
    WCContactData *msgContact = nil;
    
    if (LargerOrEqualVersion(@"2.3.26")) {
        msgContact = [sessionMgr getSessionContact:userName];
    } else {
        msgContact = [sessionMgr getContact:userName];
    }
    
    if ([msgContact isBrandContact] || [msgContact isSelf]) {
        //该消息为公众号或者本人发送的消息
        return;
    }
    YMAIAutoModel *AIModel = [[YMWeChatPluginConfig sharedConfig] AIReplyModel];
    if (AIModel.specificContacts.count < 1) {
        return;
    }
    
    [AIModel.specificContacts enumerateObjectsUsingBlock:^(NSString *wxid, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([wxid isEqualToString:addMsg.fromUserName.string]) {
            
            NSString *content = @"";
            NSString *session = @"";
            if ([wxid containsString:@"@chatroom"]) {
                NSArray *contents = [addMsg.content.string componentsSeparatedByString:@":\n"];
                NSArray *sessions = [wxid componentsSeparatedByString:@"@"];
                if (contents.count > 1) {
                    content = contents[1];
                }
                if (sessions.count > 1) {
                    session = sessions[0];
                }
            } else {
                content = addMsg.content.string;
                session = wxid;
            }
            
            [[YMNetWorkHelper share] GET:content session:session success:^(NSString *content, NSString *session) {
                [[YMMessageManager shareManager] sendTextMessage:content toUsrName:addMsg.fromUserName.string delay:kArc4random_Double_inSpace(3, 8)];
            }];
        }
    }];
}

- (void)autoForwardingWithMsg:(AddMsg *)msg
{
    if (![[YMWeChatPluginConfig sharedConfig] autoForwardingEnable]) {
         return;
    }
    if (msg.msgType != 1) {
         return;
    }

    NSString *userName = msg.fromUserName.string;

    MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];

    WCContactData *msgContact = nil;
    if (LargerOrEqualVersion(@"2.3.26")) {
        msgContact = [sessionMgr getSessionContact:userName];
    } else {
        msgContact = [sessionMgr getContact:userName];
    }
    if ([msgContact isBrandContact] || [msgContact isSelf]) {
        //该消息为公众号或者本人发送的消息
        return;
    }
    VAutoForwardingModel *model = [[YMWeChatPluginConfig sharedConfig] VAutoForwardingModel];

    if ([[YMWeChatPluginConfig sharedConfig] autoForwardingAllFriend]) {
        if (![msgContact isGroupChat]) {
            [self forwardingWithMsg:msg];
        }
    }
    [model.forwardingFromContacts enumerateObjectsUsingBlock:^(NSString *fromWxid, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([fromWxid isEqualToString:userName]) {
            if ([fromWxid containsString:@"@chatroom"]) {
                [self forwardingWithMsg:msg];
            } else {
                if (![[YMWeChatPluginConfig sharedConfig] autoForwardingAllFriend]) {
                    [self forwardingWithMsg:msg];
                }
            }
        }
    }];
}

- (void)forwardingWithMsg:(AddMsg *)msg
{
    MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
    NSString *userName = msg.fromUserName.string;
    
    WCContactData *msgContact = nil;
    if (LargerOrEqualVersion(@"2.3.26")) {
        msgContact = [sessionMgr getSessionContact:userName];
    } else {
        msgContact = [sessionMgr getContact:userName];
    }

    NSString *content = @"";
    NSString *desc = @"";
    
    if ([msgContact isGroupChat]) {
        NSArray *contents = [msg.content.string componentsSeparatedByString:@":\n"];
        NSString *groupMemberWxid = contents[0];
        MessageService *msgService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MessageService")];
        MessageData *msgData = [msgService GetMsgData:msg.fromUserName.string svrId:msg.newMsgId];
        NSLog(@"%@", msgData.groupChatSenderDisplayName);
        NSString *groupMemberNickName = msgData.groupChatSenderDisplayName.length > 0
            ? msgData.groupChatSenderDisplayName : [YMIMContactsManager getGroupMemberNickName:groupMemberWxid];
        desc = [desc stringByAppendingFormat:@"群聊【%@】里用户【%@】发来一条消息", msgContact.m_nsNickName, groupMemberNickName];
        content = contents[1];
    } else {
        content = msg.content.string;
        NSString *nickName = [msgContact.m_nsRemark isEqualToString:@""] ? msgContact.m_nsNickName : msgContact.m_nsRemark;
        desc = [desc stringByAppendingFormat:@"用户【%@】发来一条消息", nickName];
    }
    
    VAutoForwardingModel *model = [[YMWeChatPluginConfig sharedConfig] VAutoForwardingModel];
    [model.forwardingToContacts enumerateObjectsUsingBlock:^(NSString *toWxid, NSUInteger idx, BOOL * _Nonnull stop) {
        [[YMMessageManager shareManager] sendTextMessage:desc toUsrName:toWxid delay:0];
        [[YMMessageManager shareManager] sendTextMessage:content toUsrName:toWxid delay:0];
    }];
}

//自动回复
- (void)autoReplyWithMsg:(AddMsg *)addMsg
{
    //    addMsg.msgType != 49
    if (![[YMWeChatPluginConfig sharedConfig] autoReplyEnable]) {
         return;
    }
    if (addMsg.msgType != 1 && addMsg.msgType != 3) {
         return;
    }
    
    YMAIAutoModel *AIModel = [[YMWeChatPluginConfig sharedConfig] AIReplyModel];
    if ([[YMWeChatPluginConfig sharedConfig] autoReplyEnable]) {
        __block BOOL flag = NO;
        [AIModel.specificContacts enumerateObjectsUsingBlock:^(NSString * _Nonnull aiUsr, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([aiUsr isEqualToString:addMsg.fromUserName.string]) {
                if (*stop) {
                     *stop = YES;
                }
                flag = YES;
            }
        }];
        
        if (flag) {
            NSString *nick = nil;
            if ([addMsg.fromUserName.string containsString:@"@chatroom"]) {
                nick = @"此群";
            } else {
                nick = [YMIMContactsManager getWeChatNickName:addMsg.fromUserName.string];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSString *message = nil;
                if ([YMWeChatPluginConfig sharedConfig].languageType == PluginLanguageTypeZH) {
                    message = [NSString stringWithFormat:@"⚠️警告⚠️\n您对@%@ 设置了AI回复且同时打开了自动回复\n小助手将只会对@%@ 进行AI回复",nick,nick];
                } else {
                    message = @"You cannot set AI reply and auto reply to him at the same time";
                }
                [YMMessageHelper addLocalWarningMsg:message fromUsr:addMsg.fromUserName.string];
            });
            return;
        }
    };
    
    NSString *userName = addMsg.fromUserName.string;
    
    MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
    
    WCContactData *msgContact = nil;
    if (LargerOrEqualVersion(@"2.3.26")) {
        msgContact = [sessionMgr getSessionContact:userName];
    } else {
        msgContact = [sessionMgr getContact:userName];
    }
    
    if ([msgContact isBrandContact] || [msgContact isSelf]) {
        //        该消息为公众号或者本人发送的消息
        return;
    }
    NSArray *autoReplyModels = [[YMWeChatPluginConfig sharedConfig] autoReplyModels];
    [autoReplyModels enumerateObjectsUsingBlock:^(YMAutoReplyModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!model.enable) {
             return;
        }
        if (!model.replyContent || model.replyContent.length == 0) {
             return;
        }
        
        if (model.enableSpecificReply) {
            if ([model.specificContacts containsObject:userName]) {
                [self replyWithMsg:addMsg model:model];
            }
            return;
        }
        if ([addMsg.fromUserName.string containsString:@"@chatroom"] && !model.enableGroupReply) {
             return;
        }
        if (![addMsg.fromUserName.string containsString:@"@chatroom"] && !model.enableSingleReply) {
             return;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [self replyWithMsg:addMsg model:model];
        });
    }];
}

- (void)replyWithMsg:(AddMsg *)addMsg model:(YMAutoReplyModel *)model
{
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
        if (error) {
             return;
        }
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

//远程控制
- (void)remoteControlWithMsg:(AddMsg *)addMsg
{
    NSDate *now = [NSDate date];
    NSTimeInterval nowSecond = now.timeIntervalSince1970;
    if (nowSecond - addMsg.createTime > 10) {      // 若是10秒前的消息，则不进行远程控制。
        return;
    }
    if (addMsg.msgType == 1 || addMsg.msgType == 3) {
        [YMRemoteControlManager executeRemoteControlCommandWithMsg:addMsg.content.string];
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
//                [YMRemoteControlManager executeRemoteControlCommandWithVoiceMsg:callbackMsgData.msgVoiceText];
//            });
//        }];
    }
}

- (void)replySelfWithMsg:(AddMsg *)addMsg
{
    if (addMsg.msgType != 1 && addMsg.msgType != 3) {
         return;
    }
    
    if ([addMsg.content.string isEqualToString:YMLocalizedString(@"assistant.remoteControl.getList")]) {
        NSString *callBack = [YMRemoteControlManager remoteControlCommandsString];
        [[YMMessageManager shareManager] sendTextMessageToSelf:callBack];
    }
}

- (void)windowsWillMiniaturize:(NSNotification *)notification
{
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
