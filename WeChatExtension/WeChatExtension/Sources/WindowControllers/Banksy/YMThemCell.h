//
//  YMThemCell.h
//  WeChatGirlFriend
//
//  Created by MustangYM on 2021/7/2.
//  Copyright © 2021 YY Inc. All rights reserved.
//

#import "YMJNWCollectionViewCell.h"
#import "YMThemeConfigModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YMThemCell : YMJNWCollectionViewCell
- (void)reloadBy:(YMThemeConfigModel *)model;
@end

NS_ASSUME_NONNULL_END
