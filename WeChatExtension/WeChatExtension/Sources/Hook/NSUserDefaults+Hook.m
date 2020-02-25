//
//  NSUserDefaults+Hook.m
//  WeChatExtension
//
//  Created by MustangYM on 2020/2/25.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import "NSUserDefaults+Hook.h"

#import <AppKit/AppKit.h>


@implementation NSUserDefaults (Hook)
+ (void)load{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //原始系统方法
        Method originalPopFunc = class_getInstanceMethod(self, @selector(integerForKey:));
        //我的方法
        Method newPopFunc = class_getInstanceMethod(self, @selector(hook_integerForKey:));
        //方法交换
        method_exchangeImplementations(originalPopFunc, newPopFunc);
    });
}

- (NSInteger)hook_integerForKey:(NSString *)defaultName
{
//    if ([defaultName isEqualToString:@"com.wexin.task.tag"]) {
//        return 4;
//    }
    return [self hook_integerForKey:defaultName];
}
@end
