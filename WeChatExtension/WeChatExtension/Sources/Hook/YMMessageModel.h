//
//  YMMessageModel.h
//  WeChatExtension
//
//  Created by MustangYM on 2019/1/23.
//  Copyright © 2019 MustangYM. All rights reserved.
//

#import <Foundation/Foundation.h>
//语音消息
@interface OPVoiceModel : NSObject
@property (nonatomic, copy) NSString *_bufid;
@property (nonatomic, copy) NSString *_cancelflag;
@property (nonatomic, copy) NSString *_clientmsgid;
@property (nonatomic, copy) NSString *_endflag;
@property (nonatomic, copy) NSString *_forwardflag;
@property (nonatomic, copy) NSString *_fromusername;
@property (nonatomic, copy) NSString *_length;
@property (nonatomic, copy) NSString *_voiceformat;
@property (nonatomic, copy) NSString *_voicelength;
+ (OPVoiceModel *)modelWithParseXML:(NSString *)xml;
@end

//图片消息
@interface OPPictureModel : NSObject
@property (nonatomic, copy) NSString *_aeskey;
@property (nonatomic, copy) NSString *_cdnmidimgurl;;
@property (nonatomic, copy) NSString *_cdnthumbaeskey;
@property (nonatomic, copy) NSString *_cdnthumburl;
@property (nonatomic, copy) NSString *_encryver;
@property (nonatomic, copy) NSString *_length;
@property (nonatomic, copy) NSString *_md5;
+ (OPPictureModel *)modelWithParseXML:(NSString *)xml;
@end

//视频消息
@interface OPVideoModel : NSObject
@property (nonatomic, copy) NSString *_aeskey;

@property (nonatomic, copy) NSString *_cdnthumbaeskey;
@property (nonatomic, copy) NSString *_cdnthumburl;

@property (nonatomic, copy) NSString *_cdnvideourl;
@property (nonatomic, copy) NSString *_fromusername;
@property (nonatomic, copy) NSString *_isad;
@property (nonatomic, copy) NSString *_length;
@property (nonatomic, copy) NSString *_md5;
@property (nonatomic, copy) NSString *_newmd5;
@property (nonatomic, copy) NSString *_playlength;
+ (OPVideoModel *)modelWithParseXML:(NSString *)xml;
@end
