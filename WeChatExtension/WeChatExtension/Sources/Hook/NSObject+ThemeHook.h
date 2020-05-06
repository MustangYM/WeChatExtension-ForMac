//
//  NSObject+ThemeHook.h
//  WeChatExtension
//
//  Created by MustangYM on 2020/3/19.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import <AppKit/AppKit.h>


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ThemeHook)
+ (void)hookTheme;
@end

NS_ASSUME_NONNULL_END
