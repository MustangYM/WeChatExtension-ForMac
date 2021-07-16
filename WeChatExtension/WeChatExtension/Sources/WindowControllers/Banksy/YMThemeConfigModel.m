//
//  YMThemeConfigModel.m
//  WeChatExtension
//
//  Created by MustangYM on 2021/7/2.
//  Copyright © 2021 MustangYM. All rights reserved.
//

#import "YMThemeConfigModel.h"
#import "NSDictionary+Safe.h"

@implementation YMThemeConfigModel
+ (YMThemeConfigModel *)modelWith:(NSDictionary *)dic
{
    YMThemeConfigModel *model = [YMThemeConfigModel new];
    model.url = [dic stringForKey:@"pic"];
    model.desc = [dic stringForKey:@"desc"];
    return model;
}
@end
