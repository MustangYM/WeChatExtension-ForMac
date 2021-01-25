//
//  YMDeviceHelper.h
//  WeChatExtension
//
//  Created by WeChatExtension on 2019/1/12.
//  Copyright © 2019 WeChatExtension. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LargerOrEqualVersion(version) [YMDeviceHelper isLargerOrEqualVersion:version]
#define LargerOrEqualLongVersion(version) [YMDeviceHelper isLargeOrEqualLongVersion:version]
#define kImageWithName(name) [YMDeviceHelper imageWithName:name]
NS_ASSUME_NONNULL_BEGIN

@interface YMDeviceHelper : NSObject
+ (BOOL)isLargerOrEqualVersion:(NSString *)version;
+ (BOOL)isLargeOrEqualLongVersion:(NSString *)version;
+ (NSString *)deviceFingerprint;
+ (NSImage *)imageWithName:(NSString *)imageName;
+ (BOOL)checkWeChatLaunched;
+ (int)checkWeChatLaunchedCount;
@end

NS_ASSUME_NONNULL_END
