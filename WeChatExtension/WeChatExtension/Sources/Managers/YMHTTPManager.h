//
//  YMHTTPManager.h
//  WeChatExtension
//
//  Created by WeChatExtension on 2018/4/17.
//  Copyright © 2018年 WeChatExtension. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMHTTPManager : NSObject

+ (instancetype)shareManager;

- (void)downloadWithUrlString:(NSString *)urlString
               toDirectoryPah:(NSString *)directory
                     progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
            completionHandler:(nullable void (^)(NSString * filePath, NSError * _Nullable error))completionHandler;

- (void)cancelDownload;

@end
