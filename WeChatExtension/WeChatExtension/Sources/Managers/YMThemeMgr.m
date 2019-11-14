//
//  YMThemeMgr.m
//  WeChatExtension
//
//  Created by MustangYM on 2019/6/11.
//  Copyright © 2019 MustangYM. All rights reserved.
//

#import "YMThemeMgr.h"

@implementation YMThemeMgr
+ (instancetype)shareInstance {
    static id share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[self alloc] init];
    });
    return share;
}

- (void)changeTheme:(NSView *)view {
    [self changeTheme:view color:kRGBColor(61, 62, 60, 1)];
}

- (void)changeTheme:(NSView *)view color:(NSColor *)color
{
    CALayer *viewLayer = [CALayer layer];
    [viewLayer setBackgroundColor:color.CGColor];
    [view setWantsLayer:YES];
    [view setNeedsDisplay:YES];
    [view setLayer:viewLayer];
}
@end
