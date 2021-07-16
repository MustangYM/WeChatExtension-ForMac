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

#import "YMJNWCollectionViewFramework.h"
#import "YMJNWCollectionView+Private.h"
#import "YMJNWCollectionViewCell+Private.h"
#import "YMJNWCollectionViewReusableView+Private.h"
#import <QuartzCore/QuartzCore.h>
#import "YMJNWCollectionViewData.h"
#import "YMJNWCollectionViewListLayout.h"
#import "YMJNWCollectionViewDocumentView.h"
#import "YMJNWCollectionViewLayout.h"
#import "YMJNWCollectionViewLayout+Private.h"

#ifndef NSAppKitVersionNumber10_11
#define NSAppKitVersionNumber10_11 1404
#endif

typedef NS_ENUM(NSInteger, YMJNWCollectionViewSelectionType) {
	YMJNWCollectionViewSelectionTypeSingle,
	YMJNWCollectionViewSelectionTypeExtending,
	YMJNWCollectionViewSelectionTypeMultiple
};

@interface YMJNWCollectionView() {
	struct {
		unsigned int dataSourceNumberOfSections:1;
		unsigned int dataSourceViewForSupplementaryView:1;
		
		unsigned int delegateMouseDown:1;
		unsigned int delegateMouseDownWithEvent:1;
		unsigned int delegateMouseUp:1;
		unsigned int delegateMouseUpWithEvent:1;
		unsigned int delegateMouseMoved:1;
		unsigned int delegateMouseDragged:1;
		unsigned int delegateMouseEntered:1;
		unsigned int delegateMouseExited:1;
		unsigned int delegateShouldSelect:1;
		unsigned int delegateDidSelect:1;
		unsigned int delegateShouldDeselect:1;
		unsigned int delegateDidDeselect:1;
		unsigned int delegateShouldScroll:1;
		unsigned int delegateDidScroll:1;
		unsigned int delegateDidDoubleClick:1;
		unsigned int delegateDidRightClick:1;
		unsigned int delegateDidEndDisplayingCell:1;
		unsigned int delegateMenuForEvent:1;
		unsigned int delegateObjectValueForCell:1;
		
		unsigned int wantsLayout;
	} _collectionViewFlags;
	
	CGSize _lastDrawnSize;
}

// Layout data/cache
@property (nonatomic, strong) YMJNWCollectionViewData *data;

// Selection
@property (nonatomic, strong, readwrite) NSMutableArray *selectedIndexes;

// Cells
@property (nonatomic, strong) NSMutableDictionary *reusableCells; // { identifier : (cells) }
@property (nonatomic, strong) NSMutableDictionary *visibleCellsMap; // { index path : cell }
@property (nonatomic, strong) NSMutableDictionary *cellClassMap; // { identifier : class }
@property (nonatomic, strong) NSMutableDictionary *cellNibMap; // { identifier : nib }

// Supplementary views
@property (nonatomic, strong) NSMutableDictionary *reusableSupplementaryViews; // { "kind/identifier" : (views) }
@property (nonatomic, strong) NSMutableDictionary *visibleSupplementaryViewsMap; // { "index/kind/identifier" : view } }
@property (nonatomic, strong) NSMutableDictionary *supplementaryViewClassMap; // { "kind/identifier" : class }
@property (nonatomic, strong) NSMutableDictionary *supplementaryViewNibMap; // { "kind/identifier" : nib }

@property (nonatomic, strong) NSView *collectionViewDocumentView;

@end

@implementation YMJNWCollectionView
@dynamic drawsBackground;
@dynamic backgroundColor;

// We're using a static function for the common initialization so that subclassers
// don't accidentally override this method in their own common init method.
static void YMJNWCollectionViewCommonInit(YMJNWCollectionView *collectionView) {
	collectionView.data = [[YMJNWCollectionViewData alloc] initWithCollectionView:collectionView];
	
	collectionView.selectedIndexes = [NSMutableArray array];
	collectionView.cellClassMap = [NSMutableDictionary dictionary];
	collectionView.cellNibMap = [NSMutableDictionary dictionary];
	collectionView.visibleCellsMap = [NSMutableDictionary dictionary];
	collectionView.reusableCells = [NSMutableDictionary dictionary];
	collectionView.supplementaryViewClassMap = [NSMutableDictionary dictionary];
	collectionView.supplementaryViewNibMap = [NSMutableDictionary dictionary];
	collectionView.visibleSupplementaryViewsMap = [NSMutableDictionary dictionary];
	collectionView.reusableSupplementaryViews = [NSMutableDictionary dictionary];
	
	// By default we are layer-backed.
	collectionView.wantsLayer = YES;
	
	// Set the document view to a custom class that returns YES to -isFlipped.
	YMJNWCollectionViewDocumentView *documentView = [[YMJNWCollectionViewDocumentView alloc] initWithFrame:CGRectZero];
	collectionView.collectionViewDocumentView = documentView;
	collectionView.documentView = documentView;
		
	// We don't want to perform an initial layout pass until the user has called -reloadData.
	collectionView->_collectionViewFlags.wantsLayout = NO;
	
	collectionView.allowsSelection = YES;
	
	collectionView.allowsEmptySelection = YES;
	
	collectionView.backgroundColor = NSColor.whiteColor;
	collectionView.drawsBackground = YES;
}

- (id)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];
	if (self == nil) return nil;
	YMJNWCollectionViewCommonInit(self);
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self == nil) return nil;
	YMJNWCollectionViewCommonInit(self);
	return self;
}

#pragma mark Delegate and data source

- (void)setDelegate:(id<YMJNWCollectionViewDelegate>)delegate {	
	_delegate = delegate;
	_collectionViewFlags.delegateMouseUp = [delegate respondsToSelector:@selector(collectionView:mouseUpInItemAtIndexPath:)];
	_collectionViewFlags.delegateMouseUpWithEvent = [delegate respondsToSelector:@selector(collectionView:mouseUpInItemAtIndexPath:withEvent:)];
	_collectionViewFlags.delegateMouseDown = [delegate respondsToSelector:@selector(collectionView:mouseDownInItemAtIndexPath:)];
	_collectionViewFlags.delegateMouseDownWithEvent = [delegate respondsToSelector:@selector(collectionView:mouseDownInItemAtIndexPath:withEvent:)];
	_collectionViewFlags.delegateMouseMoved = [delegate respondsToSelector:@selector(collectionView:mouseMovedInItemAtIndexPath:withEvent:)];
	_collectionViewFlags.delegateMouseDragged = [delegate respondsToSelector:@selector(collectionView:mouseDraggedInItemAtIndexPath:withEvent:)];
	_collectionViewFlags.delegateMouseEntered = [delegate respondsToSelector:@selector(collectionView:mouseEnteredInItemAtIndexPath:withEvent:)];
	_collectionViewFlags.delegateMouseExited = [delegate respondsToSelector:@selector(collectionView:mouseExitedInItemAtIndexPath:withEvent:)];
	_collectionViewFlags.delegateShouldSelect = [delegate respondsToSelector:@selector(collectionView:shouldSelectItemAtIndexPath:)];
	_collectionViewFlags.delegateDidSelect = [delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)];
	_collectionViewFlags.delegateShouldDeselect = [delegate respondsToSelector:@selector(collectionView:shouldDeselectItemAtIndexPath:)];
	_collectionViewFlags.delegateDidDeselect = [delegate respondsToSelector:@selector(collectionView:didDeselectItemAtIndexPath:)];
	_collectionViewFlags.delegateDidDoubleClick = [delegate respondsToSelector:@selector(collectionView:didDoubleClickItemAtIndexPath:)];
	_collectionViewFlags.delegateDidRightClick = [delegate respondsToSelector:@selector(collectionView:didRightClickItemAtIndexPath:)];
	_collectionViewFlags.delegateDidEndDisplayingCell = [delegate respondsToSelector:@selector(collectionView:didEndDisplayingCell:forItemAtIndexPath:)];
	_collectionViewFlags.delegateShouldScroll = [delegate respondsToSelector:@selector(collectionView:shouldScrollToItemAtIndexPath:)];
	_collectionViewFlags.delegateDidScroll = [delegate respondsToSelector:@selector(collectionView:didScrollToItemAtIndexPath:)];
	_collectionViewFlags.delegateMenuForEvent = [delegate respondsToSelector:@selector(collectionView:menuForEvent:)];
	_collectionViewFlags.delegateObjectValueForCell = [delegate respondsToSelector:@selector(collectionView:objectValueForItemAtIndexPath:)];
}

