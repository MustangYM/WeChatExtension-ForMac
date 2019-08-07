//
//  BuglyConfig.h
//  Bugly
//
//  Copyright (c) 2016年 Tencent. All rights reserved.
//

#pragma once

#define BLY_UNAVAILABLE(x) __attribute__((unavailable(x)))

#if __has_feature(nullability)
#define BLY_NONNULL __nonnull
#define BLY_NULLABLE __nullable
#define BLY_START_NONNULL _Pragma("clang assume_nonnull begin")
#define BLY_END_NONNULL _Pragma("clang assume_nonnull end")
#else
#define BLY_NONNULL
#define BLY_NULLABLE
#define BLY_START_NONNULL
#define BLY_END_NONNULL
#endif

#import <Foundation/Foundation.h>

#import "BuglyLog.h"

BLY_START_NONNULL

@protocol BuglyDelegate <NSObject>

@optional
/**
 *  发生异常时回调
 *
 *  @param exception 异常信息
 *
 *  @return 返回需上报记录，随异常上报一起上报
 */
- (NSString * BLY_NULLABLE)attachmentForException:(NSException * BLY_NULLABLE)exception;

@end

@interface BuglyConfig : NSObject

/**
 *  SDK Debug信息开关, 默认关闭
 */
@property (nonatomic, assign) BOOL debugMode;

/**
 *  设置自定义渠道标识
 */
@property (nonatomic, copy) NSString *channel;

/**
 *  设置自定义版本号
 */
@property (nonatomic, copy) NSString *version;

/**
 *  设置自定义设备唯一标识
 */
@property (nonatomic, copy) NSString *deviceIdentifier;

/**
 *  卡顿监控开关，默认关闭
 */
@property (nonatomic) BOOL blockMonitorEnable;

/**
 *  卡顿监控判断间隔，单位为秒
 */
@property (nonatomic) NSTimeInterval blockMonitorTimeout;

/**
 *  设置 App Groups Id (如有使用 Bugly iOS Extension SDK，请设置该值)
 */
@property (nonatomic, copy) NSString *applicationGroupIdentifier;

/**
 *  进程内还原开关，默认开启
 */
@property (nonatomic) BOOL symbolicateInProcessEnable;

/**
 *  非正常退出事件记录开关，默认关闭
 */
@property (nonatomic) BOOL unexpectedTerminatingDetectionEnable;

/**
 *  页面信息记录开关，默认开启
 */
@property (nonatomic) BOOL viewControllerTrackingEnable;

/**
 *  Bugly Delegate
 */
@property (nonatomic, assign) id<BuglyDelegate> delegate;

/**
 * 控制自定义日志上报，默认值为BuglyLogLevelSilent，即关闭日志记录功能。
 * 如果设置为BuglyLogLevelWarn，则在崩溃时会上报Warn、Error接口打印的日志
 */
@property (nonatomic, assign) BuglyLogLevel reportLogLevel;

/**
 *  崩溃数据过滤器，如果崩溃堆栈的模块名包含过滤器中设置的关键字，则崩溃数据不会进行上报
 *  例如，过滤崩溃堆栈中包含搜狗输入法的数据，可以添加过滤器关键字SogouInputIPhone.dylib等
 */
@property (nonatomic, copy) NSArray *excludeModuleFilter;

/**
 * 控制台日志上报开关，默认开启
 */
@property (nonatomic, assign) BOOL consolelogEnable;

/**
 * 崩溃退出超时，如果监听到崩溃后，App一直没有退出，则到达超时时间后会自动abort进程退出
 * 默认值 5s， 单位 秒
 * 当赋值为0时，则不会自动abort进程退出
 */
@property (nonatomic, assign) NSUInteger crashAbortTimeout;

@end
BLY_END_NONNULL
