//
//  NSObject+ThemeHook.m
//  WeChatExtension
//
//  Created by MustangYM on 2020/3/19.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import "NSObject+ThemeHook.h"
#import <mach-o/dyld.h>
#import <dlfcn.h>
#import <QuartzCore/QuartzCore.h>
#import <AppKit/AppKit.h>
#import "YMThemeManager.h"
#import "ANYMethodLog.h"
#import "YMFuzzyManager.h"
#import "NSWindow+fuzzy.h"

@interface NSCellAuxiliary : NSObject

@end

@implementation NSObject (ThemeHook)
+ (void)hookTheme
{
    if (![YMWeChatPluginConfig sharedConfig].isThemeLoaded) {
        [[YMWeChatPluginConfig sharedConfig] setIsThemeLoaded:YES];
        [[YMWeChatPluginConfig sharedConfig] setDarkMode:YES];
    }
    
    if (YMWeChatPluginConfig.sharedConfig.usingTheme) {
        hookMethod(objc_getClass("MMTextField"), @selector(setTextColor:), [self class], @selector(hook_setTextColor:));
        hookMethod([NSTextField class], @selector(setAttributedStringValue:), [self class], @selector(hook_textFieldSetAttributedStringValue:));
        hookMethod(objc_getClass("MMTextView"), NSSelectorFromString(@"shouldDisableSetFrameOrigin"), [self class], @selector(hook_shouldDisableSetFrameOrigin));
        hookMethod(objc_getClass("NSView"), @selector(addSubview:), [self class], @selector(hook_addSubView:));
        hookMethod(objc_getClass("MMComposeInputViewController"), @selector(viewDidLoad), [self class], @selector(hook_ComposeInputViewControllerViewDidLoad));
        hookMethod(objc_getClass("MMChatMessageViewController"), @selector(viewDidLoad), [self class], @selector(hook_ChatMessageViewControllerViewDidLoad));
        hookMethod(objc_getClass("NSScrollView"), @selector(initWithFrame:), [self class], @selector(hook_scrollViewInitWithFrame:));
        hookMethod(objc_getClass("MMLoginWaitingConfirmViewController"), @selector(viewDidAppear), [self class], @selector(hook_loginWaitingViewDidLoad));
        hookMethod(objc_getClass("MMLoginQRCodeViewController"), @selector(viewDidLoad), [self class], @selector(hook_QRCodeViewDidLoad));
        //    hookMethod(objc_getClass("MMTextField"), @selector(setAttributedStringValue:), [self class], @selector(hook_setAttributedStringValue:));
        hookMethod(objc_getClass("MMChatsTableCellView"), @selector(updateNickname), [self class], @selector(hook_updateNickName));
        hookMethod(objc_getClass("NSWindowController"), @selector(windowDidLoad), [self class], @selector(hook_windowDidLoad));
        hookMethod(objc_getClass("NSWindowController"), @selector(showWindow:), [self class], @selector(hook_showWindow:));
        hookMethod(objc_getClass("MMFileListViewController"), @selector(viewDidLoad), [self class], @selector(hook_fileListViewDidLoad));
        hookMethod(objc_getClass("MMPreferencesWindowController"), @selector(windowDidLoad), [self class], @selector(hook_preferencesWindowDidLoad));
        hookMethod(objc_getClass("MMChatMemberListViewController"), @selector(viewDidLoad), [self class], @selector(hook_memberListViewDidLoad));
        hookMethod(objc_getClass("MMChatsTableCellView"), @selector(mouseDown:), [self class], @selector(hook_mouseDown:));
        hookMethod(objc_getClass("MMChatDetailSplitView"), @selector(setPreferredDividerColor:), [self class], @selector(hook_setPreferredDividerColor:));
        hookMethod(objc_getClass("NSViewController"), @selector(viewDidLoad), [self class], @selector(hook_themeViewDidLoad));
        hookMethod(objc_getClass("MMComposeTextView"), @selector(setTextColor:), [self class], @selector(hook_composeSetTextColor:));
        hookMethod(objc_getClass("MMChatManagerDetailViewController"), @selector(viewDidLoad), [self class], @selector(hook_globalChatManagerWindowDidLoad));
        hookMethod(objc_getClass("MMTableView"), @selector(setBackgroundColor:), [self class], @selector(hook_tableViewsetBackgroundColor:));
        hookMethod(objc_getClass("MMChatsTableCellView"), @selector(setSeperator:), [self class], @selector(hook_setSeperator:));
        hookMethod(objc_getClass("NSAlert"), @selector(setMessageText:), [self class], @selector(hook_setMessageText:));
        hookMethod(objc_getClass("NSTextFieldCell"), @selector(setTextColor:), [self class], @selector(hook_setTextFieldCellColor:));
        hookMethod(objc_getClass("MMChatInfoView"), @selector(updateChatName), [self class], @selector(hook_updateChatName));
        hookClassMethod(objc_getClass("MMComposeTextView"), @selector(preprocessTextAttributes:), [self class], @selector(hook_preprocessTextAttributes:));
        hookMethod(objc_getClass("MMMessageCellView"), @selector(updateGroupChatNickName), [self class], @selector(hook_updateGroupChatNickName));
        hookMethod(objc_getClass("MMCTTextView"), @selector(setAttributedString:), [self class], @selector(hook_textFieldSetTextColor:));
        hookMethod(objc_getClass("MMSessionPickerListRowView"), @selector(drawRect:), [self class], @selector(hook_pickerListDrawRect:));
        hookMethod(objc_getClass("MMChatDetailMemberRowView"), @selector(avatarImageView), [self class], @selector(hook_chatDetailAvatarImageView));
        hookMethod(objc_getClass("MMAppReferContainerView"), NSSelectorFromString(@"normalColor"), [self class], @selector(hook_referNormalColor));
        hookMethod(objc_getClass("MMAppReferContainerView"), NSSelectorFromString(@"highlightColor"), [self class], @selector(hook_referHighlightColor));
        hookMethod(objc_getClass("MMReferTextAttachmentView"), NSSelectorFromString(@"setBgView:"), [self class], @selector(hook_referSetBgView:));
        
        hookMethod(objc_getClass("MMSearchTableCellView"), NSSelectorFromString(@"setBackgroundColor:"), [self class], @selector(hook_searchCellSetBackgroundColor:));
        hookMethod(objc_getClass("MMSearchTableSectionHeaderView"), NSSelectorFromString(@"setBackgroundView:"), [self class], @selector(hook_searchHeaderSetBackgroundView:));
        hookMethod(objc_getClass("MMSearchTableCellView"), NSSelectorFromString(@"initWithFrame:"), [self class], @selector(hook_chatLogInitWithFrame:));
         hookMethod(objc_getClass("MMSearchTableCellView"), NSSelectorFromString(@"prepareForReuse"), [self class], @selector(hook_chatLogPrepareForReuse));
        //fuzzy
        hookMethod(objc_getClass("MMContactsDetailViewController"), NSSelectorFromString(@"viewWillAppear"), [self class], @selector(hook_contactsDetailViewWillAppear));
        hookMethod(objc_getClass("MMFavoriteDetailViewContoller"), NSSelectorFromString(@"viewWillAppear"), [self class], @selector(hook_favoriteDetailViewWillAppear));
        hookMethod(objc_getClass("MMSidebarContactRowView"), NSSelectorFromString(@"_updateSelectionAppearance:"), [self class], @selector(hook_updateSelectionAppearance:));
        hookMethod(objc_getClass("MMFavSidebarHeaderRowView"), NSSelectorFromString(@"initWithFrame:"), [self class], @selector(hook_sideBarHeaderInitWithFrame:));
        hookMethod(objc_getClass("MMFavSidebarRowView"), NSSelectorFromString(@"initWithFrame:"), [self class], @selector(hook_sideBarRowInitWithFrame:));
        hookMethod(objc_getClass("MMContactsDetailViewController"), @selector(sendMsgButton), [self class], @selector(hook_sendMsgButton));
        hookMethod(objc_getClass("MMChatsTableCellView"), @selector(drawSelectionBackground), [self class], @selector(hook_drawSelectionBackground));
        hookMethod(objc_getClass("MMChatsViewController"), @selector(tableView:viewForTableColumn:row:), [self class], @selector(hook_chatsViewControllerTableView:viewForTableColumn:row:));
        hookMethod(objc_getClass("MMChatsViewController"), @selector(viewDidAppear), [self class], @selector(hook_chatsViewControllerViewDidAppear));
    }
}