- (void)setDataSource:(id<YMJNWCollectionViewDataSource>)dataSource {
	_dataSource = dataSource;
	_collectionViewFlags.dataSourceNumberOfSections = [dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)];
	_collectionViewFlags.dataSourceViewForSupplementaryView = [dataSource respondsToSelector:@selector(collectionView:viewForSupplementaryViewOfKind:inSection:)];
	NSAssert(dataSource == nil || [dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)],
			 @"data source must implement collectionView:numberOfItemsInSection");
	NSAssert(dataSource == nil || [dataSource respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:)],
			 @"data source must implement collectionView:cellForItemAtIndexPath:");
}


#pragma mark Queueing and dequeuing

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)reuseIdentifier {
	NSParameterAssert(cellClass);
	NSParameterAssert(reuseIdentifier);
	NSAssert([cellClass isSubclassOfClass:YMJNWCollectionViewCell.class], @"registered cell class must be a subclass of YMJNWCollectionViewCell");
	self.cellClassMap[reuseIdentifier] = cellClass;
	[self.cellNibMap removeObjectForKey:reuseIdentifier];
}

- (void)registerClass:(Class)supplementaryViewClass forSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)reuseIdentifier {
	NSParameterAssert(supplementaryViewClass);
	NSParameterAssert(kind);
	NSParameterAssert(reuseIdentifier);
	NSAssert([supplementaryViewClass isSubclassOfClass:YMJNWCollectionViewReusableView.class],
			 @"registered supplementary view class must be a subclass of YMJNWCollectionViewReusableView");
	
	// Thanks to PSTCollectionView for the original idea of using the key and reuse identfier to
	// form the key for the supplementary views.
	NSString *identifier = [self supplementaryViewIdentifierWithKind:kind reuseIdentifier:reuseIdentifier];
	self.supplementaryViewClassMap[identifier] = supplementaryViewClass;
	[self.supplementaryViewNibMap removeObjectForKey:identifier];
}

- (void)registerNib:(NSNib *)cellNib forCellWithReuseIdentifier:(NSString *)reuseIdentifier {
	NSParameterAssert(cellNib);
	NSParameterAssert(reuseIdentifier);
	
	self.cellNibMap[reuseIdentifier] = cellNib;
	[self.cellClassMap removeObjectForKey:reuseIdentifier];
}

- (void)registerNib:(NSNib *)supplementaryViewNib forSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)reuseIdentifier {
	NSParameterAssert(supplementaryViewNib);
	NSParameterAssert(kind);
	NSParameterAssert(reuseIdentifier);
	
	NSString *identifier = [self supplementaryViewIdentifierWithKind:kind reuseIdentifier:reuseIdentifier];
	self.supplementaryViewNibMap[identifier] = supplementaryViewNib;
	[self.supplementaryViewClassMap removeObjectForKey:identifier];
}

- (id)dequeueItemWithIdentifier:(NSString *)identifier inReusePool:(NSDictionary *)reuse {
	if (identifier == nil)
		return nil;
	
	NSMutableArray *reusableItems = reuse[identifier];
	if (reusableItems != nil) {
		id reusableItem = [reusableItems lastObject];
		
		if (reusableItem != nil) {
			[reusableItems removeObject:reusableItem];
			return reusableItem;
		}
	}
	
	return nil;
}

- (void)enqueueItem:(id)item withIdentifier:(NSString *)identifier inReusePool:(NSMutableDictionary *)reuse {
	if (identifier == nil)
		return;
	
	NSMutableArray *reusableCells = reuse[identifier];
	if (reusableCells == nil) {
		reusableCells = [NSMutableArray array];
		reuse[identifier] = reusableCells;
	}

	[reusableCells addObject:item];
}

- (id)firstTopLevelObjectOfClass:(Class)objectClass inNib:(NSNib *)nib {
	NSArray *topLevelObjects = nil;
	return [self firstTopLevelObjectOfClass:objectClass inNib:nib topLevelObjects:&topLevelObjects];
}

- (id)firstTopLevelObjectOfClass:(Class)objectClass inNib:(NSNib *)nib topLevelObjects:(NSArray**)objects {
	id foundObject = nil;
	if([nib instantiateWithOwner:self topLevelObjects:objects]) {
		NSUInteger objectIndex = [*objects indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
			if ([obj isKindOfClass:objectClass]) {
				*stop = YES;
				return YES;
			}
			return NO;
		}];
		if (objectIndex != NSNotFound) {
			foundObject = [*objects objectAtIndex:objectIndex];
		}
	}
	return foundObject;
}

