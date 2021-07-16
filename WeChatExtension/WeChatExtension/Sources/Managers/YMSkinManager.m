//
//  YMSkinManager.m
//  WeChatExtension
//
//  Created by MustangYM on 2020/12/26.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import "YMSkinManager.h"
#import "YMThemeManager.h"
#import "YMWeChatPluginConfig.h"
#import "NSViewLayoutTool.h"

@implementation YMSkinManager
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
    
    //除了MMMainWindowController， 其余均做特殊处理
    if ([window isKindOfClass:objc_getClass("MMMainWindowController")]) {
        window.window.contentView.size = CGSizeMake(850, 700);
        [self addSkinImageView:window.window.contentView relativeView:nil window:window.window needSkin:YES];
    } else {
        if (window.window.contentView.subviews.count > 0) {
            NSView *firstSubView = window.window.contentView.subviews[0];
            [self addSkinImageView:window.window.contentView relativeView:firstSubView window:window.window needSkin:NO];
        } else {
            [self addSkinImageView:window.window.contentView relativeView:nil window:window.window needSkin:NO];
        }
    }
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
        ) {
        if (viewController.view.subviews.count > 0) {
            NSView *firstSubView = viewController.view.subviews[0];
            [[YMThemeManager shareInstance] changeTheme:firstSubView color:[NSColor clearColor]];
        }
    }
}

+ (void)addSkinImageView:(NSView *)contentView relativeView:(NSView *)relativeView window:(NSWindow *)window needSkin:(BOOL)needSkin
{
    if (needSkin) {
        do {
            NSView *innerContentView = [[NSView alloc] init];
            [[YMThemeManager shareInstance] changeTheme:innerContentView color:[NSColor clearColor]];
            NSImageView *imageV = [[NSImageView alloc] init];
            imageV.imageScaling = NSImageScaleAxesIndependently;
            NSImage *image = kImageWithName(@"YOUR_IMAGE.jpg");
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
            
//            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
//            animation.keyPath = @"transform.scale";
//            animation.values = @[
//
//                @1.01,@1.011,@1.012,@1.013,@1.014,
//                @1.015,@1.016,@1.017,@1.018,@1.019,
//                @1.02,
//                @1.021,@1.021,
//                @1.02,
//                @1.019,@1.018,@1.017,@1.016,@1.015,
//                @1.014,@1.013,@1.012,@1.011,@1.01
//
//            ];
//            animation.duration = 50;
//            animation.calculationMode = kCAAnimationCubic;
//            animation.repeatCount = MAXFLOAT;
//            [innerContentView.layer addAnimation:animation forKey:nil];
            
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
