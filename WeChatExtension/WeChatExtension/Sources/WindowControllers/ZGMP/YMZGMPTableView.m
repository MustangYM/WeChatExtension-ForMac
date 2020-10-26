
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
        NSPoint point = [event locationInWindow];
        NSPoint tablePoint = [self convertPoint:point toView:self.window.contentView];
        NSInteger row = [self rowAtPoint:tablePoint];
        self.rightMouseDownRow = row;
        if (row >= 0 && row < [self numberOfRows]) {
            if ([self.zgmpDelegate respondsToSelector:@selector(ym_menuForTableView:selectRow:)]) {
                return [self.zgmpDelegate ym_menuForTableView:self selectRow:row];
            }
        }
    }
    return nil;
}

@end