- (YMJNWCollectionViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier {
	NSParameterAssert(identifier);
	YMJNWCollectionViewCell *cell = [self dequeueItemWithIdentifier:identifier inReusePool:self.reusableCells];

	// If the view doesn't exist, we go ahead and create one. If we have a class registered
	// for this identifier, we use it, otherwise we just create an instance of YMJNWCollectionViewCell.
	if (cell == nil) {
		Class cellClass = self.cellClassMap[identifier];
		NSNib *cellNib = self.cellNibMap[identifier];
		
		if (cellClass == nil && cellNib == nil) {
			cellClass = YMJNWCollectionViewCell.class;
		}
		
		if (cellNib != nil) {
			NSArray *topLevelObjects = nil;
			cell = [self firstTopLevelObjectOfClass:YMJNWCollectionViewCell.class inNib:cellNib topLevelObjects:&topLevelObjects];
			// If the delegate is looking to use data binding, rig up the cell to use the NSObjectController from the nib.
			if (_collectionViewFlags.delegateObjectValueForCell) {
				for (id obj in topLevelObjects) {
					if ([obj isKindOfClass:[NSObjectController class]]) {
						cell.objectController = obj;
						break;
					}
				}
			}
		} else if (cellClass != nil) {
			cell = [[cellClass alloc] initWithFrame:CGRectZero];
		}
	}
	
	cell.reuseIdentifier = identifier;
	[cell prepareForReuse];
	return cell;
}

- (YMJNWCollectionViewReusableView *)dequeueReusableSupplementaryViewOfKind:(NSString *)kind withReuseIdentifer:(NSString *)reuseIdentifier {
	NSParameterAssert(reuseIdentifier);
	NSParameterAssert(kind);
	
	NSString *identifier = [self supplementaryViewIdentifierWithKind:kind reuseIdentifier:reuseIdentifier];
	YMJNWCollectionViewReusableView *view = [self dequeueItemWithIdentifier:identifier inReusePool:self.reusableSupplementaryViews];
	
	if (view == nil) {
		Class viewClass = self.supplementaryViewClassMap[identifier];
		NSNib *viewNib = self.supplementaryViewNibMap[identifier];
		
		if (viewClass == nil && viewNib == nil) {
			viewClass = YMJNWCollectionViewReusableView.class;
		}
		
		if (viewNib != nil) {
			view = [self firstTopLevelObjectOfClass:YMJNWCollectionViewReusableView.class inNib:viewNib];
		} else if (viewClass != nil) {
			view = [[viewClass alloc] initWithFrame:CGRectZero];
		}
	}
	
	view.reuseIdentifier = reuseIdentifier;
	view.kind = kind;

	return view;
}

- (void)enqueueReusableCell:(YMJNWCollectionViewCell *)cell withIdentifier:(NSString *)identifier {
	[self enqueueItem:cell withIdentifier:identifier inReusePool:self.reusableCells];
}

- (void)enqueueReusableSupplementaryView:(YMJNWCollectionViewReusableView *)view ofKind:(NSString *)kind withReuseIdentifier:(NSString *)reuseIdentifier {
	NSString *identifier = [self supplementaryViewIdentifierWithKind:kind reuseIdentifier:reuseIdentifier];
	[self enqueueItem:view withIdentifier:identifier inReusePool:self.reusableSupplementaryViews];
}

#pragma mark Reloading

- (void)reloadData {
	_collectionViewFlags.wantsLayout = YES;

	// Remove and notify any selected indexes we've been tracking.
	NSArray *selectedIndexes = self.selectedIndexes.copy;
	[self.selectedIndexes removeAllObjects];

	if (_collectionViewFlags.delegateDidDeselect) {
		for (NSIndexPath *indexPath in selectedIndexes) {
			[self.delegate collectionView:self didDeselectItemAtIndexPath:indexPath];
		}
	}
	
	[self.data recalculateAndPrepareLayout:YES];
	[self performFullRelayoutForcingSubviewsReset:YES];
	
	// Select the first item if empty selection is not allowed
	if (!self.allowsEmptySelection) {
		NSIndexPath *indexPath = [self indexPathForNextSelectableItemAfterIndexPath:nil];
		[self selectItemAtIndexPath:indexPath animated:NO];
	}
}

- (void)setCollectionViewLayout:(YMJNWCollectionViewLayout *)collectionViewLayout {
	if (self.collectionViewLayout == collectionViewLayout)
		return;
	
	NSAssert(collectionViewLayout.collectionView == nil, @"Collection view layouts should not be reused between separate collection view instances.");
	
	_collectionViewLayout = collectionViewLayout;
	_collectionViewLayout.collectionView = self;
	
	// Don't reload the data until we've performed an initial reload.
	if (_collectionViewFlags.wantsLayout) {
		[self reloadData];
	}
}

#pragma mark Resetting of state

/// Completely removes and resets cells, supplementary views, and selection state.
- (void)resetAllCellsAndSupplementaryViews {
	// Remove any queued views.
	[self.reusableCells removeAllObjects];
	[self.reusableSupplementaryViews removeAllObjects];
	
	// Remove any view mappings
	if (_collectionViewFlags.delegateDidEndDisplayingCell) {
		for (YMJNWCollectionViewCell *cell in self.visibleCellsMap.allValues) {
			[self.delegate collectionView:self didEndDisplayingCell:cell forItemAtIndexPath:cell.indexPath];
		}
	}
	[self.visibleCellsMap removeAllObjects];
	[self.visibleSupplementaryViewsMap removeAllObjects];
	
	// Remove any cells or views that might be added to the document view.
	NSArray *subviews = [[self.documentView subviews] copy];
	
	for (NSView *view in subviews) {
		[view removeFromSuperview];
	}
}

#pragma mark Cell Information

- (NSInteger)numberOfSections {
	return self.data.numberOfSections;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
	return [self.data numberOfItemsInSection:section];
}

- (NSIndexPath *)indexPathForItemAtPoint:(CGPoint)point {
	// TODO: Optimize, and perhaps have an option to defer this to the layout class.
	for (int i = 0; i < self.data.numberOfSections; i++) {
		YMJNWCollectionViewSection section = self.data.sections[i];
		if (!CGRectContainsPoint(section.frame, point))
			continue;
		
		NSUInteger numberOfItems = section.numberOfItems;
		for (NSInteger item = 0; item < numberOfItems; item++) {
			NSIndexPath *indexPath = [NSIndexPath YMJNW_indexPathForItem:item inSection:section.index];
			YMJNWCollectionViewLayoutAttributes *attributes = [self.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
			if (CGRectContainsPoint(attributes.frame, point)) {
				return indexPath;
			}
		}
	}
	
	return nil;
}

- (NSArray *)visibleCells {
	return self.visibleCellsMap.allValues;
}

- (BOOL)validateIndexPath:(NSIndexPath *)indexPath {
	return (indexPath.YMJNW_section < self.data.numberOfSections && indexPath.YMJNW_item < self.data.sections[indexPath.YMJNW_section].numberOfItems);
}

- (NSArray *)allIndexPaths {
	NSMutableArray *indexPaths = [NSMutableArray array];
	for (int i = 0; i < self.data.numberOfSections; i++) {
		YMJNWCollectionViewSection section = self.data.sections[i];
		for (NSInteger item = 0; item < section.numberOfItems; item++) {
			[indexPaths addObject:[NSIndexPath YMJNW_indexPathForItem:item inSection:section.index]];
		}
	}
	
	return indexPaths.copy;
}

- (NSIndexPath *)firstIndexPath {
	if ([self numberOfItemsInSection:0] > 0) {
		return [NSIndexPath YMJNW_indexPathForItem:0 inSection:0];
	}
	
	return nil;
}

- (NSIndexPath *)lastIndexPath {
	NSIndexPath *indexPath = nil;
	NSInteger numberOfSections = self.data.numberOfSections;
	if (numberOfSections > 0) {
		YMJNWCollectionViewSection section = self.data.sections[numberOfSections - 1];
		NSInteger numberOfItems = section.numberOfItems;
		if (numberOfItems > 0) {
			indexPath = [NSIndexPath YMJNW_indexPathForItem:numberOfItems - 1 inSection:numberOfSections - 1];
		}
	}
	return indexPath;
}

- (NSArray *)indexPathsForItemsInRect:(CGRect)rect {
	if (CGRectEqualToRect(rect, CGRectZero))
		return [NSArray array];
	
	NSArray *potentialIndexPaths = [self.collectionViewLayout indexPathsForItemsInRect:rect];
	if (potentialIndexPaths != nil) {
		return potentialIndexPaths;
	}
		
	NSMutableArray *visibleCells = [NSMutableArray array];
	
	for (int i = 0; i < self.data.numberOfSections; i++) {
		YMJNWCollectionViewSection section = self.data.sections[i];
		if (!CGRectIntersectsRect(section.frame, rect))
			continue;
		
		NSUInteger numberOfItems = section.numberOfItems;
		for (NSInteger item = 0; item < numberOfItems; item++) {
			NSIndexPath *indexPath = [NSIndexPath YMJNW_indexPathForItem:item inSection:section.index];
			YMJNWCollectionViewLayoutAttributes *attributes = [self.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
			
			if (CGRectIntersectsRect(attributes.frame, rect)) {
				[visibleCells addObject:indexPath];
			}
		}
	}

	return visibleCells;
}

- (NSArray *)layoutIdentifiersForSupplementaryViewsInRect:(CGRect)rect {
	NSMutableArray *visibleIdentifiers = [NSMutableArray array];
	NSArray *allIdentifiers = [self allSupplementaryViewIdentifiers];
	
	if (CGRectEqualToRect(rect, CGRectZero))
		return visibleIdentifiers;
	
	for (int i = 0; i < self.data.numberOfSections; i++) {
		YMJNWCollectionViewSection section = self.data.sections[i];
		for (NSString *identifier in allIdentifiers) {
			NSString *kind = [self kindForSupplementaryViewIdentifier:identifier];
			YMJNWCollectionViewLayoutAttributes *attributes = [self.collectionViewLayout layoutAttributesForSupplementaryItemInSection:section.index kind:kind];
			if (CGRectIntersectsRect(attributes.frame, rect)) {
				[visibleIdentifiers addObject:[self layoutIdentifierForSupplementaryViewIdentifier:identifier inSection:section.index]];
			}
		}		
	}
	
	return visibleIdentifiers.copy;
}

- (NSIndexSet *)indexesForSectionsInRect:(CGRect)rect {	
	NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
	
	if (CGRectEqualToRect(rect, CGRectZero))
		return indexes;
	
	for (int i = 0; i < self.data.numberOfSections; i++) {
		YMJNWCollectionViewSection section = self.data.sections[i];
		if (CGRectIntersectsRect(rect, section.frame)) {
			[indexes addIndex:section.index];
		}
	}
	
	return indexes.copy;
}

- (NSArray *)indexPathsForVisibleItems {
	return [self indexPathsForItemsInRect:self.documentVisibleRect];
}

- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(YMJNWCollectionViewScrollPosition)scrollPosition animated:(BOOL)animated {
	if (_collectionViewFlags.delegateShouldScroll && ![self.delegate collectionView:self shouldScrollToItemAtIndexPath:indexPath]) {
		return;
	}

	CGRect rect = [self rectForItemAtIndexPath:indexPath];
	CGRect visibleRect = self.documentVisibleRect;
	
	switch (scrollPosition) {
			break;
		case YMJNWCollectionViewScrollPositionTop:
			// make the top of our rect flush with the top of the visible bounds
			rect.size.height = CGRectGetHeight(visibleRect);
			//rect.origin.y = self.documentVisibleRect.origin.y + rect.size.height;
			break;
		case YMJNWCollectionViewScrollPositionMiddle:
			// TODO
			rect.size.height = self.bounds.size.height;
			rect.origin.y += (CGRectGetHeight(visibleRect) / 2.f) - CGRectGetHeight(rect);
			break;
		case YMJNWCollectionViewScrollPositionBottom:
			// make the bottom of our rect flush with the bottom of the visible bounds
			rect.size.height = CGRectGetHeight(visibleRect);
			rect.origin.y -= CGRectGetHeight(visibleRect);
			break;
		case YMJNWCollectionViewScrollPositionNone:
			// no scroll needed
			return;
			break;
		case YMJNWCollectionViewScrollPositionNearest:
			// We just pass the cell's frame onto the scroll view. It calculates this for us.
			break;
		default: // defaults to the same behavior as nearest
			break;
	}
	
	[self.clipView scrollRectToVisible:rect animated:animated];
	
	if (_collectionViewFlags.delegateDidScroll) {
		[self.delegate collectionView:self didScrollToItemAtIndexPath:indexPath];
	}
}

- (CGRect)rectForItemAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath == nil || indexPath.YMJNW_section < self.data.numberOfSections) {
		YMJNWCollectionViewLayoutAttributes *attributes = [self.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
		return attributes.frame;
	}
	
	return CGRectZero;
}

- (CGRect)rectForSupplementaryViewWithKind:(NSString *)kind inSection:(NSInteger)section {
	if (section >= 0 && section < self.data.numberOfSections) {
		YMJNWCollectionViewLayoutAttributes *attributes = [self.collectionViewLayout layoutAttributesForSupplementaryItemInSection:section kind:kind];
		return attributes.frame;
	}
	
	return CGRectZero;
}

- (CGRect)rectForSection:(NSInteger)index {
	if (index >= 0 && index < self.data.numberOfSections) {
		YMJNWCollectionViewSection section = self.data.sections[index];
		return section.frame;
	}
	return CGRectZero;
}

- (YMJNWCollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath == nil)
		return nil;
	return self.visibleCellsMap[indexPath];
}

- (YMJNWCollectionViewReusableView *)supplementaryViewForKind:(NSString *)kind reuseIdentifier:(NSString *)reuseIdentifier inSection:(NSInteger)section {
	NSString *identifer = [self supplementaryViewIdentifierWithKind:kind reuseIdentifier:reuseIdentifier];
	NSString *layoutIdentifier = [self layoutIdentifierForSupplementaryViewIdentifier:identifer inSection:section];
	
	return self.visibleSupplementaryViewsMap[layoutIdentifier];
}

- (NSIndexPath *)indexPathForCell:(YMJNWCollectionViewCell *)cell {
	return cell.indexPath;
}

#pragma mark Layout

- (void)layout {
	[super layout];

	if (CGSizeEqualToSize(self.visibleSize, _lastDrawnSize)) {
		[self layoutCells];
		[self layoutSupplementaryViews];
	} else {
		// Calling recalculate on our data will update the bounds needed for the collection
		// view, and optionally prepare the layout once again if the layout subclass decides
		// it needs a recalculation.
		CGRect visibleBounds = (CGRect){ .size = self.visibleSize };
		BOOL shouldInvalidate = [self.collectionViewLayout shouldInvalidateLayoutForBoundsChange:visibleBounds];
		[self.data recalculateAndPrepareLayout:shouldInvalidate];

		[self performFullRelayoutForcingSubviewsReset:NO];
	}
}

- (void)reflectScrolledClipView:(NSClipView*)clipView {
    [super reflectScrolledClipView:clipView];
    
    // 10.12 started optimizing the layout pass and reducing the number of calls to layout(). As
    // such, invalidate our layout when the scroll changes on 10.12 and above.
    if (floor(NSAppKitVersionNumber) > NSAppKitVersionNumber10_11) {
        // Invalidate our layout when we our scrolled. This is required for 10.12 and above.
        self.needsLayout = YES;
    }
}

- (void)collectionViewLayoutWasInvalidated:(YMJNWCollectionViewLayout *)layout {
	// First we prepare the layout. In the future it would possibly be a good idea to coalesce
	// this call to reduce unnecessary layout preparation calls.
	[self.data recalculateAndPrepareLayout:YES];
	[self performFullRelayoutForcingSubviewsReset:YES];
}

- (void)performFullRelayoutForcingSubviewsReset:(BOOL)forceReset {
	if (forceReset && _collectionViewFlags.wantsLayout) {
		[self resetAllCellsAndSupplementaryViews];
	}
	
	[self layoutDocumentView];
	[self layoutCellsWithRedraw:YES];
	[self layoutSupplementaryViewsWithRedraw:YES];
	
	_lastDrawnSize = self.visibleSize;
}

- (void)layoutDocumentView {
	if (!_collectionViewFlags.wantsLayout)
		return;
	
	[self updateScrollDirection];

	NSView *documentView = self.documentView;
	documentView.frameSize = self.data.encompassingSize;
}

- (void)updateScrollDirection {
	switch (self.collectionViewLayout.scrollDirection) {
		case YMJNWCollectionViewScrollDirectionVertical:
			self.hasVerticalScroller = YES;
			self.hasHorizontalScroller = NO;
			break;
		case YMJNWCollectionViewScrollDirectionHorizontal:
			self.hasVerticalScroller = NO;
			self.hasHorizontalScroller = YES;
			break;
		case YMJNWCollectionViewScrollDirectionBoth:
		default:
			self.hasVerticalScroller = YES;
			self.hasHorizontalScroller = YES;
			break;
	}
}

- (CGSize)visibleSize {
	return self.documentVisibleRect.size;
}

- (void)layoutCells {
	[self layoutCellsWithRedraw:NO];
}

- (void)layoutCellsWithRedraw:(BOOL)needsVisibleRedraw {
	if (self.dataSource == nil || !_collectionViewFlags.wantsLayout)
		return;
	
	if (needsVisibleRedraw || [self.collectionViewLayout shouldApplyExistingLayoutAttributesOnLayout]) {
		for (NSIndexPath *indexPath in self.visibleCellsMap.allKeys) {
			YMJNWCollectionViewCell *cell = self.visibleCellsMap[indexPath];
			YMJNWCollectionViewLayoutAttributes *attributes = [self.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
			
			[self applyLayoutAttributes:attributes toCell:cell];
		}
	}

	NSArray *oldVisibleIndexPaths = [self.visibleCellsMap allKeys];
	NSArray *updatedVisibleIndexPaths = [self indexPathsForItemsInRect:self.documentVisibleRect];


	NSMutableArray *indexPathsToRemove = [NSMutableArray arrayWithArray:oldVisibleIndexPaths];
	[indexPathsToRemove removeObjectsInArray:updatedVisibleIndexPaths];
	
	NSMutableArray *indexPathsToAdd = [NSMutableArray arrayWithArray:updatedVisibleIndexPaths];
	[indexPathsToAdd removeObjectsInArray:oldVisibleIndexPaths];
	
	// Remove old cells and put them in the reuse queue
	for (NSIndexPath *indexPath in indexPathsToRemove) {
		YMJNWCollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
		[self.visibleCellsMap removeObjectForKey:indexPath];
		[self enqueueReusableCell:cell withIdentifier:cell.reuseIdentifier];
		[cell setHidden:YES];
		
		// clear objectValue and objectController.content when cells are re-used
		cell.objectValue = nil;
		if (cell.objectController) {
			cell.objectController.content = nil;
		}

		if (_collectionViewFlags.delegateDidEndDisplayingCell) {
			[self.delegate collectionView:self didEndDisplayingCell:cell forItemAtIndexPath:indexPath];
		}
	}
	
	// Add the new cells
	for (NSIndexPath *indexPath in indexPathsToAdd) {
		YMJNWCollectionViewCell *cell = [self.dataSource collectionView:self cellForItemAtIndexPath:indexPath];
		
		// If any of these are true this cell isn't valid, and we'll be forced to skip it and throw the relevant exceptions.
		if (cell == nil || ![cell isKindOfClass:YMJNWCollectionViewCell.class]) {
			NSAssert(cell != nil, @"collectionView:cellForItemAtIndexPath: must return a non-nil cell.");
			// Although we have checked to ensure the class registered for the cell is a subclass
			// of YMJNWCollectionViewCell earlier, there's always the chance that the user has
			// not used the dedicated dequeuing method to retrieve their newly created cell and
			// instead have just created it themselves. There's not much we can do to prevent this,
			// so it's probably worth it to double check this one more time.
			NSAssert([cell isKindOfClass:YMJNWCollectionViewCell.class],
					 @"collectionView:cellForItemAtIndexPath: must return an instance or subclass of YMJNWCollectionViewCell.");
			continue;
		}
		cell.indexPath = indexPath;
		cell.collectionView = self;
		
		YMJNWCollectionViewLayoutAttributes *attributes = [self.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
		[self applyLayoutAttributes:attributes toCell:cell];
		
		if (cell.superview == nil) {
			[self.documentView addSubview:cell];
		} else {
			[cell setHidden:NO];
		}

		if ([self.selectedIndexes containsObject:indexPath])
			cell.selected = YES;
		else
			cell.selected = NO;
		
		if (_collectionViewFlags.delegateObjectValueForCell) {
			if (cell.objectController) {
				cell.objectController.content = [self.delegate collectionView:self objectValueForItemAtIndexPath:indexPath];
			}
			cell.objectValue = [self.delegate collectionView:self objectValueForItemAtIndexPath:indexPath];
		}
		
		self.visibleCellsMap[indexPath] = cell;
	}
}

- (void)applyLayoutAttributes:(YMJNWCollectionViewLayoutAttributes *)attributes toCell:(YMJNWCollectionViewCell *)cell {
	[cell willLayoutWithFrame:attributes.frame];

	cell.frame = attributes.frame;
	cell.alphaValue = attributes.alpha;
	cell.layer.zPosition = attributes.zIndex;
	
	[cell didLayoutWithFrame:attributes.frame];
}

#pragma mark Supplementary Views

- (NSArray *)allSupplementaryViewIdentifiers {
	return [self.supplementaryViewClassMap.allKeys arrayByAddingObjectsFromArray:self.supplementaryViewNibMap.allKeys];
}

- (NSString *)supplementaryViewIdentifierWithKind:(NSString *)kind reuseIdentifier:(NSString *)reuseIdentifier {
	return [NSString stringWithFormat:@"%@/%@", kind, reuseIdentifier];
}

- (NSString *)kindForSupplementaryViewIdentifier:(NSString *)identifier {
	NSArray *components = [identifier componentsSeparatedByString:@"/"];
	return components[0];
}

- (NSString *)reuseIdentifierForSupplementaryViewIdentifier:(NSString *)identifier {
	NSArray *components = [identifier componentsSeparatedByString:@"/"];
	return components[1];
}

- (NSString *)layoutIdentifierForSupplementaryViewIdentifier:(NSString *)identifier inSection:(NSInteger)section {
	return [NSString stringWithFormat:@"%li/%@", section, identifier];
}

- (NSString *)supplementaryViewIdentifierForLayoutIdentifier:(NSString *)identifier {
	NSArray *comps = [identifier componentsSeparatedByString:@"/"];
	return [NSString stringWithFormat:@"%@/%@", comps[1], comps[2]];
}

- (NSInteger)sectionForSupplementaryLayoutIdentifier:(NSString *)identifier {
	NSArray *comps = [identifier componentsSeparatedByString:@"/"];
	return [comps[0] integerValue];
}

- (void)layoutSupplementaryViews {
	[self layoutSupplementaryViewsWithRedraw:NO];
}

- (void)layoutSupplementaryViewsWithRedraw:(BOOL)needsVisibleRedraw {
	if (!_collectionViewFlags.dataSourceViewForSupplementaryView || !_collectionViewFlags.wantsLayout)
		return;
	
	if (needsVisibleRedraw || [self.collectionViewLayout shouldApplyExistingLayoutAttributesOnLayout]) {
		NSArray *allVisibleIdentifiers = self.visibleSupplementaryViewsMap.allKeys;
		for (NSString *layoutIdentifier in allVisibleIdentifiers) {
			NSString *identifier = [self supplementaryViewIdentifierForLayoutIdentifier:layoutIdentifier];
			NSString *reuseIdentifier = [self reuseIdentifierForSupplementaryViewIdentifier:identifier];
			NSString *kind = [self kindForSupplementaryViewIdentifier:identifier];
			NSInteger section = [self sectionForSupplementaryLayoutIdentifier:layoutIdentifier];
			YMJNWCollectionViewReusableView *view = [self supplementaryViewForKind:kind reuseIdentifier:reuseIdentifier inSection:section];
			
			YMJNWCollectionViewLayoutAttributes *attributes = [self.collectionViewLayout layoutAttributesForSupplementaryItemInSection:section kind:kind];
			[self applyLayoutAttributes:attributes toSupplementaryView:view];
		}
	}
	
	// Here's the strategy. There can only be one supplementary view for each kind in every section. Now this supplementary view
	// might not be of the same type in each section, due to the fact that the user might have registered multiple classes/identifiers
	// for the same kind. So what we're wanting to do is just loop through the kinds and ask the data source for the supplementary view
	// for each section/kind.
			
	// { "index/kind/identifier" : view }
	NSArray *oldVisibleViewsIdentifiers = self.visibleSupplementaryViewsMap.allKeys;
	NSArray *updatedVisibleViewsIdentifiers = [self layoutIdentifiersForSupplementaryViewsInRect:self.documentVisibleRect];	
	
	NSMutableArray *viewsToRemoveIdentifers = [NSMutableArray arrayWithArray:oldVisibleViewsIdentifiers];
	[viewsToRemoveIdentifers removeObjectsInArray:updatedVisibleViewsIdentifiers];
	
	NSMutableArray *viewsToAddIdentifiers = [NSMutableArray arrayWithArray:updatedVisibleViewsIdentifiers];
	[viewsToAddIdentifiers removeObjectsInArray:oldVisibleViewsIdentifiers];
	
	// Remove old views
	for (NSString *layoutIdentifier in viewsToRemoveIdentifers) {
		YMJNWCollectionViewReusableView *view = self.visibleSupplementaryViewsMap[layoutIdentifier];
		[self.visibleSupplementaryViewsMap removeObjectForKey:layoutIdentifier];
		
		[view removeFromSuperview];
		
		[self enqueueReusableSupplementaryView:view ofKind:view.kind withReuseIdentifier:view.reuseIdentifier];
	}
		
	// Add new views
	for (NSString *layoutIdentifier in viewsToAddIdentifiers) {
		NSInteger section = [self sectionForSupplementaryLayoutIdentifier:layoutIdentifier];
		NSString *identifier = [self supplementaryViewIdentifierForLayoutIdentifier:layoutIdentifier];
		NSString *kind = [self kindForSupplementaryViewIdentifier:identifier];
		
		YMJNWCollectionViewReusableView *view = [self.dataSource collectionView:self viewForSupplementaryViewOfKind:kind inSection:section];
		NSAssert([view isKindOfClass:YMJNWCollectionViewReusableView.class], @"view returned from %@ should be a subclass of %@",
				 NSStringFromSelector(@selector(collectionView:viewForSupplementaryViewOfKind:inSection:)), NSStringFromClass(YMJNWCollectionViewReusableView.class));
		
		YMJNWCollectionViewLayoutAttributes *attributes = [self.collectionViewLayout layoutAttributesForSupplementaryItemInSection:section kind:kind];
		view.frame = attributes.frame;
		view.alphaValue = attributes.alpha;
		[self.documentView addSubview:view];
		
		self.visibleSupplementaryViewsMap[layoutIdentifier] = view;
	}
}

- (void)applyLayoutAttributes:(YMJNWCollectionViewLayoutAttributes *)attributes toSupplementaryView:(YMJNWCollectionViewReusableView *)view {
	view.frame = attributes.frame;
	view.alphaValue = attributes.alpha;
	view.layer.zPosition = attributes.zIndex;
}

#pragma mark Mouse events and selection

- (BOOL)canBecomeKeyView {
	return YES;
}

- (BOOL)acceptsFirstResponder {
	return YES;
}

- (BOOL)becomeFirstResponder {
	return YES;
}

- (BOOL)resignFirstResponder {
	return YES;
}

// Returns the last object in the selection array.
- (NSIndexPath *)indexPathForSelectedItem {
	return self.selectedIndexes.lastObject;
}

- (NSArray *)indexPathsForSelectedItems {
	return self.selectedIndexes.copy;
}

- (void)deselectItemsAtIndexPaths:(NSArray *)indexPaths animated:(BOOL)animated {
	for (NSIndexPath *indexPath in indexPaths) {
		[self deselectItemAtIndexPath:indexPath animated:animated];
	}
}

- (void)selectItemsAtIndexPaths:(NSArray *)indexPaths animated:(BOOL)animated {
	for (NSIndexPath *indexPath in indexPaths) {
		[self selectItemAtIndexPath:indexPath animated:animated];
	}
}

- (void)deselectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
	if (indexPath == nil ||
		!self.allowsSelection ||
		(_collectionViewFlags.delegateShouldDeselect && ![self.delegate collectionView:self shouldDeselectItemAtIndexPath:indexPath]) ||
		(!self.allowsEmptySelection && self.indexPathsForSelectedItems.count <= 1)) {
		return;
	}
	
	YMJNWCollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
	[cell setSelected:NO animated:self.animatesSelection];
	[self.selectedIndexes removeObject:indexPath];
	
	if (_collectionViewFlags.delegateDidDeselect) {
		[self.delegate collectionView:self didDeselectItemAtIndexPath:indexPath];
	}
}

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
	if (indexPath == nil ||
		!self.allowsSelection ||
		(_collectionViewFlags.delegateShouldSelect && ![self.delegate collectionView:self shouldSelectItemAtIndexPath:indexPath])) {
		return;
	}
	
	YMJNWCollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
	[cell setSelected:YES animated:self.animatesSelection];

	if (![self.selectedIndexes containsObject:indexPath])
		[self.selectedIndexes addObject:indexPath];
	
	if (_collectionViewFlags.delegateDidSelect) {
		[self.delegate collectionView:self didSelectItemAtIndexPath:indexPath];
	}
}

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath
			atScrollPosition:(YMJNWCollectionViewScrollPosition)scrollPosition
					animated:(BOOL)animated {
	[self selectItemAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated selectionType:YMJNWCollectionViewSelectionTypeSingle];
}

- (NSIndexPath *)indexPathForNextSelectableItemAfterIndexPath:(NSIndexPath *)indexPath {
	if (indexPath == nil && [self validateIndexPath:[NSIndexPath YMJNW_indexPathForItem:0 inSection:0]]) {
		// Passing `nil` will select the very first index path
		return [NSIndexPath YMJNW_indexPathForItem:0 inSection:0];
	} else if (indexPath.YMJNW_item + 1 >= self.data.sections[indexPath.YMJNW_section].numberOfItems) {
		// Jump up to the next section
		NSIndexPath *newIndexPath = [NSIndexPath YMJNW_indexPathForItem:0 inSection:indexPath.YMJNW_section + 1];
		if ([self validateIndexPath:newIndexPath])
			return newIndexPath;
	} else {
		return [NSIndexPath YMJNW_indexPathForItem:indexPath.YMJNW_item + 1 inSection:indexPath.YMJNW_section];
	}
	return nil;
}

- (NSIndexPath *)indexPathForNextSelectableItemBeforeIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.YMJNW_item - 1 >= 0) {
		return [NSIndexPath YMJNW_indexPathForItem:indexPath.YMJNW_item - 1 inSection:indexPath.YMJNW_section];
	} else if(indexPath.YMJNW_section - 1 >= 0 && self.data.numberOfSections) {
		NSInteger numberOfItems = self.data.sections[indexPath.YMJNW_section - 1].numberOfItems;
		NSIndexPath *newIndexPath = [NSIndexPath YMJNW_indexPathForItem:numberOfItems - 1 inSection:indexPath.YMJNW_section - 1];
		if ([self validateIndexPath:newIndexPath])
			return newIndexPath;
	}
	return nil;
}

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath
			atScrollPosition:(YMJNWCollectionViewScrollPosition)scrollPosition
					animated:(BOOL)animated
			   selectionType:(YMJNWCollectionViewSelectionType)selectionType {
	if (indexPath == nil)
		return;
	
	NSMutableSet *indexesToSelect = [NSMutableSet set];
	
	if (selectionType == YMJNWCollectionViewSelectionTypeSingle) {
		[indexesToSelect addObject:indexPath];
	} else if (selectionType == YMJNWCollectionViewSelectionTypeMultiple) {
		[indexesToSelect addObjectsFromArray:self.selectedIndexes];
		if ([indexesToSelect containsObject:indexPath]) {
			[indexesToSelect removeObject:indexPath];
		} else {
			[indexesToSelect addObject:indexPath];
		}
	} else if (selectionType == YMJNWCollectionViewSelectionTypeExtending) {
		// From what I have determined, this behavior should be as follows.
		// Take the index selected first, and select all items between there and the
		// last selected item.
		NSIndexPath *firstIndex = (self.selectedIndexes.count > 0 ? self.selectedIndexes[0] : nil);
		if (firstIndex != nil) {
			[indexesToSelect addObject:firstIndex];
			
			if (![firstIndex isEqual:indexPath]) {
				NSComparisonResult order = [firstIndex compare:indexPath];
				NSIndexPath *nextIndex = firstIndex;
				
				while (nextIndex != nil && ![nextIndex isEqual:indexPath]) {
					[indexesToSelect addObject:nextIndex];
					
					if (order == NSOrderedAscending) {
						nextIndex = [self indexPathForNextSelectableItemAfterIndexPath:nextIndex];
					} else if (order == NSOrderedDescending) {
						nextIndex = [self indexPathForNextSelectableItemBeforeIndexPath:nextIndex];
					}
				}
			}
		}
		
		[indexesToSelect addObject:indexPath];
	}
	
	NSMutableSet *indexesToDeselect = [NSMutableSet setWithArray:self.selectedIndexes];
	[indexesToDeselect minusSet:indexesToSelect];
	
	[self selectItemsAtIndexPaths:indexesToSelect.allObjects animated:animated];
	[self deselectItemsAtIndexPaths:indexesToDeselect.allObjects animated:animated];
	[self scrollToItemAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}

- (void)mouseDownInCollectionViewCell:(YMJNWCollectionViewCell *)cell withEvent:(NSEvent *)event {
	NSIndexPath *indexPath = [self indexPathForCell:cell];
	if (_collectionViewFlags.delegateMouseDownWithEvent) {
		[self.delegate collectionView:self mouseDownInItemAtIndexPath:indexPath withEvent:event];
	} else if (_collectionViewFlags.delegateMouseDown) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		[self.delegate collectionView:self mouseDownInItemAtIndexPath:indexPath];
#pragma clang diagnostic pop
	}
}

