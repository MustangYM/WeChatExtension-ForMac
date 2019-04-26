//
//  NSView+Action.h
//  WeChatPlugin
//
//  Created by TK on 2017/8/20.
//  Copyright © 2017年 tk. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSView (Action)

- (void)addSubviews:(NSArray *)subViews;

@end

@interface NSView (Size)

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;
@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@end
