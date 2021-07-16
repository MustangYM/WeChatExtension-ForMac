//
//  YMThemeConfigModel.h
//  WeChatExtension
//
//  Created by MustangYM on 2021/7/2.
//  Copyright © 2021 MustangYM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMThemeConfigModel : NSObject
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) BOOL isSelected;
+ (YMThemeConfigModel *)modelWith:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
