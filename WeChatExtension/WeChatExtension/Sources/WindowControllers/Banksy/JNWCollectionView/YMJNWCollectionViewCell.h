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

#import <Cocoa/Cocoa.h>

/// This view is the base class for all cells. The properties can be set directly on this
/// class for customization, or it can be subclassed to provide custom drawing.
@class YMJNWCollectionView;
@interface YMJNWCollectionViewCell : NSView

/// The dedicated initializer for all subclasses to override.
- (instancetype)initWithFrame:(NSRect)frameRect;

/// Called when the cell is about to exit the reuse pool and be dequeued.
///
/// Subclasses must call super's implementation.
- (void)prepareForReuse __attribute((objc_requires_super));

@property (nonatomic, weak, readonly) YMJNWCollectionView *collectionView;

/// Sets the selection with no animation. Subclassers should override this method to add side
/// effects to the selection process.
@property (nonatomic, assign) BOOL selected;

/// Sets the hovering state with no animation. Subclassers should override this method to add side
/// effects to the hovering process.
@property (nonatomic, assign) BOOL hovered;

/// Calls -setSelected:, animating any changes to the content of the background view, such as
/// settting the background iamge or color.
- (void)setSelected:(BOOL)selected animated:(BOOL)animate;

/// Any content added to the cell can be added as a subview of the content view. The
/// content view is guaranteed to be in front of the background color or image.
///
/// Alternatively, a custom content view can be set for a flatter heirarchy. Note that
/// any custom content views will have autoresizing masks applied to them, and the view
/// will be layer-backed.
@property (nonatomic, strong) IBOutlet NSView *contentView;

/// Sets the background image or background color on a dedicated background view that
/// is always beneath the content view.
///
/// If both are set, the image takes precedence over the color.
@property (nonatomic, strong) NSImage *backgroundImage;
@property (nonatomic, strong) NSColor *backgroundColor;

/// Determines the duration of the crossfade effect applied to the backgroundImage
/// and backgroundColor properties when the animatesSelection property on the collection
/// view is set to YES.
///
/// Defaults to 0.25.
@property (nonatomic, assign) CGFloat crossfadeDuration;

/// The reuse identifier.
@property (nonatomic, copy, readonly) NSString *reuseIdentifier;

/// The current index path.
@property (nonatomic, strong, readonly) NSIndexPath *indexPath;

/// Called when the cell will be layed out using the provided frame.
- (void)willLayoutWithFrame:(CGRect)frame;

/// Called when the cell has been laid out using the provided frame.
- (void)didLayoutWithFrame:(CGRect)frame;

/// Object used for cell data binding. You do not need to manually set this property
/// in code. Add an NSObjectController to your nib, and it will automatically be found
/// and set up for you for data binding by the collection view.
@property (nonatomic, strong) NSObjectController *objectController;

/// Object used for cell data binding (if not using NSObjectController).
@property (nonatomic, assign) IBOutlet id objectValue;

@end
