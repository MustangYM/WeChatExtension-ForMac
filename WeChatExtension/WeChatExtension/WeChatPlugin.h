//
//  WeChatExtension.h
//  WeChatExtension
//
//  Created by WeChatExtension on 2019/4/19.
//  Copyright © 2019年 WeChatExtension. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

FOUNDATION_EXPORT double WeChatPluginVersionNumber;
FOUNDATION_EXPORT const unsigned char WeChatPluginVersionString[];

@interface MMFileTypeHelper : NSObject
+ (id)firstFrameImageOfVideoWithFilePath:(id)arg1;
@end

@interface SendVideoinfo : NSObject
@property(retain, nonatomic) NSString *m_nsMsgSource; // @synthesize m_nsMsgSource=_m_nsMsgSource;
@property(nonatomic) BOOL m_bForward; // @synthesize m_bForward=_m_bForward;
@property(nonatomic) unsigned int m_uiVideoSource; // @synthesize m_uiVideoSource=_m_uiVideoSource;
@property(nonatomic) unsigned int video_size; // @synthesize video_size=_video_size;
@property(nonatomic) unsigned int video_time; // @synthesize video_time=_video_time;
@property(retain, nonatomic) NSString *video_path; // @synthesize video_path=_video_path;
@property(retain, nonatomic) NSString *thumb_path; // @synthesize thumb_path=_thumb_path;
@end

@interface SendImageInfo : NSObject <NSCopying>
@property (nonatomic, assign) unsigned int m_uiOriginalHeight; // @synthesize m_uiOriginalHeight=_m_uiOriginalHeight;
@property (nonatomic, assign) unsigned int m_uiOriginalWidth; // @synthesize m_uiOriginalWidth=_m_uiOriginalWidth;
@property (nonatomic, assign) unsigned int m_uiThumbHeight; // @synthesize m_uiThumbHeight=_m_uiThumbHeight;
@property (nonatomic, assign) unsigned int m_uiThumbWidth; // @synthesize m_uiThumbWidth=_m_uiThumbWidth;
- (id)init;
@end

@class WCContactData;
@interface MMMessageSendLogic : NSObject
- (void)sendImageMessageWithImage:(id)arg1;
- (void)sendVideoMessageWithFileUrl:(id)arg1;
- (void)sendVideoMessageWithFileUrl:(id)arg1 leavedMessage:(id)arg2;
@property(retain, nonatomic) WCContactData *currnetChatContact;
@end

@interface MMCDNDownloadMgrExt : NSObject
- (void)cdnDownloadMgrDownloaded:(int)arg1 of:(int)arg2 withMessage:(id)arg3 type:(int)arg4 tryShow:(BOOL)arg5;
@end

@interface MMMessageCacheMgr : NSObject
- (void)originalImageWithMessage:(id)arg1 completion:(id)arg2;
- (void)originalImageWithPreviewMessage:(id)arg1 completion:(id)arg2;
- (void)downloadImageWithURLString:(id)arg1 message:(id)arg2 completion:(id)arg3;
- (void)originalImageWithMessage:(id)arg1 completion:(id)arg2;
@end

@interface MMBrandChatsViewController : NSViewController
- (void)startChatWithContact:(id)arg1;
@end

@interface MMLoginOneClickViewController : NSViewController
@property(nonatomic) NSTextField *descriptionLabel;
- (void)onLoginButtonClicked:(id)arg1;
@property(nonatomic) NSButton *loginButton;
@end

@interface AccountService : NSObject
- (id)GetLastLoginUserName;
- (id)GetLastLoginAutoAuthKey;
- (BOOL)canAutoAuth;
- (void)AutoAuth;
- (void)ManualLogin:(id)arg1 withPassword:(id)arg2;
- (void)ManualLogout;
- (void)FFAddSvrMsgImgVCZZ;
- (void)QRCodeLoginWithUserName:(id)arg1 password:(id)arg2;
- (void)onAuthOKOfUser:(id)arg1 withSessionKey:(id)arg2 withServerId:(id)arg3 autoAuthKey:(id)arg4 isAutoAuth:(BOOL)arg5;
@end

@interface MMLoginViewController : NSViewController
@property(retain, nonatomic) MMLoginOneClickViewController *oneClickViewController;
@end

@interface MMMouseEventView : NSView

@end

@class MMMainViewController;
@interface MMMainWindowController : NSWindowController
@property(retain, nonatomic) MMMouseEventView *maskView;
@property(retain, nonatomic) MMLoginViewController *loginViewController;
@property(retain, nonatomic) MMMainViewController *mainViewController; // @synthesize mainViewController=_mainViewController;
- (void)onAuthOK;
- (void)onLogOut;
@end

@interface MMImageView : NSImageView

@end

@interface MMLoginQRCodeViewController : NSViewController
@property(nonatomic) __weak MMImageView *qrCodeImgView;
- (void)updateQRCodeImage:(id)arg1;
@end

@interface MessageService : NSObject
- (void)onAddMsg:(id)arg1 msgData:(id)arg2;
- (void)notifyAddMsgOnMainThread:(id)arg1 msgData:(id)arg2;
- (void)onRevokeMsg:(id)arg1;
- (void)FFToNameFavChatZZ:(id)arg1;
- (void)FFToNameFavChatZZ:(id)arg1 sessionMsgList:(id)arg2;
- (void)OnSyncBatchAddMsgs:(NSArray *)arg1 isFirstSync:(BOOL)arg2;
- (void)OnSyncBatchAddFunctionMsgs:(id)arg1 isFirstSync:(BOOL)arg2;
- (void)FFImgToOnFavInfoInfoVCZZ:(id)arg1 isFirstSync:(BOOL)arg2;
- (id)GetMsgListWithChatName:(id)arg1 fromCreateTime:(unsigned int)arg2 limitCnt:(NSInteger)arg3 hasMore:(char *)arg4 sortAscend:(BOOL)arg5;
- (id)SendTextMessage:(id)arg1 toUsrName:(id)arg2 msgText:(id)arg3 atUserList:(id)arg4;
- (id)SendImgMessage:(id)arg1 toUsrName:(id)arg2 thumbImgData:(id)arg3 midImgData:(id)arg4 imgData:(id)arg5 imgInfo:(id)arg6;
- (id)SendVideoMessage:(id)arg1 toUsrName:(id)arg2 videoInfo:(id)arg3 msgType:(unsigned int)arg4 refMesageData:(id)arg5;
- (id)SendLocationMsgFromUser:(id)arg1 toUser:(id)arg2 withLatitude:(double)arg3 longitude:(double)arg4 poiName:(id)arg5 label:(id)arg6;
- (id)SendNamecardMsgFromUser:(id)arg1 toUser:(id)arg2 containingContact:(id)arg3;
- (id)SendEmoticonMsgFromUsr:(id)arg1 toUsrName:(id)arg2 md5:(id)arg3 emoticonType:(unsigned int)arg4;
- (id)SendAppURLMessageFromUser:(id)arg1 toUsrName:(id)arg2 withTitle:(id)arg3 url:(id)arg4 description:(id)arg5 thumbnailData:(id)arg6;

- (id)GetMsgData:(id)arg1 svrId:(long)arg2;
- (void)AddLocalMsg:(id)arg1 msgData:(id)arg2;
- (void)TranscribeVoiceMessage:(id)arg1 completion:(void (^)(void))arg2;
- (BOOL)ClearUnRead:(id)arg1 FromID:(unsigned int)arg2 ToID:(unsigned int)arg3;
- (BOOL)ClearUnRead:(id)arg1 FromCreateTime:(unsigned int)arg2 ToCreateTime:(unsigned int)arg3;
- (BOOL)hasMsgInChat:(id)arg1;
- (BOOL)HasMsgInChat:(id)arg1;
- (id)GetMsgListWithChatName:(id)arg1 fromLocalId:(unsigned int)arg2 limitCnt:(NSInteger)arg3 hasMore:(char *)arg4 sortAscend:(BOOL)arg5;
- (id)GetMsgListWithChatName:(id)arg1 fromMinCreateTime:(unsigned int)arg2 localId:(unsigned long long)arg3 limitCnt:(unsigned int)arg4 hasMore:(char *)arg5;
- (id)GetMsgListWithChatName:(id)arg1 fromCreateTime:(unsigned int)arg2 localId:(unsigned long long)arg3 limitCnt:(unsigned int)arg4 hasMore:(char *)arg5 sortAscend:(BOOL)arg6;

- (id)ForwardMessage:(id)arg1 toUser:(id)arg2 errMsg:(id *)arg3;
@end

@interface IMessageExt : NSObject
- (void)onMsgDownloadThumbOK:(NSString *)arg1 msgData:(id)arg2;
@end

@interface MMServiceCenter : NSObject
+ (id)defaultCenter;
- (id)getService:(Class)arg1;
@end

@interface SKBuiltinString_t : NSObject
@property(retain, nonatomic, setter=SetString:) NSString *string; // @synthesize string;
@end

