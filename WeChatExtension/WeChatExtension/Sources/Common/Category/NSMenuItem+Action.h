//
//  NSMenuItem+Action.h
//  WeChatExtension
//
//  Created by WeChatExtension on 2018/4/25.
//  Copyright © 2018年 WeChatExtension. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSMenuItem (Action)

+ (NSMenuItem *)menuItemWithTitle:(NSString *)title action:(SEL)selector target:(id)target keyEquivalent:(NSString *)key state:(NSControlStateValue)state;

@end
