//
//  NSView+UIViewGeometry.m
//  WeChatExtension
//
//  Created by MustangYM on 2019/12/2.
//  Copyright © 2019 MustangYM. All rights reserved.
//

#import "NSViewLayoutTool.h"
#import <Foundation/Foundation.h>

@implementation NSView (UIViewGeometryHelper)

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)xx
{
    CGRect frame = self.frame;
    frame.origin.x = xx;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)yy
{
    CGRect frame = self.frame;
    frame.origin.y = yy;
    self.frame = frame;
 
}

- (CGFloat)bottom
{
    CGRect frame = self.frame;
    return frame.origin.y + frame.size.height;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

@end


@implementation NSView (NSLayoutConstraintHelper)

- (void)fillSuperView
{
    if (self.superview) {
        if (self.translatesAutoresizingMaskIntoConstraints) {
            self.translatesAutoresizingMaskIntoConstraints = NO;
        }
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    }
}

- (NSLayoutConstraint *)addConstraint:(NSLayoutAttribute)attr
                              sibling:(NSView *)sibling
                             constant:(CGFloat)cc
{
    NSLayoutConstraint* ret = nil;
    if (self.superview && sibling) {
        if (self.translatesAutoresizingMaskIntoConstraints) {
            self.translatesAutoresizingMaskIntoConstraints = NO;
        }
        ret = [NSLayoutConstraint constraintWithItem:self attribute:attr relatedBy:NSLayoutRelationEqual toItem:sibling attribute:attr multiplier:1.0 constant:cc];
        if (ret) {
            [self.superview addConstraint:ret];
        }
    }
    return ret;
}

- (NSLayoutConstraint *)addConstraint:(NSLayoutAttribute)attr1
                              sibling:(NSView *)sibling
                            attribute:(NSLayoutAttribute)attr2
                             constant:(CGFloat)cc
{
    NSLayoutConstraint* ret = nil;
    if (self.superview && sibling) {
        if (self.translatesAutoresizingMaskIntoConstraints) {
            self.translatesAutoresizingMaskIntoConstraints = NO;
        }
        ret = [NSLayoutConstraint constraintWithItem:self attribute:attr1 relatedBy:NSLayoutRelationEqual toItem:sibling attribute:attr2 multiplier:1.0 constant:cc];
        if (ret) {
            [self.superview addConstraint:ret];
        }
    }
    return ret;
}

- (NSLayoutConstraint *)addConstraint:(NSLayoutAttribute)attr constant:(CGFloat)cc
{
    NSLayoutConstraint* ret = nil;
    if (self.superview) {
        if (self.translatesAutoresizingMaskIntoConstraints) {
            self.translatesAutoresizingMaskIntoConstraints = NO;
        }
        ret = [NSLayoutConstraint constraintWithItem:self attribute:attr relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:attr multiplier:1.0 constant:cc];
        if (ret) {
            [self.superview addConstraint:ret];
        }
    }
    return ret;
}

- (NSLayoutConstraint *)addConstraint:(NSLayoutAttribute)attr
                           multiplier:(CGFloat)mm
                             constant:(CGFloat)cc
{
    NSLayoutConstraint* ret = nil;
    if (self.superview) {
        if (self.translatesAutoresizingMaskIntoConstraints) {
            self.translatesAutoresizingMaskIntoConstraints = NO;
        }
        ret = [NSLayoutConstraint constraintWithItem:self attribute:attr relatedBy:NSLayoutRelationEqual toItem:self.superview attribute:attr multiplier:mm constant:cc];
        if (ret) {
            [self.superview addConstraint:ret];
        }
    }
    return ret;
}

- (NSLayoutConstraint *)addConstraint:(NSLayoutAttribute)attr1
                              sibling:(NSView *)sibling
                            attribute:(NSLayoutAttribute)attr2
                           multiplier:(CGFloat)mm
                             constant:(CGFloat)cc
{
    NSLayoutConstraint* ret = nil;
    if (self.superview && sibling) {
        if (self.translatesAutoresizingMaskIntoConstraints) {
            self.translatesAutoresizingMaskIntoConstraints = NO;
        }
        ret = [NSLayoutConstraint constraintWithItem:self attribute:attr1 relatedBy:NSLayoutRelationEqual toItem:sibling attribute:attr2 multiplier:mm constant:cc];
        if (ret) {
            [self.superview addConstraint:ret];
        }
    }
    return ret;
}

- (NSLayoutConstraint *)addWidthConstraint:(CGFloat)cc
{
    if (self.translatesAutoresizingMaskIntoConstraints) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSLayoutConstraint* ret = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:cc];
    if (ret) {
        [self addConstraint:ret];
    }
    
    return ret;
}

- (NSLayoutConstraint *)addHeightConstraint:(CGFloat)cc
{
    if (self.translatesAutoresizingMaskIntoConstraints) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSLayoutConstraint* ret = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:cc];
    if (ret) {
        [self addConstraint:ret];
    }
    
    return ret;
}

- (NSLayoutConstraint *)addMinimumWidthConstraint:(CGFloat)cc priority:(NSLayoutPriority)priority
{
    if (self.translatesAutoresizingMaskIntoConstraints) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSLayoutConstraint* ret = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:cc];
    ret.priority = priority;
    
    if (ret) {
        [self addConstraint:ret];
    }
    
    return ret;
}

- (NSLayoutConstraint *)addMaxmumWidthConstraint:(CGFloat)cc priority:(NSLayoutPriority)priority
{
    if (self.translatesAutoresizingMaskIntoConstraints) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSLayoutConstraint* ret = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:cc];
    ret.priority = priority;
    if (ret) {
        [self addConstraint:ret];
    }
    return ret;
}

- (NSLayoutConstraint *)addMinimumHeightConstraint:(CGFloat)cc priority:(NSLayoutPriority)priority
{
    if (self.translatesAutoresizingMaskIntoConstraints) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSLayoutConstraint* ret = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:cc];
    ret.priority = priority;
    if (ret) {
        [self addConstraint:ret];
    }
    
    return ret;
}
@end


