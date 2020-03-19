//
//  main.c
//  WeChatExtension
//
//  Created by WeChatExtension on 2017/4/19.
//  Copyright © 2017年 WeChatExtension. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeChat+hook.h"
#import "MMChatsTableCellView+hook.h"
#import "MMStickerMessageCellView+hook.h"
#import "NSObject+ThemeHook.h"

static void __attribute__((constructor)) initialize(void) {
    NSLog(@"++++++++ WeChatExtension loaded ++++++++");
    [NSObject hookTheme];
    [NSObject hookWeChat];
    [NSObject hookMMChatsTableCellView];
    [NSObject hookMMStickerMessageCellView];
}