@interface SKBuiltinBuffer_t : NSObject
@property (nonatomic, strong) NSData *buffer;
@end

@interface AddMsg : NSObject
+ (id)parseFromData:(id)arg1;
@property(retain, nonatomic, setter=SetPushContent:) NSString *pushContent;
@property(readonly, nonatomic) BOOL hasPushContent;
@property(retain, nonatomic, setter=SetMsgSource:) NSString *msgSource;
@property(readonly, nonatomic) BOOL hasMsgSource;
@property(readonly, nonatomic) BOOL hasCreateTime;
@property(readonly, nonatomic) BOOL hasImgBuf;
@property(nonatomic, setter=SetImgStatus:) unsigned int imgStatus;
@property(readonly, nonatomic) BOOL hasImgStatus;
@property(nonatomic, setter=SetStatus:) unsigned int status;

@property(retain, nonatomic, setter=SetContent:) SKBuiltinString_t *content;
@property(retain, nonatomic, setter=SetFromUserName:) SKBuiltinString_t *fromUserName;
@property(nonatomic, setter=SetMsgType:) int msgType;
@property(retain, nonatomic, setter=SetToUserName:) SKBuiltinString_t *toUserName;
@property (nonatomic, assign) unsigned int createTime;
@property(nonatomic, setter=SetNewMsgId:) long long newMsgId;
@property (nonatomic, strong) SKBuiltinBuffer_t *imgBuf;
@end

@interface MMChatsViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>
@property(nonatomic) __weak NSTableView *tableView;
@property(retain, nonatomic) MMBrandChatsViewController *brandChatsViewController;
@property(retain, nonatomic) NSString *selectedUserName; // @synthesize selectedUserName=_selectedUserName;
@property(retain, nonatomic) NSButton *startNewChatButton;
- (void)reloadTableView;
@end

@interface MMContactsViewController : NSViewController
@property(nonatomic) __weak NSTableView *tableView;
@end

@interface MMComposeTextView : NSTextView

@end

@interface MMFavoritesListMediaCell : NSView

@end

@interface MMHandoffButton : NSButton

@end

@interface MMMainViewController : NSViewController
@property(retain, nonatomic) MMChatsViewController *chatsViewController;
@property(nonatomic) __weak MMHandoffButton *handoffButton; // @synthesize handoffButton=_handoffButton;
- (void)viewDidLoad;
- (void)dealloc;
- (void)onReceiveNewHandoff:(id)arg1;
- (void)onUpdateHandoffExpt:(BOOL)arg1;
- (void)showHandoffView:(id)arg1;
@end

@interface WeChat : NSObject
+ (id)sharedInstance;
@property(nonatomic) MMChatsViewController *chatsViewController;
@property(retain, nonatomic) MMMainWindowController *mainWindowController;
@property(nonatomic) BOOL isAppTerminating;
@property(nonatomic) BOOL hasAuthOK;
- (void)startANewChatWithContact:(id)arg1;
- (void)_clearAllUnreadMessages:(id)arg1;
- (void)onAuthOK:(BOOL)arg1;
- (void)checkForUpdatesInBackground;
- (void)setupCheckUpdateIfNeeded;
- (BOOL)isTaskProgress;
@end

@interface ContactStorage : NSObject
- (id)GetSelfContact;
- (id)GetContact:(id)arg1;
- (id)GetAllBrandContacts;
- (id)GetAllFavContacts;
- (id)GetAllFriendContacts;
- (id)GetContactWithUserName:(id)arg1 updateIfNeeded:(BOOL)arg2;
- (id)getContactCache:(id)arg1;
- (id)GetContactsWithUserNames:(id)arg1;
- (id)GetGroupMemberContact:(id)arg1;
- (id)GetGroupContact:(id)arg1;
- (id)GetAllGroups;
- (id)GetGroupContactList:(id)arg1 ContactType:(id)arg2;
- (BOOL)IsFriendContact:(id)arg1;
@end

@interface GroupMember : NSObject
@property(copy, nonatomic) NSString *m_nsSignature; // @synthesize m_nsSignature=_m_nsSignature;
@property(copy, nonatomic) NSString *m_nsCity; // @synthesize m_nsCity=_m_nsCity;
@property(copy, nonatomic) NSString *m_nsProvince; // @synthesize m_nsProvince=_m_nsProvince;
@property(copy, nonatomic) NSString *m_nsCountry; // @synthesize m_nsCountry=_m_nsCountry;
@property(copy, nonatomic) NSString *m_nsRemarkFullPY; // @synthesize m_nsRemarkFullPY=_m_nsRemarkFullPY;
@property(copy, nonatomic) NSString *m_nsRemarkShortPY; // @synthesize m_nsRemarkShortPY=_m_nsRemarkShortPY;
@property(copy, nonatomic) NSString *m_nsRemark; // @synthesize m_nsRemark=_m_nsRemark;
@property(nonatomic) unsigned int m_uiSex; // @synthesize m_uiSex=_m_uiSex;
@property(copy, nonatomic) NSString *m_nsFullPY; // @synthesize m_nsFullPY=_m_nsFullPY;
@property(copy, nonatomic) NSString *m_nsNickName; // @synthesize m_nsNickName=_m_nsNickName;
@property(nonatomic) unsigned int m_uiMemberStatus; // @synthesize m_uiMemberStatus=_m_uiMemberStatus;
@property(copy, nonatomic) NSString *m_nsMemberName; // @synthesize m_nsMemberName=_m_nsMemberName;
@end

@interface GroupStorage : NSObject
{
    NSMutableDictionary *m_dictGroupContacts;
}
- (id)GetAllGroups;
- (id)GetGroupMemberContact:(id)arg1;
- (id)GetGroupContactsWithUserNames:(id)arg1;
- (id)GetGroupContact:(id)arg1;
- (void)UpdateGroupMemberDetailIfNeeded:(id)arg1 withCompletion:(id)arg2;
- (BOOL)IsGroupContactExist:(id)arg1;
- (BOOL)IsGroupMemberContactExist:(id)arg1;
- (id)GetGroupContactList:(unsigned int)arg1 ContactType:(unsigned int)arg2;
- (BOOL)AddGroupMembers:(id)arg1 withGroupUserName:(id)arg2 completion:(id)arg3;
- (void)CreateGroupChatWithTopic:(id)arg1 groupMembers:(id)arg2 completion:(id)arg3;
- (void)addChatMemberNeedVerifyMsg:(id)arg1 ContactList:(id)arg2;
- (BOOL)QuitGroup:(id)arg1 completion:(id)arg2;
- (BOOL)UIQuitGroup:(id)arg1;
- (BOOL)UIQuitGroup:(id)arg1 withConfirm:(BOOL)arg2 completion:(id)arg3;
- (id)GetGroupMemberListWithGroupUserName:(id)arg1 limit:(unsigned int)arg2 filterSelf:(BOOL)arg3;
@end

@interface ChatRoomData : NSObject
@property(retain, nonatomic) NSMutableDictionary *m_dicData;
@end

@interface WCContactData : NSObject
@property(retain, nonatomic) NSString *m_nsUsrName; // @synthesize m_nsUsrName;
@property(nonatomic) unsigned int m_uiFriendScene;  // @synthesize m_uiFriendScene;
@property(retain, nonatomic) NSString *m_nsNickName;    // 用户昵称
@property(retain, nonatomic) NSString *m_nsRemark;      // 备注
@property(retain, nonatomic) NSString *m_nsHeadImgUrl;  // 头像
@property(retain, nonatomic) NSString *m_nsHeadHDImgUrl;
@property(retain, nonatomic) NSString *m_nsHeadHDMd5;
@property(retain, nonatomic) NSString *m_nsAliasName;
@property(retain, nonatomic) NSString *avatarCacheKey;
@property(retain, nonatomic) NSString *msgFromNickName;
@property(retain, nonatomic) NSString *m_nsOwner;
@property(retain, nonatomic) NSString *m_nsChatRoomMemList;
@property(retain, nonatomic) ChatRoomData *m_chatRoomData;
@property(nonatomic) unsigned int m_uiSex;
@property(nonatomic) BOOL m_isShowRedDot;
- (BOOL)isBrandContact;
- (BOOL)isSelf;
- (id)getGroupDisplayName;
- (id)getContactDisplayUsrName;
- (BOOL)isGroupChat;
- (BOOL)isMMChat;
- (BOOL)isMMContact;
@end

