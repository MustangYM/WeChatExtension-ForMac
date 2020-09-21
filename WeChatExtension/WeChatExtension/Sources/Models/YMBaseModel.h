//
//  YMBaseModel.h
//  WeChatExtension
//
//  Created by WeChatExtension on 2019/9/17.
//  Copyright © 2019年 WeChatExtension. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMBaseModel : NSObject

- (instancetype)initWithDict:(NSDictionary *)dict;
- (NSDictionary *)dictionary;

@end
