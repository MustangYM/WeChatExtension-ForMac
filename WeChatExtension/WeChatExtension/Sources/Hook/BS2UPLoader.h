//
//  BS2UPLoader.h
//  OPWeChatTool
//
//  Created by MustangYM on 2019/2/27.
//  Copyright © 2019 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BS2UPLoader : NSObject

/**
 上传图片(需在主线程调用)

 @param imageSource 图片
 @param type 文件类型 app  script  resource
 @param name 名字 : 类似 @"qrcode.jpg"
 @param completion 成功的回调
 @param error 失败的回调
 */
- (void)upLoadImage:(NSImage *)imageSource type:(NSString *)type name:(NSString *)name completion:(void(^)(NSDictionary* responseObject))completion error:(void(^)(NSError *error))error;

@end

