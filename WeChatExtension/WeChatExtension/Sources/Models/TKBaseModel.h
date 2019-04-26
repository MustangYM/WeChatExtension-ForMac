//
//  TKBaseModel.h
//  WeChatPlugin
//
//  Created by TK on 2017/9/17.
//  Copyright © 2017年 tk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKBaseModel : NSObject

- (instancetype)initWithDict:(NSDictionary *)dict;
- (NSDictionary *)dictionary;

@end
