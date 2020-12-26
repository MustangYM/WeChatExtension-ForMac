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
//    if ([window isKindOfClass:objc_getClass("MMMainWindowController")]) {
//        [window.window.contentView addSubview:effView];
//        [effView fillSuperView];
//    } else {
//        if (window.window.contentView.subviews.count > 0) {
//            NSView *firstSubView = window.window.contentView.subviews[0];
//            [window.window.contentView addSubview:effView positioned:NSWindowBelow relativeTo:firstSubView];
//            [effView fillSuperView];
//        } else {
//            [window.window.contentView addSubview:effView];
//            [effView fillSuperView];
//        }
//    }
    
//        if ([window isKindOfClass:objc_getClass("MMMainWindowController")]) {
//            NSImageView *imageV = [[NSImageView alloc] init];
//            imageV.image = kImageWithName(@"Eminem.png");
//            [window.window.contentView addSubview:imageV];
//            [imageV fillSuperView];
//        } else {
//            if (window.window.contentView.subviews.count > 0) {
//                NSImageView *imageV = [[NSImageView alloc] init];
//                imageV.image = kImageWithName(@"Eminem.png");
//                [window.window.contentView addSubview:imageV];
//                [imageV fillSuperView];
//            } else {
//                NSImageView *imageV = [[NSImageView alloc] init];
//                imageV.image = kImageWithName(@"Eminem.png");
//                [window.window.contentView addSubview:imageV];
//                [imageV fillSuperView];
//            }
//        }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [window.window setOpaque:NO];
        [[YMThemeManager shareInstance] changeTheme:window.window.contentView color:kMainBackgroundColor];
        [window.window setBackgroundColor:kMainBackgroundColor];
        NSImageView *imageV = [[NSImageView alloc] init];
        imageV.imageScaling = NSImageScaleAxesIndependently;
        imageV.image = kImageWithName(@"Eminem.png");
        imageV.alphaValue = 0.85;
        [window.window.contentView addSubview:imageV];
        [imageV fillSuperView];
        
        CGFloat hz = 5;
        CAKeyframeAnimation *rotationAnimation = [CAKeyframeAnimation animation];
        rotationAnimation.keyPath = @"transform.rotation";
        rotationAnimation.duration = kArc4random_Double_inSpace(0.20, 0.30) / hz;
        rotationAnimation.values = @[@(-M_PI_4 /90.0 * hz * 2),@(M_PI_4 /90.0 * hz * 2),@(-M_PI_4 /90.0 * hz * 2)];
        rotationAnimation.repeatCount = HUGE;
        [imageV.layer addAnimation:rotationAnimation forKey:nil];
    });
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
//            [viewController.view addSubview:effView positioned:NSWindowBelow relativeTo:firstSubView];
            [effView fillSuperView];
        } else {
//            [viewController.view addSubview:effView];
            [effView fillSuperView];
        }
    }
}
@end
