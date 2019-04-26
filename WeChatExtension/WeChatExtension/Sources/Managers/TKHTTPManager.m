//
//  TKHTTPManager.m
//  WeChatPlugin
//
//  Created by TK on 2018/4/17.
//  Copyright © 2018年 tk. All rights reserved.
//

#import "TKHTTPManager.h"
#import "TKRemoteControlManager.h"

@interface TKHTTPManager ()

@property (nonatomic, strong) AFHTTPSessionManager *session;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong)  AFURLSessionManager *sessionManager;
@property (nonatomic, copy) NSString *zipPath;

@end

@implementation TKHTTPManager

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.session = ({
            AFHTTPSessionManager *session = [objc_getClass("AFHTTPSessionManager") manager];
            session.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
            
            session;
        });
    }
    return self;
}

+ (instancetype)shareManager {
    static TKHTTPManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TKHTTPManager alloc] init];
    });
    return manager;
}

- (void)downloadWithUrlString:(NSString *)urlString
               toDirectoryPah:(NSString *)directory
                     progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgressBlock
            completionHandler:(nullable void (^)(NSString * filePath, NSError * _Nullable error))completionHandler {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.sessionManager = [[objc_getClass("AFURLSessionManager") alloc] initWithSessionConfiguration:configuration];

    self.downloadTask = [self.sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (downloadProgressBlock) downloadProgressBlock(downloadProgress);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *path = [directory stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable urlPath, NSError * _Nullable error) {
        NSString *filePath = [[urlPath absoluteString] substringFromIndex:7];
        if (completionHandler) completionHandler(filePath, error);
    }];
    [self.downloadTask resume];
}

- (void)cancelDownload {
    if (!self.downloadTask) return;
    [self.downloadTask cancel];
    self.downloadTask = nil;
}

@end
