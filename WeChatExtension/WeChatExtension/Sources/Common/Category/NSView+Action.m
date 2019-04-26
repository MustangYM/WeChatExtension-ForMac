//
//  NSView+Action.m
//  WeChatPlugin
//
//  Created by TK on 2017/8/20.
//  Copyright © 2017年 tk. All rights reserved.
//

#import "NSView+Action.h"

@implementation NSView (Action)

- (void)addSubviews:(NSArray *)subViews {
    for (NSView *v in subViews) {
        NSAssert([v isKindOfClass:[NSView class]], @"the elements must be a view!");
        [self addSubview:v];
    }
}

@end

@implementation NSView (Size)

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)point {
    CGRect rect = self.frame;
    
    rect.origin = point;
    self.frame = rect;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect rect = self.frame;
    
    rect.size = size;
    self.frame = rect;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
    [self setOrigin:CGPointMake(x, self.y)];
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
    [self setOrigin:CGPointMake(self.x, y)];
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    [self setSize:CGSizeMake(width, self.height)];
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    [self setSize:CGSizeMake(self.width, height)];
}

@end
