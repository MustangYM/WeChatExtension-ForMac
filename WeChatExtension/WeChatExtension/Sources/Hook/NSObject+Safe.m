//
//  NSObject+Safe.m
//  WeChatExtension
//
//  Created by MustangYM on 2020/4/26.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import "NSObject+Safe.h"
#import <AppKit/AppKit.h>

static NSString *_errorFunctionName;
static void inline dynamicMethodIMP(id self,SEL _cmd)
{
    NSString *selStr = NSStringFromSelector(_cmd);
    //微信本身的一个crash, 在某些机器上会高频触发, 很奇怪
    if ([selStr containsString:@"setAllowsCollapsing"]) {
        return;
    }
    
    NSArray *calls = [NSThread callStackSymbols];
    __block BOOL flag = NO;
    [calls enumerateObjectsUsingBlock:^(NSString*  _Nonnull call, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([call containsString:@"hook_"]) {
            flag = YES;
            if (*stop) {
                 *stop = YES;
            }
        }
    }];
    
    if (flag) {
        NSString *msg = [NSString stringWithFormat:@"%@ 错误\n请点击【关于与捐赠】->【项目主页】\n提issue联系开发者修复!",NSStringFromSelector(_cmd)];
        NSString *englishMsg = [NSString stringWithFormat:@"%@ crash\nClick【About And Contribute】->【Project Homepage】\nContact developer to repair!",NSStringFromSelector(_cmd)];
        NSAlert *alert = [NSAlert alertWithMessageText:YMLanguage(@"拦截到崩溃", @"WARNING FOR CRASH")
                                         defaultButton:YMLanguage(@"确定", @"YES")                       alternateButton:nil
                                           otherButton:nil                              informativeTextWithFormat:@"%@", YMLanguage(msg, englishMsg)];
        [alert runModal];
    }
}

@implementation NSObject (Safe)
+ (void)load
{
//    hookMethod(objc_getClass("NSObject"), @selector(methodSignatureForSelector:), [self class], @selector(safe_methodSignatureForSEL:));
//    hookMethod(objc_getClass("NSObject"), @selector(forwardInvocation:), [self class], @selector(safe_forwardInvocation:));
}

- (NSMethodSignature *)safe_methodSignatureForSEL:(SEL)arg1
{
    if (![self respondsToSelector:arg1]) {
        _errorFunctionName = NSStringFromSelector(arg1);
        NSMethodSignature *methodSignature = [self safe_methodSignatureForSEL:arg1];
        if (class_addMethod([self class], arg1, (IMP)dynamicMethodIMP, "v@:")) {
            NSLog(@"临时方法添加成功！");
        }
        if (!methodSignature) {
            methodSignature = [self safe_methodSignatureForSEL:arg1];
        }
        return methodSignature;
    }else{
        return [self safe_methodSignatureForSEL:arg1];
    }
}

- (void)safe_forwardInvocation:(NSInvocation *)arg1
{
    SEL sel = [arg1 selector];
    if ([self respondsToSelector:sel]) {
        [arg1 invokeWithTarget:self];
    } else {
        [self safe_forwardInvocation:arg1];
    }
}
@end
