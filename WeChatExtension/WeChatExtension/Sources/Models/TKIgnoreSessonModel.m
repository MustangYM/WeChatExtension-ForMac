//
//  TKIgnoreSessonModel.m
//  WeChatPlugin
//
//  Created by TK on 2017/9/15.
//  Copyright © 2017年 tk. All rights reserved.
//

#import "TKIgnoreSessonModel.h"

@implementation TKIgnoreSessonModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.selfContact = dict[@"selfContact"];
        self.userName = dict[@"userName"];
        self.ignore = [dict[@"ignore"] boolValue];
    }
    return self;
}

- (NSDictionary *)dictionary {
    return @{@"selfContact": self.selfContact,
             @"userName": self.userName,
             @"ignore": @(self.ignore)};
}

@end
