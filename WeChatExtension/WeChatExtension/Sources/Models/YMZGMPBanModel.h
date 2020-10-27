//
//  YMZGMPBanModel.h
//  WeChatExtension
//
//  Created by MustangYM on 2020/10/27.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import "YMBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface YMBanModel : YMBaseModel
@property (nonatomic, copy) NSString *wxid;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *imagePath;
@end

@interface YMZGMPBanModel : YMBaseModel <NSCoding>
@property (nonatomic, strong) NSMutableArray <YMBanModel *> *bans;
@end

NS_ASSUME_NONNULL_END