- (void)mouseUpInCollectionViewCell:(YMJNWCollectionViewCell *)cell withEvent:(NSEvent *)event {
	[self.window makeFirstResponder:self];
	
	NSIndexPath *indexPath = [self indexPathForCell:cell];
	if (indexPath == nil) {
		NSLog(@"***index path not found for selection.");
	}

	if (_collectionViewFlags.delegateMouseUpWithEvent) {
		[self.delegate collectionView:self mouseUpInItemAtIndexPath:indexPath withEvent:event];
	} else if (_collectionViewFlags.delegateMouseUp) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		[self.delegate collectionView:self mouseUpInItemAtIndexPath:indexPath];
#pragma clang diagnostic pop
	}

	// Detect if modifier flags are held down.
	// We prioritize the command key over the shift key.
	if (event.modifierFlags & NSCommandKeyMask) {
		[self selectItemAtIndexPath:indexPath atScrollPosition:YMJNWCollectionViewScrollPositionNearest animated:YES selectionType:YMJNWCollectionViewSelectionTypeMultiple];
	} else if (event.modifierFlags & NSShiftKeyMask) {
		[self selectItemAtIndexPath:indexPath atScrollPosition:YMJNWCollectionViewScrollPositionNearest animated:YES selectionType:YMJNWCollectionViewSelectionTypeExtending];
	} else {
		[self selectItemAtIndexPath:indexPath atScrollPosition:YMJNWCollectionViewScrollPositionNearest animated:YES];
	}
}

