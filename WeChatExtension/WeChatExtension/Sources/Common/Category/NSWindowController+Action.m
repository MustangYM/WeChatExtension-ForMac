//
//  NSWindowController+Action.m
//  WeChatPlugin
//
//  Created by TK on 2018/5/4.
//  Copyright © 2018年 tk. All rights reserved.
//

#import "NSWindowController+Action.h"

@implementation NSWindowController (Action)

- (void)show {
    [self showWindow:self];
    [self.window center];
    [self.window makeKeyWindow];
}

@end
