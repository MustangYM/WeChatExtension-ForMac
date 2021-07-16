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

#import <Foundation/Foundation.h>
#import "YMJNWCollectionViewFramework.h"

typedef NS_ENUM(NSInteger, YMJNWCollectionViewDirection) {
	YMJNWCollectionViewDirectionLeft,
	YMJNWCollectionViewDirectionRight,
	YMJNWCollectionViewDirectionUp,
	YMJNWCollectionViewDirectionDown
};

typedef NS_ENUM(NSInteger, YMJNWCollectionViewScrollDirection) {
	YMJNWCollectionViewScrollDirectionVertical,
	YMJNWCollectionViewScrollDirectionHorizontal,
	YMJNWCollectionViewScrollDirectionBoth
};

@interface YMJNWCollectionViewLayoutAttributes : NSObject
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) CGFloat alpha;
@property (nonatomic, assign) NSInteger zIndex;
@end

@class YMJNWCollectionView;
@interface YMJNWCollectionViewLayout : NSObject

@property (nonatomic, weak, readonly) YMJNWCollectionView *collectionView;

/// This method is provided as a way to inform the layout that it will
/// need to invalidate the current layout and recalculate data.
///
/// After invalidating the layout, visible cells will be redrawn on the next
/// layout pass with the new layout information.
///
/// Any subclasses that implement this method must call super.
///
/// Note that this is not equivalent to calling `reloadData` on the collection
/// view. If any changes to the data source have occurred, you should reload the
/// data instead of invalidating the layout.
- (void)invalidateLayout __attribute((objc_requires_super));

/// Called when the layout has already been invalidated and should now
/// update the current layout.
///
/// This is an appropriate time to calculate geometry for the layout. Ideally
/// this data should be cached to provide faster access when the collection view
/// needs the layout information at a later point in time.
///
/// Will be called every time the collection view is resized, unless
/// -shouldInvalidateLayoutForBoundsChange: is overridden for custom
/// invalidation behavior.
- (void)prepareLayout;

/// Subclasses should override these methods (if applicable) to return the layout attributes
/// for the item at the specified index path, or the supplementary item for the specified
/// section and kind.
///
/// As these methods will be called quite frequently during scrolling of the collection view,
/// time-intensive calculations should not be performed in these methods. It is better to
/// do as many calculations as possible beforehand in -prepareLayout, and return
/// cached information in these methods.
///
/// Return values should be non-nil.
- (YMJNWCollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;
- (YMJNWCollectionViewLayoutAttributes *)layoutAttributesForSupplementaryItemInSection:(NSInteger)section kind:(NSString *)kind;

/// Subclasses should an array of index paths that the layout decides should be inside the
/// specified rect. Implementing this method can provide far more optimized performance during scrolling.
///
/// Default return value is nil.
- (NSArray *)indexPathsForItemsInRect:(CGRect)rect;

/// Subclasses should override this method to return the size of the specified section.
///
/// Overriding this method significantly decreases the time taken to recalculate layout
/// information since the layout can usually provide a pre-calculated rect far faster
/// than the collection view itself can calculate it.
///
/// Be sure to account for supplementary views, in addition to cells when calculating
/// this rect. The behavior when the returned rect is incorrect is undefined.
///
/// The default return value is CGRectNull.
- (CGRect)rectForSectionAtIndex:(NSInteger)index;

/// The complete size of all sections combined. Overriding this method is optional,
/// however if a different size is desired than what can be inferred from the section
/// frames, it should be overridden.
///
/// Note that the collection view will discard any values smaller than the frame size, so
/// if if an axis does not need to be scrolled a value of 0 can be provided.
///
/// Defaults to CGSizeZero, which means it will fit the collection view's frame.
- (CGSize)contentSize;

/// The scroll direction determines which way the collection view will show scroll indicators.
///
/// Subclasses should override this method to change the scroll direction.
///
/// Note that if the content view is larger than the bounds of the collection view, the content will
/// still be scrollable, even if the scroll indicators do not show up. To prevent this, do not make
/// the content view larger than the collection view itself in the direction in which you do not want
/// scrolling.
///
/// Defaults to YMJNWCollectionViewScrollDirectionVertical.
- (YMJNWCollectionViewScrollDirection)scrollDirection;

/// Subclasses must implement this method for arrowed selection to work.
- (NSIndexPath *)indexPathForNextItemInDirection:(YMJNWCollectionViewDirection)direction currentIndexPath:(NSIndexPath *)currentIndexPath;

/// Subclasses can implement this method to optionally decline a layout invalidation.
///
/// The default return value is YES.
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds;

/// Subclasses can override this method to inform the collection view that it should
/// re-apply the layout attributes of any visible items every time the collection view
/// performs a new layout pass.
///
/// The default return value is NO, for performance reasons.
- (BOOL)shouldApplyExistingLayoutAttributesOnLayout;

@end

@interface YMJNWCollectionView()

/// Returns whether an index path contains a valid item.
- (BOOL)validateIndexPath:(NSIndexPath *)indexPath;

/// Returns the next index path after the specified index path, or nil if it is the last index.
- (NSIndexPath *)indexPathForNextSelectableItemAfterIndexPath:(NSIndexPath *)indexPath;

/// Returns the next index path before the specified index path, or nil if it is the last index.
- (NSIndexPath *)indexPathForNextSelectableItemBeforeIndexPath:(NSIndexPath *)indexPath;

@end

@interface YMJNWCollectionViewLayout(Deprecated)
- (instancetype)initWithCollectionView:(YMJNWCollectionView *)collectionView __attribute__((deprecated("use -init instead.")));
@end
