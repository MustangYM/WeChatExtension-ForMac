//
//  TKUtility.h
//  WeChatExtension
//
//  Created by WeChatExtension on 2019/1/12.
//  Copyright © 2019 WeChatExtension. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LargerOrEqualVersion(version) [TKUtility isLargerOrEqualVersion:version]
NS_ASSUME_NONNULL_BEGIN

@interface TKUtility : NSObject

+ (BOOL)isLargerOrEqualVersion:(NSString *)version;

@end

NS_ASSUME_NONNULL_END
