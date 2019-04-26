//
//  TKVersionManager.h
//  WeChatPlugin
//
//  Created by TK on 2018/2/24.
//  Copyright © 2018年 tk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TKVersionStatus) {
    TKVersionStatusOld,
    TKVersionStatusNew,
};

@interface TKVersionManager : NSObject

+ (instancetype)shareManager;
- (void)checkVersionFinish:(void (^)(TKVersionStatus, NSString *))finish;
- (void)downloadPluginProgress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock completionHandler:(void (^)(NSString *filePath, NSError * _Nullable error))completionHandler;
- (void)cancelDownload;

@end