- (void)hook_chatsViewControllerViewDidAppear
{
    [self hook_chatsViewControllerViewDidAppear];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
        [sessionMgr loadSessionData];
    });
}

- (id)hook_chatsViewControllerTableView:(id)arg1 viewForTableColumn:(id)arg2 row:(long long)arg3
{
    MMChatsTableCellView *cell = [self hook_chatsViewControllerTableView:arg1 viewForTableColumn:arg2 row:arg3];
    
    if (cell.sessionInfo.m_uUnReadCount > 0 && cell.badgeView.style == 1) {
        unsigned int hz = cell.sessionInfo.m_uUnReadCount;
        if (hz > 5) {
            hz = 5;
        }
        CAKeyframeAnimation *rotationAnimation = [CAKeyframeAnimation animation];
        rotationAnimation.keyPath = @"transform.rotation";
        rotationAnimation.duration = kArc4random_Double_inSpace(0.20, 0.30) / hz;
        rotationAnimation.values = @[@(-M_PI_4 /90.0 * hz * 2),@(M_PI_4 /90.0 * hz * 2),@(-M_PI_4 /90.0 * hz * 2)];
        rotationAnimation.repeatCount = HUGE;
        [cell.avatar.layer addAnimation:rotationAnimation forKey:nil];
        //彩蛋
        if (cell.sessionInfo.m_uUnReadCount > 99) {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            animation.values = @[@1.0,@1.07,@1.15,@1.2,@1.15,@1.07,@1.0];
            animation.duration = 0.2;
            animation.repeatCount = HUGE;
            animation.calculationMode = kCAAnimationCubic;
            [cell.avatar.layer addAnimation:animation forKey:nil];
        }
    } else {
        [cell.avatar.layer removeAllAnimations];
    }
    
    return cell;
}

