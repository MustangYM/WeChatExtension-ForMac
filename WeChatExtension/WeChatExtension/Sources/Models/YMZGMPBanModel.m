//
//  YMZGMPBanModel.m
//  WeChatExtension
//
//  Created by MustangYM on 2020/10/27.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import "YMZGMPBanModel.h"
#import "NSDictionary+Safe.h"

@implementation YMZGMPBanModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.wxid = [dict stringForKey:@"wxid"];
        self.nick = [dict stringForKey:@"nick"];
    }
    return self;
}

- (NSDictionary *)dictionary
{
    return @{
        @"wxid" : self.wxid?:@"",
        @"nick" : self.nick?:@""
    };
}

- (BOOL)hasEmptyKeywordOrReplyContent
{
    return (self.wxid == nil || self.nick == nil || [self.wxid isEqualToString:@""] || [self.nick isEqualToString:@""]);
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([YMZGMPBanModel class], &count);
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
        Ivar *ivars = class_copyIvarList([YMZGMPBanModel class], &count);
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

@end
