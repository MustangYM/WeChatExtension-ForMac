//
//  TKAutoReplyCell.h
//  WeChatExtension
//
//  Created by WeChatExtension on 2017/8/21.
//  Copyright © 2017年 WeChatExtension. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TKAutoReplyModel.h"

@interface TKAutoReplyCell : NSControl

@property (nonatomic, strong) TKAutoReplyModel *model;
@property (nonatomic, copy) void (^updateModel)(void);

@end