- (void)mouseMovedInCollectionViewCell:(YMJNWCollectionViewCell *)cell withEvent:(NSEvent *)event {
	if (_collectionViewFlags.delegateMouseMoved) {
		NSIndexPath *indexPath = [self indexPathForCell:cell];
		[self.delegate collectionView:self mouseMovedInItemAtIndexPath:indexPath withEvent:event];
	}
}

- (void)mouseEnteredInCollectionViewCell:(YMJNWCollectionViewCell *)cell withEvent:(NSEvent *)event {
	if (_collectionViewFlags.delegateMouseEntered) {
		NSIndexPath *indexPath = [self indexPathForCell:cell];
		[self.delegate collectionView:self mouseEnteredInItemAtIndexPath:indexPath withEvent:event];
	}

	[[self.visibleCellsMap allValues] enumerateObjectsUsingBlock:^(YMJNWCollectionViewCell *cell, NSUInteger index, BOOL *stop) {
		cell.hovered = NO;
	}];
	cell.hovered = YES;
}

- (void)mouseExitedInCollectionViewCell:(YMJNWCollectionViewCell *)cell withEvent:(NSEvent *)event {
	if (_collectionViewFlags.delegateMouseExited) {
		NSIndexPath *indexPath = [self indexPathForCell:cell];
		[self.delegate collectionView:self mouseExitedInItemAtIndexPath:indexPath withEvent:event];
	}

	cell.hovered = NO;
}

