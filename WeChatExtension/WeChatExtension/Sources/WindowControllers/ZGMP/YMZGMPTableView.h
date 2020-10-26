//
//  YMZGMPTableView.h
//  WeChatExtension
//
//  Created by MustangYM on 2020/10/26.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN
@class YMZGMPTableView;
@protocol YMZGMPTableViewDelegate <NSObject>
@optional
- (NSMenu *)ym_menuForTableView:(YMZGMPTableView *)tableView selectRow:(NSInteger)row;
@end

@interface YMZGMPTableView : NSTableView
@property (nonatomic, assign) NSInteger rightMouseDownRow;
@property (nonatomic, weak) id <YMZGMPTableViewDelegate> zgmpDelegate;
@end

NS_ASSUME_NONNULL_END