@interface CExtendInfoOfAPP : NSObject
@property(nonatomic) unsigned int m_uiWeAppVersion; // @synthesize m_uiWeAppVersion=_m_uiWeAppVersion;
@property(nonatomic) unsigned int m_uiWeAppState; // @synthesize m_uiWeAppState=_m_uiWeAppState;
@property(retain, nonatomic) NSString *referMessageSenderDisplayName; // @synthesize referMessageSenderDisplayName=_referMessageSenderDisplayName;
@property(retain, nonatomic) NSString *referMessageSenderUsrname; // @synthesize referMessageSenderUsrname=_referMessageSenderUsrname;
@property(nonatomic) unsigned int m_realInnerType; // @synthesize m_realInnerType;
@property(nonatomic) unsigned int m_fullXmlLength; // @synthesize m_fullXmlLength;
@property(copy, nonatomic) NSString *m_authKey; // @synthesize m_authKey;
@property(retain, nonatomic) NSString *m_nsMsgMd5; // @synthesize m_nsMsgMd5;
@property(retain, nonatomic) NSString *m_nsJsAppId; // @synthesize m_nsJsAppId;
@property(retain, nonatomic) NSString *m_nsShareOriginUrl; // @synthesize m_nsShareOriginUrl;
@property(retain, nonatomic) NSString *m_nsShareOpenUrl; // @synthesize m_nsShareOpenUrl;
@property(nonatomic) BOOL m_isDirectSend; // @synthesize m_isDirectSend;
@property(nonatomic) unsigned int m_uiPercent; // @synthesize m_uiPercent;
@property(nonatomic) BOOL m_bIsForceUpdate; // @synthesize m_bIsForceUpdate;
@property(retain, nonatomic) NSString *m_nsAppMediaTagName; // @synthesize m_nsAppMediaTagName;
@property(retain, nonatomic) NSString *m_nsDisplayName; // @synthesize m_nsDisplayName;
@property(retain, nonatomic) NSString *m_nsImgSrc; // @synthesize m_nsImgSrc;
@property(retain, nonatomic) NSArray *m_arrReaderWaps; // @synthesize m_arrReaderWaps;
@property(retain, nonatomic) NSArray *m_arrCustomWrap; // @synthesize m_arrCustomWrap;
@property(nonatomic) unsigned int m_uiShowType; // @synthesize m_uiShowType;
@property(nonatomic) unsigned int m_uiRemindTime; // @synthesize m_uiRemindTime;
@property(nonatomic) unsigned int m_uiRemindId; // @synthesize m_uiRemindId;
@property(nonatomic) unsigned int m_uiRemindFormat; // @synthesize m_uiRemindFormat;
@property(nonatomic) unsigned int m_uiRemindAttachTotalLen; // @synthesize m_uiRemindAttachTotalLen;
@property(nonatomic) unsigned int m_uiOriginMsgSvrId; // @synthesize m_uiOriginMsgSvrId;
@property(nonatomic) unsigned int m_uiOriginFormat; // @synthesize m_uiOriginFormat;
@property(nonatomic) unsigned int m_uiMsgThumbWidth; // @synthesize m_uiMsgThumbWidth;
@property(nonatomic) unsigned int m_uiMsgThumbSize; // @synthesize m_uiMsgThumbSize;
@property(nonatomic) unsigned int m_uiMsgThumbHeight; // @synthesize m_uiMsgThumbHeight;
@property(nonatomic) unsigned int m_uiEncryVer; // @synthesize m_uiEncryVer;
@property(nonatomic) unsigned int m_uiAppVersion; // @synthesize m_uiAppVersion;
@property(nonatomic) unsigned int m_uiAppMsgInnerType; // @synthesize m_uiAppMsgInnerType;
@property(nonatomic) unsigned int m_uiAppExtShowType; // @synthesize m_uiAppExtShowType;
@property(nonatomic) unsigned int m_uiAppDataSize; // @synthesize m_uiAppDataSize;
@property(nonatomic) unsigned int m_uiApiSDKVersion; // @synthesize m_uiApiSDKVersion;
@property(retain, nonatomic) NSString *m_nsTitle; // @synthesize m_nsTitle;
@property(retain, nonatomic) NSString *m_nsThumbUrl; // @synthesize m_nsThumbUrl;
@property(retain, nonatomic) NSString *m_nsSourceUsername; // @synthesize m_nsSourceUsername;
@property(retain, nonatomic) NSString *m_nsSourceDisplayname; // @synthesize m_nsSourceDisplayname;
@property(retain, nonatomic) NSString *m_nsRemindAttachId; // @synthesize m_nsRemindAttachId;
@property(retain, nonatomic) NSString *m_nsMsgThumbMd5; // @synthesize m_nsMsgThumbMd5;
@property(retain, nonatomic) NSString *m_nsMsgThumbUrl; // @synthesize m_nsMsgThumbUrl;
@property(retain, nonatomic) NSString *m_nsMsgThumbAesKey; // @synthesize m_nsMsgThumbAesKey;
@property(retain, nonatomic) NSString *m_nsMsgAttachUrl; // @synthesize m_nsMsgAttachUrl;
@property(retain, nonatomic) NSString *m_nsEmoticonMD5; // @synthesize m_nsEmoticonMD5;
@property(retain, nonatomic) NSString *m_nsDesc; // @synthesize m_nsDesc;
@property(retain, nonatomic) NSString *m_nsCommentUrl; // @synthesize m_nsCommentUrl;
@property(retain, nonatomic) NSString *m_nsAppName; // @synthesize m_nsAppName;
@property(retain, nonatomic) NSString *m_nsAppMediaUrl; // @synthesize m_nsAppMediaUrl;
@property(retain, nonatomic) NSString *m_nsAppMediaLowUrl; // @synthesize m_nsAppMediaLowUrl;
@property(retain, nonatomic) NSString *m_nsAppMediaLowBandDataUrl; // @synthesize m_nsAppMediaLowBandDataUrl;
@property(retain, nonatomic) NSString *m_nsAppMediaDataUrl; // @synthesize m_nsAppMediaDataUrl;
@property(retain, nonatomic) NSString *m_nsAppID; // @synthesize m_nsAppID;
@property(retain, nonatomic) NSString *m_nsAppFileExt; // @synthesize m_nsAppFileExt;
@property(retain, nonatomic) NSString *m_nsAppMessageAction; // @synthesize m_nsAppMessageAction;
@property(retain, nonatomic) NSString *m_nsAppExtInfo; // @synthesize m_nsAppExtInfo;
@property(retain, nonatomic) NSString *m_nsAppContent; // @synthesize m_nsAppContent;
@property(retain, nonatomic) NSString *m_nsAppAttachID; // @synthesize m_nsAppAttachID;
@property(retain, nonatomic) NSString *m_nsAppAction; // @synthesize m_nsAppAction;
@property(retain, nonatomic) NSString *m_nsAesKey; // @synthesize m_nsAesKey;
@end

@interface MessageData : NSObject
- (id)initWithMsgType:(long long)arg1;
@property(retain, nonatomic) NSString *fromUsrName;
@property(retain, nonatomic) NSString *toUsrName;
@property(retain, nonatomic) NSString *msgContent;
@property(retain, nonatomic) NSString *msgPushContent;
@property(retain, nonatomic) NSString *msgRealChatUsr;
@property(retain, nonatomic) SendImageInfo *imageInfo;
@property(retain, nonatomic) id extendInfoWithMsgType;
@property(nonatomic) int messageType;
@property(nonatomic) int msgStatus;
@property(nonatomic) int msgCreateTime;
@property(nonatomic) int mesLocalID;
@property(nonatomic) long long mesSvrID;
@property(retain, nonatomic) NSString *msgVoiceText;
@property(copy, nonatomic) NSString *m_nsEmoticonMD5;
- (BOOL)isChatRoomMessage;
- (NSString *)groupChatSenderDisplayName;
- (id)getRealMessageContent;
- (id)getChatRoomUsrName;
- (BOOL)isSendFromSelf;
- (BOOL)isCustomEmojiMsg;
- (BOOL)isImgMsg;
- (BOOL)isVideoMsg;
- (BOOL)isVoiceMsg;
- (BOOL)canForward;
- (BOOL)IsPlayingSound;
- (id)summaryString:(BOOL)arg1;
- (BOOL)isEmojiAppMsg;
- (BOOL)isAppBrandMsg;
- (BOOL)IsUnPlayed;
- (void)SetPlayed;
@property(retain, nonatomic) NSString *m_nsTitle;
- (id)originalImageFilePath;
@property(retain, nonatomic) NSString *m_nsVideoPath;
@property (nonatomic, retain) NSString *m_nsVideoThumbPath;
@property(retain, nonatomic) NSString *m_nsFilePath;
@property(retain, nonatomic) NSString *m_nsAppMediaUrl;
@property(nonatomic) MessageData *m_refMessageData;
@property(nonatomic) unsigned int m_uiDownloadStatus;
- (void)SetPlayingSoundStatus:(BOOL)arg1;
@end

@interface CUtility : NSObject
+ (BOOL)HasWechatInstance;
+ (BOOL)FFSvrChatInfoMsgWithImgZZ;
+ (unsigned long long)getFreeDiskSpace;
+ (void)ReloadSessionForMsgSync;
+ (id)GetCurrentUserName;
@end
@interface MMSessionInfoPackedInfo: NSObject
@property(retain, nonatomic) WCContactData *m_contact;
@property(retain, nonatomic) MessageData *m_msgData;
@end

