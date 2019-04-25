//
//  YMConfig.m
//  WeChatExtension
//
//  Created by MustangYM on 2019/4/25.
//  Copyright © 2019 MustangYM. All rights reserved.
//

#import "YMConfig.h"

@implementation YMConfig
+ (instancetype)shareInstance {
    static id share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[self alloc] init];
    });
    return share;
}

- (NSMutableSet *)revokeMsgSet {
    if (!_revokeMsgSet) {
        _revokeMsgSet = [NSMutableSet set];
    }
    return _revokeMsgSet;
}
@end
