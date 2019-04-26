//
//  TKCacheManager.h
//  WeChatPlugin
//
//  Created by TK on 2018/8/3.
//  Copyright © 2018年 tk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKCacheManager : NSObject

+ (instancetype)shareManager;

- (BOOL)fileExistsWithName:(NSString *)fileName;
- (NSString *)filePathWithName:(NSString *)fileName;
- (NSString *)cacheEmotionMessage:(MessageData *)emotionMsg;
- (NSString *)cacheAvatarWithContact:(WCContactData *)contact;
- (NSString *)cacheImageData:(NSData *)imageData withFileName:(NSString *)fileName completion:(void (^)(BOOL))completion;
@end
