//
//  TKRemoteControlModel.m
//  WeChatPlugin
//
//  Created by TK on 2017/8/8.
//  Copyright © 2017年 tk. All rights reserved.
//

#import "TKRemoteControlModel.h"

@implementation TKRemoteControlModel

- (instancetype)initWithDict:(NSDictionary *)dict {
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

- (NSDictionary *)dictionary {
    return @{@"enable": @(self.enable),
             @"keyword": self.keyword,
             @"function": self.function,
             @"executeCommand": self.executeCommand,
             @"type": @(self.type)};
}

@end
