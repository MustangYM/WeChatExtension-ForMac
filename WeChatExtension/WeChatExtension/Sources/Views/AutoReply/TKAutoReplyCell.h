//
//  TKAutoReplyCell.h
//  WeChatPlugin
//
//  Created by TK on 2017/8/21.
//  Copyright © 2017年 tk. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TKAutoReplyModel.h"

@interface TKAutoReplyCell : NSControl

@property (nonatomic, strong) TKAutoReplyModel *model;
@property (nonatomic, copy) void (^updateModel)(void);

@end
