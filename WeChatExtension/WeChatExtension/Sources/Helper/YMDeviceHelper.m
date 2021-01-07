//
//  YMDeviceHelper.m
//  WeChatExtension
//
//  Created by WeChatExtension on 2019/1/12.
//  Copyright © 2019 WeChatExtension. All rights reserved.
//

#import "YMDeviceHelper.h"

@implementation YMDeviceHelper

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

+ (NSString *)deviceFingerprint
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);

    NSString *uuidValue = (__bridge_transfer NSString *)uuidStringRef;
    uuidValue = [uuidValue lowercaseString];
    uuidValue = [uuidValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
    return uuidValue;
}

+ (NSImage *)imageWithName:(NSString *)imageName
{
    if (!imageName || imageName.length == 0) {
        return nil;
    }
    NSBundle *bundle = [NSBundle bundleWithIdentifier:@"MustangYM.WeChatExtension"];
    NSString *imgPath = [bundle pathForImageResource:imageName];
    return [[NSImage alloc] initWithContentsOfFile:imgPath];
}

#pragma mark - CheckWechat
+ (BOOL)checkWeChatLaunched
{
    NSArray *ary = [[NSWorkspace sharedWorkspace] launchedApplications];
    __block BOOL isWeChatLaunched = NO;
    [ary enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *bundleID = [obj valueForKey:@"NSApplicationBundleIdentifier"];
        if ([bundleID isEqualToString:@"com.tencent.xinWeChat"]) {
            isWeChatLaunched = YES;
        }
    }];
    return isWeChatLaunched;
}

+ (int)checkWeChatLaunchedCount
{
    NSArray *ary = [[NSWorkspace sharedWorkspace] launchedApplications];
    __block int count = 0;
    [ary enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *bundleID = [obj valueForKey:@"NSApplicationBundleIdentifier"];
        if ([bundleID isEqualToString:@"com.tencent.xinWeChat"]) {
            count++;
        }
    }];
    return count;
}
@end
