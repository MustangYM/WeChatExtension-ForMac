//
//  TKAutoReplyWindowController.h
//  WeChatExtension
//
//  Created by WeChatExtension on 2019/4/19.
//  Copyright © 2019年 WeChatExtension. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "YMAutoReplyModel.h"

@interface TKAutoReplyWindowController : NSWindowController

@property (nonatomic, copy) YMAutoReplyModel *model;

@end
