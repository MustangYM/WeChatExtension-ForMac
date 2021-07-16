/*
 Created by Jonathan Willing on 8/28/13.
 Copyright (c) 2013, ButterKit. All rights reserved.
 Licensed under the MIT license <http://opensource.org/licenses/MIT>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 documentation files (the "Software"), to deal in the Software without restriction, including without limitation
 the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
 to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
 TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 IN THE SOFTWARE.
 */

#import <Cocoa/Cocoa.h>

// A NSClipView subclass with a buttery -scrollToRect: animation.
@interface YMJNWClipView : NSClipView

// Calls -scrollRectToVisible:, optionally animated.
//
// If animated, the animation will be performed with an ease-out timing function.
// Any calls to this method while an animation is still in flight will update the
// current animation and adjust the deceleration as needed.
//
// Any input to the scroll view that would cause an adjustment to the bounds (such as
// a trackpad scroll) will cancel any animations in progress.
- (BOOL)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated;

// Calls -scrollRectToVisible:animated: with an optional completion block. The scrolled
// completion parameter is whether any scrolling was performed.
- (BOOL)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated completion:(void (^)(BOOL scrolled))completion;

// Any time the origin changes with an animation as discussed above, the deceleration
// rate will be used to create an ease-out animation.
//
// Values should range from (0, 1]. Smaller deceleration rates will provide
// generally fast animations, whereas larger rates will create lengthy animations.
//
// Defaults to 0.78.
@property (nonatomic, assign) CGFloat decelerationRate;

@end
