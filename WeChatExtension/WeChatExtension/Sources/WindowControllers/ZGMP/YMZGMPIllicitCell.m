//
//  YMZGMPIllicitCell.m
//  WeChatExtension
//
//  Created by MustangYM on 2020/10/24.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import "YMZGMPIllicitCell.h"
#import "YMZGMPInfoHelper.h"

@implementation YMZGMPIllicitCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)setMemberInfo:(YMZGMPInfo *)memberInfo
{
    _memberInfo = memberInfo;
    if (memberInfo.sensitive > 0) {
        self.msgLabel.stringValue = [NSString stringWithFormat:@"%d条",memberInfo.sensitive];
    } else {
        self.msgLabel.stringValue = @"";
    }
}

@end
