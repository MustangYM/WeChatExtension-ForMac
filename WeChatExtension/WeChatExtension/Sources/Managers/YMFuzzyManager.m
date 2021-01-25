//
//  YMFuzzyManager.m
//  WeChatExtension
//
//  Created by MustangYM on 2020/7/20.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import "YMFuzzyManager.h"
#import "YMThemeManager.h"
#import "YMWeChatPluginConfig.h"
#import "NSViewLayoutTool.h"

@implementation YMFuzzyManager
+ (void)fuzzyWindowViewController:(NSWindowController *)window
{
    if (!YMWeChatPluginConfig.sharedConfig.fuzzyMode) {
        return;
    }
    
    if ([window isKindOfClass:objc_getClass("MMVoipCallerWindowController")]) {
        return;
    }
    
    if ([window isKindOfClass:objc_getClass("MMVoipReceiverWindowController")]) {
        return;
    }
    
    if ([window isKindOfClass:objc_getClass("MMPreviewWindowController")]) {
        return;
    }
    
    if ([window isKindOfClass:objc_getClass("MMPreviewChatMediaWindowController")]) {
        return;
    }
    
    [window.window setOpaque:YES];
    [window.window setBackgroundColor:[NSColor clearColor]];
    NSVisualEffectView *effView = [YMThemeManager creatFuzzyEffectView];
    
    //除了MMMainWindowController， 其余均做特殊处理
    if ([window isKindOfClass:objc_getClass("MMMainWindowController")]) {
        [window.window.contentView addSubview:effView];
        [effView fillSuperView];
    } else {
        if (window.window.contentView.subviews.count > 0) {
            NSView *firstSubView = window.window.contentView.subviews[0];
            [window.window.contentView addSubview:effView positioned:NSWindowBelow relativeTo:firstSubView];
            [effView fillSuperView];
        } else {
            [window.window.contentView addSubview:effView];
            [effView fillSuperView];
        }
    }

    do {
        [[YMThemeManager shareInstance] changeTheme:window.window.contentView color:kMainBackgroundColor];
        [window.window setBackgroundColor:kMainBackgroundColor];
    } while (CGRectEqualToRect(window.window.contentView.frame, CGRectZero));
}

+ (void)fuzzyViewController:(NSViewController *)viewController
{
    if (!YMWeChatPluginConfig.sharedConfig.fuzzyMode) {
        return;
    }
    
    //联系人详情单独处理
    if ([viewController isKindOfClass:objc_getClass("MMContactsDetailViewController")]) {
        return;
    }

    if ([viewController isKindOfClass:objc_getClass("MMChatCollectionViewController")]
        || [viewController isKindOfClass:objc_getClass("MMSessionListView")]
        || [viewController isKindOfClass:objc_getClass("MMStickerCollectionViewController")]
        || [viewController isKindOfClass:objc_getClass("MMContactProfileController")]
        || [viewController isKindOfClass:objc_getClass("MMContactsListViewController")]
        || [viewController isKindOfClass:objc_getClass("MMContactsLeftMasterViewController")]
        || [viewController isKindOfClass:objc_getClass("MMContactsRightDetailViewController")]
        || [viewController isKindOfClass:objc_getClass("MMChatMessageViewController")]
        || [viewController isKindOfClass:objc_getClass("MMSessionChoosenView")]) {
        NSVisualEffectView *effView = [YMThemeManager creatFuzzyEffectView];
        if (viewController.view.subviews.count > 0) {
            NSView *firstSubView = viewController.view.subviews[0];
            [[YMThemeManager shareInstance] changeTheme:firstSubView color:[NSColor clearColor]];
            [viewController.view addSubview:effView positioned:NSWindowBelow relativeTo:firstSubView];
            [effView fillSuperView];
        } else {
            [viewController.view addSubview:effView];
            [effView fillSuperView];
        }
    }
}
@end
