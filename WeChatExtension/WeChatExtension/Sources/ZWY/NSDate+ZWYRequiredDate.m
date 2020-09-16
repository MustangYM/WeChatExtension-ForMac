//
//  NSDate+ZWYRequiredDate.m
//  ShangHao
//
//  Created by 赵五一 on 2018/1/11.
//  Copyright © 2018年 赵五一. All rights reserved.
//

#import "NSDate+ZWYRequiredDate.h"

@implementation ZWYCalender


static ZWYCalender *_calender;
+ (instancetype)sharedCalender {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _calender = (ZWYCalender *)[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    });
    
    return _calender;
}
@end

@implementation ZWYDateFormatter

static ZWYDateFormatter *_dateFormatter;
+ (instancetype)sharedFormatter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = (ZWYDateFormatter *)[[NSDateFormatter alloc] init];
    });
    
    return _dateFormatter;
}
@end


@implementation NSDate (ZWYRequiredDate)

+ (NSDate *)zwy_timeStringToDate:(NSString *)timeString formatter:(NSString *)formatter {
    NSAssert(timeString, @"时间不能为空");
    
    if (!formatter) {
        formatter = @"yyyy-MM-dd HH:mm:ss";
    }
    /** /// "Sat Dec 03 19:56:38 +0800 2016",根据回调的时间字符串制定不一样的日期格式 */
//    NSString * formatterString = @"EEE  MMM dd HH:mm:ss zzz yyyy";
    /** DateFormatter, Calendar初始化比较消耗内存, 定义成单例 */
    [[ZWYDateFormatter sharedFormatter] setDateFormat:formatter];
    /** 指定区域，真机一定要指定 */
    [ZWYDateFormatter sharedFormatter].locale = [NSLocale localeWithLocaleIdentifier: @"en"];
    
    return [[ZWYDateFormatter sharedFormatter] dateFromString: timeString];
}

- (NSString *)zwy_dateToRequiredString {
    if ([[ZWYCalender sharedCalender] isDateInToday:self]) {
        //如果是今天
        int seconds = [[NSDate date] timeIntervalSinceDate:self];
        if (seconds < 60) {
            return @"刚刚";
        } else if (seconds < 60 * 60) {
            return [NSString stringWithFormat:@"%d分钟前", seconds / 60];
        } else {
            return [NSString stringWithFormat:@"%d小时前", seconds / 3600];
        }
    } else if ([[ZWYCalender sharedCalender] isDateInYesterday:self]) {
        //如果是昨天 10: 10
        [ZWYDateFormatter sharedFormatter].dateFormat = @"昨天 HH:mm";
        [ZWYDateFormatter sharedFormatter].locale =  [NSLocale localeWithLocaleIdentifier: @"en"];
        return [[ZWYDateFormatter sharedFormatter] stringFromDate:self];
    } else {
        //首先要取到今年是哪一年 2017
        //再取到当前的date是哪一年, 再做比较
        NSInteger thisYear = [[ZWYCalender sharedCalender] component:NSCalendarUnitYear fromDate:[NSDate date]];
        NSInteger dateYear = [[ZWYCalender sharedCalender] component:NSCalendarUnitYear fromDate: self];
        //是今年
        if (thisYear == dateYear) {
            [ZWYDateFormatter sharedFormatter].dateFormat = @"MM-dd HH:mm";
            [ZWYDateFormatter sharedFormatter].locale =  [NSLocale localeWithLocaleIdentifier: @"en"];
            return [[ZWYDateFormatter sharedFormatter] stringFromDate:self];
        }
        //往年
        else {
            [ZWYDateFormatter sharedFormatter].dateFormat = @"yyyy-MM-dd HH:mm";
            [ZWYDateFormatter sharedFormatter].locale =  [NSLocale localeWithLocaleIdentifier: @"en"];
            return [[ZWYDateFormatter sharedFormatter] stringFromDate:self];
        }
    }
}


- (NSDate *)zwy_setATimeToDate:(ZWYDateModel *)dateModel  {
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = dateModel.timeZone ? dateModel.timeZone : [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [greCalendar setTimeZone: timeZone];
    
    NSDateComponents *dateComponents = [greCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond  fromDate:self]; // [NSDate date]
    
    //  定义一个NSDateComponents对象，设置一个时间点
    NSDateComponents *dateComponentsForDate = [[NSDateComponents alloc] init];
    [dateComponentsForDate setYear:dateModel.year > 0 ? dateModel.year : dateComponents.year];
    [dateComponentsForDate setMonth:dateModel.year > 0 ? dateModel.month : dateComponents.month];
    [dateComponentsForDate setDay:dateModel.day > 0 ? dateModel.day : dateComponents.day];
    [dateComponentsForDate setHour:dateModel.hour];
    [dateComponentsForDate setMinute:dateModel.minutes];
    [dateComponentsForDate setSecond:dateModel.second];
    
    NSDate *dateFromDateComponentsForDate = [greCalendar dateFromComponents:dateComponentsForDate];
    return dateFromDateComponentsForDate;
}

// 获取当前是星期几
+ (NSInteger)getNowWeekday {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDate *now = [NSDate date];
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    comps = [calendar components:unitFlags fromDate:now];
    return [comps weekday];
}

@end

@implementation ZWYDateModel

@end