//会话选中高亮
- (void)hook_drawSelectionBackground
{
    MMChatsTableCellView *cell = (MMChatsTableCellView *)self;
    if ([YMWeChatPluginConfig sharedConfig].usingTheme) {
        if (cell.selected) {
            CAKeyframeAnimation *rotationAnimation = [CAKeyframeAnimation animation];
            rotationAnimation.keyPath = @"transform.rotation";
            rotationAnimation.duration = 0.15;
            rotationAnimation.values = @[@(-M_PI_4 /90.0 * 5),@(M_PI_4 /90.0 * 5),@(-M_PI_4 /90.0 * 5)];
            rotationAnimation.repeatCount = 2;
            [cell.avatar.layer addAnimation:rotationAnimation forKey:nil];
        }
    }
    
    if ([YMWeChatPluginConfig sharedConfig].usingDarkTheme) {
        [cell.shapeLayer removeFromSuperlayer];
        NSColor *color = nil;
        if (cell.selected) {
            if ([cell.window isMainWindow] && cell.shouldRemoveHighlight == YES) {
                color = [NSColor whiteColor];
            } else {
                color = kRGBColor(206,207,211, 0.4);
            }
        } else {
            color = [NSColor clearColor];
        }
        cell.shapeLayer = [[objc_getClass("CAShapeLayer") alloc] init];
        CGPathRef path = CGPathCreateWithRect(cell.bounds, nil);
        cell.shapeLayer.path = path;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        cell.shapeLayer.fillColor = color.CGColor;
        [CATransaction commit];
        CGPathRelease(path);
        [cell.layer addSublayer:cell.shapeLayer];
    } else {
        [self hook_drawSelectionBackground];
    }
    
}

- (id)hook_sendMsgButton
{
    NSButton *btn = [self hook_sendMsgButton];
    if ([YMWeChatPluginConfig sharedConfig].usingTheme) {
        dispatch_async(dispatch_get_main_queue(), ^{
            btn.layer.cornerRadius = 5;
            btn.layer.borderColor = TK_RGBA(6, 193, 96, 0.2).CGColor;
            btn.layer.borderWidth = 2;
        });
    }
    return btn;
}

- (id)hook_sideBarRowInitWithFrame:(struct CGRect)arg1
{
    MMFavSidebarRowView *rowView = [self hook_sideBarRowInitWithFrame:arg1];
    if (LargerOrEqualVersion(@"2.4.2")) {
        if ([YMWeChatPluginConfig sharedConfig].usingDarkTheme) {
            NSColor *normalColor = kDarkModeTextColor;
            rowView.iconView.normalColor = normalColor;
        }
    }
    return rowView;
}

- (id)hook_sideBarHeaderInitWithFrame:(struct CGRect)arg1
{
    MMFavSidebarHeaderRowView *rowView = [self hook_sideBarHeaderInitWithFrame:arg1];
    if (LargerOrEqualVersion(@"2.4.2")) {
        if ([YMWeChatPluginConfig sharedConfig].usingDarkTheme) {
            NSColor *normalColor = kDarkModeTextColor;
            rowView.iconView.normalColor = normalColor;
            rowView.arrowIconView.normalColor = normalColor;
        }
    }
    return rowView;
}

#pragma mark - 联系人
- (void)hook_updateSelectionAppearance:(id)arg1
{
    NSNotification *ntf = (NSNotification *)arg1;
    if ([ntf.name containsString:@"NSWindow"]) {
        return;
    }
    [self hook_updateSelectionAppearance:arg1];
}

#pragma mark - 收藏
- (void)hook_favoriteDetailViewWillAppear
{
    [self hook_favoriteDetailViewWillAppear];
    
    if (!YMWeChatPluginConfig.sharedConfig.fuzzyMode) {
        return;
    }
    
    MMFavoriteDetailViewContoller *favoriteDetailVC = (MMFavoriteDetailViewContoller *)self;
    for (NSView *sub in favoriteDetailVC.view.subviews) {
        if ([sub isKindOfClass:objc_getClass("MMFavoriteCollectionView")]) {
            [[YMThemeManager shareInstance] changeTheme:sub color:[NSColor clearColor]];
        }
    }
}

#pragma mark - 联系人详情
- (void)hook_contactsDetailViewWillAppear
{
    [self hook_contactsDetailViewWillAppear];
    
    if (!YMWeChatPluginConfig.sharedConfig.fuzzyMode) {
        return;
    }
    
    MMContactsDetailViewController *contactsDetailVC = (MMContactsDetailViewController *)self;
    for (NSView *sub in contactsDetailVC.scrollViewContainer.subviews) {
        if ([sub isKindOfClass:NSClipView.class]) {
            [[YMThemeManager shareInstance] changeTheme:sub color:[NSColor clearColor]];
        }
    }
}

#pragma mark - 搜索界面
- (id)hook_chatLogInitWithFrame:(CGRect)arg1
{
    MMSearchChatLogTableCellView *cell = [self hook_chatLogInitWithFrame:arg1];
    cell.hidden = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell setSelected:YES];
        cell.hidden = NO;
    });
    return cell;
}

- (void)hook_chatLogPrepareForReuse
{
    MMSearchChatLogTableCellView *cell = (MMSearchChatLogTableCellView *)self;
    cell.hidden = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
       [cell setSelected:YES];
        cell.hidden = NO;
    });
    [self hook_chatLogPrepareForReuse];
}

