//
//  TKRemoteControlModel.h
//  WeChatExtension
//
//  Created by WeChatExtension on 2019/8/8.
//  Copyright © 2019年 WeChatExtension. All rights reserved.
//

#import "YMBaseModel.h"

typedef NS_ENUM(NSUInteger, TKRemoteControlType) {
    TKRemoteControlTypeShell = 1,
    TKRemoteControlTypeScript,
    TKRemoteControlTypePlugin,
};

@interface TKRemoteControlModel : YMBaseModel

@property (nonatomic, assign) BOOL enable;
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, copy) NSString *function;
@property (nonatomic, copy) NSString *executeCommand;
@property (nonatomic, assign) TKRemoteControlType type;

@end
