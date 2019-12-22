//
//  YMBaseModel.h
//  WeChatExtension
//
//  Created by WeChatExtension on 2017/9/17.
//  Copyright © 2017年 WeChatExtension. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMBaseModel : NSObject

- (instancetype)initWithDict:(NSDictionary *)dict;
- (NSDictionary *)dictionary;

@end