- (void)mouseDraggedInCollectionViewCell:(YMJNWCollectionViewCell *)cell withEvent:(NSEvent *)event {
	if (_collectionViewFlags.delegateMouseDragged) {
		NSIndexPath *indexPath = [self indexPathForCell:cell];
		[self.delegate collectionView:self mouseDraggedInItemAtIndexPath:indexPath withEvent:event];
	}
}

- (void)doubleClickInCollectionViewCell:(YMJNWCollectionViewCell *)cell withEvent:(NSEvent *)event {
	if (_collectionViewFlags.delegateDidDoubleClick) {
		NSIndexPath *indexPath = [self indexPathForCell:cell];
		[self.delegate collectionView:self didDoubleClickItemAtIndexPath:indexPath];
	}
}

- (void)rightClickInCollectionViewCell:(YMJNWCollectionViewCell *)cell withEvent:(NSEvent *)event {
	if (_collectionViewFlags.delegateDidRightClick) {
		NSIndexPath *indexPath = [self indexPathForCell:cell];
		[self.delegate collectionView:self didRightClickItemAtIndexPath:indexPath];
	}
}

- (void)moveUp:(id)sender {
	NSIndexPath *toSelect = [self.collectionViewLayout indexPathForNextItemInDirection:YMJNWCollectionViewDirectionUp currentIndexPath:[self indexPathForSelectedItem]];
	[self selectItemAtIndexPath:toSelect atScrollPosition:YMJNWCollectionViewScrollPositionNearest animated:YES];
}