@interface MMSessionInfo : NSObject
@property(nonatomic) BOOL m_bIsTop; // @synthesize m_bIsTop;
@property(nonatomic) BOOL m_bShowUnReadAsRedDot;
@property(nonatomic) BOOL m_isMentionedUnread; // @synthesize
@property(retain, nonatomic) NSString *m_nsUserName; // @synthesize m_nsUserName;
@property(retain, nonatomic) MMSessionInfoPackedInfo *m_packedInfo;
@property(nonatomic) unsigned int m_uUnReadCount; 
@end

@protocol MMChatsTableCellViewDelegate <NSObject>
@optional
- (void)cellViewReloadData:(MMSessionInfo *)arg1;
@end

@interface MMSessionMgr : NSObject
@property(retain, nonatomic) NSMutableArray *m_arrSession;
@property(retain) NSString *m_currentSessionName; // @synthesize m_currentSessionName=_m_currentSessionName;
- (id)getAllSessions;
- (id)GetAllSessions;
- (id)GetSessionAtIndex:(unsigned long long)arg1;//2.3.24废弃
- (id)sessionInfoByUserName:(id)arg1;
- (void)MuteSessionByUserName:(id)arg1;
- (void)muteSessionByUserName:(id)arg1 syncToServer:(BOOL)arg2;
- (void)onUnReadCountChange:(id)arg1;
//- (void)TopSessionByUserName:(id)arg1;
- (void)processOnEnterSession:(id)arg1 isFromLocal:(BOOL)arg2;
- (void)UnmuteSessionByUserName:(id)arg1;
- (void)unmuteSessionByUserName:(id)arg1 syncToServer:(BOOL)arg2;
- (void)untopSessionByUserName:(id)arg1 syncToServer:(BOOL)arg2;
- (void)deleteSessionWithoutSyncToServerWithUserName:(id)arg1;
- (void)storageDeleteSessionInfo:(id)arg1;
- (void)changeSessionUnreadCountWithUserName:(id)arg1 to:(unsigned int)arg2;
- (void)removeSessionOfUser:(id)arg1 isDelMsg:(BOOL)arg2;
- (void)sortSessions;
- (void)FFDataSvrMgrSvrFavZZ;
- (id)getContact:(id)arg1;
- (id)getSessionContact:(id)arg1;
- (void)onEnterSession:(id)arg1;
- (void)loadExtendedMsgData;
- (void)loadBrandSessionData;
- (void)loadSessionData;
- (void)loadData;
- (void)updateGroupChatSessionIfNeeded;
@end

@interface BrandSessionMgr : NSObject
- (void)deleteSessionOfUserName:(id)arg1 isDelMsg:(BOOL)arg2;
@end

@interface LogoutCGI : NSTableCellView
- (void)sendLogoutCGIWithCompletion:(id)arg1;
- (void)FFVCRecvDataAddDataToMsgChatMgrRecvZZ:(id)arg1;
@end

@interface MMNotificationService : NSObject
- (id)getNotificationContentWithMsgData:(id)arg1;
- (void)userNotificationCenter:(id)arg1 didActivateNotification:(id)arg2;
@end

@interface MMMessageScrollView : NSScrollView
- (void)startLoading;
- (void)viewDidMoveToWindow;
@end


@interface MMTableView : NSTableView
@property(nonatomic) __weak id mmTableviewDelegate;
- (void)rightMouseUp:(id)arg1;
- (void)rightMouseDown:(id)arg1;
- (void)didRemoveRowView:(id)arg1 forRow:(long long)arg2;
- (void)mouseUp:(id)arg1;
- (void)mouseDown:(id)arg1;
- (void)scrollRowAtIndexToTop:(unsigned long long)arg1 animated:(BOOL)arg2;
- (void)scrollToTopAnimated:(BOOL)arg1;
- (void)scrollToBottomAnimated:(BOOL)arg1 completion:(id)arg2;
- (void)setFrameSize:(struct CGSize)arg1;
- (void)setFrame:(struct CGRect)arg1;
@end

@protocol MMTableViewDelegate <NSObject>
@optional
- (void)tableView:(MMTableView *)arg1 rowGotDoubleClicked:(long long)arg2;
- (void)tableView:(MMTableView *)arg1 rowGotRightMouseUp:(long long)arg2;
- (void)tableView:(MMTableView *)arg1 rowGotMouseUp:(long long)arg2;
- (void)gotMouseDownNotAtRow:(MMTableView *)arg1;
- (void)tableView:(MMTableView *)arg1 rowGotRightMouseDown:(long long)arg2;
- (void)tableView:(MMTableView *)arg1 rowGotMouseDown:(long long)arg2;
@end

@interface MMChatMessageViewController : NSViewController
- (void)viewDidLoad;
@property(nonatomic) __weak MMTableView *messageTableView;
@property(retain, nonatomic) WCContactData *chatContact;
- (void)onClickSession;
@end

@interface MMMessageTableItem : NSObject
@property(retain, nonatomic) MessageData *message;
@end

@interface MMStickerMessageCellView : NSObject
@property(retain, nonatomic) MMMessageTableItem *messageTableItem;
@property(nonatomic) MMChatMessageViewController *delegate;
- (BOOL)allowCopy;
- (void)contextMenuCopy;
- (id)contextMenu;
@end

@interface MMImageMessageCellView: NSObject
@property(retain, nonatomic) MMMessageTableItem *messageTableItem;
@end

@interface EmoticonMgr : NSObject
@property(retain, nonatomic) MessageData *message;
- (id)getEmotionDataWithMD5:(id)arg1;
- (void)addFavEmoticon:(id)arg1;
- (void)addEmoticonToUploadQueueWithMD5:(id)arg1;
- (void)setAppStickerToastViewDelegate:(id)arg1;
@end

@interface MMComplexContactSearchTaskMgr : NSObject
+ (id)sharedInstance;
- (void)doComplexContactSearch:(id)arg1 searchScene:(unsigned long long)arg2 complete:(void (^)(NSString *,NSArray *, NSArray *, NSArray *,id))arg3 cancelable:(BOOL)arg4;
@end

@interface MMBasicSearchResult : NSObject
@end

@interface MMSearchResultItem : NSObject
@property(retain, nonatomic) MMBasicSearchResult *result;
@end

@interface MMSearchResultContainer : NSObject
@property(nonatomic) unsigned long long logicSearchResultFlag; // @synthesize
@end

@interface MMContactSearchLogic : NSObject
{
    unsigned long long _logicSearchResultFlag;      // 2.3.19 失效
}
@property(retain, nonatomic) NSMutableArray *contactResults;
- (void)doSearchWithKeyword:(id)arg1 searchScene:(unsigned long long)arg2 resultIsShownBlock:(id)arg3 completion:(id)arg4;
@property(retain, nonatomic) NSMutableArray *groupResults;
@property(nonatomic) BOOL isBrandContactSearched;
@property(nonatomic) BOOL isChatLogSearched;
@property(nonatomic) BOOL isContactSearched;
@property(nonatomic) BOOL isGroupContactSearched;
@property(retain, nonatomic) NSMutableArray *oaResults;
- (void)clearAllResults;    //  2.3.19 失效
- (void)clearDataWhenSearchEnd;
- (void)reloadSearchResultDataWithKeyword:(id)arg1 completionBlock:(id)arg2;    //  2.3.17
- (void)reloadSearchResultDataWithCompletionBlock:(id)arg1;                     //  2.3.13
- (void)reloadSearchResultDataWithKeyword:(id)arg1 resultContainer:(id)arg2 completionBlock:(id)arg3;
@property(retain, nonatomic) MMSearchResultContainer *searchResultContainer;
@end

@interface MMComplexContactSearchResult : MMBasicSearchResult
@property(retain, nonatomic) NSString *fieldValue;
@property(retain, nonatomic) WCContactData *contact;
@property(nonatomic) unsigned long long fieldType;  // 1：备注 3：昵称 4：微信号  8：省份  7：市  9：国家
@end

@interface MMComplexGroupContactMembersSearchResult : MMBasicSearchResult
@property(retain, nonatomic) NSMutableArray<MMComplexContactSearchResult *> *membersSearchReults;
@end

@interface MMComplexGroupContactSearchResult : MMBasicSearchResult
@property(nonatomic) unsigned long long searchType;     // 1 名称 2 群成员名称
@property(retain) WCContactData *groupContact;
@property(retain, nonatomic) MMComplexGroupContactMembersSearchResult *groupMembersResult;
@end

