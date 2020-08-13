//
//  TKAutoReplyContentView.h
//  WeChatExtension
//
//  Created by WeChatExtension on 2019/8/20.
//  Copyright © 2019年 WeChatExtension. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "YMAutoReplyModel.h"

@interface TKAutoReplyContentView : NSView

@property (nonatomic, strong) YMAutoReplyModel *model;
@property (nonatomic, copy) void (^endEdit)(void);

@end
