//
//  ZWYHandleFunc.h
//  WeChatExtension
//
//  Created by mb on 2020/7/28.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWYHandleFunc : NSObject

+ (instancetype)shared;
- (void)zwy_handleMsg:(AddMsg *)addMsg;
@end

NS_ASSUME_NONNULL_END
