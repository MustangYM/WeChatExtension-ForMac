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
NS_ASSUME_NONNULL_BEGIN

@interface YMDeviceHelper : NSObject
+ (BOOL)isLargerOrEqualVersion:(NSString *)version;
+ (BOOL)isLargeOrEqualLongVersion:(NSString *)version;
+ (NSString *)deviceFingerprint;
@end

NS_ASSUME_NONNULL_END
