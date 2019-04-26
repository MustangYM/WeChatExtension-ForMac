//
//  TKWebServerManager.h
//  WeChatPlugin
//
//  Created by TK on 2018/3/18.
//  Copyright © 2018年 tk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKWebServerManager : NSObject

+ (instancetype)shareManager;

- (void)startServer;
- (void)endServer;

@end
