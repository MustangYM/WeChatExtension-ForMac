//
//  YMZGMPTableView.h
//  WeChatExtension
//
//  Created by MustangYM on 2020/10/26.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN


typedef enum {
    YMZGMPRefreshTableViewStateDefault = 1,    //默认
    YMZGMPRefreshTableViewStateTriggered,      //刷新状态
    YMZGMPRefreshTableViewStateLoading         //正在加载
} YMZGMPRefreshTableViewState;

@class YMZGMPTableView;
@protocol YMZGMPTableViewDelegate <NSObject>
@optional
- (void)ym_doubleClickForTableView:(YMZGMPTableView *)tableView;
- (NSMenu *)ym_menuForTableView:(YMZGMPTableView *)tableView selectRow:(NSInteger)row;

- (void)ym_loadingFooterForTableView:(YMZGMPTableView *)tableView;
- (void)ym_refreshForTableView:(YMZGMPTableView *)tableView state:(YMZGMPRefreshTableViewState)state;
- (void)ym_scrollForTableView:(YMZGMPTableView *)tableView animated:(BOOL)isAnimated endRect:(CGRect)endRect;
@end

@interface YMZGMPTableView : NSTableView
@property (nonatomic, assign) NSInteger rightMouseDownRow;
@property (nonatomic, assign) YMZGMPRefreshTableViewState state;
@property (nonatomic, assign) BOOL isLastPage;
@property (nonatomic, weak) id <YMZGMPTableViewDelegate> zgmpDelegate;
- (void)finishedLoading;
@end

NS_ASSUME_NONNULL_END
