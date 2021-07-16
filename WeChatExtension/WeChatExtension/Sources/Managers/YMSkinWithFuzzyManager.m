//
//  YMSkinWithFuzzyManager.m
//  WeChatExtension
//
//  Created by MustangYM on 2021/7/1.
//  Copyright © 2021 MustangYM. All rights reserved.
//

#import "YMSkinWithFuzzyManager.h"
#import "YMThemeManager.h"
#import "YMWeChatPluginConfig.h"
#import "NSViewLayoutTool.h"
#import "SDImageCache.h"

@implementation YMSkinWithFuzzyManager
+ (void)skinWindowViewController:(NSWindowController *)window
{
    if (!YMWeChatPluginConfig.sharedConfig.skinMode) {
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
        window.window.contentView.size = CGSizeMake(850, 700);
        [self addSkinImageView:window.window.contentView relativeView:nil window:window.window needSkin:YES];
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
    } while (CGRectEqualToRect(window.window.frame, CGRectZero));
}

+ (void)skinViewController:(NSViewController *)viewController
{
    if (!YMWeChatPluginConfig.sharedConfig.skinMode) {
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
        || [viewController isKindOfClass:objc_getClass("MMSessionChoosenView")]
        || [viewController isKindOfClass:objc_getClass("MMComposeInputViewController")]
        || [viewController isKindOfClass:objc_getClass("MMFileListViewController")]
        || [viewController isKindOfClass:objc_getClass("MMFileSplitViewController")]) {
        NSVisualEffectView *effView = [YMThemeManager creatFuzzyEffectView];
        if (viewController.view.subviews.count > 0) {
            NSView *firstSubView = viewController.view.subviews[0];
            [[YMThemeManager shareInstance] changeTheme:firstSubView color:[NSColor clearColor]];
        } else {
            [viewController.view addSubview:effView];
            [effView fillSuperView];
        }
    }
}

+ (void)addSkinImageView:(NSView *)contentView relativeView:(NSView *)relativeView window:(NSWindow *)window needSkin:(BOOL)needSkin
{
    if (needSkin) {
        do {
            NSView *innerContentView = [[NSView alloc] init];
            [[YMThemeManager shareInstance] changeTheme:innerContentView color:[NSColor clearColor]];
            NSImageView *imageV = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 850, 700)];
            imageV.imageScaling = NSImageScaleAxesIndependently;
//            NSImage *image = kImageWithName(@"YOUR_IMAGE.jpg");
            
//            [imageV sd_setImageWithURL:[NSURL URLWithString:url]];
            NSImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"kSKINURL"]];
            image.size = CGSizeMake(850, 700);
            imageV.image = image;
            imageV.alphaValue = 1.0;
            [innerContentView addSubview:imageV];
            [imageV fillSuperView];
            
            if (!relativeView) {
                [contentView addSubview:innerContentView];
            } else {
                [contentView addSubview:innerContentView positioned:NSWindowBelow relativeTo:relativeView];
            }
            [innerContentView fillSuperView];
            
        } while (CGRectEqualToRect(contentView.frame, CGRectZero));
        
        if (window) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [window setOpaque:NO];
                [[YMThemeManager shareInstance] changeTheme:window.contentView color:kMainBackgroundColor];
                [window setBackgroundColor:kMainBackgroundColor];
            });
        }
    } else {
        if (window) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [window setOpaque:NO];
                [[YMThemeManager shareInstance] changeTheme:window.contentView color:kMainBackgroundColor];
                [window setBackgroundColor:kMainBackgroundColor];
            });
        }
    }
}

@end
