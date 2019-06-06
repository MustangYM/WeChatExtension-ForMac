//
//  LocationInfoModel.m
//  WeChatExtension
//
//  Created by zhouwei on 2019/6/6.
//  Copyright © 2019年 MustangYM. All rights reserved.
//

#import "LocationInfoModel.h"

@implementation LocationModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
         self.maptype = dict[@"maptype"];
         self.x = dict[@"x"];
         self.y = dict[@"y"];
         self.poiname = dict[@"poiname"];
         self.label = dict[@"label"];
         self.poiid = dict[@"poiid"];
         self.scale = dict[@"scale"];
    }
    return self;
}

@end

@implementation LocationInfoModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.location = [[LocationModel alloc] initWithDict:dict[@"location"]];
    }
    return self;
}

@end
