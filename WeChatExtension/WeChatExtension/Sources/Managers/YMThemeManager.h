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
@property (nonatomic, assign) int loadCount;
+ (instancetype)shareInstance;
+ (void)changeButtonTheme:(NSButton *)button;
+ (void)changeEffectViewMode:(NSVisualEffectView *)effectView;
+ (NSVisualEffectView *)creatFuzzyEffectView;
- (void)initializeModelConfig;
- (void)changeTheme:(NSView *)view;
- (void)changeTheme:(NSView *)view color:(NSColor *)color;
- (NSColor *)randomColor:(NSString *)string;
- (void)chatsCellViewAnimation:(MMChatsTableCellView *)cell isSelected:(BOOL)isSelected;
@end

NS_ASSUME_NONNULL_END
