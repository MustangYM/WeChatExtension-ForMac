//
//  YMCacheManager.h
//  WeChatExtension
//
//  Created by WeChatExtension on 2018/8/3.
//  Copyright © 2018年 WeChatExtension. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMCacheManager : NSObject

+ (instancetype)shareManager;
- (NSString *) getUpdateSandboxFilePathWithName:(NSString *)Name;
- (BOOL)fileExistsWithName:(NSString *)fileName;
//拼接文件path, 请带上文件格式
- (NSString *)filePathWithName:(NSString *)fileName;
- (NSString *)gifFilePathWithName:(NSString *)fileName;
- (NSString *)cacheEmotionMessage:(MessageData *)emotionMsg;
- (NSString *)cacheAvatarWithContact:(WCContactData *)contact;
- (NSString *)cacheImageData:(NSData *)imageData withFileName:(NSString *)fileName completion:(void (^)(BOOL))completion;
- (void)cacheImage:(NSImage *)image chatroom:(NSString *)chatroom;
- (NSImage *)imageWithChatroom:(NSString *)chatroom;
@end
