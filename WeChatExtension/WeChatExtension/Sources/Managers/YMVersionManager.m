//
//  YMVersionManager.m
//  WeChatExtension
//
//  Created by WeChatExtension on 2018/2/24.
//  Copyright © 2018年 WeChatExtension. All rights reserved.
//

#import "YMVersionManager.h"
#import "YMWeChatPluginConfig.h"
#import "YMHTTPManager.h"
#import "YMRemoteControlManager.h"
#import "YMCacheManager.h"

@implementation YMVersionManager

+ (instancetype)shareManager
{
    static YMVersionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YMVersionManager alloc] init];
    });
    return manager;
}

- (NSString *)currentVersion
{
    NSDictionary *infoDictionary = [[NSBundle bundleWithIdentifier:@"MustangYM.WeChatExtension"] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app版本
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}

- (void)checkVersionFinish:(void (^)(TKVersionStatus, NSString *))finish
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *localInfo = [[YMWeChatPluginConfig sharedConfig] localInfoPlist];
        NSDictionary *romoteInfo = [[YMWeChatPluginConfig sharedConfig] romoteInfoPlist];
        NSString *localBundle = localInfo[@"CFBundleShortVersionString"];
        NSString *romoteBundle = romoteInfo[@"CFBundleShortVersionString"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([localBundle isEqualToString:romoteBundle]) {
                NSString *versionMsg = [localInfo[@"versionInfo"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
                finish(TKVersionStatusOld, versionMsg);
            } else if (romoteInfo[@"versionInfo"]) {
                if (![romoteInfo[@"showUpdateWindow"] boolValue]) {
                     return;
                }
                if ([self compareVersion:localBundle to:romoteBundle] == 1) {
                    NSString *versionMsg = [romoteInfo[@"versionInfo"] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
                    finish(TKVersionStatusNew, versionMsg);
                }
            }
        });
    });
}

- (void)downloadPluginProgress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock completionHandler:(void (^)(NSString *filePath, NSError * _Nullable error))completionHandler
{
    NSString *cachesPath = [[YMCacheManager shareManager] getUpdateSandboxFilePathWithName:@""];
    NSString *pluginName = @"WeChatExtension";
    NSString *pluginPath = [NSString stringWithFormat:@"%@/%@",cachesPath,pluginName];
    NSString *pluginZipPath = [NSString stringWithFormat:@"%@.zip",pluginPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:pluginPath error:nil];
    [fileManager removeItemAtPath:pluginZipPath error:nil];
    
    NSString *urlString = @"https://github.com/MustangYM/WeChatExtension-ForMac/raw/master/WeChatExtension/Rely/Plugin/WeChatExtension.zip";
    [[YMHTTPManager shareManager] downloadWithUrlString:urlString toDirectoryPah:cachesPath progress:^(NSProgress *downloadProgress) {
        if (downloadProgressBlock) {
             downloadProgressBlock(downloadProgress);
        }
    } completionHandler:^(NSString *filePath, NSError * _Nullable error) {
        if (completionHandler) {
             completionHandler(filePath,error);
        }
    }];
}

- (void)cancelDownload
{
    [[YMHTTPManager shareManager] cancelDownload];
}

//版本2大于版本1, 返回1; 否则返回-1. 版本号相等,返回0;
- (NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2 {
    if (!v1 && !v2) {
        return 0;
    }
    
    if (!v1 && v2) {
        return 1;
    }
    
    if (v1 && !v2) {
        return -1;
    }
    
    NSArray *v1Array = [v1 componentsSeparatedByString:@"."];
    NSArray *v2Array = [v2 componentsSeparatedByString:@"."];
    NSInteger bigCount = (v1Array.count > v2Array.count) ? v1Array.count : v2Array.count;
    
    for (int i = 0; i < bigCount; i++) {
        NSInteger value1 = (v1Array.count > i) ? [[v1Array objectAtIndex:i] integerValue] : 0;
        NSInteger value2 = (v2Array.count > i) ? [[v2Array objectAtIndex:i] integerValue] : 0;
        if (value1 > value2) {
            return -1;
        } else if (value1 < value2) {
            return 1;
        }
    }
    
    return 0;
}
@end
