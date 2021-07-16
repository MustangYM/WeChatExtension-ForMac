//
//  YMJNWScrollView.h
//  YMJNWCollectionView
//
//  Created by MustangYM on 2021/7/2.
//  Copyright © 2021 AppJon. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "YMJNWClipView.h"

// A NSScrollView subclass which uses an instance of YMJNWClipView
// as the clip view instead of NSClipView.
//
// Layer-backed by default.
@interface YMJNWScrollView : NSScrollView

// Returns the scroll view's content view that is an instance of BTRClipView, or
// nil if it does not exist.
- (YMJNWClipView *)clipView;

@end
