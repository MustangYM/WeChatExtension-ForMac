//
//  NSTextField+Action.m
//  WeChatExtension
//
//  Created by WeChatExtension on 2019/9/19.
//  Copyright © 2019年 WeChatExtension. All rights reserved.
//

#import "NSTextField+Action.h"

@implementation NSTextField (Action)

+ (instancetype)tk_labelWithString:(NSString *)stringValue
{
    NSTextField *textField = ({
        NSTextField *textField = [[self alloc] initWithFrame:NSMakeRect(10, 10, 200, 17)];
        [textField setStringValue:stringValue];
        [textField setBezeled:NO];
        [textField setDrawsBackground:NO];
        [textField setEditable:NO];
        [textField setSelectable:NO];
        
        textField;
    });

    return textField;
}

@end
