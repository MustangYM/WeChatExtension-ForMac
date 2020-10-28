
//
//  YMZGMPTableView.m
//  WeChatExtension
//
//  Created by MustangYM on 2020/10/26.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import "YMZGMPTableView.h"

@interface YMZGMPTableView ()
@property (nonatomic, assign) BOOL isScrollAnimated;
@property (nonatomic, assign) BOOL isPerformSelector;
@property (nonatomic, assign) BOOL isAddObserverNotify;
@property (nonatomic, assign) NSRect lastRect;
@property (nonatomic, assign) NSTimeInterval throttle;
@end

@implementation YMZGMPTableView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.state = YMZGMPRefreshTableViewStateDefault;
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

- (NSMenu *)menuForEvent:(NSEvent *)event
{
    if (event.type == 3) {
        self.rightMouseDownRow = [self rowWithEvent:event];
        if (self.rightMouseDownRow >= 0 && self.rightMouseDownRow < [self numberOfRows]) {
            if ([self.zgmpDelegate respondsToSelector:@selector(ym_menuForTableView:selectRow:)]) {
                return [self.zgmpDelegate ym_menuForTableView:self selectRow:self.rightMouseDownRow];
            }
        }
    }
    return nil;
}

- (void)mouseDown:(NSEvent *)event
{
    [super mouseDown:event];
    if (event.pressure == 1 && event.clickCount == 2) {
        if ([self.zgmpDelegate respondsToSelector:@selector(ym_doubleClickForTableView:)]) {
            [self.zgmpDelegate ym_doubleClickForTableView:self];
        }
    }
}

- (NSInteger)rowWithEvent:(NSEvent *)event
{
    NSPoint point = [event locationInWindow];
    NSPoint tablePoint = [self convertPoint:point toView:self.window.contentView];
    return [self rowAtPoint:tablePoint];
}

#pragma mark - Refresh & State
- (void)prepareForNewDisplay:(NSNotification *)notificaition
{
    //取消正在执行的selector
    if(self.isPerformSelector) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopScrollAnimated) object:nil];
        self.isPerformSelector = NO;
    }
    
    if(!self.isScrollAnimated) {
        self.isScrollAnimated = YES;
        if ([self.zgmpDelegate respondsToSelector:@selector(ym_scrollForTableView:animated:endRect:)]) {
            [self.zgmpDelegate ym_scrollForTableView:self animated:self.isScrollAnimated endRect:NSZeroRect];
        }
    }
    
    NSClipView *clipView = [notificaition object];
    
    // 如果第一次进来数据很少也会触发
    if (clipView.documentRect.size.height <= clipView.documentVisibleRect.size.height) {
        return;
    }
    
    float originSizeAndOffSize = clipView.documentVisibleRect.origin.y + clipView.documentVisibleRect.size.height;
    if  (originSizeAndOffSize >= clipView.documentRect.size.height ) {
        if (self.state == YMZGMPRefreshTableViewStateDefault) {
            self.state = YMZGMPRefreshTableViewStateTriggered;
            [self doFooterLoading:[[NSDate date] timeIntervalSince1970]];
        } else if(self.state == YMZGMPRefreshTableViewStateTriggered ) {
            if (self.state != YMZGMPRefreshTableViewStateLoading) {
                self.state = YMZGMPRefreshTableViewStateLoading;
                [self doFooterLoading:[[NSDate date] timeIntervalSince1970]];
            }
        }
        
    } else if (originSizeAndOffSize < clipView.documentRect.size.height && self.state != YMZGMPRefreshTableViewStateDefault && self.state == YMZGMPRefreshTableViewStateLoading){
        self.state = YMZGMPRefreshTableViewStateDefault;
    }
    
    if(!self.isPerformSelector) {
        self.lastRect = clipView.documentVisibleRect;
        /** 0.5s 后执行滑动停止*/
        [self performSelector:@selector(stopScrollAnimated) withObject:nil afterDelay:0.5f];
        self.isPerformSelector = YES;
    }
    
}
 
- (void)doFooterLoading:(NSTimeInterval)timestamp
{
    if (self.isLastPage) {
        return;
    }
    
    if ([self.zgmpDelegate respondsToSelector:@selector(ym_loadingFooterForTableView:)]) {
        [self.zgmpDelegate ym_loadingFooterForTableView:self];
    }
}

- (void)finishedLoading
{
    [self setState:YMZGMPRefreshTableViewStateDefault];
}
 
- (void)stopScrollAnimated
{
    self.isPerformSelector = self.isScrollAnimated = NO;
    if ([self.zgmpDelegate respondsToSelector:@selector(ym_scrollForTableView:animated:endRect:)]) {
        [self.zgmpDelegate ym_scrollForTableView:self animated:self.isScrollAnimated endRect:self.lastRect];
    }
}

@end