- (void)hook_chatLogCellSetTitleLabel:(MMTextField *)arg1
{
    [self hook_chatLogCellSetTitleLabel:arg1];
    dispatch_async(dispatch_get_main_queue(), ^{
        arg1.backgroundColor = [YMWeChatPluginConfig sharedConfig].mainChatCellBackgroundColor;
    });
}

- (void)hook_searchHeaderSetBackgroundView:(NSView *)arg1
{
    [self hook_searchHeaderSetBackgroundView:arg1];
    dispatch_async(dispatch_get_main_queue(), ^{
       [[YMThemeManager shareInstance] changeTheme:arg1];
    });
}

- (void)hook_searchCellSetBackgroundColor:(NSColor *)arg1
{
    [self hook_searchCellSetBackgroundColor:[YMWeChatPluginConfig sharedConfig].mainChatCellBackgroundColor];
}

- (NSImageView *)hook_chatDetailAvatarImageView
{
    if ([YMWeChatPluginConfig sharedConfig].usingDarkTheme) {
        @try {
            MMChatDetailMemberRowView *row = (MMChatDetailMemberRowView *)self;
            NSTextFieldCell *cell = [row.nameField valueForKey:@"cell"];
            NSAttributedString *originalText = [cell valueForKey:@"contents"];
            NSMutableAttributedString *darkModelChatName = [[NSMutableAttributedString alloc] initWithString:originalText.string attributes:@{NSForegroundColorAttributeName : kMainTextColor, NSFontAttributeName : [NSFont systemFontOfSize:14]}];
            [row.nameField setAttributedStringValue:darkModelChatName];
        } @catch (NSException *exception) {
            
        }
    }

    return [self hook_chatDetailAvatarImageView];
}

- (void)hook_pickerListDrawRect:(CGRect)arg1
{
    [self hook_pickerListDrawRect:arg1];
    
    if ([YMWeChatPluginConfig sharedConfig].usingDarkTheme) {
        @try {
            MMSessionPickerListRowView *row = (MMSessionPickerListRowView *)self;
            NSTextFieldCell *cell = [row.sessionNameField valueForKey:@"cell"];
            NSAttributedString *originalText = [cell valueForKey:@"contents"];
            NSMutableAttributedString *darkModelChatName = [[NSMutableAttributedString alloc] initWithString:originalText.string attributes:@{NSForegroundColorAttributeName : kMainTextColor, NSFontAttributeName : [NSFont systemFontOfSize:14]}];
            [row.sessionNameField setAttributedStringValue:darkModelChatName];
        } @catch (NSException *exception) {
            
        }
    }

}

- (void)hook_textFieldSetTextColor:(NSAttributedString *)arg1
{
    // history trigger by button in chat dialog
    if ([YMWeChatPluginConfig sharedConfig].usingDarkTheme) {
        NSView *view = (NSView *)self;
        if ([view.superview isKindOfClass:objc_getClass("MMChatTextMessageCellView")] && arg1.string.length > 0) {
            arg1 = [[NSMutableAttributedString alloc] initWithString:arg1.string attributes:@{NSForegroundColorAttributeName : kMainTextColor, NSFontAttributeName : [NSFont systemFontOfSize:13]}];
        }
    }
    [self hook_textFieldSetTextColor:arg1];
}

#pragma mark - 防止 dark mode 黑底黑色
- (void)hook_textFieldSetAttributedStringValue:(NSAttributedString *)attributedString
{
    NSTextField *field = (NSTextField *)self;
    NSMutableAttributedString *a = [attributedString mutableCopy];
    
    if (YMWeChatPluginConfig.sharedConfig.usingTheme) {
        NSView *sv = field.superview;
        
        Class tcClass = NSClassFromString(@"MMFavoritesListTextCell");
        Class mdClass = NSClassFromString(@"MMFavoritesListMediaCell");
        Class dvClass = NSClassFromString(@"MMDragEventView");
        Class ntClass = NSClassFromString(@"MMFavoritesListNoteCell");
        
        for (int i = 0; i < 5; i++) {
            if (sv == nil) {
                 break;
            }
            if ([sv isKindOfClass:tcClass] || [sv isKindOfClass:dvClass] || [sv isKindOfClass:mdClass] || [sv isKindOfClass:ntClass]) {
                [a addAttributes:@{
                    NSForegroundColorAttributeName: kMainTextColor
                } range:NSMakeRange(0, a.length)];
                field.backgroundColor = kMainBackgroundColor;
                break;
            }
            sv = sv.superview;
        }
    }
    
    [self hook_textFieldSetAttributedStringValue: a];
}

- (BOOL)hook_shouldDisableSetFrameOrigin
{
    NSTextView *view = (NSTextView *)self;
    
    // Search chat history window
    if (view.superview != nil && ([view.superview isKindOfClass:NSClassFromString(@"MMChatLogEventView")] || [view.superview isKindOfClass:NSClassFromString(@"MMView")]) && ![view.superview isKindOfClass:objc_getClass("MMReaderWrapView")]) {
        NSRange area = NSMakeRange(0, [view.textStorage length]);
        [view.textStorage removeAttribute:NSForegroundColorAttributeName range:area];
        [view.textStorage addAttributes:@{
            NSForegroundColorAttributeName: kMainTextColor
        } range:area];
    }
    
    return [self hook_shouldDisableSetFrameOrigin];
}

