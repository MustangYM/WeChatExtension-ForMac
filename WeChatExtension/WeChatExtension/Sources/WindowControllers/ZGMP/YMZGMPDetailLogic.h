//
//  YMZGMPDetailLogic.h
//  WeChatExtension
//
//  Created by MustangYM on 2020/10/30.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMZGMPDetailLogic : NSObject
- (void)updateSessionData:(void(^)(NSArray *ary))completion;
- (void)updateDetailData:(NSString *)chatroom completion:(void(^)(NSArray *ary))completion finally:(void(^)(void))finally;
@end

NS_ASSUME_NONNULL_END
