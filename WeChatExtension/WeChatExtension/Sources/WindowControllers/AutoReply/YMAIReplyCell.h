//
//  YMAIReplyCell.h
//  WeChatExtension
//
//  Created by MustangYM on 2019/12/3.
//  Copyright © 2019 MustangYM. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN
@class YMZGMPGroupInfo;
@interface YMAIReplyCell : NSControl
@property (nonatomic, strong) YMZGMPGroupInfo *info;
@property (nonatomic, copy) NSString *wxid;
- (void)onUpdateCell;
@end

NS_ASSUME_NONNULL_END
