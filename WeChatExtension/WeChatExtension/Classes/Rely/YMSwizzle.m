//
//  OPSwizzle.m
//  WeChatExtension
//
//  Created by MustangYM on 2019/1/21.
//  Copyright © 2019 YY Inc. All rights reserved.
//

#import "YMSwizzle.h"

#define LargerOrEqualVersion(version) [YMSwizzle isLargerOrEqualVersion:version]
@implementation YMSwizzle
+ (BOOL)isLargerOrEqualVersion:(NSString *)version {
    NSDictionary *dict = [NSBundle mainBundle].infoDictionary;
    if ([dict[@"CFBundleShortVersionString"] compare:version options:NSNumericSearch] == NSOrderedAscending) {
        return NO;
    } else {
        return YES;
    }
}
void YM_hookMethod(Class originalClass, SEL originalSelector, Class swizzledClass, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(originalClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(swizzledClass, swizzledSelector);
    if(originalMethod && swizzledMethod) {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

void YM_hookClassMethod(Class originalClass, SEL originalSelector, Class swizzledClass, SEL swizzledSelector) {
    Method originalMethod = class_getClassMethod(originalClass, originalSelector);
    Method swizzledMethod = class_getClassMethod(swizzledClass, swizzledSelector);
    if(originalMethod && swizzledMethod) {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
@end
