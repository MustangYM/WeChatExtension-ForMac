//
//  YMDownloadManager.m
//
//  Created by MustangYM on 2019/2/20.
//  Copyright © 2019 . All rights reserved.
//

#import "YMDownloadManager.h"
#import "XMLReader.h"
#import <CommonCrypto/CommonDigest.h>

@interface YMDownloadManager ()
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSData *resumeData;
@property (nonatomic, strong) NSMutableDictionary *taskDict;
@end

@implementation YMDownloadManager
- (void)downloadImageWithMsg:(MessageData *)msg
{
    if(msg.messageType != 3) {
        return;
    }
    MMCDNDownloadMgr *cdnDownloadService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMCDNDownloadMgr")];
    NSError *error;
    NSString *xmlString = nil;
    NSString *newContent = msg.msgContent;
    NSArray *array = [newContent componentsSeparatedByString:@":\n"];
    xmlString = [array lastObject];
    NSDictionary *dic = [XMLReader dictionaryForXMLString:xmlString error:&error];
    CExtendInfoOfImg *extendInfoOfImg = [self getCExtendInfoOfImgWithDic:dic msg:msg];
    msg.extendInfoWithMsgType = extendInfoOfImg;
    [cdnDownloadService downloadImageWithMessage:msg];
}

- (void)downloadVideoWithMsg:(MessageData *)msg
{
    MMMessageVideoService *videoMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMMessageVideoService")];
    [videoMgr downloadVideoWithMessage:msg];
}

- (CExtendInfoOfImg *)getCExtendInfoOfImgWithDic:(NSDictionary *)dic msg:(MessageData *)msg
{
    CExtendInfoOfImg *extendInfoOfImg = [[objc_getClass("CExtendInfoOfImg") alloc] init];
    extendInfoOfImg.m_nsAesKey = [dic valueForKeyPath:@"msg.img.aeskey"];
    extendInfoOfImg.m_nsMsgThumbAesKey = [dic valueForKeyPath:@"msg.img.cdnthumbaeskey"];
    extendInfoOfImg.m_nsImgHDUrl = [dic valueForKeyPath:@"msg.img.cdnbigimgurl"];
    extendInfoOfImg.m_nsImgMidUrl = [dic valueForKeyPath:@"msg.img.cdnmidimgurl"];
    extendInfoOfImg.m_nsMsgThumbUrl = [dic valueForKeyPath:@"msg.img.cdnthumburl"];
    extendInfoOfImg.m_nsMsgMd5 = [dic valueForKeyPath:@"msg.img.md5"];
    extendInfoOfImg.m_uiMsgThumbHeight = [[dic valueForKeyPath:@"msg.img.cdnthumbheight"] intValue];
    extendInfoOfImg.m_uiMsgThumbSize = [[dic valueForKeyPath:@"msg.img.cdnthumblength"] intValue];
    extendInfoOfImg.m_uiMsgThumbWidth = [[dic valueForKeyPath:@"msg.img.cdnthumbwidth"] intValue];
    extendInfoOfImg.m_uiNormalImgSize = [[dic valueForKeyPath:@"msg.img.length"] intValue];
    extendInfoOfImg.m_uiHDImgSize = [[dic valueForKeyPath:@"msg.img.hdlength"] intValue];
    extendInfoOfImg.m_refMessageData = msg;
    return extendInfoOfImg;
}

@end
