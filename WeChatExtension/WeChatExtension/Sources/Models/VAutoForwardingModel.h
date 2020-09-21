//
//  Test.h
//  WeChatExtension
//
//  Created by Wetoria V on 2020/7/8.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import "YMBaseModel.h"

@interface VAutoForwardingModel : YMBaseModel

@property (nonatomic, assign) BOOL enable;                        /**<    是否开启自动转发     */
@property (nonatomic, strong) NSMutableArray *forwardingFromContacts;    /**<    需要转发的聊天列表     */
@property (nonatomic, strong) NSMutableArray *forwardingToContacts;      /**<    需要接受转发消息的聊天列表     */

@end

