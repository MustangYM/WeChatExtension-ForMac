//
//  YMTableView.m
//  WeChatExtension
//
//  Created by MustangYM on 2020/10/30.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import "YMTableView.h"


@interface YMTableView () <YMTableViewDelegate>
@property (nonatomic, assign) NSInteger rightMouseDownRow;
@end

@implementation YMTableView

- (NSMenu *)menuForEvent:(NSEvent *)event
{
    if (event.type == 3) {
        self.rightMouseDownRow = [self rowWithEvent:event];
        if (self.rightMouseDownRow >= 0 && self.rightMouseDownRow < [self numberOfRows]) {
            if ([self.ym_delegate respondsToSelector:@selector(ym_menuForTableView:selectRow:)]) {
                return [self.ym_delegate ym_menuForTableView:self selectRow:self.rightMouseDownRow];
            }
        }
    }
    return nil;
}

- (void)mouseDown:(NSEvent *)event
{
    [super mouseDown:event];
    if (event.pressure == 1 && event.clickCount == 2) {
        if ([self.ym_delegate respondsToSelector:@selector(ym_doubleClickForTableView:)]) {
            [self.ym_delegate ym_doubleClickForTableView:self];
        }
    }
}

- (NSInteger)rowWithEvent:(NSEvent *)event
{
    NSPoint point = [event locationInWindow];
    NSPoint tablePoint = [self convertPoint:point toView:self.window.contentView];
    return [self rowAtPoint:tablePoint];
}

@end
