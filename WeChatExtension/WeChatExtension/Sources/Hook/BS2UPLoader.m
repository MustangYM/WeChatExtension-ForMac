//
//  BS2UPLoader.m
//  OPWeChatTool
//
//  Created by MustangYM on 2019/2/27.
//  Copyright © 2019 YY Inc. All rights reserved.
//

#import "BS2UPLoader.h"

static NSUInteger const kLogRequestTimeout = 5 * 60;
#define kLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
typedef void(^callBackBlock)(NSDictionary* responseObject);
typedef void(^callBackErrorBlock)(NSError* error);
static NSString *const kMediaUrl = @"http://scrm-yijian.yy.com/bs2/files/";

@interface BS2UPLoader ()<NSURLConnectionDataDelegate>
@property (nonatomic, strong) NSMutableURLRequest *request;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *reveivedData;
@property (copy , nonatomic) callBackBlock successBlock;
@property (copy , nonatomic) callBackErrorBlock errorBlock;
@property (nonatomic, strong) AFHTTPSessionManager *session;
@end

@implementation BS2UPLoader

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.session = ({
            AFHTTPSessionManager *session = [objc_getClass("AFHTTPSessionManager") manager];
            session;
        });
    }
    return self;
}

- (void)upLoadImage:(NSImage *)imageSource type:(NSString *)type name:(NSString *)name completion:(void(^)(NSDictionary* responseObject))completion error:(void(^)(NSError *error))error {
    if (!([type isEqualToString:@"app"] || [type isEqualToString:@"script"] || [type isEqualToString:@"resource"])) {
        type = @"resource";
    }
    
    if (name.length == 0) {
        name = @"yyCRMImage.jpg";
    }
    
    if (!imageSource) {
        kLog(@"上传图片不能为空:%@",name);
        return;
    }
    
    self.successBlock = completion;
    self.errorBlock = error;
    NSString *fileKey = @"crmImage";
    
    NSData *fileData = [imageSource TIFFRepresentation];
    NSString *contentType = @"image/jpeg";
    NSBitmapImageFileType bitmapType = NSBitmapImageFileTypeJPEG;
    
    NSBitmapImageRep *bitMapRep = [NSBitmapImageRep imageRepWithData:fileData];
    NSData *data = [bitMapRep representationUsingType:bitmapType properties:nil];
    
   
//        bitmapType = NSBitmapImageFileTypeJPEG;
//        name = [name stringByAppendingString:@".jpg"];
//        contentType = @"image/jpeg";
  
        bitmapType = NSBitmapImageFileTypePNG;
        name = [name stringByAppendingString:@".png"];
        contentType = @"image/png";
   
    [self _uploadData:data url:kMediaUrl type:type ContentType:contentType fileKey:fileKey name:name];
}

- (void)uploadAudio:(NSString *)audioPath type:(NSString *)type name:(NSString *)name completion:(void(^)(NSDictionary* responseObject))completion error:(void(^)(NSError *error))error {
    if (!([type isEqualToString:@"app"] || [type isEqualToString:@"script"] || [type isEqualToString:@"resource"])) {
        type = @"resource";
    }
    
    if (name.length == 0) {
        name = @"chatAudio.mp3";
    }
    
    if (audioPath.length == 0) {
        kLog(@"上传音频地址不能为空");
        return;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:audioPath];
    
    if (!data) {
        kLog(@"上传音频不存在");
        return;
    }
    
    self.successBlock = completion;
    self.errorBlock = error;
    
    NSString *fileKey = @"audioMp3";
    
    [self _uploadData:data url:kMediaUrl type:type ContentType:@"audio/mp3" fileKey:fileKey name:name];
}

- (void)uploadVideo:(NSString *)videoPath type:(NSString *)type name:(NSString *)name completion:(void(^)(NSDictionary* responseObject))completion error:(void(^)(NSError *error))error {
    if (!([type isEqualToString:@"app"] || [type isEqualToString:@"script"] || [type isEqualToString:@"resource"])) {
        type = @"resource";
    }
    
    if (name.length == 0) {
        name = @"chatVideo.mp4";
    }
    
    if (videoPath.length == 0) {
        kLog(@"上传视频地址不能为空");
        return;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:videoPath];
    
    if (!data) {
        kLog(@"上传视频不存在");
        return;
    }
    
    self.successBlock = completion;
    self.errorBlock = error;
    NSString *fileKey = @"video";
    
    [self _uploadData:data url:kMediaUrl type:type ContentType:@"video/mp4" fileKey:fileKey name:name];
}

- (void)_uploadData:(NSData *)data url:(NSString *)url type:(NSString *)type ContentType:(NSString *)contentType fileKey:(NSString *)fileKey name:(NSString *)name {
    NSString *uploadUrl = [NSString stringWithFormat:@"%@%@", url, type];
    NSLog(@"----%@",data);
    self.request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:uploadUrl] cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:5];
    NSString *boundary = @"yy_scrm_wfWiEWrgEFA9A78512weF7106A";
    self.request.HTTPMethod = @"POST";
    self.request.allHTTPHeaderFields = @{
                                         @"Content-Type":[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary]
                                         };
    NSMutableData *postData = [[NSMutableData alloc] init];
    NSString *filePair = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\";Content-Type=%@\r\n\r\n",boundary,fileKey,name,contentType];
    [postData appendData:[filePair dataUsingEncoding:NSUTF8StringEncoding]];
    //文件部分
    [postData appendData:data];
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    self.request.HTTPBody = postData;
    [self.request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)postData.length] forHTTPHeaderField:@"Content-Length"];
    self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self];
    [self.connection start];
}

- (NSString *)jsonString:(NSDictionary *)jsonDict {
    NSError *error = nil;
    NSData *jsonData = nil;
    if (!self) {
        return nil;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [jsonDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *keyString = nil;
        NSString *valueString = nil;
        if ([key isKindOfClass:[NSString class]]) {
            keyString = key;
        }else{
            keyString = [NSString stringWithFormat:@"%@",key];
        }
        
        if ([obj isKindOfClass:[NSString class]]) {
            valueString = obj;
        }else{
            valueString = [NSString stringWithFormat:@"%@",obj];
        }
        
        [dict setObject:valueString forKey:keyString];
    }];
    jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] == 0 || error != nil) {
        return nil;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

#pragma mark - connection delegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"reveive Response:\n%@",response);
    _reveivedData = nil;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if (!_reveivedData) {
        _reveivedData = [[NSMutableData alloc]init];
    }
    
    [_reveivedData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    if (self.successBlock)//成功的回调
    {
        
        NSDictionary *responseObject = nil;
        if (_reveivedData) {
            responseObject = [NSJSONSerialization JSONObjectWithData:_reveivedData options:NSJSONReadingMutableContainers error:nil];
            if (!responseObject) {
                NSString *responseStr = [[NSString alloc] initWithData:_reveivedData encoding:NSUTF8StringEncoding];
                kLog(@"BS2日志上传返回结果:%@",responseStr);
                responseObject = @{@"LOG UPLOAD RESULT :" : responseStr ?: @""};
            }
            
        } else {
            kLog(@"BS2日志上传返回结果:NULL");
            responseObject = @{@"LOG UPLOAD RESULT :" : @"BS2上传结果为空"};
        }
        
        self.successBlock(responseObject);
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"fail connect:\n%@",error);
    if (self.errorBlock) {//失败的回调
        self.errorBlock(error);
    }
}

@end