- (void)moveUpAndModifySelection:(id)sender {
	NSIndexPath *toSelect = [self.collectionViewLayout indexPathForNextItemInDirection:YMJNWCollectionViewDirectionUp currentIndexPath:[self indexPathForSelectedItem]];
	[self selectItemAtIndexPath:toSelect atScrollPosition:YMJNWCollectionViewScrollPositionNearest animated:YES selectionType:YMJNWCollectionViewSelectionTypeExtending];
}

- (void)moveDown:(id)sender {
	NSIndexPath *toSelect = [self.collectionViewLayout indexPathForNextItemInDirection:YMJNWCollectionViewDirectionDown currentIndexPath:[self indexPathForSelectedItem]];
	[self selectItemAtIndexPath:toSelect atScrollPosition:YMJNWCollectionViewScrollPositionNearest animated:YES];
}

- (void)moveDownAndModifySelection:(id)sender {
	NSIndexPath *toSelect = [self.collectionViewLayout indexPathForNextItemInDirection:YMJNWCollectionViewDirectionDown currentIndexPath:[self indexPathForSelectedItem]];
	[self selectItemAtIndexPath:toSelect atScrollPosition:YMJNWCollectionViewScrollPositionNearest animated:YES selectionType:YMJNWCollectionViewSelectionTypeExtending];
}

