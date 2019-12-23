//
//  TKWeChatPluginConfig.h
//  WeChatExtension
//
//  Created by WeChatExtension on 2017/4/19.
//  Copyright © 2017年 WeChatExtension. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PluginLanguageType) {
    PluginLanguageTypeZH,
    PluginLanguageTypeEN
};

@class YMAIAutoModel;
@interface TKWeChatPluginConfig : NSObject

@property (nonatomic, assign) BOOL preventRevokeEnable;                 /**<    是否开启防撤回    */
@property (nonatomic, assign) BOOL preventSelfRevokeEnable;             /**<    是否防撤回自己    */
@property (nonatomic, assign)  BOOL preventAsyncRevokeToPhone;           /**<    是否将防撤回同步到手机    */
@property (nonatomic, assign) BOOL preventAsyncRevokeSignal;             /**<    只同步单聊    */
@property (nonatomic, assign) BOOL preventAsyncRevokeChatRoom;           /**<    只同步群聊    */
@property (nonatomic, assign) BOOL autoReplyEnable;                     /**<    是否开启自动回复  */
@property (nonatomic, assign) BOOL autoAuthEnable;                      /**<    是否免认证登录    */
@property (nonatomic, assign) BOOL autoLoginEnable;                     /**<    是否自动登录      */
@property (nonatomic, assign) BOOL onTop;                               /**<    是否要置顶微信    */
@property (nonatomic, assign) BOOL multipleSelectionEnable;             /**<    是否要进行多选    */
@property (nonatomic, assign) BOOL forbidCheckVersion;                  /**<    禁止检测版本      */
@property (nonatomic, assign) BOOL alfredEnable;                        /**<    是否开启Alfred   */
@property (nonatomic, assign) BOOL checkUpdateWechatEnable;             /**<    是否允许微信启动检测更新  */
@property (nonatomic, assign) BOOL systemBrowserEnable;                 /**<    是否使用自身浏览器打开连接   */
@property (nonatomic, strong) NSMutableArray *autoReplyModels;           /**<    自动回复的数组    */
@property (nonatomic, strong) NSMutableArray *remoteControlModels;       /**<    远程控制的数组    */
@property (nonatomic, strong) NSMutableArray *ignoreSessionModels;       /**<    聊天置底的数组    */
@property (nonatomic, strong) NSMutableArray *selectSessions;            /**<    已经选中的会话    */
@property (nonatomic, strong) NSMutableSet *revokeMsgSet;                /**<    撤回的消息集合    */
@property (nonatomic, strong) NSMutableSet *unreadSessionSet;            /**<    标记未读消息集合    */
@property (nonatomic, copy) NSString *currentUserName;                   /**<    当前用户的id     */
@property (nonatomic, copy, readonly) NSDictionary *localInfoPlist;
@property (nonatomic, copy, readonly) NSDictionary *romoteInfoPlist;
@property (nonatomic, strong) YMAIAutoModel *AIReplyModel;
@property (nonatomic, assign) PluginLanguageType languageType;
- (void)saveAutoReplyModels;
- (void)saveRemoteControlModels;
- (void)saveIgnoreSessionModels;
- (void)saveAIAutoReplyModel:(YMAIAutoModel *)model;
+ (instancetype)sharedConfig;

@end

