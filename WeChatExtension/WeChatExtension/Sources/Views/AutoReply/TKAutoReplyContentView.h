//
//  TKAutoReplyContentView.h
//  WeChatPlugin
//
//  Created by TK on 2017/8/20.
//  Copyright © 2017年 tk. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TKAutoReplyModel.h"

@interface TKAutoReplyContentView : NSView

@property (nonatomic, strong) TKAutoReplyModel *model;
@property (nonatomic, copy) void (^endEdit)(void);

@end