- (void)hook_updateGroupChatNickName
{
    [self hook_updateGroupChatNickName];
    MMMessageCellView *cellView = (MMMessageCellView *)self;
    NSTextFieldCell *cell = [cellView.groupChatNickNameLabel valueForKey:@"cell"];
    NSAttributedString *originalText = [cell valueForKey:@"contents"];
    
    if (originalText.length > 0) {
        NSColor *radomColor = nil;
        if ([YMWeChatPluginConfig sharedConfig].usingDarkTheme) {
            radomColor = [[YMThemeManager shareInstance] randomColor:originalText.string.md5String];
        } else {
            radomColor = kMainTextColor;
        }
        
        NSMutableAttributedString *darkModelChatName = [[NSMutableAttributedString alloc] initWithString:originalText.string attributes:@{NSForegroundColorAttributeName : radomColor, NSFontAttributeName : [NSFont systemFontOfSize:12]}];
        [cellView.groupChatNickNameLabel setAttributedStringValue:darkModelChatName];
    }
}

+ (id)hook_preprocessTextAttributes:(id)arg1
{
    NSDictionary *styleDict = (NSDictionary *)arg1;
    NSMutableDictionary *changeDict = [NSMutableDictionary dictionaryWithDictionary:styleDict];
    
    NSColor *color = nil;
    if (YMWeChatPluginConfig.sharedConfig.fuzzyMode) {
        color = [NSColor whiteColor];
    } else {
        color = kMainTextColor;
    }
    
    [changeDict setValue:color forKey:@"NSColor"];
    return changeDict;
}

- (void)hook_updateChatName
{
    [self hook_updateChatName];
    MMChatInfoView *infoView = (MMChatInfoView *)self;
    
    @try {
        NSTextFieldCell *cell = [infoView.chatNameLabel valueForKey:@"cell"];
        NSAttributedString *originalText = [cell valueForKey:@"contents"];
        NSMutableAttributedString *darkModelChatName = [[NSMutableAttributedString alloc] initWithString:originalText.string attributes:@{NSForegroundColorAttributeName : [NSColor whiteColor], NSFontAttributeName : [NSFont systemFontOfSize:15]}];
        [infoView.chatNameLabel setAttributedStringValue:darkModelChatName];
    } @catch (NSException *exception) {
        
    };
}

- (void)hook_setTextFieldCellColor:(NSColor *)color
{
    NSColor *textColor = nil;
    if (YMWeChatPluginConfig.sharedConfig.fuzzyMode) {
        textColor = kDarkModeTextColor;
    } else {
        textColor = kMainTextColor;
    }
    
    [self hook_setTextFieldCellColor:textColor];
}

- (void)hook_setMessageText:(id)arg1
{
    [self hook_setMessageText:arg1];
    NSAlert *alert = (NSAlert *)self;
    [[YMThemeManager shareInstance] changeTheme:alert.window.contentView];
    
    if ([YMWeChatPluginConfig sharedConfig].darkMode || [YMWeChatPluginConfig sharedConfig].blackMode) {
        for (NSView *sub in alert.window.contentView.subviews) {
            if ([sub isKindOfClass:NSTextField.class]) {
                NSTextFieldCell *cell = [sub valueForKey:@"cell"];
                cell.textColor = [NSColor whiteColor];
                NSAttributedString *originalText = [cell valueForKey:@"contents"];
                NSColor *radomColor = [NSColor whiteColor];
                if (originalText.length > 0) {
                    NSMutableAttributedString *darkModelChatName = [[NSMutableAttributedString alloc] initWithString:originalText.string attributes:@{NSForegroundColorAttributeName : radomColor, NSFontAttributeName : [NSFont systemFontOfSize:12]}];
                               [cell setAttributedStringValue:darkModelChatName];
                }
            }
        }
    }
}

- (void)hook_setSeperator:(NSView *)arg1
{
    [[YMThemeManager shareInstance] changeTheme:arg1 color:kMainSeperatorColor];
    [self hook_setSeperator:arg1];
}

- (void)hook_tableViewsetBackgroundColor:(NSColor *)arg1
{
    [self hook_tableViewsetBackgroundColor:kMainBackgroundColor];
}

- (void)hook_globalChatManagerWindowDidLoad
{
    [self hook_globalChatManagerWindowDidLoad];
    NSViewController *viewController = (NSViewController *)self;
    [[YMThemeManager shareInstance] changeTheme:viewController.view];
}

- (void)hook_sessionPickerWindowDidLoad
{
    [self hook_sessionPickerWindowDidLoad];
    MMSessionPickerWindow *window = (MMSessionPickerWindow *)self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[YMThemeManager shareInstance] changeTheme:window.window.contentView];
    });
}

- (void)hook_setPreferredDividerColor:(NSColor *)arg1
{
    [self hook_setPreferredDividerColor:kMainDividerColor];
}

- (void)hook_composeSetTextColor:(NSColor *)color
{
    // 联系人介绍 What's up
    [self hook_composeSetTextColor:kMainTextColor];
}

- (NSColor *)hook_referNormalColor
{
    return kRGBColor(160, 180, 200, 1);
}

- (NSColor *)hook_referHighlightColor
{
    return NSColor.lightGrayColor;
}

- (void)hook_referSetBgView:(NSView *)view
{
    [self hook_referSetBgView:view];
    
    view.layer.backgroundColor = kRGBColor(160, 180, 200, 1).CGColor;
}

