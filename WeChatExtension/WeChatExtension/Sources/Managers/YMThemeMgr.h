//
//  YMThemeMgr.h
//  WeChatExtension
//
//  Created by MustangYM on 2019/6/11.
//  Copyright © 2019 MustangYM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMThemeMgr : NSObject
+ (instancetype)shareInstance;
- (void)changeTheme:(NSView *)view;
- (void)changeTheme:(NSView *)view color:(NSColor *)color;
@end

NS_ASSUME_NONNULL_END
