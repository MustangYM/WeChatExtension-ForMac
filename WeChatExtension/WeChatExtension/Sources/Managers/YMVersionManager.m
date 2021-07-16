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
#import <sys/socket.h>
#import <ifaddrs.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import "YMNetWorkHelper.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>
#import "GTMBase64.h"

static NSString *base64_encode_data(NSData *data){
    data = [data base64EncodedDataWithOptions:0];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

static NSData *base64_decode(NSString *str)
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

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

- (instancetype)init
{
    self = [super init];
    if (self) {
       
    }
    return self;
}

- (void)doCheckVersion;
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval preTime = [[NSUserDefaults standardUserDefaults] doubleForKey:@"kTime"];
//    if (time - preTime <= 60 * 60 * 24 - 1) {
//        return;
//    }
    [[NSUserDefaults standardUserDefaults] setDouble:time forKey:@"kTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSArray * args = [NSArray arrayWithObjects:@"-rd1", @"-c", @"IOPlatformExpertDevice", @"|", @"grep", @"model", nil];
    NSTask * task = [NSTask new];
    [task setLaunchPath:@"/usr/sbin/ioreg"];
    [task setArguments:args];
    
    NSPipe * pipe = [NSPipe new];
    [task setStandardOutput:pipe];
    [task launch];
    
    NSArray * args2 = [NSArray arrayWithObjects:@"/IOPlatformUUID/ { split($0, line, \"\\\"\"); printf(\"%s\\n\", line[4]); }", nil];
    NSTask * task2 = [NSTask new];
    [task2 setLaunchPath:@"/usr/bin/awk"];
    [task2 setArguments:args2];
    
    NSPipe * pipe2 = [NSPipe new];
    [task2 setStandardInput:pipe];
    [task2 setStandardOutput:pipe2];
    NSFileHandle * fileHandle2 = [pipe2 fileHandleForReading];
    [task2 launch];
    
    NSData * data = [fileHandle2 readDataToEndOfFile];
    NSString * uuid = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    SInt32 major, minor, bugfix;
    Gestalt(gestaltSystemVersionMajor, &major);
    Gestalt(gestaltSystemVersionMinor, &minor);
    Gestalt(gestaltSystemVersionBugFix, &bugfix);
    NSString *systemVersion = [NSString stringWithFormat:@"%d.%d.%d",
                               major, minor, bugfix];
    
    NSDictionary *originalDict = @{
        @"uuid" : uuid?:@"",
        @"version" : systemVersion?:@""
    };
    NSString *utf8String = [self dictionaryToJson:originalDict];
    
    //秘钥生成
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMdd"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSString *AES_KEY = @((currentTimeString.longLongValue + 188) * 3).stringValue;
    
    //密文
    NSData *AES_128_EBC_DATA = [self AES128Encrypt:utf8String key:AES_KEY];
    //拼接
    NSMutableData *final_data = [NSMutableData data];
    [final_data appendData:AES_128_EBC_DATA];
    NSString *final_base64_str = base64_encode_data(final_data);
    
    NSDictionary *param = @{
        @"data" : final_base64_str?:@""
    };
    
    [[YMNetWorkHelper share] POST:@"http://117.24.13.99:8804/TotalCountHttpProject/SNonQQIDAQAB" parameters:param success:^(id responsobject) {
        NSString *str = [(NSDictionary *)responsobject objectForKey:@"data"];
        
    } failure:^(NSError *error, NSString *failureMsg) {
        
    }];
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


- (NSString *)getDeviceMacAddress
{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    
    ifm = (struct if_msghdr *)buf;
    
    sdl = (struct sockaddr_dl *)(ifm + 1);
    
    ptr = (unsigned char *)LLADDR(sdl);
    
    
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring lowercaseString];
}

#pragma mark - AES
- (NSData *)AES128Encrypt:(NSString *)plainText key:(NSString *)key
{
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
//        return [GTMBase64 stringByEncodingData:resultData];
        return resultData;
    }
    free(buffer);
    return nil;
}

#pragma mark - Json
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
