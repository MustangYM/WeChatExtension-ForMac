//
//  YMUtility.h
//  WeChatExtension
//
//  Created by WeChatExtension on 2019/1/12.
//  Copyright © 2019 WeChatExtension. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LargerOrEqualVersion(version) [YMUtility isLargerOrEqualVersion:version]
NS_ASSUME_NONNULL_BEGIN

@interface YMUtility : NSObject

+ (BOOL)isLargerOrEqualVersion:(NSString *)version;

@end

NS_ASSUME_NONNULL_END
