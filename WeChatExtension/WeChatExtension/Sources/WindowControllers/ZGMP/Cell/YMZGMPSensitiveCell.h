//
//  YMZGMPSensitiveCell.h
//  WeChatExtension
//
//  Created by MustangYM on 2021/1/14.
//  Copyright © 2021 MustangYM. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN
@interface YMZGMPSensitiveCell : NSControl
@property (nonatomic, strong) MessageData *msgData;
@property (nonatomic, strong) NSImage *avatar;
@end

NS_ASSUME_NONNULL_END
