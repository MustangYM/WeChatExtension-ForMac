//
//  YMConfig.h
//  WeChatExtension
//
//  Created by MustangYM on 2019/4/25.
//  Copyright © 2019 MustangYM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMConfig : NSObject
@property (nonatomic, strong) NSMutableSet *revokeMsgSet;

+ (instancetype)shareInstance;
@end

NS_ASSUME_NONNULL_END
