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

#import "YMJNWCollectionViewData.h"
#import "YMJNWCollectionView+Private.h"
#import "YMJNWCollectionViewFramework.h"
#import "YMJNWCollectionViewLayout.h"

@interface YMJNWCollectionViewData()
@property (nonatomic, weak) YMJNWCollectionView *collectionView;
@property (nonatomic, assign, readwrite) NSInteger numberOfSections;
@property (nonatomic, assign, readwrite) CGSize encompassingSize;
@end

@implementation YMJNWCollectionViewData {
	YMJNWCollectionViewSection *_sectionData;
}

- (YMJNWCollectionViewSection *)sections {
	return _sectionData;
}

- (instancetype)initWithCollectionView:(YMJNWCollectionView *)collectionView {
	self = [super init];
	if (self == nil) return nil;
	self.collectionView = collectionView;
	return self;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
	if (self.numberOfSections < section)
		return 0;
	
	return self.sections[section].numberOfItems;
}

- (void)recalculateAndPrepareLayout:(BOOL)prepareLayout {
	YMJNWCollectionViewLayout *layout = self.collectionView.collectionViewLayout;
	
	if (layout == nil) {
		return;
	}
	
	if (prepareLayout) {
		if (_sectionData != nil) {
			free(_sectionData);
		}
		
		// Find how many sections we have in the collection view.
		// We default to 1 if the data source doesn't implement the optional method.
		self.numberOfSections = 1;
		if ([self.collectionView.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
			self.numberOfSections = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
		}
		
		_sectionData = calloc(self.numberOfSections, sizeof(YMJNWCollectionViewSection));
		
		// Run through with empty sections and fill in the number of items in each, so that
		// the layouts can query the collection view and get correct values for the number of items
		// in each section.
		for (NSInteger sectionIdx = 0; sectionIdx < self.numberOfSections; sectionIdx++) {
			YMJNWCollectionViewSection section;
			section.index = sectionIdx;
			section.numberOfItems = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:sectionIdx];
			
			self.sections[sectionIdx] = section;
		}
		
		// Recalculate the layout.
		[layout prepareLayout];
	}
	
	for (NSInteger sectionIdx = 0; sectionIdx < self.numberOfSections; sectionIdx++) {
		YMJNWCollectionViewSection section = self.sections[sectionIdx];
		
		// We're running through all of the items just to find the total size of each section.
		// Although this might seem like a waste, remember that this is only performed each time the
		// collection view is reloaded. The benefits of knowing what area the section encompasses
		// far outweight the cost of effectively running a double-iteration over the data.
		// Additionally, the total size of all of the sections is needed so that we can figure out
		// how large the document view of the collection view needs to be.
		//
		// However, this wastage can be avoided if the collection view layout returns something other
		// than CGRectNull in -rectForSectionAtIndex:, which allows us to bypass this entire section iteration
		// and increase the speed of the layout reloading.
		CGRect potentialSectionFrame = [layout rectForSectionAtIndex:sectionIdx];
		if (!CGRectIsNull(potentialSectionFrame)) {
			self.sections[sectionIdx].frame = potentialSectionFrame;
			continue;
		}
		
		CGRect sectionFrame = CGRectNull;
		for (NSInteger itemIdx = 0; itemIdx < section.numberOfItems; itemIdx++) {
			NSIndexPath *indexPath = [NSIndexPath YMJNW_indexPathForItem:itemIdx inSection:sectionIdx];
			YMJNWCollectionViewLayoutAttributes *attributes = [layout layoutAttributesForItemAtIndexPath:indexPath];
			
			sectionFrame = CGRectUnion(sectionFrame, attributes.frame);
		}
		
		for (NSString *identifier in [self.collectionView allSupplementaryViewIdentifiers]) {
			NSString *kind = [self.collectionView kindForSupplementaryViewIdentifier:identifier];
			YMJNWCollectionViewLayoutAttributes *attributes = [layout layoutAttributesForSupplementaryItemInSection:sectionIdx kind:kind];
			sectionFrame = CGRectUnion(sectionFrame, attributes.frame);
		}
		
		self.sections[sectionIdx].frame = sectionFrame;
	}
	
	self.encompassingSize = [self encompassingSizeWithLayout:layout];
}

- (CGSize)encompassingSizeWithLayout:(YMJNWCollectionViewLayout *)layout {
	CGSize encompassingSize = CGSizeZero;
	
	if (CGSizeEqualToSize(CGSizeZero, layout.contentSize)) {
		CGRect frame = CGRectNull;

		for (int i = 0; i < self.numberOfSections; i++) {
			frame = CGRectUnion(frame, self.sections[i].frame);
		}
		
		encompassingSize = frame.size;
	} else {
		encompassingSize = layout.contentSize;
	}
	
	// As documented, we stretch the size to be at least the size of the collection view's frame size.
	CGSize collectionViewSize = self.collectionView.visibleSize;
	encompassingSize.height = MAX(encompassingSize.height, collectionViewSize.height);
	encompassingSize.width = MAX(encompassingSize.width, collectionViewSize.width);
	
	return encompassingSize;
}

@end
