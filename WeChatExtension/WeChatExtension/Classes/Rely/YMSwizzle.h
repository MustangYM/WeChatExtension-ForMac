//
//  OPSwizzle.h
//  WeChatExtension
//
//  Created by MustangYM on 2019/1/21.
//  Copyright © 2019 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#define LargerOrEqualVersion(version) [YMSwizzle isLargerOrEqualVersion:version]
@interface YMSwizzle : NSObject
+ (BOOL)isLargerOrEqualVersion:(NSString *)version;
//swizzle对象方法
void YM_hookMethod(Class originalClass, SEL originalSelector, Class swizzledClass, SEL swizzledSelector);
//swizzle类方法
void YM_hookClassMethod(Class originalClass, SEL originalSelector, Class swizzledClass, SEL swizzledSelector);
@end

