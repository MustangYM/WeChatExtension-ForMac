//
//  TKAutoReplyModel.m
//  WeChatPlugin
//
//  Created by TK on 2017/8/18.
//  Copyright © 2017年 tk. All rights reserved.
//

#import "TKAutoReplyModel.h"

@implementation TKAutoReplyModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.enable = [dict[@"enable"] boolValue];
        self.keyword = dict[@"keyword"];
        self.replyContent = dict[@"replyContent"];
        self.enableGroupReply = [dict[@"enableGroupReply"] boolValue];
        self.enableSingleReply = [dict[@"enableSingleReply"] boolValue];
        self.enableRegex = [dict[@"enableRegex"] boolValue];
        self.enableDelay = [dict[@"enableDelay"] boolValue];
        self.delayTime = [dict[@"delayTime"] floatValue];
        self.enableSpecificReply = [dict[@"enableSpecificReply"] boolValue];
        self.specificContacts = dict[@"specificContacts"] ? : [NSArray array];
    }
    return self;
}

- (NSDictionary *)dictionary {
    return @{@"enable": @(self.enable),
             @"keyword": self.keyword,
             @"replyContent": self.replyContent,
             @"enableGroupReply": @(self.enableGroupReply),
             @"enableSingleReply": @(self.enableSingleReply),
             @"enableRegex": @(self.enableRegex),
             @"enableDelay": @(self.enableDelay),
             @"delayTime": @(self.delayTime),
             @"enableSpecificReply": @(self.enableSpecificReply),
             @"specificContacts": self.specificContacts
             };
}

- (BOOL)hasEmptyKeywordOrReplyContent {
    return (self.keyword == nil || self.replyContent == nil || [self.keyword isEqualToString:@""] || [self.replyContent isEqualToString:@""]);
}

- (NSArray *)specificContacts {
    if (!_specificContacts) {
        _specificContacts = [NSArray array];
    }
    return _specificContacts;
}
@end
