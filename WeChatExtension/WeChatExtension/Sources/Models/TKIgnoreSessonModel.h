//
//  TKIgnoreSessonModel.h
//  WeChatExtension
//
//  Created by WeChatExtension on 2019/9/15.
//  Copyright © 2019年 WeChatExtension. All rights reserved.
//

#import "YMBaseModel.h"

@interface TKIgnoreSessonModel : YMBaseModel

@property (nonatomic, copy) NSString *selfContact;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign) BOOL ignore;

@end
