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

#import "YMJNWClipView.h"

// The default deceleration constant used for the ease-out curve in the animation.
static const CGFloat YMJNWClipViewDecelerationRate = 0.78;

@interface YMJNWClipView ()
// Used to drive the animation through repeated callbacks.
// A display link is used instead of a timer so that we don't get dropped frames and tearing.
// Lazily created when needed, released in dealloc. Stopped automatically when scrolling is not occurring.
@property (nonatomic, assign) CVDisplayLinkRef displayLink;

// Used to determine whether to animate in `scrollToPoint:`.
@property (nonatomic, assign) BOOL shouldAnimateOriginChange;

// Used when animating with the display link as the final origin for the animation.
@property (nonatomic, assign) CGPoint destinationOrigin;

// The scroll view which has this clip view set as the content view.
@property (nonatomic, assign) NSScrollView *containingScrollView;

// The optional completion block which is called at the end of the scroll animation.
@property (nonatomic, copy) void (^scrollCompletion)(BOOL success);
@end


@implementation YMJNWClipView

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self == nil) return nil;
    
    self.wantsLayer = YES;
    self.decelerationRate = YMJNWClipViewDecelerationRate;
    
    return self;
}

- (void)dealloc {
    CVDisplayLinkRelease(_displayLink);
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark View Heirarchy

- (void)viewWillMoveToWindow:(NSWindow *)newWindow {
    if (self.window != nil) {
        [NSNotificationCenter.defaultCenter removeObserver:self name:NSWindowDidChangeScreenNotification object:self.window];
    }
    
    [super viewWillMoveToWindow:newWindow];
    
    if (newWindow != nil) {
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateCVDisplay:) name:NSWindowDidChangeScreenNotification object:newWindow];
    }
}

#pragma mark Display link

static CVReturn YMJNWScrollingCallback(CVDisplayLinkRef displayLink, const CVTimeStamp *now, const CVTimeStamp *outputTime, CVOptionFlags flagsIn, CVOptionFlags *flagsOut, void *displayLinkContext) {
    @autoreleasepool {
        YMJNWClipView *clipView = (__bridge id)displayLinkContext;
        dispatch_async(dispatch_get_main_queue(), ^{
            [clipView updateOrigin];
        });
    }
    
    return kCVReturnSuccess;
}

- (CVDisplayLinkRef)displayLink {
    if (_displayLink == NULL) {
        CVDisplayLinkCreateWithActiveCGDisplays(&_displayLink);
        CVDisplayLinkSetOutputCallback(_displayLink, &YMJNWScrollingCallback, (__bridge void *)self);
        [self updateCVDisplay:nil];
    }
    
    return _displayLink;
}

- (void)updateCVDisplay:(NSNotification *)note {
    NSScreen *screen = self.window.screen;
    if (screen == nil) {
        NSDictionary *screenDictionary = NSScreen.mainScreen.deviceDescription;
        NSNumber *screenID = screenDictionary[@"NSScreenNumber"];
        CGDirectDisplayID displayID = screenID.unsignedIntValue;
        CVDisplayLinkSetCurrentCGDisplay(_displayLink, displayID);
    } else {
        CVDisplayLinkSetCurrentCGDisplay(_displayLink, kCGDirectMainDisplay);
    }
}

#pragma mark Scrolling

- (void)scrollToPoint:(NSPoint)newOrigin {
    // We should only attempt to animate ourselves if we know this point we're scrolling to
    // was the point determined from a -scrollToRect:animated: call.
    if (self.shouldAnimateOriginChange) {
        self.shouldAnimateOriginChange = NO;
        self.destinationOrigin = newOrigin;
        [self beginScrolling];
    } else {
        // Otherwise, we stop any scrolling that is currently occurring (if needed) and let
        // super's implementation handle a normal scroll.
        [self endScrolling];
        [super scrollToPoint:newOrigin];
    }
}

- (BOOL)scrollRectToVisible:(NSRect)aRect animated:(BOOL)animated {
    self.shouldAnimateOriginChange = animated;
    return [super scrollRectToVisible:aRect];
}

- (BOOL)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated completion:(void (^)(BOOL sucess))completion {
    self.scrollCompletion = completion;
    BOOL success = [self scrollRectToVisible:rect animated:animated];
    
    if (!animated || !success) {
        [self handleCompletionIfNeededWithSuccess:success];
    }
    
    return success;
}

- (void)beginScrolling {
    if (CVDisplayLinkIsRunning(self.displayLink)) {
        return;
    }
        
    CVDisplayLinkStart(self.displayLink);
}

- (void)endScrolling {
    if (!CVDisplayLinkIsRunning(self.displayLink)) {
        return;
    }
    
    CVDisplayLinkStop(self.displayLink);
}

// Sanitize the deceleration rate to [0, 1] so nothing unexpected happens.
- (void)setDecelerationRate:(CGFloat)decelerationRate {
    if (decelerationRate > 1) {
        decelerationRate = 1;
    }
    else if (decelerationRate < 0) {
        decelerationRate = 0;
    }
    _decelerationRate = decelerationRate;
}

- (NSScrollView *)containingScrollView {
    if (_containingScrollView == nil) {
        _containingScrollView = self.enclosingScrollView;
        if (_containingScrollView == nil && [self.superview isKindOfClass:NSScrollView.class]) {
            _containingScrollView = (NSScrollView *)self.superview;
        }
    }
    
    return _containingScrollView;
}

- (void)updateOrigin {
    if (self.window == nil) {
        [self endScrolling];
        return;
    }
    
    CGPoint o = self.bounds.origin;
    CGPoint lastOrigin = o;
    CGFloat deceleration = self.decelerationRate;
    
    // Calculate the next origin on a basic ease-out curve.
    o.x = o.x * deceleration + self.destinationOrigin.x * (1 - self.decelerationRate);
    o.y = o.y * deceleration + self.destinationOrigin.y * (1 - self.decelerationRate);
    
    // Calling -scrollToPoint: instead of manually adjusting the bounds lets us get the expected
    // overlay scroller behavior for free.
    [super scrollToPoint:o];
    
    // Make this call so that we can force an update of the scroller positions.
    [self.containingScrollView reflectScrolledClipView:self];

    if ((fabs(o.x - lastOrigin.x) < 0.1 && fabs(o.y - lastOrigin.y) < 0.1)) {
        [self endScrolling];
        
        // Make sure we always finish out the animation with the actual coordinates
        [super scrollToPoint:o];
        [self handleCompletionIfNeededWithSuccess:YES];
    }
}

#pragma mark Completion handling

- (void)handleCompletionIfNeededWithSuccess:(BOOL)success {
    if (self.scrollCompletion != nil) {
        self.scrollCompletion(success);
        self.scrollCompletion = nil;
    }
}

@end
