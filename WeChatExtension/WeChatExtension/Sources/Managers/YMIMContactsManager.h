//
//  YMIMContactsManager.h
//  WeChatExtension
//
//  Created by MustangYM on 2019/6/28.
//  Copyright © 2019 MustangYM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMBaseModel.h"

@interface YMMonitorChildInfo : YMBaseModel
@property (nonatomic, assign) NSTimeInterval quitTimestamp;
@property (nonatomic, copy) NSString *usrName;
@property (nonatomic, copy) NSString *group;
@end

@interface YMIMContactsManager : NSObject
+ (instancetype)shareInstance;
- (void)monitorQuitGroup:(WCContactData *)groupData;

+ (NSString *)getGroupMemberNickNameFromCache:(NSString *)username;
+ (NSString *)getGroupMemberNickName:(NSString *)username;
+ (NSString *)getWeChatNickName:(NSString *)username;
+ (NSString *)getWeChatAvatar:(NSString *)userName;
+ (MMSessionInfo *)getSessionInfo:(NSString *)userName;
@end

