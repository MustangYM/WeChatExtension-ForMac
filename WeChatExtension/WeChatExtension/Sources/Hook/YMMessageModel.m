//
//  YMMessageModel.m
//  WeChatExtension
//
//  Created by MustangYM on 2019/1/23.
//  Copyright © 2019 MustangYM. All rights reserved.
//

#import "YMMessageModel.h"
#import "WeChatPlugin.h"
#import "NSDictionary+Safe.h"

@implementation YMVoiceModel
+ (YMVoiceModel *)modelWithParseXML:(NSString *)xml
{
    if (xml.length == 0) {
        return nil;
    }
    XMLDictionaryParser *xmlParser = [objc_getClass("XMLDictionaryParser") sharedInstance];
    NSDictionary *parseDic = [xmlParser dictionaryWithString:xml];
    NSDictionary *msgDict = [parseDic dictionaryForKey:@"voicemsg"];
    YMVoiceModel *model = [[YMVoiceModel alloc] init];
    model._bufid = [msgDict stringForKey:@"_bufid"];
    model._cancelflag = [msgDict stringForKey:@"_cancelflag"];
    model._clientmsgid = [msgDict stringForKey:@"_clientmsgid"];
    model._endflag = [msgDict stringForKey:@"_endflag"];
    model._forwardflag = [msgDict stringForKey:@"_forwardflag"];
    model._fromusername = [msgDict stringForKey:@"_fromusername"];
    model._length = [msgDict stringForKey:@"_length"];
    model._voiceformat = [msgDict stringForKey:@"_voiceformat"];
    model._voicelength = [msgDict stringForKey:@"_voicelength"];
    return model;
}
@end

@implementation YMPictureModel
+ (YMPictureModel *)modelWithParseXML:(NSString *)xml
{
    if (xml.length == 0) {
        return nil;
    }
    XMLDictionaryParser *xmlParser = [objc_getClass("XMLDictionaryParser") sharedInstance];
    NSDictionary *parseDic = [xmlParser dictionaryWithString:xml];
    NSDictionary *msgDict = [parseDic dictionaryForKey:@"img"];
    YMPictureModel *model = [[YMPictureModel alloc] init];
    model._aeskey = [msgDict stringForKey:@"_aeskey"];
    model._cdnmidimgurl = [msgDict stringForKey:@"_cdnmidimgurl"];
    model._cdnthumbaeskey = [msgDict stringForKey:@"_cdnthumbaeskey"];
    model._cdnthumburl = [msgDict stringForKey:@"_cdnthumburl"];
    model._encryver = [msgDict stringForKey:@"_encryver"];
    model._length = [msgDict stringForKey:@"_length"];
    model._md5 = [msgDict stringForKey:@"_md5"];
    return model;
}
@end

@implementation YMVideoModel
+ (YMVideoModel *)modelWithParseXML:(NSString *)xml
{
    if (xml.length == 0) {
        return nil;
    }
    XMLDictionaryParser *xmlParser = [objc_getClass("XMLDictionaryParser") sharedInstance];
    NSDictionary *parseDic = [xmlParser dictionaryWithString:xml];
    NSDictionary *msgDict = [parseDic dictionaryForKey:@"videomsg"];
    YMVideoModel *model = [[YMVideoModel alloc] init];
    model._aeskey = [msgDict stringForKey:@"_aeskey"];
    model._cdnthumbaeskey = [msgDict stringForKey:@"_cdnthumbaeskey"];
    model._cdnthumburl = [msgDict stringForKey:@"_cdnthumburl"];
    model._cdnvideourl = [msgDict stringForKey:@"_cdnvideourl"];
    model._fromusername = [msgDict stringForKey:@"_fromusername"];
    model._isad = [msgDict stringForKey:@"_isad"];
    model._length = [msgDict stringForKey:@"_length"];
    model._md5 = [msgDict stringForKey:@"_md5"];
    model._newmd5 = [msgDict stringForKey:@"_newmd5"];
    model._playlength = [msgDict stringForKey:@"_playlength"];
    return model;
}
@end
