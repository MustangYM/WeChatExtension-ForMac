//
//  main.c
//  WeChatExtension
//
//  Created by WeChatExtension on 2019/4/19.
//  Copyright © 2019年 WeChatExtension. All rights reserved.
//
/*
 cd ~/Library/Developer/Xcode/DerivedData/
 xattr -rc .
 */
#import <Foundation/Foundation.h>
#import "WeChat+hook.h"
#import "MMChatsTableCellView+hook.h"
#import "MMStickerMessageCellView+hook.h"
#import "NSObject+ThemeHook.h"

static void __attribute__((constructor)) initialize(void) {
    NSLog(@"++++++++ WeChatExtension loaded ++++++++");
    if (@available(macOS 10.14, *)) {
        [NSObject hookTheme];
    }
    [NSObject hookWeChat];
    [NSObject hookMMChatsTableCellView];
    [NSObject hookMMStickerMessageCellView];
}
