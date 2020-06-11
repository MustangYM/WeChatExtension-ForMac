//
//  MMChatsTableCellView+hook.m
//  WeChatExtension
//
//  Created by WeChatExtension on 2017/9/15.
//  Copyright © 2017年 WeChatExtension. All rights reserved.
//

#import "MMChatsTableCellView+hook.h"
#import "WeChatPlugin.h"
#import "TKIgnoreSessonModel.h"
#import "YMMessageManager.h"

@implementation NSObject (MMChatsTableCellViewHook)

+ (void)hookMMChatsTableCellView
{
    hookMethod(objc_getClass("MMChatsTableCellView"), @selector(menuWillOpen:), [self class], @selector(hook_menuWillOpen:));
    hookMethod(objc_getClass("MMChatsTableCellView"), @selector(setSessionInfo:), [self class], @selector(hook_setSessionInfo:));
    hookMethod(objc_getClass("MMChatsTableCellView"), @selector(contextMenuSticky:), [self class], @selector(hook_contextMenuSticky:));
    hookMethod(objc_getClass("MMChatsTableCellView"), @selector(contextMenuDelete:), [self class], @selector(hook_contextMenuDelete:));
    hookMethod(objc_getClass("MMChatsViewController"), @selector(tableView:rowGotMouseDown:), [self class], @selector(hooktableView:rowGotMouseDown:));
}

- (void)hooktableView:(NSTableView *)arg1 rowGotMouseDown:(long long)arg2
{
    
    @try {
         [self hooktableView:arg1 rowGotMouseDown:arg2];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
    NSArray *allSessions = nil;
    if (LargerOrEqualVersion(@"2.3.22")) {
         allSessions = [sessionMgr getAllSessions];
    } else {
         allSessions = [sessionMgr GetAllSessions];
    }
    MMSessionInfo *sessionInfo = [allSessions objectAtIndex:arg2];
    
    if ([[TKWeChatPluginConfig sharedConfig] multipleSelectionEnable]) {
        NSMutableArray *selectSessions = [[TKWeChatPluginConfig sharedConfig] selectSessions];
        if ([selectSessions containsObject:sessionInfo]) {
            [selectSessions removeObject:sessionInfo];
        } else {
            [selectSessions addObject:sessionInfo];
        }
        [arg1 reloadData];
    }
}

- (void)hook_setSessionInfo:(MMSessionInfo *)sessionInfo
{
    [self hook_setSessionInfo:sessionInfo];
    
    MMChatsTableCellView *cellView = (MMChatsTableCellView *)self;
    NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
    __block BOOL isIgnore = false;
    NSMutableArray *ignoreSessions = [[TKWeChatPluginConfig sharedConfig] ignoreSessionModels];
    [ignoreSessions enumerateObjectsUsingBlock:^(TKIgnoreSessonModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.userName isEqualToString:sessionInfo.m_nsUserName] && [model.selfContact isEqualToString:currentUserName]) {
            isIgnore = true;
            *stop = YES;
        }
    }];
    
    NSMutableArray *selectSessions = [[TKWeChatPluginConfig sharedConfig] selectSessions];
    
    if ([TKWeChatPluginConfig sharedConfig].usingDarkTheme) {
        NSColor *changeColor = kRGBColor(255, 255, 255, 1.0);
        if (isIgnore) {
            changeColor = kMainIgnoredTextColor;//kRGBColor(25, 185, 77, 1.0);
        } else if ([selectSessions containsObject:sessionInfo]) {
            changeColor = [NSColor redColor];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSAttributedString *str = cellView.nickName.attributedStringValue;
            NSRange range = NSMakeRange(0, str.length);
            NSDictionary *attributes = [str attributesAtIndex:0 effectiveRange:&range];
            NSFont *attributesFont = [attributes valueForKey:@"NSFont"];
            NSMutableAttributedString *returnValue = [[NSMutableAttributedString alloc] initWithString:str.string attributes:@{NSForegroundColorAttributeName :changeColor, NSFontAttributeName : attributesFont}];
            cellView.nickName.attributedStringValue = returnValue;
            
            // MARK: - Add pined image in dark mode
            NSBundle *bundle = [NSBundle bundleWithIdentifier:@"MustangYM.WeChatExtension"];
            NSString *imgPath= [bundle pathForImageResource:@"pin.png"];

            NSImage *pined = [[NSImage alloc] initWithContentsOfFile:imgPath];
            NSImageView *pinedView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, 20, 20)];
            [pinedView setImage:pined];

            pinedView.tag = 999;
            [cellView.stickyBackgroundView addSubview:pinedView];
            pinedView.translatesAutoresizingMaskIntoConstraints = NO;
            NSMutableArray<NSLayoutConstraint*> *contraints = [NSMutableArray array];
            if (@available(macOS 10.11, *)) {
                [contraints addObject:[pinedView.topAnchor constraintEqualToAnchor:cellView.stickyBackgroundView.topAnchor constant:0]];
                
                [contraints addObject:[pinedView.widthAnchor constraintEqualToConstant:10]];
                
                [contraints addObject:[pinedView.heightAnchor constraintEqualToConstant:10]];
                
                [contraints addObject:[pinedView.leadingAnchor constraintEqualToAnchor:cellView.stickyBackgroundView.leadingAnchor constant:0]];
                [cellView.stickyBackgroundView addConstraints:contraints];
            } else {
                // Fallback on earlier versions
            }
            
        });
    } else {
        if (isIgnore) {
            cellView.layer.backgroundColor = kBG3.CGColor;
        } else if ([selectSessions containsObject:sessionInfo]) {
            cellView.layer.backgroundColor = kBG4.CGColor;
        } else {
            cellView.layer.backgroundColor = [NSColor clearColor].CGColor;
        }
    }
    
    [cellView.layer setNeedsDisplay];
}