- (void)hook_memberListViewDidLoad
{
    [self hook_memberListViewDidLoad];
    MMChatMemberListViewController *memberListVC = (MMChatMemberListViewController *)self;
    for (NSView *sub in memberListVC.view.subviews) {
        for (NSView *effect in sub.subviews) {
            if ([effect isKindOfClass:NSVisualEffectView.class]) {
                [YMThemeManager changeEffectViewMode:(NSVisualEffectView *)effect];
                for (NSView *effectSub in effect.subviews) {
                    [[YMThemeManager shareInstance] changeTheme:effectSub];
                }
                break;
            }
        }
    }
}

- (void)hook_preferencesWindowDidLoad
{
    [self hook_preferencesWindowDidLoad];
    MMPreferencesWindowController *window = (MMPreferencesWindowController *)self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[YMThemeManager shareInstance] changeTheme:window.window.contentView];
    });
}

- (void)hook_fileListViewDidLoad
{
    [self hook_fileListViewDidLoad];
    MMFileListViewController *fileListVC = (MMFileListViewController *)self;
    [[YMThemeManager shareInstance] changeTheme:fileListVC.view];
}

- (void)hook_showWindow:(nullable id)sender
{
    [self hook_showWindow:sender];
    
    NSWindowController *window = (NSWindowController *)self;
    [[YMThemeManager shareInstance] changeTheme:window.window.contentView];
}

- (void)hook_updateNickName
{
    [self hook_updateNickName];
    MMChatsTableCellView *cell = (MMChatsTableCellView *)self;
    NSAttributedString *str = cell.nickName.attributedStringValue;
    NSRange range = NSMakeRange(0, str.length);
    NSDictionary *attributes = [str attributesAtIndex:0 effectiveRange:&range];
    NSFont *attributesFont = [attributes valueForKey:@"NSFont"];
    NSMutableAttributedString *returnValue = [[NSMutableAttributedString alloc] initWithString:str.string attributes:@{NSForegroundColorAttributeName :kRGBColor(255, 255, 255, 1.0), NSFontAttributeName : attributesFont}];
    cell.nickName.attributedStringValue = returnValue;
    
    if ([YMWeChatPluginConfig sharedConfig].usingDarkTheme) {
        cell.muteIndicator.normalColor = [NSColor redColor];
    }
}

- (void)hook_mouseDown:(id)arg1
{
    [self hook_mouseDown:arg1];
    
    if ([YMWeChatPluginConfig sharedConfig].usingDarkTheme) {
        MMChatsTableCellView *cell = (MMChatsTableCellView *)self;
    }
}

- (void)hook_setAttributedStringValue:(NSAttributedString *)arg1
{
    struct mach_header *mh_addr = _dyld_get_image_header(0);
    NSString *mh_addrStr = [NSString stringWithFormat:@"%p",mh_addr];
    NSString *call = [NSThread callStackSymbols][1];
    NSArray *sepList = [call componentsSeparatedByString:@"0x"];
    NSString *offset_addrStr = nil;
    if (sepList.count > 1) {
        NSArray *sepWList = [sepList[1] componentsSeparatedByString:@" W"];
        if (sepWList.count > 1) {
            NSString *final = sepWList[0];
            offset_addrStr = [NSString stringWithFormat:@"0x%@",final];
        }
    }
    
    if (offset_addrStr) {
        unsigned long mh_ten = strtoul(mh_addrStr.UTF8String, 0, 16);
        unsigned long offset_ten = strtoul(offset_addrStr.UTF8String, 0, 16);
        unsigned long slide = offset_ten - mh_ten;
        NSMutableAttributedString *returnValue = nil;
        if (slide == 11212944) {
            returnValue = [[NSMutableAttributedString alloc] initWithString:arg1.string attributes:@{NSForegroundColorAttributeName :kRGBColor(255, 255, 255, 1.0), NSFontAttributeName : [NSFont systemFontOfSize:14]}];
            
        } else if (slide == 11218107) {
            returnValue = [[NSMutableAttributedString alloc] initWithString:arg1.string attributes:@{NSForegroundColorAttributeName :kRGBColor(162, 182, 203, 1.0), NSFontAttributeName : [NSFont systemFontOfSize:12]}];
        } else {
            returnValue = arg1;
        }
        
        [self hook_setAttributedStringValue:returnValue];
    } else {
        [self hook_setAttributedStringValue:arg1];
    }
    
}

- (void)hook_QRCodeViewDidLoad
{
    [self hook_QRCodeViewDidLoad];
}

- (void)hook_loginWaitingViewDidLoad
{
    [self hook_loginWaitingViewDidLoad];
    
    if ([self.className isEqualToString:@"MMLoginWaitingConfirmViewController"]) {
        MMLoginWaitingConfirmViewController *loginWaitVC = (MMLoginWaitingConfirmViewController *)self;
        [[YMThemeManager shareInstance] changeTheme:loginWaitVC.view];
    }
}

- (void)hook_setTextColor:(NSColor *)arg1
{
    arg1 = kMainTextColor;
    [self hook_setTextColor:arg1];
}

- (instancetype)hook_scrollViewInitWithFrame:(NSRect)frameRect
{
    NSScrollView *view = (NSScrollView *)self;
    [[YMThemeManager shareInstance] changeTheme:view.contentView];
    return [self hook_scrollViewInitWithFrame:frameRect];
}

