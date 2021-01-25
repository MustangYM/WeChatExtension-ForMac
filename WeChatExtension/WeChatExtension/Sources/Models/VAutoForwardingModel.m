//
//  Test.m
//  WeChatExtension
//
//  Created by Wetoria V on 2020/7/8.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import "VAutoForwardingModel.h"

@implementation VAutoForwardingModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.enable = [dict[@"enable"] boolValue];
    }
    return self;
}

- (NSDictionary *)dictionary
{
    return @{@"enable": @(self.enable)
             };
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([VAutoForwardingModel class], &count);
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
        Ivar *ivars = class_copyIvarList([VAutoForwardingModel class], &count);
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

- (NSMutableArray *)forwardingFromContacts
{
    if (!_forwardingFromContacts) {
        _forwardingFromContacts = [NSMutableArray array];
    }
    return _forwardingFromContacts;
}

- (NSMutableArray *)forwardingToContacts
{
    if (!_forwardingToContacts) {
        _forwardingToContacts = [NSMutableArray array];
    }
    return _forwardingToContacts;
}

@end
