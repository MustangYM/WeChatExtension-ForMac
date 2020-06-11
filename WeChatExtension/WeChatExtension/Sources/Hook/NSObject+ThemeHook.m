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

@interface NSCellAuxiliary : NSObject

@end

@implementation NSObject (ThemeHook)
+ (void)hookTheme
{
    if (![TKWeChatPluginConfig sharedConfig].isThemeLoaded) {
        [[TKWeChatPluginConfig sharedConfig] setIsThemeLoaded:YES];
        [[TKWeChatPluginConfig sharedConfig] setDarkMode:YES];
        [[TKWeChatPluginConfig sharedConfig] setGroupMultiColorMode:YES];
    }
    
    if (TKWeChatPluginConfig.sharedConfig.usingTheme) {
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
        arg1.backgroundColor = [TKWeChatPluginConfig sharedConfig].mainChatCellBackgroundColor;
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
    [self hook_searchCellSetBackgroundColor:[TKWeChatPluginConfig sharedConfig].mainChatCellBackgroundColor];
}

- (NSImageView *)hook_chatDetailAvatarImageView
{
    if ([TKWeChatPluginConfig sharedConfig].usingDarkTheme) {
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
    
    if ([TKWeChatPluginConfig sharedConfig].usingDarkTheme) {
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
    if ([TKWeChatPluginConfig sharedConfig].usingDarkTheme) {
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
    
    if (TKWeChatPluginConfig.sharedConfig.usingTheme) {
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
    if (view.superview != nil && ([view.superview isKindOfClass:NSClassFromString(@"MMChatLogEventView")] || [view.superview isKindOfClass:NSClassFromString(@"MMView")])) {
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
        if ([TKWeChatPluginConfig sharedConfig].usingDarkTheme && [TKWeChatPluginConfig sharedConfig].groupMultiColorMode) {
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
    [changeDict setValue:kMainTextColor forKey:@"NSColor"];
    return changeDict;
}

- (void)hook_updateChatName
{
    [self hook_updateChatName];
    MMChatInfoView *infoView = (MMChatInfoView *)self;
    
    @try {
        NSTextFieldCell *cell = [infoView.chatNameLabel valueForKey:@"cell"];
        NSAttributedString *originalText = [cell valueForKey:@"contents"];
        NSMutableAttributedString *darkModelChatName = [[NSMutableAttributedString alloc] initWithString:originalText.string attributes:@{NSForegroundColorAttributeName : [NSColor whiteColor], NSFontAttributeName : [NSFont systemFontOfSize:16]}];
        [infoView.chatNameLabel setAttributedStringValue:darkModelChatName];
    } @catch (NSException *exception) {
        
    };
}

- (void)hook_setTextFieldCellColor:(NSColor *)color
{
    [self hook_setTextFieldCellColor:kMainTextColor];
}

- (void)hook_setMessageText:(id)arg1
{
    [self hook_setMessageText:arg1];
    NSAlert *alert = (NSAlert *)self;
    [[YMThemeManager shareInstance] changeTheme:alert.window.contentView];
    
    if ([TKWeChatPluginConfig sharedConfig].usingDarkTheme) {
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

- (void)hook_windowDidLoad
{
    [self hook_windowDidLoad];
    
    if ([self isKindOfClass:objc_getClass("MMMultiTalkWindowController")]) {
        return;
    }
    
    NSWindowController *window = (NSWindowController *)self;
    [[YMThemeManager shareInstance] changeTheme:window.window.contentView];
    
    if ([self isKindOfClass:objc_getClass("MMGlobalChatManagerWindowController")]) {
        MMGlobalChatManagerWindowController *window = (MMGlobalChatManagerWindowController *)self;
        for (NSView *sub in window.window.contentView.subviews) {
            if (![sub isKindOfClass:objc_getClass("MMCustomSearchField")]) {
               [[YMThemeManager shareInstance] changeTheme:sub];
            }
        }
    }
    
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
    
    if ([TKWeChatPluginConfig sharedConfig].usingDarkTheme) {
        [[YMThemeManager shareInstance] changeTheme:cell color:[TKWeChatPluginConfig sharedConfig].mainChatCellBackgroundColor];
        cell.muteIndicator.normalColor = [NSColor redColor];
    }
}

- (void)hook_mouseDown:(id)arg1
{
    [self hook_mouseDown:arg1];
    
    if ([TKWeChatPluginConfig sharedConfig].usingDarkTheme) {

        MMChatsTableCellView *cell = (MMChatsTableCellView *)self;

        NSColor *original = [NSColor colorWithCGColor:cell.layer.backgroundColor];
        cell.layer.backgroundColor = (TKWeChatPluginConfig.sharedConfig.blackMode ? kRGBColor(128,128,128, 0.5) : kRGBColor(147, 148, 248, 0.5)).CGColor;
        [cell setNeedsDisplay:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            cell.layer.backgroundColor = original.CGColor;
            [cell setNeedsDisplay:YES];
        });
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
    
    if ([TKWeChatPluginConfig sharedConfig].usingDarkTheme) {
        for (NSView *sub in controller.view.subviews) {
            if ([sub isKindOfClass:objc_getClass("SVGButton")]) {
                NSButton *button = (NSButton *)sub;
                NSImage *tempImage = button.image;
                button.image = button.alternateImage;
                button.alternateImage = tempImage;
                button.alphaValue = 1.0;
            }
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
        textView.backgroundColor = kMainBackgroundColor;
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
    
    NSViewController *viewController = (NSViewController *)self;
    [[YMThemeManager shareInstance] changeTheme:viewController.view];
}

@end
