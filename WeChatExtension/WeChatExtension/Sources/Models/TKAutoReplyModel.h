//
//  TKAutoReplyModel.h
//  WeChatPlugin
//
//  Created by TK on 2017/8/18.
//  Copyright © 2017年 tk. All rights reserved.
//

#import "TKBaseModel.h"

@interface TKAutoReplyModel : TKBaseModel

@property (nonatomic, assign) BOOL enable;                  /**<    是否开启自动回复     */
@property (nonatomic, copy) NSString *keyword;              /**<    自动回复关键字       */
@property (nonatomic, copy) NSString *replyContent;         /**<    自动回复的内容       */
@property (nonatomic, assign) BOOL enableGroupReply;        /**<    是否开启群聊自动回复  */
@property (nonatomic, assign) BOOL enableSingleReply;       /**<    是否开启私聊自动回复  */
@property (nonatomic, assign) BOOL enableRegex;             /**<    是否开启正则匹配     */
@property (nonatomic, assign) BOOL enableDelay;             /**<    是否开启延迟回复     */
@property (nonatomic, assign) NSInteger delayTime;          /**<    延迟时间            */
@property (nonatomic, assign) BOOL enableSpecificReply;     /**<    是否开启特定回复     */
@property (nonatomic, strong) NSArray *specificContacts;    /**<    特定回复的联系人     */

- (BOOL)hasEmptyKeywordOrReplyContent;

@end
