//
//  ANYMethodLog.h
//  ANYMethodLog
//
//  Created by qiuhaodong on 2017/1/14.
//  Copyright © 2017年 qiuhaodong. All rights reserved.
//
//  https://github.com/qhd/ANYMethodLog.git
//

#import <Foundation/Foundation.h>

typedef BOOL (^ConditionBlock)(SEL sel);
typedef void (^BeforeBlock)(id target, SEL sel, NSArray *args, int deep);
typedef void (^AfterBlock)(id target, SEL sel, NSArray *args, NSTimeInterval interval, int deep, id retValue);

@interface ANYMethodLog : NSObject

/**
 打印对象的方法调用

 @param aClass 要打印的类
 @param condition 根据此 block 来决定是否追踪方法（sel 是方法名）
 @param before 方法调用前会调用该 block（target 是检测的对象，sel 是方法名，args 是参数列表，deep 是调用层级）
 @param after 方法调用后会调用该 block（interval 是执行方法的耗时，retValue 是返回值）
 */
+ (void)logMethodWithClass:(Class)aClass
                 condition:(ConditionBlock) condition
                    before:(BeforeBlock) before
                     after:(AfterBlock) after;

@end
