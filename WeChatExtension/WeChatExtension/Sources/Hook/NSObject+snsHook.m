//
//  NSObject+snsHook.m
//  WeChatExtension
//
//  Created by MustangYM on 2021/7/1.
//  Copyright © 2021 MustangYM. All rights reserved.
//

#import "NSObject+snsHook.h"
#import "ANYMethodLog.h"
#import <AppKit/AppKit.h>


@implementation NSObject (snsHook)
+ (void)snsHook
{
//    [ANYMethodLog logMethodWithClass:[objc_getClass("_TtC6WeChat25SnsFeedListViewController") class] condition:^BOOL(SEL sel) {
//        return YES;
//    } before:^(id target, SEL sel, NSArray *args, int deep) {
//        NSLog(@"\n🐸类名:%@ 👍方法:%@\n%@", target, NSStringFromSelector(sel),args);
//    } after:^(id target, SEL sel, NSArray *args, NSTimeInterval interval, int deep, id retValue) {
//        NSLog(@"\n🚘类名:%@ 👍方法:%@\n%@\n↪️%@", target, NSStringFromSelector(sel),args,retValue);
//    }];
}

@end
