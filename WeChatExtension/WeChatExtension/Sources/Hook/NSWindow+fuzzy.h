//
//  NSWindow+fuzzy.h
//  WeChatExtension
//
//  Created by MustangYM on 2020/7/20.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import <AppKit/AppKit.h>


#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSWindow (fuzzy)
- (void)setWindowBackgroundBlurRadius:(int)radius;
@end

NS_ASSUME_NONNULL_END
