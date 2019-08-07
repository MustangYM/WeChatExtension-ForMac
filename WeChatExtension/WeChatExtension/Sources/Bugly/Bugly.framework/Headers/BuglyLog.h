//
//  BuglyLog.h
//  Bugly
//
//  Copyright (c) 2017年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

// Log level for Bugly Log
typedef NS_ENUM(NSUInteger, BuglyLogLevel) {
    BuglyLogLevelSilent  = 0,
    BuglyLogLevelError   = 1,
    BuglyLogLevelWarn    = 2,
    BuglyLogLevelInfo    = 3,
    BuglyLogLevelDebug   = 4,
    BuglyLogLevelVerbose = 5,
};
#pragma mark -

OBJC_EXTERN void BLYLog(BuglyLogLevel level, NSString *format, ...) NS_FORMAT_FUNCTION(2, 3);

OBJC_EXTERN void BLYLogv(BuglyLogLevel level, NSString *format, va_list args) NS_FORMAT_FUNCTION(2, 0);

#pragma mark -
#define BUGLY_LOG_MACRO(_level, fmt, ...) [BuglyLog level:_level tag:nil log:fmt, ##__VA_ARGS__]

#define BLYLogError(fmt, ...)   BUGLY_LOG_MACRO(BuglyLogLevelError, fmt, ##__VA_ARGS__)
#define BLYLogWarn(fmt, ...)    BUGLY_LOG_MACRO(BuglyLogLevelWarn,  fmt, ##__VA_ARGS__)
#define BLYLogInfo(fmt, ...)    BUGLY_LOG_MACRO(BuglyLogLevelInfo, fmt, ##__VA_ARGS__)
#define BLYLogDebug(fmt, ...)   BUGLY_LOG_MACRO(BuglyLogLevelDebug, fmt, ##__VA_ARGS__)
#define BLYLogVerbose(fmt, ...) BUGLY_LOG_MACRO(BuglyLogLevelVerbose, fmt, ##__VA_ARGS__)

#pragma mark - Interface
@interface BuglyLog : NSObject

/**
 *    @brief  初始化日志模块
 *
 *    @param level 设置默认日志级别，默认BLYLogLevelSilent
 *
 *    @param printConsole 是否打印到控制台，默认NO
 */
+ (void)initLogger:(BuglyLogLevel) level consolePrint:(BOOL)printConsole;

/**
 *    @brief 打印BLYLogLevelInfo日志
 *
 *    @param format   日志内容 总日志大小限制为：字符串长度30k，条数200
 */
+ (void)log:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

/**
 *    @brief  打印日志
 *
 *    @param level 日志级别
 *    @param message   日志内容 总日志大小限制为：字符串长度30k，条数200
 */
+ (void)level:(BuglyLogLevel) level logs:(NSString *)message;

/**
 *    @brief  打印日志
 *
 *    @param level 日志级别
 *    @param format   日志内容 总日志大小限制为：字符串长度30k，条数200
 */
+ (void)level:(BuglyLogLevel) level log:(NSString *)format, ... NS_FORMAT_FUNCTION(2, 3);

/**
 *    @brief  打印日志
 *
 *    @param level  日志级别
 *    @param tag    日志模块分类
 *    @param format   日志内容 总日志大小限制为：字符串长度30k，条数200
 */
+ (void)level:(BuglyLogLevel) level tag:(NSString *) tag log:(NSString *)format, ... NS_FORMAT_FUNCTION(3, 4);

@end
