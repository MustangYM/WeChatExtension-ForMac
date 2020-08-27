//
//  YMThemeManager.h
//  WeChatExtension
//
//  Created by MustangYM on 2019/6/11.
//  Copyright © 2019 MustangYM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMThemeManager : NSObject
@property (nonatomic, assign, readonly) BOOL isTempDark;
@property (nonatomic, assign, readonly) BOOL isTempPink;
@property (nonatomic, strong) MMChatsTableCellView *currentChatCellView;
@property (nonatomic, strong) MMChatsTableCellView *preChatCellView;
@property (nonatomic, copy) NSString *currentSessionName;
+ (instancetype)shareInstance;
+ (void)changeButtonTheme:(NSButton *)button;
+ (void)changeEffectViewMode:(NSVisualEffectView *)effectView;
+ (NSVisualEffectView *)creatFuzzyEffectView:(id)superView;
- (void)initializeModelConfig;
- (void)changeTheme:(NSView *)view;
- (void)changeTheme:(NSView *)view color:(NSColor *)color;
- (NSColor *)randomColor:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
