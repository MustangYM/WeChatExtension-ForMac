//
//  YMZGMPInfoHelper.h
//  WeChatExtension
//
//  Created by MustangYM on 2020/10/22.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMZGMPInfo : NSObject
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *wxid;
@property (nonatomic, assign) BOOL male;
@property (nonatomic, assign) int timestamp;
@end

@interface YMZGMPInfoHelper : NSObject
+ (void)saveChatroomMember:(NSString *)chatroom member:(YMZGMPInfo *)model;
@end

NS_ASSUME_NONNULL_END
