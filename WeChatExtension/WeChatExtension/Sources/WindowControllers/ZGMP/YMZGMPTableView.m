
//
//  YMZGMPTableView.m
//  WeChatExtension
//
//  Created by MustangYM on 2020/10/26.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import "YMZGMPTableView.h"

@interface YMZGMPTableView ()

@end

@implementation YMZGMPTableView

- (NSMenu *)menuForEvent:(NSEvent *)event
{
    if (event.type == 3) {
        self.rightMouseDownRow = [self rowWithEvent:event];
        if (self.rightMouseDownRow >= 0 && self.rightMouseDownRow < [self numberOfRows]) {
            if ([self.zgmpDelegate respondsToSelector:@selector(ym_menuForTableView:selectRow:)]) {
                return [self.zgmpDelegate ym_menuForTableView:self selectRow:self.rightMouseDownRow];
            }
        }
    }
    return nil;
}

- (void)mouseDown:(NSEvent *)event
{
    [super mouseDown:event];
    if (event.pressure == 1 && event.clickCount == 2) {
        if ([self.zgmpDelegate respondsToSelector:@selector(ym_doubleClickForTableView:)]) {
            [self.zgmpDelegate ym_doubleClickForTableView:self];
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
