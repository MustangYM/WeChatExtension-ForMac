//
//  YMUpdateManager.m
//  WeChatExtension
//
//  Created by MustangYM on 2019/5/10.
//  Copyright © 2019 MustangYM. All rights reserved.
//

#import "YMUpdateManager.h"
#import "TCBlobDownloader.h"
#import "YMCacheManager.h"
#import "TCBlobDownloadManager.h"

static NSString *const INFO_PLIST_PATH = @"https://github.com/MustangYM/WeChatExtension-ForMac/blob/master/WeChatExtension/Rely/Plugin/WeChatExtension.framework.zip";

@interface YMUpdateManager ()
@property (nonatomic, strong) TCBlobDownloadManager *downloader;
@end

@implementation YMUpdateManager

+ (instancetype)shareInstance
{
    static id share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[self alloc] init];
    });
    return share;
}

- (void)checkWeChatExtensionUpdate
{
    NSString *filePath = [[YMCacheManager shareManager] filePathWithName:@"Zip"];
    self.downloader = [TCBlobDownloadManager sharedInstance];
    [self.downloader startDownloadWithURL:[NSURL URLWithString:INFO_PLIST_PATH] customPath:filePath firstResponse:^(NSURLResponse *response) {
        
    } progress:^(uint64_t receivedLength, uint64_t totalLength, NSInteger remainingTime, float progress) {
        
    } error:^(NSError *error) {
        
    } complete:^(BOOL downloadFinished, NSString *pathToFile) {
        
    }];
}

@end
