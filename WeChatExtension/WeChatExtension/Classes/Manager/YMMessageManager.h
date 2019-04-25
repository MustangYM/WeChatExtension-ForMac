//
//  YMMessageManager.h
//  WeChatExtension
//
//  Created by MustangYM on 2019/4/25.
//  Copyright © 2019 MustangYM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMMessageManager : NSObject
+ (instancetype)shareInstance;
- (NSString *)getMessageContentWithData:(MessageData *)msgData;
@end

NS_ASSUME_NONNULL_END