- (void)hook_menuWillOpen:(NSMenu *)arg1
{
    
    MMChatsTableCellView *cell = (MMChatsTableCellView *)self;
    MMSessionInfo *sessionInfo = [cell sessionInfo];
    NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
    NSString *delegate = NSStringFromClass(cell.delegate.class);

    if ([delegate isEqualToString:@"MMChatsViewController"]) {
        __block BOOL isIgnore = false;
        NSMutableArray *ignoreSessions = [[TKWeChatPluginConfig sharedConfig] ignoreSessionModels];
        [ignoreSessions enumerateObjectsUsingBlock:^(TKIgnoreSessonModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([model.userName isEqualToString:sessionInfo.m_nsUserName] && [model.selfContact isEqualToString:currentUserName]) {
                isIgnore = true;
                *stop = YES;
            }
        }];
        
        NSString *itemString = isIgnore ? YMLocalizedString(@"assistant.chat.unStickyBottom") : YMLocalizedString(@"assistant.chat.stickyBottom");
        NSMenuItem *preventRevokeItem = [[NSMenuItem alloc] initWithTitle:itemString action:@selector(contextMenuStickyBottom) keyEquivalent:@""];
        
        BOOL multipleSelectionEnable = [[TKWeChatPluginConfig sharedConfig] multipleSelectionEnable];
        NSString *multipleSelectionString = multipleSelectionEnable ? YMLocalizedString(@"assistant.chat.unMultiSelect") : YMLocalizedString(@"assistant.chat.multiSelect");
        NSMenuItem *multipleSelectionItem = [[NSMenuItem alloc] initWithTitle:multipleSelectionString action:@selector(contextMenuMutipleSelection) keyEquivalent:@""];
        
        NSMenuItem *clearUnReadItem = [[NSMenuItem alloc] initWithTitle:YMLocalizedString(@"assistant.chat.readAll") action:@selector(contextMenuClearUnRead) keyEquivalent:@""];
        
        NSMenuItem *clearEmptySessionItem = [[NSMenuItem alloc] initWithTitle:YMLocalizedString(@"assistant.chat.clearEmpty") action:@selector(contextMenuClearEmptySession) keyEquivalent:@""];
        
        NSMenuItem *removeSessionItem = [[NSMenuItem alloc] initWithTitle:YMLocalizedString(@"assistant.chat.remove") action:@selector(contextMenuRemoveSession) keyEquivalent:@""];
        
        NSMenuItem *unreadSessionItem = [[NSMenuItem alloc] initWithTitle:YMLocalizedString(@"assistant.chat.unread") action:@selector(contextMenuUnreadSession) keyEquivalent:@""];
        
        [arg1 addItems:@[[NSMenuItem separatorItem],
                         preventRevokeItem,
                         multipleSelectionItem,
                         clearUnReadItem,
                         clearEmptySessionItem,
                         removeSessionItem,
                         unreadSessionItem
        ]];
    }
    
   
    [self hook_menuWillOpen:arg1];
}

