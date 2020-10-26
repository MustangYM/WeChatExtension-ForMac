
//
//  YMZGMPTableView.m
//  WeChatExtension
//
//  Created by MustangYM on 2020/10/26.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import "YMZGMPTableView.h"
#import "NSMenuItem+Action.h"

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
            NSMenu *menu = [[NSMenu alloc] init];
            NSMenuItem *item1 = [NSMenuItem menuItemWithTitle:@"屏蔽该群" action:@selector(refuseMsg) target:self keyEquivalent:@"" state:NO];
            [menu addItems:@[item1]];
            return menu;
        }
    }
    return nil;
}

- (void)refuseMsg
{
    if ([self.zgmpDelegate respondsToSelector:@selector(ym_tableView:selectRow:)]) {
        [self.zgmpDelegate ym_tableView:self selectRow:self.rightMouseDownRow];
    }
}

@end
