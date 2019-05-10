//
//  MF_Base64Additions.h
//  Base64 -- RFC 4648 compatible implementation
//  see http://www.ietf.org/rfc/rfc4648.txt for more details
//
//  Designed to be compiled with Automatic Reference Counting
//
//  Created by Dave Poirier on 2012-06-14.
//  Public Domain
//  Hosted at https://github.com/ekscrypto/Base64
//

#import <Foundation/Foundation.h>

@interface NSString (Base64Addition)
+(NSString *)stringFromBase64String:(NSString *)base64String;
+(NSString *)stringFromBase64UrlEncodedString:(NSString *)base64UrlEncodedString;
-(NSString *)base64String;
-(NSString *)base64UrlEncodedString;
@end

@interface NSData (Base64Addition)
+(NSData *)dataWithBase64String:(NSString *)base64String;
+(NSData *)dataWithBase64UrlEncodedString:(NSString *)base64UrlEncodedString;
-(NSString *)base64String;
-(NSString *)base64UrlEncodedString;
@end

@interface MF_Base64Codec : NSObject 
+(NSData *)dataFromBase64String:(NSString *)base64String;
+(NSString *)base64StringFromData:(NSData *)data;
+(NSString *)base64UrlEncodedStringFromBase64String:(NSString *)base64String;
+(NSString *)base64StringFromBase64UrlEncodedString:(NSString *)base64UrlEncodedString;
@end