@interface MMAvatarService : NSObject
- (id)defaultHDAvatar;
- (NSString *)avatarCachePath;
- (id)_getImageFromCacheWithMD5Key:(id)arg1;
- (void)avatarImageWithContact:(id)arg1 completion:(void (^)(NSImage *image))arg2;
- (void)getAvatarImageWithContact:(id)arg1 completion:(void (^)(NSImage *image))arg2;
- (void)getAvatarImageBeforeAuthOKWithUrl:(id)arg1 completion:(id)arg2;
-(void)_fetchAvatarWithUrl:(id)arg2 withUserName:(id)arg3 isHD:(char)arg4 completion:(id)arg5;
@end

@interface NSString (MD5)
- (id)md5String;
@end

@interface MMSessionPickerLogic : NSObject
@property(nonatomic) NSArray *selectedUserNames;
@end


@interface MMSessionListView : NSObject
{
    MMSessionPickerLogic *m_logic;
}
- (void)setPreSelectedUserNames:(id)arg1;
- (void)setAllowsMultipleSelection:(BOOL)arg1;
@end

@interface MMSessionChoosenView : NSViewController
@property(retain, nonatomic) NSArray *selectedUserNames;
@property(retain, nonatomic) NSArray *selectedUsers;
@property(retain, nonatomic) NSArray *preSelectedUserNames;
- (void)setSelectedUserNames:(id)arg1 insertOrNot:(BOOL)arg2;
@end

@interface MMSessionPickerWindow : NSWindowController
+ (id)shareInstance;
- (void)beginSheetForWindow:(id)arg1 completionHandler:(void(^)(id a1))arg2;
- (void)beginRemoveMemberSheetForWindow:(id)arg1 assignedContact:(id)arg2 confirmButtonText:(id)arg3 completionHandler:(void(^)(id a1))arg4;
- (void)beginAddMemberSheetForWindow:(id)arg1 preSelectedContact:(id)arg2 confirmButtonText:(id)arg3 completionHandler:(void(^)(id a1))arg4;
@property(retain, nonatomic) MMSessionChoosenView* choosenViewController; // @synthesize
@property(retain, nonatomic) MMSessionListView* listViewController; // @synthesize
- (void)setShowsGroupChats:(BOOL)arg1;
- (void)setShowsOfficialAccounts:(BOOL)arg1;
- (void)setShowsOtherNonhumanChats:(BOOL)arg1;
- (void)setType:(unsigned long long)arg1;
- (void)setAssignedContact:(id)arg1;
- (void)setFilteredUserNames:(id)arg1;
- (void)setForwardMessageData:(id)arg1;
- (void)setForwardMessageData:(id)arg1 messageCannotBeOpened:(BOOL)arg2;
- (void)setForwardMessageDataWrap:(id)arg1 messageCannotBeOpened:(BOOL)arg2;
- (void)setPreSelectedUserNames:(id)arg1;
- (void)setPreSelectedContact:(id)arg1;
@end

@interface AFHTTPResponseSerializer : NSObject
@property (nonatomic, copy, nullable) NSSet <NSString *> *acceptableContentTypes;
@end

