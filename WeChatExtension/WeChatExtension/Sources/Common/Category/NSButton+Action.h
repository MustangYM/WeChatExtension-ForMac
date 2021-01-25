//
//  NSButton+Action.h
//  WeChatExtension
//
//  Created by WeChatExtension on 2019/9/19.
//  Copyright © 2019年 WeChatExtension. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSButton (Action)

+ (instancetype)tk_buttonWithTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (instancetype)tk_checkboxWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@end
