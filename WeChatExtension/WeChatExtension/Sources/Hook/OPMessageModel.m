//
//  OPMessageModel.m
//  WeChatPlugin
//
//  Created by MustangYM on 2019/1/23.
//  Copyright © 2019 YY Inc. All rights reserved.
//

#import "OPMessageModel.h"
#import "WeChatPlugin.h"
#import "NSDictionary+Safe.h"

@implementation OPVoiceModel
+ (OPVoiceModel *)modelWithParseXML:(NSString *)xml {
    if (xml.length == 0) {
        return nil;
    }
    XMLDictionaryParser *xmlParser = [objc_getClass("XMLDictionaryParser") sharedInstance];
    NSDictionary *parseDic = [xmlParser dictionaryWithString:xml];
    NSDictionary *msgDict = [parseDic dictionaryForKey:@"voicemsg"];
    OPVoiceModel *model = [[OPVoiceModel alloc] init];
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

@implementation OPPictureModel
+ (OPPictureModel *)modelWithParseXML:(NSString *)xml {
    if (xml.length == 0) {
        return nil;
    }
    XMLDictionaryParser *xmlParser = [objc_getClass("XMLDictionaryParser") sharedInstance];
    NSDictionary *parseDic = [xmlParser dictionaryWithString:xml];
    NSDictionary *msgDict = [parseDic dictionaryForKey:@"img"];
    OPPictureModel *model = [[OPPictureModel alloc] init];
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

@implementation OPVideoModel
+ (OPVideoModel *)modelWithParseXML:(NSString *)xml {
    if (xml.length == 0) {
        return nil;
    }
    XMLDictionaryParser *xmlParser = [objc_getClass("XMLDictionaryParser") sharedInstance];
    NSDictionary *parseDic = [xmlParser dictionaryWithString:xml];
    NSDictionary *msgDict = [parseDic dictionaryForKey:@"videomsg"];
    OPVideoModel *model = [[OPVideoModel alloc] init];
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
