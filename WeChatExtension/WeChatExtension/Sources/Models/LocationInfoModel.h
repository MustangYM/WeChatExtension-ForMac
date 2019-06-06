//
//  LocationInfoModel.h
//  WeChatExtension
//
//  Created by zhouwei on 2019/6/6.
//  Copyright © 2019年 MustangYM. All rights reserved.
//

#import "TKBaseModel.h"

@interface LocationModel : TKBaseModel

@property (nonatomic, copy) NSString *maptype;              /**<   地图类型      */
@property (nonatomic, copy) NSString *x;                    /**<    x(经度)       */
@property (nonatomic, copy) NSString *y;                    /**<    y(纬度)       */
@property (nonatomic, copy) NSString *poiname;              /**<    poiname       */
@property (nonatomic, copy) NSString *label;                /**<    label       */
@property (nonatomic, copy) NSString *poiid;                /**<    poiid       */
@property (nonatomic, copy) NSString *scale;                /**<    scale 地图比例       */

@end

@interface LocationInfoModel : TKBaseModel

@property (nonatomic, strong) LocationModel *location;      /**<    定位信息      */

@end
