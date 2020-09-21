//
//  NSWindow+fuzzy.m
//  WeChatExtension
//
//  Created by MustangYM on 2020/7/20.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import "NSWindow+fuzzy.h"
#import <AppKit/AppKit.h>
#import "YMPrivate.h"

extern OSStatus CGSSetWindowBackgroundBlurRadius(CGSConnection connection, NSInteger   windowNumber, int radius);
extern CGSConnection CGSDefaultConnectionForThread();
@implementation NSWindow (fuzzy)

- (void)setWindowBackgroundBlurRadius:(int)radius
{
    CGSConnection connection = CGSDefaultConnectionForThread();
    CGSSetWindowBackgroundBlurRadius(connection, [self windowNumber], radius);
}
@end
