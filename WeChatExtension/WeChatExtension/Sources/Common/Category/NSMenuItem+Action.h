//
//  NSMenuItem+Action.h
//  WeChatPlugin
//
//  Created by TK on 2018/4/25.
//  Copyright © 2018年 tk. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSMenuItem (Action)

+ (NSMenuItem *)menuItemWithTitle:(NSString *)title action:(SEL)selector target:(id)target keyEquivalent:(NSString *)key state:(NSControlStateValue)state;

@end
