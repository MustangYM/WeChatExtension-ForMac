//
//  YMUpdateManager.h
//  WeChatExtension
//
//  Created by MustangYM on 2019/5/10.
//  Copyright © 2019 MustangYM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMUpdateManager : NSObject
+ (id)shareInstance;
- (void)checkWeChatExtensionUpdate;
@end

NS_ASSUME_NONNULL_END
