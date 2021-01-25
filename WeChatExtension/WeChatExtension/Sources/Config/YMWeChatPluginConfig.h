//
//  YMWeChatPluginConfig.h
//  WeChatExtension
//
//  Created by WeChatExtension on 2019/4/19.
//  Copyright © 2019年 WeChatExtension. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "GVUserDefaults.h"
#import <AppKit/AppKit.h>
#import "WeChatPlugin.h"

typedef NS_ENUM(NSInteger, PluginLanguageType) {
    PluginLanguageTypeZH,
    PluginLanguageTypeEN
};

@class YMAIAutoModel, VAutoForwardingModel, YMZGMPGroupInfo;

@interface YMWeChatPluginConfig : GVUserDefaults

@property (nonatomic) BOOL preventRevokeEnable;                 /**<    是否开启防撤回    */
@property (nonatomic) BOOL preventSelfRevokeEnable;             /**<    是否防撤回自己    */
@property (nonatomic) BOOL preventAsyncRevokeToPhone;           /**<    是否将防撤回同步到手机    */
@property (nonatomic) BOOL preventAsyncRevokeSignal;            /**<    只同步单聊    */
@property (nonatomic) BOOL preventAsyncRevokeChatRoom;          /**<    只同步群聊    */
@property (nonatomic) BOOL autoReplyEnable;                     /**<    是否开启自动回复  */
@property (nonatomic) BOOL AIReplyEnable;                     /**<    是否开启自动回复  */
@property (nonatomic) BOOL autoForwardingEnable;                /**<    是否开启自动转发  */
@property (nonatomic) BOOL autoForwardingAllFriend;             /**<    开启自动转发所有好友消息  */
@property (nonatomic) BOOL autoAuthEnable;                      /**<    是否免认证登录    */
@property (nonatomic) BOOL launchFromNew;                       /**<    是否是从 -> 登录新微信 -> 启动      */
@property (nonatomic) BOOL quitMonitorEnable;
@property (nonatomic) BOOL autoLoginEnable;                     /**<    是否自动登录      */
@property (nonatomic) BOOL onTop;                               /**<    是否要置顶微信    */
@property (nonatomic) BOOL multipleSelectionEnable;             /**<    是否要进行多选    */
@property (nonatomic) BOOL forbidCheckVersion;                  /**<    禁止检测版本      */
@property (nonatomic) BOOL alfredEnable;                        /**<    是否开启Alfred   */
@property (nonatomic) BOOL checkUpdateWechatEnable;             /**<    是否允许微信启动检测更新  */
@property (nonatomic) BOOL systemBrowserEnable;                 /**<    是否使用自身浏览器打开连接   */
@property (nonatomic, copy) NSString *currentUserName;          /**<    当前用户的id     */
@property (nonatomic) BOOL isAllowMoreOpenBaby;                 /**<    子WeChat多开     */

@property (nonatomic) BOOL fuzzyMode;                           /**<    模糊模式     */
@property (nonatomic) BOOL darkMode;                            /**<    黑暗模式     */
@property (nonatomic) BOOL blackMode;                           /**<    深邃模式     */
@property (nonatomic) BOOL pinkMode;                            /**<    少女模式     */
@property (nonatomic) BOOL closeThemeMode;                      /**<    原始模式     */
@property (nonatomic) BOOL isThemeLoaded;                       /**<    是否有使用过皮肤    */

@property (nonatomic, strong) NSMutableArray *autoReplyModels;           /**<    自动回复的    */
@property (nonatomic, strong) NSMutableArray *remoteControlModels;       /**<    远程控制的    */
@property (nonatomic, strong) NSMutableArray *ignoreSessionModels;       /**<    聊天置底的    */
@property (nonatomic, strong) NSMutableArray *selectSessions;            /**<    已经选中的会话    */
@property (nonatomic, strong) NSMutableSet *revokeMsgSet;                /**<    撤回的消息    */
@property (nonatomic, strong) NSMutableSet *unreadSessionSet;            /**<    标记未读消息    */
@property (nonatomic, copy, readonly) NSDictionary *localInfoPlist;
@property (nonatomic, copy, readonly) NSDictionary *romoteInfoPlist;
@property (nonatomic, strong) VAutoForwardingModel *VAutoForwardingModel;      /**<    自动转发的数组    */
@property (nonatomic, strong) NSMutableArray *banModels;                /**<    屏蔽的群    */
@property (nonatomic, strong) YMAIAutoModel *AIReplyModel;
@property (nonatomic) PluginLanguageType languageType;
@property (nonatomic, weak) MMBrandChatsViewController *brandChatsViewController;
@property (nonatomic, weak) MMChatsTableCellView *preChatsCellView;

- (void)saveBanGroup:(YMZGMPGroupInfo *)info;
- (void)saveBanModels;
- (void)saveAutoReplyModels;
- (void)saveRemoteControlModels;
- (void)saveIgnoreSessionModels;
- (void)saveAutoForwardingModel:(VAutoForwardingModel *)model;
- (void)saveAIAutoReplyModel:(YMAIAutoModel *)model;
+ (instancetype)sharedConfig;
- (NSString *)getSandboxFilePathWithPlistName:(NSString *)plistName;

- (void)saveMonitorQuitMembers:(NSMutableArray *)members;
- (NSMutableArray *)getMonitorQuitMembers;
- (NSString *)languageSetting:(NSString *)chinese english:(NSString *)english;

- (BOOL)usingTheme;
- (BOOL)usingDarkTheme;

- (NSColor *)mainBackgroundColor;
- (NSColor *)mainTextColor;
- (NSColor *)mainIgnoredBackgroundColor;
- (NSColor *)mainIgnoredTextColor;
- (NSColor *)mainSeperatorColor;
- (NSColor *)mainScrollerColor;
- (NSColor *)mainDividerColor;
- (NSColor *)mainChatCellBackgroundColor;
@end

