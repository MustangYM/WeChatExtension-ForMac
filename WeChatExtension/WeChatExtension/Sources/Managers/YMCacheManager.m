//
//  YMCacheManager.m
//  WeChatExtension
//
//  Created by WeChatExtension on 2018/8/3.
//  Copyright © 2018年 WeChatExtension. All rights reserved.
//

#import "YMCacheManager.h"
static NSString * const kWeChatResourcesPath = @"/Applications/WeChat.app/Contents/MacOS/WeChatExtension.framework/Resources/";
@interface YMCacheManager () <EmoticonDownloadMgrExt>

@property (nonatomic, copy) NSString *cacheDirectory;
@property (nonatomic, strong) NSMutableSet *emotionSet;
@property (nonatomic, strong) NSMutableSet *avatarSet;
@end

@implementation YMCacheManager

+ (instancetype)shareManager
{
    static YMCacheManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YMCacheManager alloc] init];
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

- (void)dealloc
{
    MMExtensionCenter *extensionCenter = [[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("MMExtensionCenter") class]];
    MMExtension *extension = [extensionCenter getExtension:@protocol(EmoticonDownloadMgrExt)];
    if (extension) {
        [extension unregisterExtension:self];
    }
}

- (BOOL)fileExistsWithName:(NSString *)fileName
{
    fileName = [fileName stringByAppendingString:@".gif"];
    NSString *filePath = [self.cacheDirectory stringByAppendingString:fileName];
    NSFileManager *manager = [NSFileManager defaultManager];
    return [manager fileExistsAtPath:filePath];
}

- (NSString *)gifFilePathWithName:(NSString *)fileName
{
    if (![self fileExistsWithName:fileName]) {
         return nil;
    }
    
    fileName = [fileName stringByAppendingString:@".gif"];
    return [self.cacheDirectory stringByAppendingString:fileName];
}

- (NSString *)filePathWithName:(NSString *)fileName
{
    if (fileName.length == 0) {
        return nil;
    }
    return [self.cacheDirectory stringByAppendingString:fileName];
}

- (NSString *)cacheImageData:(NSData *)imageData withFileName:(NSString *)fileName completion:(void (^)(BOOL))completion
{
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

- (NSString *)cacheEmotionMessage:(MessageData *)emotionMsg
{
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

- (void)emoticonDownloadFinished:(EmoticonMsgInfo *)msgInfo
{
    if (![self.emotionSet containsObject:msgInfo.m_nsMD5]) {
         return;
    }
    
    EmoticonMgr *emoticonMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("EmoticonMgr")];
    NSData *imageData = [emoticonMgr getEmotionDataWithMD5:msgInfo.m_nsMD5];
    [self cacheImageData:imageData withFileName:msgInfo.m_nsMD5 completion:^(BOOL result) {
        if (result) {
            [self.emotionSet removeObject:msgInfo.m_nsMD5];
        }
    }];
}

- (NSString *)cacheAvatarWithContact:(WCContactData *)contact
{
    NSString *headImgUrl = contact.m_nsHeadImgUrl;
    if (headImgUrl.length == 0) {
         return @"";
    }
    
    NSString *imgPath = @"";
    if ([headImgUrl respondsToSelector:@selector(md5String)]) {
        NSString *imgMd5Str = [headImgUrl performSelector:@selector(md5String)];
        MMAvatarService *avatarService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMAvatarService")];

        NSString *userCache =  [objc_getClass("PathUtility") GetCurUserDocumentPath];
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

- (void)cacheImage:(NSImage *)image chatroom:(NSString *)chatroom
{
    if (!image || chatroom.length == 0) {
        return;
    }
    
    NSString *imgMd5Str = [chatroom performSelector:@selector(md5String)];
    NSString *userCache =  [objc_getClass("PathUtility") GetCurUserDocumentPath];
    NSString *imgPath = [NSString stringWithFormat:@"%@/avatar/%@",userCache, imgMd5Str];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if (imgPath && ![fileMgr fileExistsAtPath:imgPath]) {
      NSData *imageData = [image TIFFRepresentation];
      [imageData writeToFile:imgPath atomically:YES];
    }
}

- (NSImage *)imageWithChatroom:(NSString *)chatroom
{
    if (!chatroom || chatroom.length == 0) {
        return nil;
    }
    NSString *imgMd5Str = [chatroom performSelector:@selector(md5String)];
    NSString *userCache =  [objc_getClass("PathUtility") GetCurUserDocumentPath];
    NSString *imgPath = [NSString stringWithFormat:@"%@/avatar/%@",userCache, imgMd5Str];
    NSImage *image = [[NSImage alloc] initWithData:[NSData dataWithContentsOfFile:imgPath]];
    return image;
}

- (NSString *)getUpdateSandboxFilePathWithName:(NSString *)Name
{
    return [self _getSandBoxPath:@"/WeChatExtension/Update/" name:Name];
}

- (NSString *)_getSandBoxPath:(NSString *)path name:(NSString *)name
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *wechatPluginDirectory = [documentDirectory stringByAppendingFormat:@"%@", path];
    NSString *plistFilePath = [wechatPluginDirectory stringByAppendingPathComponent:name];
    if ([manager fileExistsAtPath:plistFilePath]) {
        return plistFilePath;
    }
    
    [manager createDirectoryAtPath:wechatPluginDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *resourcesFilePath = [kWeChatResourcesPath stringByAppendingString:path];
    if (![manager fileExistsAtPath:resourcesFilePath]) {
        return plistFilePath;
    }
    
    NSError *error = nil;
    [manager copyItemAtPath:resourcesFilePath toPath:plistFilePath error:&error];
    if (!error) {
        return plistFilePath;
    }
    return resourcesFilePath;
}
@end