- (void)hook_ChatMessageViewControllerViewDidLoad
{
    [self hook_ChatMessageViewControllerViewDidLoad];
}

- (void)hook_ComposeInputViewControllerViewDidLoad
{
    [self hook_ComposeInputViewControllerViewDidLoad];
    MMComposeInputViewController *controller = (MMComposeInputViewController *)self;
    [[YMThemeManager shareInstance] changeTheme:controller.view];
    if (LargerOrEqualVersion(@"2.4.2")) {
        if ([YMWeChatPluginConfig sharedConfig].usingDarkTheme) {
            NSColor *normalColor = kDarkModeTextColor;
            controller.openBrandMenuButton.normalColor = normalColor;
            controller.closeBrandMenuButton.normalColor = normalColor;
            controller.chatManagerButton.normalColor = normalColor;
            controller.voiceButton.normalColor = normalColor;
            controller.videoButton.normalColor = normalColor;
            controller.screenShotButton.normalColor = normalColor;
            controller.attachmentButton.normalColor = normalColor;
            controller.stickerButton.normalColor = normalColor;
            controller.multiTalkButton.normalColor = normalColor;
        }
    }
}

- (void)hook_addSubView:(NSView *)view
{
    [self hook_addSubView:view];
    
    //不适配小程序
    NSArray *runApps = [NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.tencent.xinWeChat"];
    if (runApps.count > 1) {
        return;
    }
    
    if ([self isKindOfClass:[objc_getClass("MMAppReferContainerView") class]]) {
        return;
    }
    
    //Excel与Word文档黑色适配
    if ([self isKindOfClass:[objc_getClass("MMQLPreviewFileView") class]]) {
        return;
    }
    
    if ([view isKindOfClass:[objc_getClass("SVGImageView") class]]) {
        return;
    }
    
    if ([view isKindOfClass:[objc_getClass("MMStickerMessageCellView") class]]) {
        return;
    }
    
    if ([view isKindOfClass:[objc_getClass("MMSystemMessageCellView") class]]) {
        if (YMWeChatPluginConfig.sharedConfig.fuzzyMode) {
           [[YMThemeManager shareInstance] changeTheme:view color:[NSColor clearColor]];
        }
        return;
    }
    
    if ([view isKindOfClass:[objc_getClass("NSTouchBarView") class]]) {
        return;
    }
    
    if ([view isKindOfClass:[objc_getClass("NSButtonImageView") class]]) {
        return;
    }
    
    if ([view isKindOfClass:[objc_getClass("NSButton") class]]) {
        return;
    }
    
    if ([view isKindOfClass:[objc_getClass("MMAvatarImageView") class]]) {
        return;
    }
    
    if ([view isKindOfClass:[objc_getClass("_NSScrollViewFloatingSubviewsContainerView") class]]) {
        return;
    }
    
    
    if ([view isKindOfClass:[objc_getClass("MMBadgeOverlayView") class]]) {
        return;
    }
    
    if ([view isKindOfClass:[objc_getClass("MMMessageCellView") class]]) {
        return;
    }
    
    
    if ([view isKindOfClass:[objc_getClass("MMChatsTableCellView") class]]) {
        return;
    }
    
    if ([view isKindOfClass:[objc_getClass("MMPreviewVideoPlayerView") class]]) {
        return;
    }
    
    if ([view isKindOfClass:NSVisualEffectView.class]) {
        NSVisualEffectView *effectView = (NSVisualEffectView *)view;
        [YMThemeManager changeEffectViewMode:effectView];
        return;
    }
    
    if ([view isKindOfClass:[objc_getClass("NewNoteContentView") class]]) {
        [[YMThemeManager shareInstance] changeTheme:view];
    }

    #pragma mark - view
    if ([view isKindOfClass:[objc_getClass("MMSessionPickerListGroupRowView") class]]) {
        for (NSView *sub in view.subviews) {
            if (![sub isKindOfClass:[NSTextField class]]) {
                [[YMThemeManager shareInstance] changeTheme:sub];
            }
        }
    }
    
    if ([view isKindOfClass:[objc_getClass("MMOutlineButton") class]]) {
        [[YMThemeManager shareInstance] changeTheme:view];
    }
    
    if ([view isKindOfClass:[objc_getClass("JNWClipView") class]]) {
        [[YMThemeManager shareInstance] changeTheme:view];
    }
    
    if ([view isKindOfClass:[objc_getClass("_NSBrowserFlippedClipView") class]]) {
        [[YMThemeManager shareInstance] changeTheme:view];
    }
    
    if ([view isKindOfClass:[objc_getClass("NSClipView") class]]) {
        [[YMThemeManager shareInstance] changeTheme:view];
    }
    
    #pragma mark - controller
    NSResponder *responder = view;
    NSViewController *controller = nil;
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass: [NSViewController class]]) {
            controller = (NSViewController *)responder;
        }
    }
    
    
    if ([view isKindOfClass:[objc_getClass("MMComposeTextView") class]]) {
        MMComposeTextView *textView = (MMComposeTextView *)view;
        textView.insertionPointColor = [NSColor whiteColor];
        textView.textColor = [NSColor whiteColor];
        textView.backgroundColor = [YMWeChatPluginConfig sharedConfig].mainBackgroundColor;
    }
    
    if ([view isKindOfClass:[objc_getClass("SwipeDeleteView") class]]) {
        [[YMThemeManager shareInstance] changeTheme:view];
    }
    
    
    if ([view isKindOfClass:[objc_getClass("MMFavoritesListMediaCell") class]]) {
        for (NSView *sub in view.subviews) {
            [[YMThemeManager shareInstance] changeTheme:sub];
        }
    }
    
    
    if ([view isKindOfClass:[objc_getClass("MMFavoritesListTextCell") class]]) {
        for (NSView *sub in view.subviews) {
            [[YMThemeManager shareInstance] changeTheme:sub];
        }
    }
    
    if ([view isKindOfClass:[objc_getClass("MMFavoritesListNoteCell") class]]) {
        for (NSView *sub in view.subviews) {
            [[YMThemeManager shareInstance] changeTheme:sub];
        }
    }
    
    //公众号
    if ([view isKindOfClass:[objc_getClass("MMDragEventView") class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![view.superview isKindOfClass:objc_getClass("MMQLPreviewView")]) {
                [[YMThemeManager shareInstance] changeTheme:view];
                for (NSView *effect in view.subviews) {
                    if ([effect isKindOfClass:NSVisualEffectView.class]) {
                        [YMThemeManager changeEffectViewMode:(NSVisualEffectView *)effect];
                        for (NSView *effectSub in effect.subviews) {
                            if (![effectSub isKindOfClass:NSTextField.class]) {
                                [[YMThemeManager shareInstance] changeTheme:effectSub];
                                break;
                            }
                        }
                    }
                }
            }
        });
    }
    
    if ([controller isKindOfClass:[objc_getClass("MMChatMessageViewController") class]]) {
        MMChatMessageViewController *msgViewController = (MMChatMessageViewController *)controller;
        [msgViewController.messageTableView setBackgroundColor:kMainBackgroundColor];
        [[msgViewController.messageTableView enclosingScrollView] setDrawsBackground:NO];
        if (![view isKindOfClass:objc_getClass("NSTextField")]) {
            [[YMThemeManager shareInstance] changeTheme:view];
            //会话标题高斯模糊
            if ([view isKindOfClass:NSVisualEffectView.class]) {
                [YMThemeManager changeEffectViewMode:(NSVisualEffectView *)view];
            }
        }
    }
    
    if ([controller isKindOfClass:[objc_getClass("MMFavoriteDetailViewContoller") class]]) {
        [[YMThemeManager shareInstance] changeTheme:view];
    }
    
    if ([controller isKindOfClass:[objc_getClass("MMComposeInputViewController") class]]) {
        [[YMThemeManager shareInstance] changeTheme:view];
    }
    
    if ([controller isKindOfClass:[objc_getClass("MMMainViewController") class]]) {
        if (![view isKindOfClass:objc_getClass("_NSImageViewSimpleImageView")]) {
            [[YMThemeManager shareInstance] changeTheme:view];
        }
    }
    
    if ([controller isKindOfClass:[objc_getClass("MMContactsDetailViewController") class]]) {
        [[YMThemeManager shareInstance] changeTheme:view];
    }
}


