//
//  YMDFAFilter.h
//  WeChatExtension
//
//  Created by MustangYM on 2020/10/27.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMDFAFilter : NSObject
+ (instancetype)shareInstance;
- (BOOL)filterSensitiveWords:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
