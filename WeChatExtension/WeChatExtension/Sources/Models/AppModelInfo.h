//
//  AppModelInfo.h
//  WeChatExtension
//
//  Created by zhouwei on 2019/6/6.
//  Copyright © 2019年 MustangYM. All rights reserved.
//

#import "TKBaseModel.h"

@interface AppInfoModel : TKBaseModel

@property (nonatomic, assign) NSInteger version;   // app版本号
@property (nonatomic, copy) NSString *appname;      // app名称


@end



@interface AppMsgModel : TKBaseModel

/* 5:饿了吗 */
@property (nonatomic, assign) NSInteger type;      // app 类型
@property (nonatomic, copy) NSString *title;       // app标题
@property (nonatomic, copy) NSString *des;         // app描述

@end


@interface AppModelInfo : TKBaseModel

@property (nonatomic, strong) AppInfoModel *appinfo;        /**<    appinfo      */
@property (nonatomic, strong) AppMsgModel *appmsg;          /**<    appmsg      */

@end




/**
 * 微信红包
 **/
@interface WCRedEnvelopPayInfoModel : TKBaseModel

@property (nonatomic, copy) NSString *nativeurl;   // 链接

@end


@interface WCRedEnvelopMsgModel : TKBaseModel

/* 2001:微信红包 */
@property (nonatomic, assign) NSInteger type;      // app 类型
@property (nonatomic, copy) NSString *title;       // app标题
@property (nonatomic, copy) NSString *des;         // app描述
@property (nonatomic, strong) WCRedEnvelopPayInfoModel *wcpayinfo;// 微信支付信息

@end


@interface WCRedEnvelopesModel : TKBaseModel

@property (nonatomic, strong) WCRedEnvelopMsgModel *appmsg;          /**<    appmsg      */

@end


