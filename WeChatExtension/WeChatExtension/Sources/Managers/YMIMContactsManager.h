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
@property (nonatomic, copy) void(^onVerifyMsgBlock) (NSString *userName);
+ (instancetype)shareInstance;
- (void)monitorQuitGroup:(WCContactData *)groupData;
- (void)checkStranger:(NSDictionary *)verifyDict chatroom:(NSString *)chatroom;

+ (NSString *)getGroupMemberNickNameFromCache:(NSString *)username;
+ (NSString *)getGroupMemberNickName:(NSString *)username;
+ (NSString *)getWeChatNickName:(NSString *)username;
+ (NSString *)getWeChatAvatar:(NSString *)userName;
+ (WCContactData *)getMemberInfo:(NSString *)userName;
+ (MMSessionInfo *)getSessionInfo:(NSString *)userName;
+ (NSArray<NSString *> *)getAllChatroomFromSessionList;
+ (NSArray<WCContactData *> *)getAllFriendContacts;
+ (NSArray<WCContactData *> *)getAllFriendContactsWithOutChatroom;
@end

