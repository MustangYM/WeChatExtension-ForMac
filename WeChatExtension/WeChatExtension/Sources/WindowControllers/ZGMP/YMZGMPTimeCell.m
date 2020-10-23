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
        if (YMWeChatPluginConfig.sharedConfig.usingDarkTheme) {
            [[YMThemeManager shareInstance] changeTheme:line color:[NSColor lightGrayColor]];
        }
        line;
    });
    
    [self addSubviews:@[self.timeLabel, self.bottomLine]];
    [self.bottomLine addConstraint:NSLayoutAttributeLeft constant:0];
    [self.bottomLine addConstraint:NSLayoutAttributeBottom constant:0];
    [self.bottomLine addConstraint:NSLayoutAttributeRight constant:0];
    [self.bottomLine addHeightConstraint:0.5];
}

- (void)setMemberInfo:(YMZGMPInfo *)memberInfo
{
    _memberInfo = memberInfo;
    self.timeLabel.stringValue = [self timeDistanceWithTimestamp:memberInfo.timestamp];
}


- (NSString *)timeDistanceWithTimestamp:(int)timestamp
{
    if (timestamp <= 0) {
        return @"本地无发言记录";
    }
    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] - timestamp;
    NSInteger small = time / 60;
    if (small == 0) {
        return [NSString stringWithFormat:@"刚刚"];
    }
    if (small < 60) {
        return [NSString stringWithFormat:@"%ld分钟前",small];
    }
    NSInteger hours = time/3600;
    if (hours<24) {
        return [NSString stringWithFormat:@"%ld小时前",hours];
    }
    NSInteger days = time/3600/24;
    if (days < 30) {
        return [NSString stringWithFormat:@"%ld天前",days];
    }
    NSInteger months = time/3600/24/30;
    if (months < 12) {
        return [NSString stringWithFormat:@"%ld月前",months];
    }
    NSInteger years = time/3600/24/30/12;
    return [NSString stringWithFormat:@"%ld年前",years];
}

@end
