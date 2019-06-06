//
//  AppModelInfo.m
//  WeChatExtension
//
//  Created by zhouwei on 2019/6/6.
//  Copyright © 2019年 MustangYM. All rights reserved.
//

#import "AppModelInfo.h"

@implementation AppInfoModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.version = [dict[@"version"][@"text"] integerValue];
        self.appname = dict[@"appname"][@"text"];
    }
    return self;
}

@end



@implementation AppMsgModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.type = [dict[@"type"][@"text"] integerValue];
        self.title = dict[@"title"][@"text"];
        self.des = dict[@"des"][@"text"];
    }
    return self;
}

@end


@implementation AppModelInfo

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.appinfo = [[AppInfoModel alloc] initWithDict:dict[@"appinfo"]];
         self.appmsg = [[AppMsgModel alloc] initWithDict:dict[@"appmsg"]];
//        self.enable = [dict[@"enable"] boolValue];
//        self.keyword = dict[@"keyword"];
//        self.replyContent = dict[@"replyContent"];
//        self.enableGroupReply = [dict[@"enableGroupReply"] boolValue];
//        self.enableSingleReply = [dict[@"enableSingleReply"] boolValue];
//        self.enableRegex = [dict[@"enableRegex"] boolValue];
//        self.enableDelay = [dict[@"enableDelay"] boolValue];
//        self.delayTime = [dict[@"delayTime"] floatValue];
//        self.enableSpecificReply = [dict[@"enableSpecificReply"] boolValue];
//        self.specificContacts = dict[@"specificContacts"] ? : [NSArray array];
    }
    return self;
}

- (NSDictionary *)dictionary {
    return @{
             @"appinfo": self.appinfo,
             @"appmsg": self.appmsg,
             };
//    return @{@"enable": @(self.enable),
//             @"keyword": self.keyword,
//             @"replyContent": self.replyContent,
//             @"enableGroupReply": @(self.enableGroupReply),
//             @"enableSingleReply": @(self.enableSingleReply),
//             @"enableRegex": @(self.enableRegex),
//             @"enableDelay": @(self.enableDelay),
//             @"delayTime": @(self.delayTime),
//             @"enableSpecificReply": @(self.enableSpecificReply),
//             @"specificContacts": self.specificContacts
//             };
}


@end



/**
 * 微信红包
 **/

@implementation WCRedEnvelopPayInfoModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.nativeurl = dict[@"nativeurl"][@"text"];
    }
    return self;
}

@end

@implementation WCRedEnvelopMsgModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.type = [dict[@"type"][@"text"] integerValue];
        self.title = dict[@"title"][@"text"];
        self.des = dict[@"des"][@"text"];
        self.wcpayinfo = [[WCRedEnvelopPayInfoModel alloc]initWithDict:dict[@"wcpayinfo"]];
    }
    return self;
}

@end

@implementation WCRedEnvelopesModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.appmsg = [[WCRedEnvelopMsgModel alloc] initWithDict:dict[@"appmsg"]];
        //        self.enable = [dict[@"enable"] boolValue];
        //        self.keyword = dict[@"keyword"];
        //        self.replyContent = dict[@"replyContent"];
        //        self.enableGroupReply = [dict[@"enableGroupReply"] boolValue];
        //        self.enableSingleReply = [dict[@"enableSingleReply"] boolValue];
        //        self.enableRegex = [dict[@"enableRegex"] boolValue];
        //        self.enableDelay = [dict[@"enableDelay"] boolValue];
        //        self.delayTime = [dict[@"delayTime"] floatValue];
        //        self.enableSpecificReply = [dict[@"enableSpecificReply"] boolValue];
        //        self.specificContacts = dict[@"specificContacts"] ? : [NSArray array];
    }
    return self;
}

- (NSDictionary *)dictionary {
    return @{
             @"appmsg": self.appmsg,
             };
    //    return @{@"enable": @(self.enable),
    //             @"keyword": self.keyword,
    //             @"replyContent": self.replyContent,
    //             @"enableGroupReply": @(self.enableGroupReply),
    //             @"enableSingleReply": @(self.enableSingleReply),
    //             @"enableRegex": @(self.enableRegex),
    //             @"enableDelay": @(self.enableDelay),
    //             @"delayTime": @(self.delayTime),
    //             @"enableSpecificReply": @(self.enableSpecificReply),
    //             @"specificContacts": self.specificContacts
    //             };
}


@end