- (void)moveRight:(id)sender {
	NSIndexPath *toSelect = [self.collectionViewLayout indexPathForNextItemInDirection:YMJNWCollectionViewDirectionRight currentIndexPath:[self indexPathForSelectedItem]];
	[self selectItemAtIndexPath:toSelect atScrollPosition:YMJNWCollectionViewScrollPositionNearest animated:YES];
}

- (void)moveRightAndModifySelection:(id)sender {
	NSIndexPath *toSelect = [self.collectionViewLayout indexPathForNextItemInDirection:YMJNWCollectionViewDirectionRight currentIndexPath:[self indexPathForSelectedItem]];
	[self selectItemAtIndexPath:toSelect atScrollPosition:YMJNWCollectionViewScrollPositionNearest animated:YES selectionType:YMJNWCollectionViewSelectionTypeExtending];
}

- (void)moveLeft:(id)sender {
	NSIndexPath *toSelect = [self.collectionViewLayout indexPathForNextItemInDirection:YMJNWCollectionViewDirectionLeft currentIndexPath:[self indexPathForSelectedItem]];
	[self selectItemAtIndexPath:toSelect atScrollPosition:YMJNWCollectionViewScrollPositionNearest animated:YES];
}

- (void)moveLeftAndModifySelection:(id)sender {
	NSIndexPath *toSelect = [self.collectionViewLayout indexPathForNextItemInDirection:YMJNWCollectionViewDirectionLeft currentIndexPath:[self indexPathForSelectedItem]];
	[self selectItemAtIndexPath:toSelect atScrollPosition:YMJNWCollectionViewScrollPositionNearest animated:YES selectionType:YMJNWCollectionViewSelectionTypeExtending];
}

- (void)moveToBeginningOfDocument:(id)sender {
	NSIndexPath *toSelect = [self firstIndexPath];
	[self selectItemAtIndexPath:toSelect atScrollPosition:YMJNWCollectionViewScrollPositionNearest animated:YES];
}

- (void)moveToEndOfDocument:(id)sender {
	NSIndexPath *toSelect = [self lastIndexPath];
	[self selectItemAtIndexPath:toSelect atScrollPosition:YMJNWCollectionViewScrollPositionNearest animated:YES];
}

- (void)selectAll:(id)sender {
	[self selectItemsAtIndexPaths:[self allIndexPaths] animated:YES];
}

- (void)deselectAllItems {
	[self deselectItemsAtIndexPaths:[self allIndexPaths] animated:YES];
}

- (void)selectAllItems {
	[self selectAll:nil];
}

- (NSMenu *)menuForEvent:(NSEvent *)event {
	if (_collectionViewFlags.delegateMenuForEvent) {
		NSMenu *menu = [self.delegate collectionView:self menuForEvent:event];
		return menu;
	}
	return nil;
}

#pragma mark NSObject

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p; frame = %@; layer = <%@: %p>; content offset: %@> collection view layout: %@",
			self.class, self, NSStringFromRect(self.frame), self.layer.class, self.layer,
			NSStringFromPoint(self.documentVisibleRect.origin), self.collectionViewLayout];
}

#pragma mark NSResponder

// TODO: make these ask the layout for "where's the beginning/end?" in case of non-ltr layouts
- (void)scrollToBeginningOfDocument:(id)sender {
	[self.clipView scrollRectToVisible:NSMakeRect(0, 0, 0, 0) animated:self.animatesSelection];
}

- (void)scrollToEndOfDocument:(id)sender {
	NSSize documentSize = ((YMJNWCollectionViewDocumentView *)self.clipView.documentView).frame.size;
	NSRect scrollToRect = NSMakeRect(documentSize.width, documentSize.height, 0, 0);
	[self.clipView scrollRectToVisible:scrollToRect animated:self.animatesSelection];
}

@end
