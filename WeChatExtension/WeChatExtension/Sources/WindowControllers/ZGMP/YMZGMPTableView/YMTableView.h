//
//  YMTableView.h
//  WeChatExtension
//
//  Created by MustangYM on 2020/10/30.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "YMTableViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface YMTableView : NSTableView
@property (nonatomic, weak) id <YMTableViewDelegate> ym_delegate;
@end

NS_ASSUME_NONNULL_END
