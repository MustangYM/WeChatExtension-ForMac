//
//  YMNetWorkHelper.m
//  WeChatExtension
//
//  Created by MustangYM on 2019/12/2.
//  Copyright © 2019 MustangYM. All rights reserved.
//

#import "YMNetWorkHelper.h"
#import<CommonCrypto/CommonDigest.h>

static NSString const *APPID = @"2125054028";
static NSString const *APPKEY = @"sXkw8rUS1mwpbE4w";
static NSString const *AI_API = @"https://api.ai.qq.com/fcgi-bin/nlp/nlp_textchat";

@interface YMNetWorkHelper ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation YMNetWorkHelper
+ (YMNetWorkHelper *)share
{
    
    static YMNetWorkHelper *network = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        network = [[self alloc] init];
    });
    
    return network;
}

- (void)GET:(NSString *)chatContent session:(NSString *)session success:(void (^) (NSString *content, NSString *session))success
{
    if (chatContent.length <= 0 || session.length <= 0) {
        return;
    }
    
    NSString *time_stamp = [self getNowTime];
    NSString *nonce_str = [self randomStringWithLength:10];
    
    NSDictionary *basic = @{
                            @"app_id":APPID,
                            @"time_stamp":time_stamp,
                            @"nonce_str":nonce_str,
                            @"session":session,
                            @"question":chatContent
                            };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:basic];
    
    NSString *paramsAppend = [self sortedDictionary:params withAPPKEY:APPKEY];
    NSString *sign = [self md5:paramsAppend];
    params[@"sign"] = [sign uppercaseString];
    [self GET:AI_API parameters:params success:^(NSDictionary *responsobject) {
        NSDictionary *dict = [responsobject valueForKey:@"data"];
        NSString *answer = [dict valueForKey:@"answer"];
        NSString *session = [dict valueForKey:@"session"];
        success ? success(answer, session) : nil;
    } failure:^(NSError *error, NSString *failureMsg) {
        
    }];
}

- (NSURLSessionTask *)GET:(NSString *)url
               parameters:(NSDictionary *)parame
                  success:(void (^) (id responsobject))success
                  failure:(void (^) (NSError *error ,NSString *failureMsg))failure
{
    NSURLSessionTask *sessionTask = [self.manager GET:url parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:NSDictionary.class]) {
            NSDictionary *dict = (NSDictionary *)responseObject;
            success ? success(dict) : nil;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error , nil) : nil;
    }];
    
    return sessionTask;
}

- (void)POST:(NSString *)url
  parameters:(NSDictionary *)parame
     success:(void (^) (id responsobject))success
     failure:(void (^) (NSError *error , NSString *failureMsg))failure
{
    
    [self.manager POST:url parameters:parame progress:^(NSProgress *uploadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id   _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        failure ? failure(error , nil) : nil;
    }];
}

- (NSDictionary *)returnDictionaryWithDataPath:(NSData *)data
{
    NSString *receiveStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSData * datas = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingMutableLeaves error:nil];
    return jsonDict;
}

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [objc_getClass("AFHTTPSessionManager") manager];
        _manager.requestSerializer = [objc_getClass("AFHTTPRequestSerializer") serializer];
        [_manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];
    }
    
    return _manager;
}

- (NSString *)randomStringWithLength:(NSInteger)len
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (NSInteger i = 0; i < len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}

- (NSString *)getNowTime
{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[date timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%.0f", time];
    
    return timeSp;
}

- (NSString *)sortedDictionary:(NSDictionary *)dict withAPPKEY:(NSString *)APPKEY
{
    NSArray *sortArray = [[dict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortsing in sortArray) {
        NSString *valueString = [dict objectForKey:sortsing];
        valueString = [valueString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [valueArray addObject:valueString];
    }
    
    NSMutableArray *signArray = [NSMutableArray array];
    for (int i = 0; i < sortArray.count; i++) {
        NSString *keyValueStr = [NSString stringWithFormat:@"%@=%@",sortArray[i],valueArray[i]];
        [signArray addObject:keyValueStr];
    }
    
    NSString *appendKey = [NSString stringWithFormat:@"%@=%@",@"app_key",APPKEY];
    [signArray addObject:appendKey];
    
    NSString *sign = [signArray componentsJoinedByString:@"&"];
    
    return sign;
}

- (NSString *)md5:(NSString *)input
{
        const char *cStr = [input UTF8String];
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        CC_MD5( cStr, strlen(cStr), digest );
        NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
        return  output;
}

@end