@interface AFURLSessionManager : NSObject
- (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request
                                             progress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock
                                          destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                    completionHandler:(void (^)(NSURLResponse *response, NSURL * filePath, NSError * error))completionHandler;
- (id)initWithSessionConfiguration:(id)arg1;
@end

@interface AFHTTPRequestSerializer : NSObject
@property (nullable, copy) NSData *HTTPBody;
+ (id)serializer;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property(nonatomic) unsigned long long cachePolicy;
- (void)setValue:(nullable NSString *)value
forHTTPHeaderField:(NSString *)field;
@property (nonatomic, strong) NSSet <NSString *> *HTTPMethodsEncodingParametersInURI;
@end

@protocol AFMultipartFormData
- (void)appendPartWithFormData:(NSData *)data
                          name:(NSString *)name;

- (void)appendPartWithFileData:(NSData *)data
                          name:(NSString *)name
                      fileName:(NSString *)fileName
                      mimeType:(NSString *)mimeType;
@end

@interface AFHTTPSessionManager : NSObject
+ (AFHTTPSessionManager *)manager;
@property(retain, nonatomic) AFHTTPRequestSerializer *requestSerializer;
@property(retain, nonatomic) AFHTTPResponseSerializer *responseSerializer;
- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                              progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;
@end

@interface MMURLHandler : NSObject
+ (id)defaultHandler;
- (void)startGetA8KeyWithURL:(id)arg1;
- (BOOL)openURLWithDefault:(id)arg1;
- (void)openURLWithDefault:(id)arg1 useA8Key:(BOOL)arg2;
+ (BOOL)containsHTTPString:(id)arg1;
@end



@interface UserDefaultsService : NSObject
- (void)setString:(id)arg1 forKey:(id)arg2;
- (id)stringForKey:(id)arg1;
@end

@interface MMLinkInfo : NSObject
+ (NSRange)rangeOfUrlInString:(id)arg1 withRange:(NSRange)arg2;
@end

@interface MMCDNDownloadMgr : NSObject
- (BOOL)downloadImageWithMessage:(id)arg1;
@end

@interface MMMessageVideoService : NSObject
- (BOOL)downloadVideoWithMessage:(id)arg1;
@end

@interface MMVoiceMessagePlayer : NSObject
+ (id)defaultPlayer;
- (void)playWithVoiceMessage:(id)arg1 isUnplayedBeforePlay:(BOOL)arg2;
- (void)stop;
@end

@interface MultiPlatformStatusSyncMgr : NSObject
- (void)markVoiceMessageAsRead:(id)arg1;
@end

@interface EmoticonDownloadMgr : NSObject
- (void)downloadEmoticonWithMessageData:(id)arg1;
@end

@interface PathUtility : NSObject
+ (id)GetCurUserCachePath;
+ (id)GetCurUserDocumentPath;
+ (id)emoticonPath:(id)arg1;
+ (id)getMsgVideoPathWithMessage:(id)arg1;
+ (id)getMsgVideoPathWithUserName:(id)arg1 localId:(unsigned int)arg2;
@end

@interface MMExtensionCenter : NSObject
- (id)getExtension:(id)arg1;
@end

@interface MMExtension : NSObject
- (BOOL)registerExtension:(id)arg1;
- (void)unregisterExtension:(id)arg1;
@end

@interface EmoticonMsgInfo : NSObject
@property(copy, nonatomic) NSString *cdnUrl;
@property(copy, nonatomic) NSString *m_nsMD5;
@end

@protocol EmoticonDownloadMgrExt <NSObject>
@optional
- (void)emoticonDownloadFailed:(EmoticonMsgInfo *)arg1;
- (void)emoticonDownloadFinished:(EmoticonMsgInfo *)arg1;
@end

@interface MMChatMangerSearchReportMgr : NSObject
@property(retain, nonatomic) NSMutableArray *brandContactSearchResults;
@property(retain, nonatomic) NSMutableArray *chatLogSearchResults;
@property(retain, nonatomic) NSMutableArray *contactSearchResults;
@property(retain, nonatomic) NSMutableArray *groupContactSearchResults;
@end

@interface MMWebViewHelper : NSObject
+ (BOOL)preHandleWebUrlStr:(id)arg1 withMessage:(id)arg2;
+ (void)handleWebViewDataItem:(id)arg1 windowId:(id)arg2;
@end

@interface XMLDictionaryParser : NSObject
+ (id)sharedInstance;
- (id)dictionaryWithString:(id)arg1;
@end

@interface MMChatMessageDataSource : NSObject
- (void)onAddMsg:(id)arg1 msgData:(id)arg2;
@end

@interface MMVoiceTranscribeCGI : NSObject
- (void)transcribeVoiceMessage:(id)arg1 withCompletion:(id)arg2;
@end

@interface CExtendInfoOfImg : NSObject
@property(nonatomic) unsigned int m_uiPercent; // @synthesize m_uiPercent;
@property(nonatomic) MessageData *m_refMessageData; // @synthesize m_refMessageData;
@property(retain, nonatomic) SendImageInfo *imageInfo; // @synthesize imageInfo=m_oImageInfo;
@property(copy, nonatomic) NSString *m_authKey; // @synthesize m_authKey;
@property(copy, nonatomic) NSString *m_nsMsgMd5; // @synthesize m_nsMsgMd5;
@property(retain, nonatomic) NSData *dtImg; // @synthesize dtImg=m_dtImg;
@property(nonatomic) unsigned int m_uiNormalImgSize; // @synthesize m_uiNormalImgSize;
@property(nonatomic) unsigned int m_uiMsgThumbWidth; // @synthesize m_uiMsgThumbWidth;
@property(nonatomic) unsigned int m_uiMsgThumbSize; // @synthesize m_uiMsgThumbSize;
@property(nonatomic) unsigned int m_uiMsgThumbHeight; // @synthesize m_uiMsgThumbHeight;
@property(nonatomic) unsigned int m_uiHDImgSize; // @synthesize m_uiHDImgSize;
@property(copy, nonatomic) NSString *m_nsMsgThumbUrl; // @synthesize m_nsMsgThumbUrl;
@property(copy, nonatomic) NSString *m_nsMsgThumbAesKey; // @synthesize m_nsMsgThumbAesKey;
@property(copy, nonatomic) NSString *m_nsImgMidUrl; // @synthesize m_nsImgMidUrl;
@property(copy, nonatomic) NSString *m_nsImgHDUrl; // @synthesize m_nsImgHDUrl;
@property(copy, nonatomic) NSString *m_nsCommentUrl; // @synthesize m_nsCommentUrl;
@property(copy, nonatomic) NSString *m_nsAesKey; // @synthesize m_nsAesKey;
@end

@interface MMUpdateMgr : NSObject
- (void)checkForUpdatesInBackground;
- (void)checkForUpdates:(id)arg1;
- (id)sparkleUpdater;
@end

@interface WebViewDataItem : NSObject
@property(nonatomic) BOOL isForceWebView; // @synthesize isForceWebView=_isForceWebView;
@property(retain, nonatomic) NSDictionary *extraData; // @synthesize extraData=_extraData;
@property(retain, nonatomic) WCContactData *brandContact; // @synthesize
@property(retain, nonatomic) MessageData *message; // @synthesize message=_message;
@property(retain, nonatomic) NSString *urlString; // @synthesize urlString=_urlString;
@end

@interface MMTextField : NSTextField

@end

@interface MMSidebarLabelTextField : NSTextField

@end

@interface MMView : NSView

@end

@interface MMSidebarColorIconView : MMView
@property(retain, nonatomic) NSImage *image; // @synthesize image=_image;
@property(retain, nonatomic) NSColor *selectedColor; // @synthesize selectedColor=_selectedColor;
@property(retain, nonatomic) NSColor *normalColor; // @synthesize normalColor=_normalColor;
@property(retain, nonatomic) NSColor *imageColor; // @synthesize imageColor=_imageColor;
@end

@interface MMBadgeOverlayView : NSView
@property(nonatomic) unsigned long long number; // @synthesize number=_number;
@property(nonatomic) int style; // @synthesize style=_style;
@end

@interface SVGImageView : NSImageView
@property(nonatomic) BOOL bFlipped; // @synthesize bFlipped=_bFlipped;
@property(nonatomic) struct CGSize imageSize; // @synthesize imageSize=_imageSize;
@property(retain, nonatomic) NSColor *imageColor; // @synthesize imageColor=_imageColor;
@property(retain, nonatomic) NSString *imageName; // @synthesize imageName=_imageName;
@end

@interface MMChatsTableCellView : NSTableCellView
@property(nonatomic) __weak id <MMChatsTableCellViewDelegate> delegate;
@property(retain, nonatomic) MMSessionInfo *sessionInfo;
@property(retain, nonatomic) MMImageView *openimGroupFlag; // @synthesize openimGroupFlag=_openimGroupFlag;
@property(retain, nonatomic) MMImageView *sendFailedImg; // @synthesize sendFailedImg=_sendFailedImg;
@property(nonatomic) BOOL shouldDrawFocusRing; // @synthesize shouldDrawFocusRing=_shouldDrawFocusRing;
@property(readonly, nonatomic) NSString *userName; // @synthesize userName=_userName;
@property(retain, nonatomic) NSString *messageTime; // @synthesize messageTime=_messageTime;
@property(retain, nonatomic) MMTextField *nickName; // @synthesize nickName=_nickName;
@property(retain, nonatomic) MMSidebarLabelTextField *timeLabel; // @synthesize timeLabel=_timeLabel;
@property(retain, nonatomic) MMSidebarLabelTextField *summary; //  @synthesize muteIndicator=_muteIndicator;
@property(retain, nonatomic) MMView *seperator; // @synthesize seperator=_seperator;
@property(retain, nonatomic) NSView *stickyBackgroundView; // @synthesize stickyBackgroundView=_stickyBackgroundView;
@property(nonatomic) BOOL shouldRemoveHighlight; // @synthesize shouldRemoveHighlight=_shouldRemoveHighlight;
@property(retain, nonatomic) NSView *containerView; // @synthesize containerView=_containerView;
@property(retain, nonatomic) id muteIndicator;//MMSidebarColorIconView SVGImageView
@property(retain, nonatomic) CAShapeLayer * _Nullable shapeLayer; // @synthesize shapeLayer=_shapeLayer;_focusingLineLayer
@property(retain, nonatomic) CAShapeLayer * _Nullable focusingLineLayer; // @synthesize shapeLayer=_shapeLayer;
@property(retain, nonatomic) NSView *avatar;
@property(retain, nonatomic) MMBadgeOverlayView *badgeView; // @synthesize badgeView=_badgeView;
@property(nonatomic) BOOL selected; // @synthesize selected=_selected;
- (void)menuWillOpen:(id)arg1;
- (void)contextMenuSticky:(id)arg1;
- (void)contextMenuDelete:(id)arg1;
- (void)tableView:(NSTableView *)arg1 rowGotMouseDown:(long long)arg2;
- (id)initWithFrame:(struct CGRect)arg1;
- (id)nicknameAttributedStringWithString:(id)arg1;

- (void)drawSelectionBackground;
- (void)updateSelectionBackground;
- (BOOL)isWxWorkSession;
- (BOOL)isMentionedUnread;
- (BOOL)isMsgStatusFailed;
- (BOOL)isMuted;
- (BOOL)isSticky;
- (BOOL)isMarkUnRead;
@end

@interface CmdItem : NSObject
+ (id)parseFromData:(id)arg1;
@property(retain, nonatomic, setter=SetCmdBuf:) SKBuiltinBuffer_t *cmdBuf; // @synthesize cmdBuf;
@property(readonly, nonatomic) BOOL hasCmdBuf; // @synthesize hasCmdBuf;
@property(nonatomic, setter=SetCmdId:) int cmdId; // @synthesize cmdId;
@property(readonly, nonatomic) BOOL hasCmdId; // @synthesize hasCmdId;
@end

@interface AddMsgSyncCmdHandler : NSObject
- (void)handleSyncCmdId:(id)arg1 withSyncCmdItems:(id)arg2 onComplete:(id)arg3;
@end


@interface MMSidebarRowView : NSTableRowView
@property (nonatomic, strong) MMView *containerView;
@end

@interface MMLoginWaitingConfirmViewController : NSViewController

@end

@interface MMFileListViewController : NSViewController
@property(nonatomic) __weak NSView *headerContainer;
@end

@interface MMPreferencesWindowController : NSWindowController

@end


@interface MMChatBackupBaseWindowController : NSWindowController
@property (nonatomic, strong) NSTitlebarAccessoryViewController * titlebarController;
@end

@interface MMPreferencesShortcutController : NSViewController

@end

@interface MMPreferencesNotificationController : NSViewController

@end

@interface MMChatMemberListViewController : NSViewController
- (void)startAGroupChatWithSelectedUserNames:(id)arg1;
@property(nonatomic) __weak MMTableView *tableView;
@property(retain, nonatomic) MMView *backgroundView; 
@end

@interface MMContactProfileController : NSViewController

@end

@interface MMWebSearchTableCellView : NSTableCellView
@property (nonatomic, strong) NSColor *backgroundColor;
@end

@interface MMSearchChatLogTableCellView : NSTableCellView
@property(retain, nonatomic) MMTextField *descriptionLabel; // @synthesize descriptionLabel=_descriptionLabel;
@property(retain, nonatomic) MMTextField *titleLabel; // @synthesize titleLabel=_titleLabel;
@property (nonatomic, strong) NSColor *backgroundColor;
- (void)setSelected:(BOOL)arg1;
@end

@class SVGButton;
@interface MMChatInfoView : NSView
@property(retain, nonatomic) MMTextField *chatNameLabel; // @synthesize chatNameLabel=_chatNameLabel;
@property(nonatomic) __weak SVGButton *chatDetailButton; // @synthesize chatDetailButton=_chatDetailButton;
@end

@interface MMMessageCellView : NSView
@property(retain, nonatomic) NSTextField *groupChatNickNameLabel;
@end

@interface MMSessionPickerListRowView : NSObject
@property(retain, nonatomic) NSTextField *sessionNameField; // @synthesize sessionNameField=_sessionNameField;
@end


@interface MMChatDetailMemberRowView : NSObject
@property(retain, nonatomic) NSTextField *nameField;
@end

@interface MMSearchTableCellView : NSObject
@property(retain, nonatomic) NSString *queryText; // @synthesize queryText=_queryText;
@property(nonatomic) unsigned long long subRanking; // @synthesize subRanking=_subRanking;
@property(nonatomic) unsigned long long ranking; // @synthesize ranking=_ranking;
@property(retain, nonatomic) NSString *keyword; // @synthesize keyword=_keyword;
@property(retain, nonatomic) MMSearchResultItem *dataItem; // @synthesize dataItem=_dataItem;
@property(retain, nonatomic) NSColor *backgroundColor; // @synthesize backgroundColor=_backgroundColor;

@end

@interface MMViewController : NSViewController

@end

@interface MMChatDetailSplitViewController : NSViewController
@property(nonatomic) __weak MMViewController *placeHolderViewController;
@end

@interface MMSidebarContactRowView : MMSidebarRowView
- (void)dealloc;
- (void)prepareForReuse;
- (void)mouseDown:(id)arg1;
- (void)resizeSubviewsWithOldSize:(struct CGSize)arg1;
- (void)relayoutSubView;
- (id)initWithFrame:(struct CGRect)arg1;
@end

@interface MMChatManagerDetailViewController : NSViewController

@end

@interface MMChatManagerWindowController : NSWindowController
@property(retain, nonatomic) MMChatManagerDetailViewController *chatManagerDetailViewController; // @synthesize chatManagerDetailViewController=_chatManagerDetailViewController;
@property(nonatomic) __weak NSView *detailContainer; // @synthesize detailContainer=_detailContainer;
@property(nonatomic) __weak NSView *divider; // @synthesize divider=_divider;
@property(retain, nonatomic) NSString *searchKey; // @synthesize searchKey=_searchKey;
@property(retain, nonatomic) WCContactData *chatContact; // @synthesize chatContact=_chatContact;
- (void)layoutVerticalAlignForPlaceHolder;
- (void)searchAction:(id)arg1;
- (void)onModifyContacts:(id)arg1;
- (BOOL)windowShouldClose:(id)arg1;
- (void)windowDidResignKeyAction:(id)arg1;
- (void)showWindow:(id)arg1;
- (void)pushWindow:(id)arg1;
- (void)windowDidLoad;
- (void)dealloc;
- (id)initWithWindowNibName:(id)arg1;
@end

@interface MMGlobalChatManagerWindowController : NSWindowController

@end

@interface WeChatApplication : NSApplication
- (BOOL)isMiniProgramProcess;
@end

@interface MMContactsDetailViewController : NSViewController
@property(nonatomic) unsigned int mySessionId; // @synthesize mySessionId=_mySessionId;
@property(nonatomic) __weak NSView *sendGroupMsgBox; // @synthesize sendGroupMsgBox=_sendGroupMsgBox;
@property(nonatomic) __weak NSTextField *groupChatNameLabel; // @synthesize groupChatNameLabel=_groupChatNameLabel;
@property(nonatomic) __weak NSImageView *groupChatAVatar; // @synthesize groupChatAVatar=_groupChatAVatar;
@property(retain, nonatomic) NSView *groupChatContainerView; // @synthesize groupChatContainerView=_groupChatContainerView;
@property(retain, nonatomic) NSMutableArray *openIMLabelList; // @synthesize openIMLabelList=_openIMLabelList;
@property(retain, nonatomic) NSMutableArray *valueLabelList; // @synthesize valueLabelList=_valueLabelList;
@property(retain, nonatomic) NSMutableArray *keyLabelList; // @synthesize keyLabelList=_keyLabelList;
@property(nonatomic) int macKeyLabelWidth; // @synthesize macKeyLabelWidth=_macKeyLabelWidth;
@property(nonatomic) int currentDetailIndex; // @synthesize currentDetailIndex=_currentDetailIndex;
@property(nonatomic) int diffHeight; // @synthesize diffHeight=_diffHeight;
@property(nonatomic) BOOL friendAdded; // @synthesize friendAdded=_friendAdded;
@property(retain, nonatomic) WCContactData *currContactData; // @synthesize currContactData=_currContactData;
@property(retain, nonatomic) NSData *kvGreetingRowPrototype; // @synthesize kvGreetingRowPrototype=_kvGreetingRowPrototype;
@property(retain, nonatomic) NSData *kvRowPrototype; // @synthesize kvRowPrototype=_kvRowPrototype;
@property(nonatomic) int addedHeight; // @synthesize addedHeight=_addedHeight;
@property(retain, nonatomic) NSTextField *remarkInput; // @synthesize remarkInput=_remarkInput;
@property(retain, nonatomic) NSString *originalRemark; // @synthesize originalRemark=_originalRemark;
@property(retain, nonatomic) NSTextField *brandDescription; // @synthesize brandDescription=_brandDescription;
@property(retain, nonatomic) NSView *greetingRow; // @synthesize greetingRow=_greetingRow;
@property(retain, nonatomic) NSBox *dividerLine; // @synthesize dividerLine=_dividerLine;
@property(nonatomic) __weak NSView *keyValueContainer; // @synthesize keyValueContainer=_keyValueContainer;
@property(retain, nonatomic) NSView *keyValueRow; // @synthesize keyValueRow=_keyValueRow;
@property(retain, nonatomic) NSTextView *descriptionTextView; // @synthesize descriptionTextView=_descriptionTextView;
@property(nonatomic) __weak NSImageView *avatarImage; // @synthesize avatarImage=_avatarImage;
@property(nonatomic) __weak NSImageView *sexIcon; // @synthesize sexIcon=_sexIcon;
@property(nonatomic) __weak NSTextField *contactNameLabel; // @synthesize contactNameLabel=_contactNameLabel;
@property __weak NSView *contactDetailContainerView; // @synthesize contactDetailContainerView=_contactDetailContainerView;
@property(retain, nonatomic) MMView *placeHolderView; // @synthesize placeHolderView=_placeHolderView;
@property(retain, nonatomic) NSView *detailContainerView; // @synthesize detailContainerView=_detailContainerView;
@property(nonatomic) __weak NSScrollView *scrollViewContainer; // @synthesize scrollViewContainer=_scrollViewContainer;
@property(retain, nonatomic) NSButton *sendMsgButton; // @synthesize sendMsgButton=_sendMsgButton;
@end

@interface MMFavoriteCollectionView : NSCollectionView

@end

@interface MMFavoriteDetailViewContoller : NSViewController
@property(retain, nonatomic) NSArray *cellsBeingDragged; // @synthesize cellsBeingDragged=_cellsBeingDragged;
@property(retain, nonatomic) NSArray *allPreviewItems; // @synthesize allPreviewItems=_allPreviewItems; collectionData=_collectionData;
@property(retain, nonatomic) MMFavoriteCollectionView *collectionView; // @synthesize collectionView=_collectionView;
@property(nonatomic) unsigned long long currentLayoutStyle; // @synthesize currentLayoutStyle=_currentLayoutStyle;
@property(retain, nonatomic) NSMutableDictionary *viewerWindowDic; // @synthesize viewerWindowDic=_viewerWindowDic;
@property(nonatomic) __weak NSView *noSearchResultView; // @synthesize noSearchResultView=_noSearchResultView;
@property(retain, nonatomic) NSString *searchingString; // @synthesize searchingString=_searchingString;
@property(nonatomic) unsigned long long lastCalledSearchTime; // @synthesize lastCalledSearchTime=_lastCalledSearchTime;
@property(retain, nonatomic) id mouseDraggedEvent; // @synthesize mouseDraggedEvent=_mouseDraggedEvent; draggingOverlayView=_draggingOverlayView;
@property(retain, nonatomic) NSTextField *titleTextField; // @synthesize titleTextField=_titleTextField; delegate=_delegate;
@end

@interface MMLoginStateMachine : NSObject

@end

@interface SyncCGI : NSObject
- (void)callSyncFail;
- (void)callSyncSucc;
- (BOOL)shouldContinueOpenIMSync:(id)arg1 withResponse:(id)arg2;
- (BOOL)shouldContinueNewSync:(id)arg1 withResponse:(id)arg2;
- (BOOL)handleSyncResponse:(id)arg1;
- (void)handleOpenIMSyncResponse:(id)arg1 sessionId:(unsigned int)arg2;
- (void)handleNewSyncResponse:(id)arg1 sessionId:(unsigned int)arg2;
- (void)OnResponseCGI:(BOOL)arg1 sessionId:(unsigned int)arg2 cgiWrap:(id)arg3;
- (void)doOpenIMSyncRequest;
- (void)doNewSyncRequest;
- (void)startSync;
- (void)OnReceiveNotifyData:(id)arg1;
- (void)FixOpenIMSync;
- (void)BackGroundToForeGroundSync;
- (void)NeedToSync:(unsigned int)arg1;
- (void)Stop;
- (void)dealloc;
@end

@interface SyncService : NSObject
{
 SyncCGI *_syncCGI;
}
- (BOOL)ProcessHeartBeatResponse:(id)arg1 isSessionTimeout:(char *)arg2;
- (BOOL)FillHeartBeatRequestBuffer:(id)arg1 reqCmdId:(int *)arg2 respCmdId:(int *)arg3;
- (void)CheckHeartBeatIfNeeded;
- (void)StartCheckHeartBeat;
- (void)ClearHeartBeat;
- (void)onServerNotify:(int)arg1 cmdID:(int)arg2 notifyData:(id)arg3;
- (void)onSyncSuccess;
- (void)onSyncFail;
- (void)CheckNeedToSync:(unsigned int)arg1;
- (void)FixOpenIMSync;
- (void)BackGroundToForeGroundSync;
- (void)sendSyncCGIWithScene:(unsigned int)arg1;
- (BOOL)isSyncClosed;
- (void)OpenSync;
- (void)CloseSync;
- (BOOL)IsNeedSync;
- (BOOL)IsDoingSync;
- (BOOL)isCanStartSync;
- (void)onContactInitSuccess;
- (void)onContactInitFail;
- (void)onContactInitUserNameUpdate;
- (void)onContactInitProcessUpdate:(unsigned int)arg1;
- (void)tryInitContact;
- (void)onInitCGIFail;
- (void)onInitCGIFinish;
- (void)onInitCGIProcessed:(unsigned int)arg1;
- (void)StartSyncOnAuthOK;
- (void)StartInitNoSyncBuffer;
- (void)StartInit;
- (void)CancelInit;
- (BOOL)IsDoingInit;
- (BOOL)IsNeedInit;
- (BOOL)IsFirstSync;
- (void)UnregisterKeyExtension;
- (void)RegisterKeyExtension;
- (void)onServiceClearData;
- (void)onServiceInit;
- (void)dealloc;
- (id)init;
@end

@interface SVGButton : NSButton
@property(nonatomic) struct CGSize imageSize; // @synthesize imageSize=_imageSize;
@property(retain, nonatomic) NSColor *alternateColor; // @synthesize alternateColor=_alternateColor;
@property(retain, nonatomic) NSColor *normalColor; // @synthesize normalColor=_normalColor;
@property(retain, nonatomic) NSString *imageName; // @synthesize imageName=_imageName;
- (void)setup;
- (void)dealloc;
- (id)initWithCoder:(id)arg1;
- (id)initWithFrame:(struct CGRect)arg1;
- (id)init;
@end

@interface LVSVGImageButton : SVGImageView
@property(retain, nonatomic) NSColor *alternateColor;
@end

@interface MMComposeInputViewController : NSViewController
- (void)viewDidLoad;
@property(nonatomic) __weak SVGButton *openBrandMenuButton; // @synthesize openBrandMenuButton=_openBrandMenuButton;
@property(nonatomic) __weak SVGButton *closeBrandMenuButton; // @synthesize openBrandMenuButton=_openBrandMenuButton;
@property(nonatomic) __weak SVGButton *chatManagerButton; // @synthesize chatManagerButton=_chatManagerButton;
@property(nonatomic) __weak SVGButton *voiceButton; // @synthesize voiceButton=_voiceButton;
@property(nonatomic) __weak SVGButton *videoButton; // @synthesize videoButton=_videoButton;
@property(nonatomic) __weak SVGButton *screenShotButton; // @synthesize screenShotButton=_screenShotButton;
@property(nonatomic) __weak SVGButton *attachmentButton; // @synthesize attachmentButton=_attachmentButton;
@property(nonatomic) __weak SVGButton *stickerButton; // @synthesize stickerButton=_stickerButton;
@property(nonatomic) __weak SVGButton *multiTalkButton; // @synthesize stickerButton=_stickerButton;
@property(retain, nonatomic) LVSVGImageButton *liveButton;
@end

@interface MMFavSidebarHeaderRowView : NSTableRowView
@property(retain, nonatomic) MMSidebarColorIconView *arrowIconView; // @synthesize arrowIconView=_arrowIconView;
@property(retain, nonatomic) MMSidebarColorIconView *iconView; // @synthesize iconView=_iconView;
@property(retain, nonatomic) MMSidebarLabelTextField *titleLabel; // @synthesize titleLabel=_titleLabel;
@property(retain, nonatomic) NSImage *arrowIcon; // @synthesize arrowIcon=_arrowIcon;
@property(retain, nonatomic) NSImage *icon; // @synthesize icon=_icon;
@end

@interface MMFavSidebarRowView : NSTableRowView
@property(retain, nonatomic) MMView *containerView; // @synthesize containerView=_containerView;
@property(retain, nonatomic) MMImageView *avatarView; // @synthesize avatarView=_avatarView;
@property(retain, nonatomic) MMSidebarColorIconView *iconView; // @synthesize iconView=_iconView;
@end

@interface RFOverlayScrollView : NSScrollView

@end

@interface MMContactsMgrRecentRowView : NSView
@property(retain, nonatomic) NSTextField *nameTextField; // @synthesize nameTextField=_nameTextField;
@end

@interface MMContactsListViewController : NSViewController
@property(retain, nonatomic) CAShapeLayer *shapeLayer; // @synthesize shapeLayer=_shapeLayer;
@end

@interface MMContactsColumn3CellView : NSView
@property(retain, nonatomic) NSTextField *titleField; // @synthesize titleField=_titleField;
- (void)updateUIWithContact:(id)arg1;
@end

@interface MMChatFTSSearchLogic : NSObject
- (void)doSearchWithKeyword:(id)arg1 chatName:(id)arg2 realFromUser:(id)arg3 messageType:(unsigned int)arg4 minMsgCreateTime:(unsigned int)arg5 maxMsgCreateTime:(unsigned int)arg6 limitCount:(unsigned int)arg7 isFromGlobalSearch:(unsigned char)arg8 completion:(id)arg9;
@end

@interface WindowCenter : NSObject
- (id)getWindowController:(id)arg1 makeIfNecessary:(BOOL)arg2;
- (id)getWindowController:(id)arg1;
- (void)pop:(id)arg1 withIdentifier:(id)arg2;
- (void)popWithoutIdentifier:(id)arg1;
- (void)pop:(id)arg1;
- (void)push:(id)arg1 withIdentifier:(id)arg2 sender:(id)arg3;
- (void)push:(id)arg1 withIdentifier:(id)arg2;
- (void)push:(id)arg1 sender:(id)arg2;
- (void)push:(id)arg1;
- (void)pushWithoutIdentifier:(id)arg1;
- (void)onServiceClearData;
- (void)onServiceInit;
@end

@interface MMVerifyContactWrap : NSObject
@property(retain, nonatomic) NSString *sourceNickName; // @synthesize sourceNickName=_sourceNickName;
@property(retain, nonatomic) NSString *sourceUserName; // @synthesize sourceUserName=_sourceUserName;
@property(retain, nonatomic) NSString *chatRoomUserName; // @synthesize chatRoomUserName=_chatRoomUserName;
@property(retain, nonatomic) WCContactData *verifyContact; // @synthesize verifyContact=_verifyContact;
@property(nonatomic) unsigned int flag; // @synthesize flag=_flag;
@property(retain, nonatomic) NSString *ticket; // @synthesize ticket=_ticket;
@property(nonatomic) unsigned int scene; // @synthesize scene=_scene;
@property(retain, nonatomic) NSString *originalUsrName; // @synthesize originalUsrName=_originalUsrName;
@property(retain, nonatomic) NSString *usrName; // @synthesize usrName=_usrName;
@end

@interface MMFriendRequestMgr : NSObject
- (void)sendFriendVerifyMessage:(id)arg1 withVerifyContactWrap:(id)arg2;
- (void)sendVerifyUserRequestWithUserName:(id)arg1 opCode:(int)arg2 verifyMsg:(id)arg3 ticket:(id)arg4 verifyContactWrap:(id)arg5 completion:(id)arg6;
- (void)showFriendVerifyWindowWithContact:(id)arg1 groupChatUserName:(id)arg2 completion:(id)arg3;
@end

@interface MMTextView : NSTextView
@property(retain, nonatomic) NSColor *selectedTextColor; // @synthesize selectedTextColor=_selectedTextColor;
@property(retain, nonatomic) NSColor *normalTextColor; // @synthesize normalTextColor=_normalTextColor;
@end

@interface MMSystemMessageCellView : MMMessageCellView
@property(retain, nonatomic) MMTextView *msgTextView; // @synthesize msgTextView=_msgTextView;
@end

@interface MMSessionCreateSessionButtonRowView : NSTableRowView

@property(retain, nonatomic) NSTextField *titleField; // @synthesize titleField=_titleField;
@property(retain, nonatomic) NSView *backgroundView; // @synthesize backgroundView=_backgroundView;
@end

@interface MMSessionPickerListSwitchSelectMode : NSTableRowView

@end

@interface MMContactMgrButtonView : NSView
@property(nonatomic) BOOL highlighted; // @synthesize highlighted=_highlighted;
@property(retain, nonatomic) CALayer *borderLayer; // @synthesize borderLayer=_borderLayer;
@property(retain, nonatomic) NSImageView *iconImageView; // @synthesize iconImageView=_iconImageView;
@property(retain, nonatomic) NSTextField *titleTextField; // @synthesize titleTextField=_titleTextField;
@property(retain, nonatomic) NSView *contentView; // @synthesize contentView=_contentView;
@end
