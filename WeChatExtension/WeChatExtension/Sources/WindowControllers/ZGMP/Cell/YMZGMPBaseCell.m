//
//  YMZGMPBaseCell.m
//  WeChatExtension
//
//  Created by MustangYM on 2020/10/24.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import "YMZGMPBaseCell.h"
#import "NSViewLayoutTool.h"
#import "YMThemeManager.h"

@interface YMZGMPBaseCell ()
@property (nonatomic, strong) NSBox *bottomLine;
@end

@implementation YMZGMPBaseCell

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
    self.msgLabel = ({
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
    
    [self addSubviews:@[self.msgLabel, self.bottomLine]];
    [self.bottomLine addConstraint:NSLayoutAttributeLeft constant:-5];
    [self.bottomLine addConstraint:NSLayoutAttributeBottom constant:0];
    [self.bottomLine addConstraint:NSLayoutAttributeRight constant:0];
    [self.bottomLine addHeightConstraint:0.5];
}

@end
