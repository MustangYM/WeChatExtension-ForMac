//
//  ZWYHandleFunc.m
//  WeChatExtension
//
//  Created by mb on 2020/7/28.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import "ZWYHandleFunc.h"
#import "NSDate+ZWYRequiredDate.h"
#import "YMMessageManager.h"

@implementation ZWYHandleFunc

+ (instancetype)shared {
    static ZWYHandleFunc *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = ZWYHandleFunc.new;
    });
    return obj;
}

- (void)zwy_handleMsg:(AddMsg *)addMsg {
//    10876000325@chatroom 公司群
//    9532245596@chatroom  聚龙二手群
//    if ([addMsg.fromUserName.string containsString:@"@chatroom"]) {
//        [[TKMessageManager shareManager] sendTextMessageToSelf:addMsg.fromUserName.string];
//    }
    if ([addMsg.fromUserName.string isEqualToString:@"9532245596@chatroom"]) {
        if ([addMsg.content.string containsString:@"免费"] ||
            [addMsg.content.string containsString:@"求缘"] ||
            [addMsg.content.string containsString:@"缘分"] ||
            [addMsg.content.string containsString:@"结缘"] ||
            [addMsg.content.string containsString:@"不要钱"]) {
            NSUserNotification *localNotify = [[NSUserNotification alloc] init];
            localNotify.soundName = NSUserNotificationDefaultSoundName;
            localNotify.title = @"二手";
            localNotify.informativeText = addMsg.content.string;
            [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:localNotify];
        }
    }
    
    [self automaticInvestmentPlanTip];
}


/**
 * 每周四定投提醒
 */
- (void)automaticInvestmentPlanTip {
    NSInteger week = [NSDate getNowWeekday];
    NSString *key = @"handleCount";
    static NSInteger handleCount = 0;
    static BOOL isReOpenWechat = YES;
    
    if (isReOpenWechat) {
        isReOpenWechat = NO;
        handleCount = [NSUserDefaults.standardUserDefaults integerForKey:key];
    }
    
    if (week != 5) {
        handleCount = 0;
        [NSUserDefaults.standardUserDefaults setInteger:0 forKey:key];
        [NSUserDefaults.standardUserDefaults synchronize];
        return;
    }
    
    if (week == 5 && handleCount < 2) {
        // 18424412750@chatroom 澳洲小分队
        // wxid_rkmvosx1qdn111 zwy
        ZWYDateModel *dateModel = [ZWYDateModel new];
        dateModel.hour = handleCount == 1 ? 14 : 10;
        dateModel.minutes = 0;
        dateModel.second = 0;
        NSDate *targetDate = [[NSDate date] zwy_setATimeToDate:dateModel];
        if (NSDate.date.timeIntervalSince1970 > targetDate.timeIntervalSince1970) {
            handleCount++;
            [[YMMessageManager shareManager] sendTextMessage:[NSString stringWithFormat:@"今天星期四别忘记定投, 我会提醒两次~😃~提醒第%d次哈~", (int)handleCount] toUsrName:@"18424412750@chatroom" delay:0];
            [NSUserDefaults.standardUserDefaults setInteger:handleCount forKey:key];
            [NSUserDefaults.standardUserDefaults synchronize];
        }
    }
}
@end
