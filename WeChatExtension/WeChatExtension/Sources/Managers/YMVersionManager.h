//
//  YMVersionManager.h
//  WeChatExtension
//
//  Created by WeChatExtension on 2018/2/24.
//  Copyright © 2018年 WeChatExtension. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TKVersionStatus) {
    TKVersionStatusOld,
    TKVersionStatusNew,
};

@interface YMVersionManager : NSObject
@property (nonatomic, copy) NSString *currentVersion;
+ (instancetype)shareManager;
- (void)checkVersionFinish:(void (^)(TKVersionStatus, NSString *))finish;
- (void)downloadPluginProgress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock completionHandler:(void (^)(NSString *filePath, NSError * _Nullable error))completionHandler;
- (void)cancelDownload;

@end
