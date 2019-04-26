//
//  TKCacheManager.m
//  WeChatPlugin
//
//  Created by TK on 2018/8/3.
//  Copyright © 2018年 tk. All rights reserved.
//

#import "TKCacheManager.h"

@interface TKCacheManager () <EmoticonDownloadMgrExt>

@property (nonatomic, copy) NSString *cacheDirectory;
@property (nonatomic, strong) NSMutableSet *emotionSet;
@property (nonatomic, strong) NSMutableSet *avatarSet;
@end

@implementation TKCacheManager

+ (instancetype)shareManager {
    static TKCacheManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TKCacheManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cacheDirectory = [NSTemporaryDirectory() stringByAppendingString:@"TKWeChatPlugin/"];
        NSFileManager *manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:self.cacheDirectory]) {
            [manager createDirectoryAtPath:self.cacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        MMExtensionCenter *extensionCenter = [[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("MMExtensionCenter") class]];
        MMExtension *extension = [extensionCenter getExtension:@protocol(EmoticonDownloadMgrExt)];
        if (extension) {
            [extension registerExtension:self];
        }
        
        self.emotionSet = [NSMutableSet set];
        self.avatarSet = [NSMutableSet set];
    }
    return self;
}

- (void)dealloc {
    MMExtensionCenter *extensionCenter = [[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("MMExtensionCenter") class]];
    MMExtension *extension = [extensionCenter getExtension:@protocol(EmoticonDownloadMgrExt)];
    if (extension) {
        [extension unregisterExtension:self];
    }
}

- (BOOL)fileExistsWithName:(NSString *)fileName {
    fileName = [fileName stringByAppendingString:@".gif"];
    NSString *filePath = [self.cacheDirectory stringByAppendingString:fileName];
    NSFileManager *manager = [NSFileManager defaultManager];
    return [manager fileExistsAtPath:filePath];
}

- (NSString *)filePathWithName:(NSString *)fileName {
    if (![self fileExistsWithName:fileName]) return nil;
    
    fileName = [fileName stringByAppendingString:@".gif"];
    return [self.cacheDirectory stringByAppendingString:fileName];
}

- (NSString *)cacheImageData:(NSData *)imageData withFileName:(NSString *)fileName completion:(void (^)(BOOL))completion {
    BOOL result = NO;
    if (!imageData) {
        if (completion) {
            completion(result);
        }
    }
    NSString *imageName = [NSString stringWithFormat:@"%@.gif", fileName];
    NSString *tempImageFilePath = [self.cacheDirectory stringByAppendingString:imageName];
    if (imageData) {
        NSURL *imageUrl = [NSURL fileURLWithPath:tempImageFilePath];
        result = [imageData writeToURL:imageUrl atomically:YES];
    }
    
    if (completion) {
        completion(result);
    }
    return tempImageFilePath;
}

- (NSString *)cacheEmotionMessage:(MessageData *)emotionMsg {
    EmoticonMgr *emoticonMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("EmoticonMgr")];
    NSData *imageData = [emoticonMgr getEmotionDataWithMD5:emotionMsg.m_nsEmoticonMD5];
    if (!imageData && ![self.emotionSet containsObject:emotionMsg.m_nsEmoticonMD5]) {
        EmoticonDownloadMgr *emotionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("EmoticonDownloadMgr")];
        [emotionMgr downloadEmoticonWithMessageData:emotionMsg];
        [self.emotionSet addObject:emotionMsg.m_nsEmoticonMD5];
    }
    NSString *tempImageFilePath = [self cacheImageData:imageData withFileName:emotionMsg.m_nsEmoticonMD5 completion:nil];

    return tempImageFilePath;
}

- (void)emoticonDownloadFinished:(EmoticonMsgInfo *)msgInfo {
    if (![self.emotionSet containsObject:msgInfo.m_nsMD5]) return;
    
    EmoticonMgr *emoticonMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("EmoticonMgr")];
    NSData *imageData = [emoticonMgr getEmotionDataWithMD5:msgInfo.m_nsMD5];
    [self cacheImageData:imageData withFileName:msgInfo.m_nsMD5 completion:^(BOOL result) {
        if(result) {
            [self.emotionSet removeObject:msgInfo.m_nsMD5];
        }
    }];
}

- (NSString *)cacheAvatarWithContact:(WCContactData *)contact {
    NSString *headImgUrl = contact.m_nsHeadImgUrl;
    if (headImgUrl.length == 0) return @"";
    
    NSString *imgPath = @"";
    if ([headImgUrl respondsToSelector:@selector(md5String)]) {
        NSString *imgMd5Str = [headImgUrl performSelector:@selector(md5String)];
        MMAvatarService *avatarService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMAvatarService")];

        NSString *userCache =  [objc_getClass("PathUtility") GetCurUserCachePath];
        imgPath = [NSString stringWithFormat:@"%@/avatar/%@",userCache, imgMd5Str];

        NSFileManager *fileMgr = [NSFileManager defaultManager];
        if (imgPath && ![fileMgr fileExistsAtPath:imgPath] && ![self.avatarSet containsObject:imgPath]) {
            [self.avatarSet addObject:imgPath];
            
            void (^cacheImage)(NSImage *img) = ^(NSImage *img) {
                NSData *imageData = [img TIFFRepresentation];
                [imageData writeToFile:imgPath atomically:YES];
                [self.avatarSet removeObject:imgPath];
            };
            
            if ([avatarService respondsToSelector:@selector(avatarImageWithContact:completion:)]) {
                [avatarService avatarImageWithContact:contact completion:cacheImage];
            } else {
                [avatarService getAvatarImageWithContact:contact completion:cacheImage];
            }
        }

    }
    return imgPath ?: @"";

}
@end
