//
//  TKRemoteControlModel.h
//  WeChatPlugin
//
//  Created by TK on 2017/8/8.
//  Copyright © 2017年 tk. All rights reserved.
//

#import "TKBaseModel.h"

typedef NS_ENUM(NSUInteger, TKRemoteControlType) {
    TKRemoteControlTypeShell = 1,
    TKRemoteControlTypeScript,
    TKRemoteControlTypePlugin,
};

@interface TKRemoteControlModel : TKBaseModel

@property (nonatomic, assign) BOOL enable;
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, copy) NSString *function;
@property (nonatomic, copy) NSString *executeCommand;
@property (nonatomic, assign) TKRemoteControlType type;

@end
