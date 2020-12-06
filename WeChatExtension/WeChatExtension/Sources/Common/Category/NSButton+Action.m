//
//  NSButton+Action.m
//  WeChatExtension
//
//  Created by WeChatExtension on 2019/9/19.
//  Copyright © 2019年 WeChatExtension. All rights reserved.
//

#import "NSButton+Action.h"

@implementation NSButton (Action)

+ (instancetype)tk_checkboxWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    NSButton *btn = [self tk_buttonWithTitle:title target:target action:action];
    [btn setButtonType:NSButtonTypeSwitch];
    
    return btn;
}

+ (instancetype)tk_buttonWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    NSButton *btn = ({
        NSButton *btn = [[self alloc] init];
        btn.title = title;
        btn.target = target;
        btn.action = action;
        
        btn;
    });
    
    return btn;
}

@end
