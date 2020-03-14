//
//  TKVersionManager.m
//  WeChatExtension
//
//  Created by WeChatExtension on 2018/2/24.
//  Copyright © 2018年 WeChatExtension. All rights reserved.
//

#import "TKVersionManager.h"
#import "TKWeChatPluginConfig.h"
#import "TKHTTPManager.h"
#import "TKRemoteControlManager.h"
#import "TKCacheManager.h"

@implementation TKVersionManager

+ (instancetype)shareManager {
    static TKVersionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TKVersionManager alloc] init];
    });
    return manager;
}

- (NSString *)currentVersion {
    NSDictionary *infoDictionary = [[NSBundle bundleWithIdentifier:@"MustangYM.WeChatExtension"] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app版本
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}

- (void)checkVersionFinish:(void (^)(TKVersionStatus, NSString *))finish {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *localInfo = [[TKWeChatPluginConfig sharedConfig] localInfoPlist];
        NSDictionary *romoteInfo = [[TKWeChatPluginConfig sharedConfig] romoteInfoPlist];
        NSString *localBundle = localInfo[@"CFBundleShortVersionString"];
        NSString *romoteBundle = romoteInfo[@"CFBundleShortVersionString"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([localBundle isEqualToString:romoteBundle]) {
                NSString *versionMsg = [localInfo[@"versionInfo"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
                finish(TKVersionStatusOld, versionMsg);
            } else if (romoteInfo[@"versionInfo"]) {
                if (![romoteInfo[@"showUpdateWindow"] boolValue]) return;
                NSString *versionMsg = [romoteInfo[@"versionInfo"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
                finish(TKVersionStatusNew, versionMsg);
            }
        });
    });
}

- (void)downloadPluginProgress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock completionHandler:(void (^)(NSString *filePath, NSError * _Nullable error))completionHandler {
    NSString *cachesPath = [[TKCacheManager shareManager] getUpdateSandboxFilePathWithName:@""];
    NSString *pluginName = @"WeChatExtension";
    NSString *pluginPath = [NSString stringWithFormat:@"%@/%@",cachesPath,pluginName];
    NSString *pluginZipPath = [NSString stringWithFormat:@"%@.zip",pluginPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:pluginPath error:nil];
    [fileManager removeItemAtPath:pluginZipPath error:nil];
    
    NSString *urlString = @"https://github.com/MustangYM/WeChatExtension-ForMac/raw/master/WeChatExtension/Rely/Plugin/WeChatExtension.zip";
    [[TKHTTPManager shareManager] downloadWithUrlString:urlString toDirectoryPah:cachesPath progress:^(NSProgress *downloadProgress) {
        if (downloadProgressBlock) downloadProgressBlock(downloadProgress);
    } completionHandler:^(NSString *filePath, NSError * _Nullable error) {
        if (completionHandler) completionHandler(filePath,error);
    }];
}

- (void)cancelDownload {
    [[TKHTTPManager shareManager] cancelDownload];
}
@end
