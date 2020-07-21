//
//  YMFuzzyManager.h
//  WeChatExtension
//
//  Created by MustangYM on 2020/7/20.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMFuzzyManager : NSObject
+ (void)fuzzyWindowViewController:(NSWindowController *)window;
+ (void)fuzzyViewController:(NSViewController *)viewController;
@end

NS_ASSUME_NONNULL_END
