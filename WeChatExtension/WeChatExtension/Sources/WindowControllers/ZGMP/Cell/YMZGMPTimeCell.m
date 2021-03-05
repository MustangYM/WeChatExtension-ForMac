//
//  YMZGMPTimeCell.m
//  WeChatExtension
//
//  Created by MustangYM on 2020/10/23.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import "YMZGMPTimeCell.h"
#import "YMZGMPInfoHelper.h"
#import "YMThemeManager.h"

@interface YMZGMPTimeCell ()

@end

@implementation YMZGMPTimeCell
- (void)setMemberInfo:(YMZGMPInfo *)memberInfo
{
    _memberInfo = memberInfo;
    self.msgLabel.stringValue = [NSString stringWithFormat:@"%@ (%ld %@)",[self timeDistanceWithTimestamp:memberInfo.timestamp], memberInfo.totalMsgs, memberInfo.totalMsgs < 2 ? YMLanguage(@"条", @"msg") : YMLanguage(@"条", @"msgs")];
    if (memberInfo.timestamp <= 0) {
        [[YMThemeManager shareInstance] changeTheme:self color:YM_RGBA(99, 99, 99, 0.2)];
    } else {
        [[YMThemeManager shareInstance] changeTheme:self color:[NSColor clearColor]];
    }
}

- (NSString *)timeDistanceWithTimestamp:(int)timestamp
{
    if (timestamp <= 0) {
        return YMLanguage(@"长期潜水", @"Ghost");
    }
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] - timestamp;
    NSInteger small = time / 60;
    if (small == 0) {
        return [NSString stringWithFormat:@"%@", YMLanguage(@"刚刚", @"just now")];
    }
    if (small < 60) {
        return [NSString stringWithFormat:@"%ld%@", small, YMLanguage(@"分钟前", @"minutes ago")];
    }
    NSInteger hours = time/3600;
    if (hours < 24) {
        return [NSString stringWithFormat:@"%ld%@", hours, YMLanguage(@"小时前", @"hours ago")];
    }
    NSInteger days = time/3600/24;
    if (days < 30) {
        return [NSString stringWithFormat:@"%ld%@", days, YMLanguage(@"天前", @"days ago")];
    }
    NSInteger months = time/3600/24/30;
    if (months < 12) {
        return [NSString stringWithFormat:@"%ld%@", months, YMLanguage(@"月前", @"months ago")];
    }
    NSInteger years = time/3600/24/30/12;
    return [NSString stringWithFormat:@"%ld%@", years, YMLanguage(@"年前", @"years ago")];
}

@end
