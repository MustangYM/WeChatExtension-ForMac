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

#import "YMJNWCollectionViewLayout.h"
#import "YMJNWCollectionView+Private.h"
#import "YMJNWCollectionViewLayout+Private.h"

@implementation YMJNWCollectionViewLayoutAttributes

@end

@implementation YMJNWCollectionViewLayout

- (void)invalidateLayout {
	// Forward this onto the collection view itself.
	[self.collectionView collectionViewLayoutWasInvalidated:self];
}

- (void)prepareLayout {
	// For subclasses
}

- (instancetype)initWithCollectionView:(YMJNWCollectionView *)collectionView {
	return [super init];
}

- (YMJNWCollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (YMJNWCollectionViewLayoutAttributes *)layoutAttributesForSupplementaryItemInSection:(NSInteger)section kind:(NSString *)kind {
	return nil;
}

- (NSArray *)indexPathsForItemsInRect:(CGRect)rect {
	return nil;
}

- (CGRect)rectForSectionAtIndex:(NSInteger)index {
	return CGRectNull;
}

- (CGSize)contentSize {
	return CGSizeZero;
}

- (YMJNWCollectionViewScrollDirection)scrollDirection {
	return YMJNWCollectionViewScrollDirectionVertical;
}

- (NSIndexPath *)indexPathForNextItemInDirection:(YMJNWCollectionViewDirection)direction currentIndexPath:(NSIndexPath *)currentIndexPath {
	return currentIndexPath;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
	return YES;
}

- (BOOL)shouldApplyExistingLayoutAttributesOnLayout {
	return YES;
}

@end
