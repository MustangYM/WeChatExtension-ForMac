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
#import "NSViewLayoutTool.h"

@interface YMZGMPTimeCell ()
@property (nonatomic, strong) NSTextField *timeLabel;
@property (nonatomic, strong) NSBox *bottomLine;
@end

@implementation YMZGMPTimeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initSubViews];
    }
    return self;
}

- (void)_initSubViews
{
    self.timeLabel = ({
        NSTextField *label = [NSTextField tk_labelWithString:@""];
        label.textColor = [NSColor blackColor];
        [[label cell] setLineBreakMode:NSLineBreakByCharWrapping];
        [[label cell] setTruncatesLastVisibleLine:YES];
        label.font = [NSFont systemFontOfSize:12];
        label.frame = NSMakeRect(5, 12, 200, 16);
        label;
    });
    
    self.bottomLine = ({
        NSBox *line = [[NSBox alloc] init];
        line.frame = NSMakeRect(0, 0, 300, 0.5);
        [[YMThemeManager shareInstance] changeTheme:line color:YM_RGBA(242, 242, 242, 1.0)];
        line;
    });
    
    [self addSubviews:@[self.timeLabel, self.bottomLine]];
    [self.bottomLine addConstraint:NSLayoutAttributeLeft constant:-5];
    [self.bottomLine addConstraint:NSLayoutAttributeBottom constant:0];
    [self.bottomLine addConstraint:NSLayoutAttributeRight constant:0];
    [self.bottomLine addHeightConstraint:0.5];
}

- (void)setMemberInfo:(YMZGMPInfo *)memberInfo
{
    _memberInfo = memberInfo;
    self.timeLabel.stringValue = [self timeDistanceWithTimestamp:memberInfo.timestamp];
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
        return [NSString stringWithFormat:@"%@", YMLanguage(@"刚刚", @"Just now")];
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
