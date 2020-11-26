//
//  YMZGMPPDDCell.m
//  WeChatExtension
//
//  Created by MustangYM on 2020/10/24.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import "YMZGMPPDDCell.h"
#import "YMZGMPInfoHelper.h"
#import "YMThemeManager.h"

@implementation YMZGMPPDDCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)setMemberInfo:(YMZGMPInfo *)memberInfo
{
    _memberInfo = memberInfo;
    if (memberInfo.pdd > 0) {
        self.msgLabel.stringValue = [NSString stringWithFormat:@"%d %@",memberInfo.pdd, memberInfo.pdd == 1 ? YMLanguage(@"条", @"msg") : YMLanguage(@"条", @"msgs")];
    } else {
        self.msgLabel.stringValue = @"";
    }
    
    if (memberInfo.timestamp <= 0) {
        [[YMThemeManager shareInstance] changeTheme:self color:YM_RGBA(99, 99, 99, 0.2)];
    } else {
        [[YMThemeManager shareInstance] changeTheme:self color:[NSColor clearColor]];
    }
}

@end
