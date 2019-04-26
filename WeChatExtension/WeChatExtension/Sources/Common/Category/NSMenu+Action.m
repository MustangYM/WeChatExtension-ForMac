//
//  NSMenu+Action.m
//  WeChatPlugin
//
//  Created by TK on 2018/4/15.
//  Copyright © 2018年 tk. All rights reserved.
//

#import "NSMenu+Action.h"

@implementation NSMenu (Action)

- (void)addItems:(NSArray *)subItems {
    for (NSMenuItem *item in subItems) {
        NSAssert([item isKindOfClass:[NSMenuItem class]], @"the elements must be a NSMenuItem!");
        [self addItem:item];
    }
}

@end
