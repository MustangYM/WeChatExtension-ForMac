//
//  YMBaseModel.m
//  WeChatExtension
//
//  Created by WeChatExtension on 2019/9/17.
//  Copyright © 2019年 WeChatExtension. All rights reserved.
//

#import "YMBaseModel.h"

@implementation YMBaseModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    NSAssert(NO, @"the mothed initWithDict: must be override by subclass");
    return nil;
}

- (NSDictionary *)dictionary
{
    NSAssert(NO, @"the mothed dictionary must be override by subclass");
    return nil;
}
@end
