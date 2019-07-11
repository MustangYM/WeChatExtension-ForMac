//
//  YMIMContactsManager.m
//  WeChatExtension
//
//  Created by MustangYM on 2019/6/28.
//  Copyright © 2019 MustangYM. All rights reserved.
//

#import "YMIMContactsManager.h"

@implementation YMIMContactsManager
+ (NSString *)getGroupMemberNickName:(NSString *)username {
    if (!username) {
        return nil;
    }
    ContactStorage *contactStorage = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("ContactStorage")];
    WCContactData *data = [contactStorage getContactCache:username];
    
    return data.m_nsNickName;
}

+ (NSString *)getWeChatNickName:(NSString *)username {
    NSArray *arr = [self getAllFriendContacts];
    __block NSString *temp = nil;
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WCContactData *contactData = (WCContactData *)obj;
        if ([contactData.m_nsUsrName isEqualToString:username]) {
            temp = contactData.m_nsNickName;
        }
    }];
    
    return temp;
}

+ (NSArray <WCContactData *> *)getAllFriendContacts {
    ContactStorage *contactStorage = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("ContactStorage")];
    return [contactStorage GetAllFriendContacts];
}
@end
