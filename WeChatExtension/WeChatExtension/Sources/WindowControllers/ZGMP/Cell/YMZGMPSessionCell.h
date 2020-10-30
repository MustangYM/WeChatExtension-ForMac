//
//  YMZGMPSessionCell.h
//  WeChatExtension
//
//  Created by MustangYM on 2020/10/22.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN
@class YMZGMPInfo;
@interface YMZGMPSessionCell : NSControl
@property (nonatomic, strong) YMZGMPInfo *memberInfo;
@end

NS_ASSUME_NONNULL_END
