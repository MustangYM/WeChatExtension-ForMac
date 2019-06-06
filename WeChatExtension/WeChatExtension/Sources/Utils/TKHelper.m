//
//  TKHelper.m
//  WeChatPlugin
//
//  Created by TK on 2017/4/19.
//  Copyright © 2017年 tk. All rights reserved.
//

#import "TKHelper.h"

@implementation TKHelper

/**
 替换对象方法
 
 @param originalClass 原始类
 @param originalSelector 原始类的方法
 @param swizzledClass 替换类
 @param swizzledSelector 替换类的方法
 */
void tk_hookMethod(Class originalClass, SEL originalSelector, Class swizzledClass, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(originalClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(swizzledClass, swizzledSelector);
    if(originalMethod && swizzledMethod) {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

/**
 替换类方法
 
 @param originalClass 原始类
 @param originalSelector 原始类的类方法
 @param swizzledClass 替换类
 @param swizzledSelector 替换类的类方法
 */
void tk_hookClassMethod(Class originalClass, SEL originalSelector, Class swizzledClass, SEL swizzledSelector) {
    Method originalMethod = class_getClassMethod(originalClass, originalSelector);
    Method swizzledMethod = class_getClassMethod(swizzledClass, swizzledSelector);
    if(originalMethod && swizzledMethod) {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


/**
 获取类方法
 @param originalClass 原始类
 */
void tk_getMethodsOfClass(Class originalClass) {
    unsigned int count;
    Method *methods = class_copyMethodList([originalClass class], &count);
    for (int i = 0; i < count; i++) {
        Method method = methods[i];
        SEL selector = method_getName(method);
        NSString *name = NSStringFromSelector(selector);
        NSLog(@"方法 名字 ==== %@",name);
//        if ([name hasPrefix:@"test"])
//            NSLog(@"方法 名字 ==== %@",name);
//        if (name){
//            //avoid arc warning by using c runtime
//            objc_msgSend(self, selector);
//        }
        //NSLog(@"Test '%@' completed successfuly", [name substringFromIndex:4]);
    }
}


@end
