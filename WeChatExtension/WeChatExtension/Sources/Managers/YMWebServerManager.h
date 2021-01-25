//
//  YMWebServerManager.h
//  WeChatExtension
//
//  Created by WeChatExtension on 2018/3/18.
//  Copyright © 2018年 WeChatExtension. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMWebServerManager : NSObject

+ (instancetype)shareManager;

- (void)startServer;
- (void)endServer;

@end
