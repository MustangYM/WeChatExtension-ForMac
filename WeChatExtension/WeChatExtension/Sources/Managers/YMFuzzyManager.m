//
//  YMFuzzyManager.m
//  WeChatExtension
//
//  Created by MustangYM on 2020/7/20.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import "YMFuzzyManager.h"
#import "YMThemeManager.h"
#import "TKWeChatPluginConfig.h"

@implementation YMFuzzyManager
+ (void)fuzzyWindowViewController:(NSWindowController *)window
{
    if (!TKWeChatPluginConfig.sharedConfig.fuzzyMode) {
        return;
    }
    
    //窗口高斯模式
    //视频通话不适配
    if ([window isKindOfClass:objc_getClass("MMVoipCallerWindowController")]) {
        return;
    }
    
    if ([window isKindOfClass:objc_getClass("MMVoipReceiverWindowController")]) {
        return;
    }
    
    [window.window setOpaque:YES];
    [window.window setBackgroundColor:[NSColor clearColor]];
    NSVisualEffectView *effView = [YMThemeManager creatFuzzyEffectView:window.window];
    
    //除了MMMainWindowController， 其余均做特殊处理
    if ([window isKindOfClass:objc_getClass("MMMainWindowController")]) {
        [window.window.contentView addSubview:effView];
    } else {
        if (window.window.contentView.subviews.count > 0) {
            NSView *firstSubView = window.window.contentView.subviews[0];
            [window.window.contentView addSubview:effView positioned:NSWindowBelow relativeTo:firstSubView];
        } else {
            [window.window.contentView addSubview:effView];
        }
    }
    
    [[YMThemeManager shareInstance] changeTheme:window.window.contentView];
}

+ (void)fuzzyViewController:(NSViewController *)viewController
{
    if (!TKWeChatPluginConfig.sharedConfig.fuzzyMode) {
        return;
    }
    
    if ([viewController isKindOfClass:objc_getClass("MMChatCollectionViewController")] || [viewController isKindOfClass:objc_getClass("MMSessionListView")]) {
        NSVisualEffectView *effView = [YMThemeManager creatFuzzyEffectView:viewController.view];
        if (viewController.view.subviews.count > 0) {
            NSView *firstSubView = viewController.view.subviews[0];
            [[YMThemeManager shareInstance] changeTheme:firstSubView color:[NSColor clearColor]];
            [viewController.view addSubview:effView positioned:NSWindowBelow relativeTo:firstSubView];
        } else {
            [viewController.view addSubview:effView];
        }
    }
}
@end
