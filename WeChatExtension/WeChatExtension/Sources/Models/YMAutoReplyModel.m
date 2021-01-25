//
//  YMAutoReplyModel.m
//  WeChatExtension
//
//  Created by WeChatExtension on 2019/8/18.
//  Copyright © 2019年 WeChatExtension. All rights reserved.
//

#import "YMAutoReplyModel.h"

@implementation YMAutoReplyModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
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

- (NSDictionary *)dictionary
{
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

- (BOOL)hasEmptyKeywordOrReplyContent
{
    return (self.keyword == nil || self.replyContent == nil || [self.keyword isEqualToString:@""] || [self.replyContent isEqualToString:@""]);
}

- (NSArray *)specificContacts
{
    if (!_specificContacts) {
        _specificContacts = [NSArray array];
    }
    return _specificContacts;
}

@end

@implementation YMAIAutoModel
- (void)encodeWithCoder:(NSCoder *)coder
{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([YMAIAutoModel class], &count);
    for (int i = 0; i<count; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:name];
        [coder encodeObject:[self valueForKey:key] forKey:key];
    }
    free(ivars);
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([YMAIAutoModel class], &count);
        for (int i = 0; i<count; i++) {
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [coder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(ivars);
    }
    return self;
}

- (NSMutableArray *)specificContacts
{
    if (!_specificContacts) {
        _specificContacts = [NSMutableArray array];
    }
    return _specificContacts;
}
@end
