/*
 Copyright (c) 2013, Jonathan Willing. All rights reserved.
 Licensed under the MIT license <http://opensource.org/licenses/MIT>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 documentation files (the "Software"), to deal in the Software without restriction, including without limitation
 the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
 to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions
 of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
 TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 IN THE SOFTWARE.
 */

#import "YMJNWCollectionViewCell.h"
#import "YMJNWCollectionViewCell+Private.h"
#import "YMJNWCollectionView+Private.h"
#import <QuartzCore/QuartzCore.h>

@interface YMJNWCollectionViewCellBackgroundView : NSView
@property (nonatomic, strong) NSColor *color;
@property (nonatomic, strong) NSImage *image;
@property (nonatomic, weak) YMJNWCollectionView *collectionView;
@end

@implementation YMJNWCollectionViewCellBackgroundView

- (id)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];
	if (self == nil) return nil;
	self.wantsLayer = YES;
	self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;
	return self;
}

- (void)setImage:(NSImage *)image {
	_image = image;
	[self setNeedsDisplay:YES];
}

- (void)setColor:(NSColor *)color {
	_color = color;
	[self setNeedsDisplay:YES];
}

- (void)setFrame:(NSRect)frameRect {
	if (CGRectEqualToRect(self.frame, frameRect))
		return;

	[super setFrame:frameRect];
	[self setNeedsDisplay:YES];
}

- (BOOL)wantsUpdateLayer {
	return YES;
}

- (void)updateLayer {
	self.layer.contents = self.image;
	self.layer.backgroundColor = self.color.CGColor;
}

@end

@interface YMJNWCollectionViewCell()
@property (nonatomic, strong) YMJNWCollectionViewCellBackgroundView *backgroundView;
@property (nonatomic, strong) NSTrackingArea *trackingArea;
@end

@implementation YMJNWCollectionViewCell
@synthesize contentView = _contentView;

- (instancetype)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];
	if (self == nil) return nil;
	
	[self _commonInit];
	
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	if (self == nil) return nil;

	[self _commonInit];
	
	return self;
}

- (void)_commonInit {
	self.wantsLayer = YES;
	self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;

	_backgroundView = [[YMJNWCollectionViewCellBackgroundView alloc] initWithFrame:self.bounds];
	_backgroundView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;

	_crossfadeDuration = 0.25;

	[self addSubview:_backgroundView positioned:NSWindowBelow relativeTo:nil];
}

- (void)prepareForReuse {
	[self.backgroundView.layer removeAllAnimations];
	
	// for subclasses
}

- (void)willLayoutWithFrame:(CGRect)frame {
	// for subclasses
}

- (void)didLayoutWithFrame:(CGRect)frame {
	// for subclasses
}

- (void)updateTrackingAreas {
	[super updateTrackingAreas];
	if (self.trackingArea) {
		[self removeTrackingArea:self.trackingArea];
		self.trackingArea = nil;
	}

	NSTrackingAreaOptions options = (NSTrackingActiveAlways | NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved);
	self.trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds] options:options owner:self userInfo:nil];
	[self addTrackingArea:self.trackingArea];
}

- (NSView *)contentView {
	if (_contentView == nil) {
		_contentView = [[NSView alloc] initWithFrame:self.bounds];
		[self configureContentView:_contentView];
	}
	
	return _contentView;
}

- (void)setContentView:(NSView *)contentView {
	if (_contentView) {
		[_contentView removeFromSuperview];
	}
	
	_contentView = contentView;
	[self configureContentView:contentView];
}

- (void)configureContentView:(NSView *)contentView {
	contentView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
	contentView.wantsLayer = YES;
	
	[self addSubview:contentView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animate {
	if (animate && self.selected != selected) {
		CATransition *transition = [CATransition animation];
		transition.duration = self.crossfadeDuration;
		[self.backgroundView.layer addAnimation:transition forKey:@"fade"];
	}
	
	self.selected = selected;
}

- (void)setCollectionView:(YMJNWCollectionView *)collectionView {
	_collectionView = collectionView;
	self.backgroundView.collectionView = collectionView;
}

- (void)setBackgroundColor:(NSColor *)backgroundColor {
	self.backgroundView.color = backgroundColor;
}

- (NSColor *)backgroundColor {
	return self.backgroundView.color;
}

- (void)setBackgroundImage:(NSImage *)backgroundImage {
	self.backgroundView.image = backgroundImage;
}

- (NSImage *)backgroundImage {
	return self.backgroundView.image;
}

- (void)mouseDown:(NSEvent *)theEvent {
	[self.collectionView mouseDownInCollectionViewCell:self withEvent:theEvent];
}

- (void)mouseUp:(NSEvent *)theEvent {
	[self.collectionView mouseUpInCollectionViewCell:self withEvent:theEvent];
	
	if (theEvent.clickCount == 2) {
		[self.collectionView doubleClickInCollectionViewCell:self withEvent:theEvent];
	}
}

- (void)mouseMoved:(NSEvent *)theEvent {
	[super mouseMoved:theEvent];

	[self.collectionView mouseMovedInCollectionViewCell:self withEvent:theEvent];
}

- (void)mouseEntered:(NSEvent *)theEvent {
	[super mouseEntered:theEvent];

	[self.collectionView mouseEnteredInCollectionViewCell:self withEvent:theEvent];
}

- (void)mouseExited:(NSEvent *)theEvent {
	[super mouseExited:theEvent];

	[self.collectionView mouseExitedInCollectionViewCell:self withEvent:theEvent];
}

- (void)mouseDragged:(NSEvent *)theEvent {
	[super mouseDragged:theEvent];

	[self.collectionView mouseDraggedInCollectionViewCell:self withEvent:theEvent];
}

- (void)rightMouseDown:(NSEvent *)theEvent {
	[super rightMouseDown:theEvent];

	[self.collectionView rightClickInCollectionViewCell:self withEvent:theEvent];
}

- (void)rightMouseUp:(NSEvent *)theEvent {
}

#pragma mark NSObject

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p; frame = %@; layer = <%@: %p>>", self.class, self, NSStringFromRect(self.frame), self.layer.class, self.layer];
}

@end
