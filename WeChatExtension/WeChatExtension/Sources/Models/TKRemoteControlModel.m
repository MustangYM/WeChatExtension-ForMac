//
//  TKRemoteControlModel.m
//  WeChatExtension
//
//  Created by WeChatExtension on 2019/8/8.
//  Copyright © 2019年 WeChatExtension. All rights reserved.
//

#import "TKRemoteControlModel.h"

@implementation TKRemoteControlModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.enable = [dict[@"enable"] boolValue];
        self.keyword = dict[@"keyword"];
        self.function = dict[@"function"];
        self.executeCommand = dict[@"executeCommand"];
        self.type = [dict[@"type"] integerValue];
    }
    return self;
}

- (NSDictionary *)dictionary
{
    return @{@"enable": @(self.enable),
             @"keyword": self.keyword,
             @"function": self.function,
             @"executeCommand": self.executeCommand,
             @"type": @(self.type)};
}

@end
