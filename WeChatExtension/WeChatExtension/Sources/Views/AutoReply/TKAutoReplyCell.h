//
//  TKAutoReplyCell.h
//  WeChatExtension
//
//  Created by WeChatExtension on 2017/8/21.
//  Copyright © 2017年 WeChatExtension. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "YMAutoReplyModel.h"

@interface TKAutoReplyCell : NSControl

@property (nonatomic, strong) YMAutoReplyModel *model;
@property (nonatomic, copy) void (^updateModel)(void);

@end
