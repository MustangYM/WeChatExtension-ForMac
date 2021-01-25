//
//  YMZGMPInfoHelper.h
//  WeChatExtension
//
//  Created by MustangYM on 2020/10/22.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMZGMPGroupInfo : NSObject
@property (nonatomic, copy) NSString *wxid;
@property (nonatomic, assign) BOOL isIgnore;
@property (nonatomic, copy) NSString *nick;
@end

@interface YMZGMPInfo : NSObject
@property (nonatomic, assign) int timestamp;
@property (nonatomic, assign) int sensitive;
@property (nonatomic, assign) int pdd;
@property (nonatomic, assign) NSInteger totalMsgs;
@property (nonatomic, strong) WCContactData *contact;
@end

@interface YMZGMPInfoHelper : NSObject

@end

NS_ASSUME_NONNULL_END
