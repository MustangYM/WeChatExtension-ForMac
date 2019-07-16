//
//  YMIMContactsManager.h
//  WeChatExtension
//
//  Created by MustangYM on 2019/6/28.
//  Copyright © 2019 MustangYM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMIMContactsManager : NSObject
+ (NSString *)getGroupMemberNickName:(NSString *)username;
+ (NSString *)getWeChatNickName:(NSString *)username;
@end

