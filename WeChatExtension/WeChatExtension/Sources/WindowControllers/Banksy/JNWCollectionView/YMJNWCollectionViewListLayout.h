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

/// The supplementary view kind identifiers used for the header and the footer.
extern NSString * const YMJNWCollectionViewListLayoutHeaderKind;
extern NSString * const YMJNWCollectionViewListLayoutFooterKind;

/// The delegate is responsible for returning size information for the list layout.
@protocol YMJNWCollectionViewListLayoutDelegate <NSObject>

@optional

/// Asks the delegate for the size of the row at the specified index path.
///
/// Note that if all rows are the same height, this method should not be implemented.
/// Instead, `rowHeight` should be set manually for performance improvements.
- (CGFloat)collectionView:(YMJNWCollectionView *)collectionView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

/// Asks the delegate for the height of the header or footer in the specified section.
///
/// The default height for both the header and footer is 0.
- (CGFloat)collectionView:(YMJNWCollectionView *)collectionView heightForHeaderInSection:(NSInteger)index;
- (CGFloat)collectionView:(YMJNWCollectionView *)collectionView heightForFooterInSection:(NSInteger)index;

@end

/// A layout subclass that displays items in a vertical list with rows of
/// items, similar to a table view.
@interface YMJNWCollectionViewListLayout : YMJNWCollectionViewLayout

/// The delegate for the list layout. The delegate, if needed, should be set before
/// the collection view is reloaded.
@property (nonatomic, unsafe_unretained) id<YMJNWCollectionViewListLayoutDelegate> delegate;

/// The height of all rows in the list. If the row heights for all items are
/// the same, setting this property directly instead of using the delegate method will
/// yield performance gains.
///
/// However, if the delegate method -collectionView:heightForRowAtIndexPath: is
/// implemented, it will take precedence over any value set here.
@property (nonatomic, assign) CGFloat rowHeight;

/// The spacing between any adjacent cells.
///
/// Defaults to 0.
@property (nonatomic, assign) CGFloat verticalSpacing;

/// If enabled, the headers will stick to the top of the visible area while
/// the section is still visible.
///
/// Defaults to NO.
@property (nonatomic, assign) BOOL stickyHeaders;

@end
