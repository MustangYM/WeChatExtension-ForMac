//
//  NSView+UIViewGeometry.h
//  WeChatExtension
//
//  Created by MustangYM on 2019/12/2.
//  Copyright © 2019 MustangYM. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

@interface NSView (UIViewGeometryHelper)

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, readonly) CGFloat bottom;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@end

@interface NSView (NSLayoutConstraintHelper)

- (void)fillSuperView;
- (NSLayoutConstraint *)addConstraint:(NSLayoutAttribute)attr constant:(CGFloat)cc;
- (NSLayoutConstraint *)addConstraint:(NSLayoutAttribute)attr
                           multiplier:(CGFloat)mm
                             constant:(CGFloat)cc;
- (NSLayoutConstraint *)addConstraint:(NSLayoutAttribute)attr
                              sibling:(NSView *)sibling
                             constant:(CGFloat)cc;
- (NSLayoutConstraint *)addConstraint:(NSLayoutAttribute)attr1
                              sibling:(NSView *)sibling
                            attribute:(NSLayoutAttribute)attr2
                             constant:(CGFloat)cc;
- (NSLayoutConstraint *)addConstraint:(NSLayoutAttribute)attr1
                              sibling:(NSView *)sibling
                            attribute:(NSLayoutAttribute)attr2
                           multiplier:(CGFloat)mm
                             constant:(CGFloat)cc;

- (NSLayoutConstraint *)addWidthConstraint:(CGFloat)cc;
- (NSLayoutConstraint *)addHeightConstraint:(CGFloat)cc;

- (NSLayoutConstraint *)addMinimumWidthConstraint:(CGFloat)cc priority:(NSLayoutPriority)priority;
- (NSLayoutConstraint *)addMinimumHeightConstraint:(CGFloat)cc priority:(NSLayoutPriority)priority;
- (NSLayoutConstraint *)addMaxmumWidthConstraint:(CGFloat)cc priority:(NSLayoutPriority)priority;

@end