- (void)contextMenuStickyBottom
{
    MMSessionInfo *sessionInfo = [(MMChatsTableCellView *)self sessionInfo];
    NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
    
    NSMutableArray *ignoreSessions = [[TKWeChatPluginConfig sharedConfig] ignoreSessionModels];
    __block NSInteger index = -1;
    [ignoreSessions enumerateObjectsUsingBlock:^(TKIgnoreSessonModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.userName isEqualToString:sessionInfo.m_nsUserName] && [model.selfContact isEqualToString:currentUserName]) {
            index = idx;
            *stop = YES;
        }
    }];
    
    MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
    
    if (index == -1 && sessionInfo.m_nsUserName) {
        TKIgnoreSessonModel *model = [[TKIgnoreSessonModel alloc] init];
        model.userName = sessionInfo.m_nsUserName;
        model.selfContact = currentUserName;
        model.ignore = true;
        [ignoreSessions addObject:model];
        if (!sessionInfo.m_bShowUnReadAsRedDot) {
            [sessionMgr muteSessionByUserName:sessionInfo.m_nsUserName syncToServer:YES];
        }
        if (sessionInfo.m_bIsTop) {
            [sessionMgr untopSessionByUserName:sessionInfo.m_nsUserName syncToServer:YES];
        } 
    } else {
        [ignoreSessions removeObjectAtIndex:index];
        if (sessionInfo.m_bShowUnReadAsRedDot && sessionInfo.m_nsUserName) {
            [sessionMgr unmuteSessionByUserName:sessionInfo.m_nsUserName syncToServer:YES];
        }
    }
    if ([sessionMgr respondsToSelector:@selector(FFDataSvrMgrSvrFavZZ)]) {
        [sessionMgr FFDataSvrMgrSvrFavZZ];
    } else if ([sessionMgr respondsToSelector:@selector(sortSessions)]) {
        [sessionMgr sortSessions];
    }
    [[TKWeChatPluginConfig sharedConfig] saveIgnoreSessionModels];
}

- (void)contextMenuMutipleSelection
{
    BOOL multipleSelectionEnable = [[TKWeChatPluginConfig sharedConfig] multipleSelectionEnable];
    if (multipleSelectionEnable) {
        [[[TKWeChatPluginConfig sharedConfig] selectSessions] removeAllObjects];
        WeChat *wechat = [objc_getClass("WeChat") sharedInstance];
        [wechat.chatsViewController.tableView reloadData];
    }
    
    [[TKWeChatPluginConfig sharedConfig] setMultipleSelectionEnable:!multipleSelectionEnable];
}

- (void)contextMenuClearUnRead
{
    MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
    NSMutableArray *arrSession = sessionMgr.m_arrSession;

    [arrSession enumerateObjectsUsingBlock:^(MMSessionInfo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[YMMessageManager shareManager] clearUnRead:obj.m_nsUserName];
        });
    }];
}

- (void)contextMenuClearEmptySession
{
    MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
    
    MessageService *msgService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MessageService")];
    
    NSMutableArray *arrSession = sessionMgr.m_arrSession;
    NSMutableArray *emptyArrSession = [NSMutableArray array];
    
    [arrSession enumerateObjectsUsingBlock:^(MMSessionInfo *sessionInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL hasEmplyMsgSession = ![msgService hasMsgInChat:sessionInfo.m_nsUserName];
        WCContactData *contact = sessionInfo.m_packedInfo.m_contact;
        if (![sessionInfo.m_nsUserName isEqualToString:@"brandsessionholder"] && ![contact isSelf] && hasEmplyMsgSession) {
            [emptyArrSession addObject:sessionInfo];
        }
    }];
    
    while (emptyArrSession.count > 0) {
        [emptyArrSession enumerateObjectsUsingBlock:^(MMSessionInfo *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.m_nsUserName.length > 0) {
                if (LargerOrEqualVersion(@"2.3.25")) {
                    [sessionMgr removeSessionOfUser:obj.m_nsUserName isDelMsg:NO];
                } else {
                    [sessionMgr deleteSessionWithoutSyncToServerWithUserName:obj.m_nsUserName];
                }
            }
            [emptyArrSession removeObject:obj];
        }];
    }
}

