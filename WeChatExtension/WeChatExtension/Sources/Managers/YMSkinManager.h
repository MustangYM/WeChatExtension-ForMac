//
//  YMSkinManager.h
//  WeChatExtension
//
//  Created by MustangYM on 2020/12/26.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMSkinManager : NSObject
+ (void)skinWindowViewController:(NSWindowController *)window;
+ (void)skinViewController:(NSViewController *)viewController;
@end

NS_ASSUME_NONNULL_END
