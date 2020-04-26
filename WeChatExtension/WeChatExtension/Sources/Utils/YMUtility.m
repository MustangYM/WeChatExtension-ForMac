//
//  YMUtility.m
//  WeChatExtension
//
//  Created by WeChatExtension on 2019/1/12.
//  Copyright © 2019 WeChatExtension. All rights reserved.
//

#import "YMUtility.h"

@implementation YMUtility

+ (BOOL)isLargerOrEqualVersion:(NSString *)version
{
    NSDictionary *dict = [NSBundle mainBundle].infoDictionary;
    if ([dict[@"CFBundleShortVersionString"] compare:version options:NSNumericSearch] == NSOrderedAscending) {
        return NO;
    } else {
        return YES;
    }
}

+ (BOOL)isLargeOrEqualLongVersion:(NSString *)version
{
    NSDictionary *dict = [NSBundle mainBundle].infoDictionary;
    if ([dict[@"MMBundleVersion"] compare:version options:NSNumericSearch] == NSOrderedAscending) {
        return NO;
    } else {
        return YES;
    }
}
@end
