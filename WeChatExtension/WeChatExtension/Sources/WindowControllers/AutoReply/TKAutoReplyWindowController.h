//
//  TKAutoReplyWindowController.h
//  WeChatExtension
//
//  Created by WeChatExtension on 2017/4/19.
//  Copyright © 2017年 WeChatExtension. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "YMAutoReplyModel.h"

@interface TKAutoReplyWindowController : NSWindowController

@property (nonatomic, copy) YMAutoReplyModel *model;

@end
