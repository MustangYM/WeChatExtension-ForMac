//
//  TKHTTPManager.h
//  WeChatPlugin
//
//  Created by TK on 2018/4/17.
//  Copyright © 2018年 tk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKHTTPManager : NSObject

+ (instancetype)shareManager;

- (void)downloadWithUrlString:(NSString *)urlString
               toDirectoryPah:(NSString *)directory
                     progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
            completionHandler:(nullable void (^)(NSString * filePath, NSError * _Nullable error))completionHandler;

- (void)cancelDownload;

@end