- (void)contextMenuRemoveSession
{
    MMSessionInfo *sessionInfo = [(MMChatsTableCellView *)self sessionInfo];
    MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
    
    BOOL multipleSelection = [[TKWeChatPluginConfig sharedConfig] multipleSelectionEnable];
    if (multipleSelection) {
        NSMutableArray *selectSessions = [[TKWeChatPluginConfig sharedConfig] selectSessions];
        [selectSessions  enumerateObjectsUsingBlock:^(MMSessionInfo *sessionInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *sessionUserName = sessionInfo.m_nsUserName;
            if (sessionUserName.length > 0) {
                [sessionMgr removeSessionOfUser:sessionInfo.m_nsUserName isDelMsg:NO];
            }
        }];
        [[TKWeChatPluginConfig sharedConfig] setMultipleSelectionEnable:NO];
        WeChat *wechat = [objc_getClass("WeChat") sharedInstance];
        [wechat.chatsViewController.tableView reloadData];
    } else if (sessionInfo.m_nsUserName.length > 0) {
        [sessionMgr removeSessionOfUser:sessionInfo.m_nsUserName isDelMsg:NO];
    }
}

- (void)contextMenuUnreadSession
{
    MMSessionInfo *sessionInfo = [(MMChatsTableCellView *)self sessionInfo];
    if (sessionInfo.m_uUnReadCount > 0) {
         return;
    }
    
    NSMutableSet *unreadSessionSet = [[TKWeChatPluginConfig sharedConfig] unreadSessionSet];
    if ([unreadSessionSet containsObject:sessionInfo.m_nsUserName]) {
         return;
    }
    
    [unreadSessionSet addObject:sessionInfo.m_nsUserName];
    MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
    [sessionMgr changeSessionUnreadCountWithUserName:sessionInfo.m_nsUserName to:sessionInfo.m_uUnReadCount + 1];
}

- (void)hook_contextMenuSticky:(id)arg1
{
    [self hook_contextMenuSticky:arg1];
    
    MMSessionInfo *sessionInfo = [(MMChatsTableCellView *)self sessionInfo];
    if (!sessionInfo.m_bIsTop) {
         return;
    }
    
    NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
    NSMutableArray *ignoreSessions = [[TKWeChatPluginConfig sharedConfig] ignoreSessionModels];
    __block NSInteger index = -1;
    [ignoreSessions enumerateObjectsUsingBlock:^(TKIgnoreSessonModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.userName isEqualToString:sessionInfo.m_nsUserName] && [model.selfContact isEqual:currentUserName]) {
            index = idx;
            *stop = YES;
        }
    }];
    
    if (index != -1) {
        [ignoreSessions removeObjectAtIndex:index];
        MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
        
        if (sessionInfo.m_bShowUnReadAsRedDot && sessionInfo.m_nsUserName) {
            [sessionMgr UnmuteSessionByUserName:sessionInfo.m_nsUserName];
        }
        if ([sessionMgr respondsToSelector:@selector(FFDataSvrMgrSvrFavZZ)]) {
            [sessionMgr FFDataSvrMgrSvrFavZZ];
        } else if ([sessionMgr respondsToSelector:@selector(sortSessions)]) {
            [sessionMgr sortSessions];
        }
        [[TKWeChatPluginConfig sharedConfig] saveIgnoreSessionModels];
    }
}

- (void)hook_contextMenuDelete:(id)arg1
{
    BOOL multipleSelection = [[TKWeChatPluginConfig sharedConfig] multipleSelectionEnable];
    
    if (multipleSelection) {
        MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
        NSMutableArray *selectSessions = [[TKWeChatPluginConfig sharedConfig] selectSessions];
        
        [selectSessions  enumerateObjectsUsingBlock:^(MMSessionInfo *sessionInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *sessionUserName = sessionInfo.m_nsUserName;
            if (sessionUserName.length != 0) {
                if (LargerOrEqualVersion(@"2.3.25")) {
                    [sessionMgr removeSessionOfUser:sessionUserName isDelMsg:NO];
                } else {
                    [sessionMgr deleteSessionWithoutSyncToServerWithUserName:sessionUserName];
                }
            }
        }];
        [[TKWeChatPluginConfig sharedConfig] setMultipleSelectionEnable:NO];
        WeChat *wechat = [objc_getClass("WeChat") sharedInstance];
        [wechat.chatsViewController.tableView reloadData];
    } else {
        [self hook_contextMenuDelete:arg1];
    }
}

@end
