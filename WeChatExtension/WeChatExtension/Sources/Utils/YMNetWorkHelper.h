//
//  YMNetWorkHelper.h
//  WeChatExtension
//
//  Created by MustangYM on 2019/12/2.
//  Copyright © 2019 MustangYM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMNetWorkHelper : NSObject
+ (YMNetWorkHelper *)share;
- (NSURLSessionTask *)GET:(NSString *)url
               parameters:(NSDictionary *)parame
                  success:(void (^) (id responsobject))success
                  failure:(void (^) (NSError *error , NSString *failureMsg))failure;
- (void)POST:(NSString *)url
  parameters:(NSDictionary *)parame
     success:(void (^) (id responsobject))success
     failure:(void (^) (NSError *error , NSString *failureMsg))failure;
- (void)GET:(NSString *)chatContent session:(NSString *)session success:(void (^) (NSString *content, NSString *session))success;
@end