- (void)hook_themeViewDidLoad
{
    [self hook_themeViewDidLoad];
    
    if ([self isKindOfClass:objc_getClass("QLPreviewPasswordViewController")]) {
        return;
    }
    
    if ([self isKindOfClass:objc_getClass("MMChatMemberListViewController")]) {
        return;
    }
    
    if ([self isKindOfClass:objc_getClass("AVControlsContainerViewController")]) {
         return;
    }
    
    //Fix: TouchBar在少女模式下会变色
    if ([self isKindOfClass:objc_getClass("NSCandidateListViewController")]) {
        return;
    }
    
    if ([self isKindOfClass:objc_getClass("NSTouchBarViewController")]) {
        return;
    }
    
    if ([NSStringFromClass(self.class) containsString:@"FI_"]) {
        return;
    }
    
    
    if ([self isKindOfClass:objc_getClass("MMContactsDetailViewController")]) {
        MMContactsDetailViewController *contactsVC = (MMContactsDetailViewController *)self;
        if (!contactsVC.currContactData) {
            contactsVC.contactNameLabel.stringValue = @"";
        }
    }
    
    NSViewController *viewController = (NSViewController *)self;
    [[YMThemeManager shareInstance] changeTheme:viewController.view];
    [YMFuzzyManager fuzzyViewController:viewController];
}

- (void)hook_windowDidLoad
{
    [self hook_windowDidLoad];
    
    if ([self isKindOfClass:objc_getClass("MMMultiTalkWindowController")]) {
        return;
    }
    
    if ([self isKindOfClass:objc_getClass("MMGlobalChatManagerWindowController")]) {
        MMGlobalChatManagerWindowController *window = (MMGlobalChatManagerWindowController *)self;
        for (NSView *sub in window.window.contentView.subviews) {
            if (![sub isKindOfClass:objc_getClass("MMCustomSearchField")]) {
               [[YMThemeManager shareInstance] changeTheme:sub];
            }
        }
    }
    
    [YMFuzzyManager fuzzyWindowViewController:(NSWindowController *)self];
}

@end
