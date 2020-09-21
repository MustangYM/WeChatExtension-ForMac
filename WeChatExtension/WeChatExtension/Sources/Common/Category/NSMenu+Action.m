//
//  NSMenu+Action.m
//  WeChatExtension
//
//  Created by WeChatExtension on 2018/4/15.
//  Copyright © 2018年 WeChatExtension. All rights reserved.
//

#import "NSMenu+Action.h"

@implementation NSMenu (Action)

- (void)addItems:(NSArray *)subItems
{
    for (NSMenuItem *item in subItems) {
        NSAssert([item isKindOfClass:[NSMenuItem class]], @"the elements must be a NSMenuItem!");
        [self addItem:item];
    }
}

@end
