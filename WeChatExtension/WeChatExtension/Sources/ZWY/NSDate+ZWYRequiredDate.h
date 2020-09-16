//
//  NSDate+ZWYRequiredDate.h
//  ShangHao
//
//  Created by 赵五一 on 2018/1/11.
//  Copyright © 2018年 赵五一. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZWYDateModel;

@interface ZWYCalender : NSCalendar

/** calender单例 */
+ (instancetype)sharedCalender;
@end

@interface ZWYDateFormatter : NSDateFormatter

/** formatter单例 */
+ (instancetype)sharedFormatter;
@end

@interface NSDate (ZWYRequiredDate)

/** 获取到的时间字符串转成NSDate */
+ (NSDate * )zwy_timeStringToDate:(NSString *)timeString
                        formatter:(NSString *)formatter;
/** 把NSDate转成自己需要的时间格式 */
- (NSString *)zwy_dateToRequiredString;
/**
 * 修改成想要的时间
 */
- (NSDate *)zwy_setATimeToDate:(ZWYDateModel *)dateModel;
/**
 * 获取当前是星期几
 */
+ (NSInteger)getNowWeekday;
@end


@interface ZWYDateModel : NSObject

@property (nonatomic, copy) NSTimeZone *timeZone;
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minutes;
@property (nonatomic, assign) NSInteger second;

@end
