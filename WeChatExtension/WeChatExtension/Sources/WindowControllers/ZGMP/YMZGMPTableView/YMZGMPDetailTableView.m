//
//  YMZGMPDetailTableView.m
//  WeChatExtension
//
//  Created by MustangYM on 2020/10/30.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import "YMZGMPDetailTableView.h"

@interface YMZGMPDetailTableView ();
@property (nonatomic, assign) BOOL isAddObserverNotify;
@property (nonatomic, assign) BOOL isPerformSelector;
@property (nonatomic, assign) BOOL isLastPage;
@property (nonatomic, assign) BOOL isScrollAnimated;
@property (nonatomic, assign) NSRect lastRect;
@property (nonatomic, assign) YMRefreshTableViewState state;
@end

@implementation YMZGMPDetailTableView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.state = YMRefreshTableViewStateDefault;
        if(!self.isAddObserverNotify) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareForNewDisplay:) name:NSViewBoundsDidChangeNotification object:[[self enclosingScrollView] contentView]];
            self.isAddObserverNotify = YES;
        }
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSViewBoundsDidChangeNotification object:nil];
}

- (void)prepareForNewDisplay:(NSNotification *)notificaition
{
    NSClipView *view = (NSClipView *)notificaition.object;
    if (![view.documentView isKindOfClass:NSClassFromString(@"YMZGMPDetailTableView")]) {
        return;
    }
    //取消正在执行的selector
    if(self.isPerformSelector) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopScrollAnimated) object:nil];
        self.isPerformSelector = NO;
    }
    
    if(!self.isScrollAnimated) {
        self.isScrollAnimated = YES;
        if ([self.ym_delegate respondsToSelector:@selector(ym_scrollForTableView:animated:endRect:)]) {
            [self.ym_delegate ym_scrollForTableView:self animated:self.isScrollAnimated endRect:NSZeroRect];
        }
    }
    
    NSClipView *clipView = [notificaition object];
    
    // 如果第一次进来数据很少也会触发
    if (clipView.documentRect.size.height <= clipView.documentVisibleRect.size.height) {
        return;
    }
    
    float originSizeAndOffSize = clipView.documentVisibleRect.origin.y + clipView.documentVisibleRect.size.height;
    if  (originSizeAndOffSize >= clipView.documentRect.size.height ) {
        if (self.state == YMRefreshTableViewStateDefault) {
            self.state = YMRefreshTableViewStateTriggered;
            CGFloat old;
            CGFloat new = clipView.documentVisibleRect.origin.y;
            if (old == new) return;
            [self doFooterLoading];
             old = clipView.documentVisibleRect.origin.y;
        } else if(self.state == YMRefreshTableViewStateTriggered ) {
            if (self.state != YMRefreshTableViewStateLoading) {
                self.state = YMRefreshTableViewStateLoading;
            }
        }
        
    } else if (originSizeAndOffSize < clipView.documentRect.size.height && self.state != YMRefreshTableViewStateDefault && self.state == YMRefreshTableViewStateLoading){
        self.state = YMRefreshTableViewStateDefault;
    }
    
    if(!self.isPerformSelector) {
        self.lastRect = clipView.documentVisibleRect;
        /** 0.5s 后执行滑动停止*/
        [self performSelector:@selector(stopScrollAnimated) withObject:nil afterDelay:0.5f];
        self.isPerformSelector = YES;
    }
    
}

- (void)doFooterLoading
{
    if (self.isLastPage) {
        return;
    }
    if ([self.ym_delegate respondsToSelector:@selector(ym_loadingFooterForTableView:)]) {
        [self.ym_delegate ym_loadingFooterForTableView:self];
    }
}

- (void)stopScrollAnimated
{
    self.isPerformSelector = self.isScrollAnimated == NO;
    if ([self.ym_delegate respondsToSelector:@selector(ym_scrollForTableView:animated:endRect:)]) {
        [self.ym_delegate ym_scrollForTableView:self animated:self.isScrollAnimated endRect:self.lastRect];
    }
}

- (void)finishedLoading
{
    [self setState:YMRefreshTableViewStateDefault];
}

@end
