//
//  main.m
//  WeChatExtension
//
//  Created by MustangYM on 2019/1/21.
//  Copyright © 2019 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Hook.h"

static void __attribute__((constructor)) initialize(void) {
    [NSObject loadHook];
}
