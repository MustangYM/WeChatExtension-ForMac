//
//  YMTableViewProtocol.h
//  WeChatExtension
//
//  Created by MustangYM on 2020/10/30.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#ifndef YMTableViewProtocol_h
#define YMTableViewProtocol_h

typedef enum {
    YMRefreshTableViewStateDefault = 1,    //默认
    YMRefreshTableViewStateTriggered,      //刷新状态
    YMRefreshTableViewStateLoading         //正在加载
} YMRefreshTableViewState;

@class YMTableView;
@protocol YMTableViewDelegate <NSObject>
@optional
- (void)ym_doubleClickForTableView:(YMTableView *)tableView;
- (NSMenu *)ym_menuForTableView:(YMTableView *)tableView selectRow:(NSInteger)row;

- (void)ym_loadingFooterForTableView:(YMTableView *)tableView;
- (void)ym_refreshForTableView:(YMTableView *)tableView state:(YMRefreshTableViewState)state;
- (void)ym_scrollForTableView:(YMTableView *)tableView animated:(BOOL)isAnimated endRect:(CGRect)endRect;
@end

#endif /* YMTableViewProtocol_h */
