//
//  WeChatExtension.h
//  WeChatExtension
//
//  Created by MustangYM on 2019/4/25.
//  Copyright © 2019 MustangYM. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//! Project version number for WeChatExtension.
FOUNDATION_EXPORT double WeChatExtensionVersionNumber;

//! Project version string for WeChatExtension.
FOUNDATION_EXPORT const unsigned char WeChatExtensionVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <WeChatExtension/PublicHeader.h>

/**
 微信原始的部分类与方法
 */

@interface CBaseFile : NSObject
+ (long long)GetFileSize:(id)arg1;
@end

@interface LazyExtensionAgent : NSObject
- (void)ensureLazyListenerInitedForExtension:(id)arg1 withSelector:(SEL)arg2;
@end

@interface ContactProfileHeader : NSObject
@property(copy, nonatomic) NSAttributedString *wechatId; // @synthesize wechatId=_wechatId;
@property(copy, nonatomic) NSAttributedString *nickName; // @synthesize nickName=_nickName;
@end

@interface AccountServiceExt : NSObject
- (void)onUserLogout;
@end

//负责大图下载
@interface MMMessageCacheMgr : NSObject
@property(retain, nonatomic) NSMutableDictionary *cdnDownloadTasks;
- (void)downloadImageFinishedWithMessage:(id)arg1 type:(int)arg2 isSuccess:(BOOL)arg3;
- (void)downloadImageWithURLString:(id)arg1 message:(id)arg2 completion:(id)arg3;
- (void)originalImageWithMessage:(id)arg1 completion:(id)arg2;
@end

@interface MMBrandChatsViewController : NSObject
- (void)startChatWithContact:(id)arg1;
@end

@interface MMLoginOneClickViewController : NSViewController
@property(nonatomic) NSTextField *descriptionLabel;
- (void)onLoginButtonClicked:(id)arg1;
@property(nonatomic) NSButton *loginButton;
@property(nonatomic) NSButton *unlinkButton;
@end

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

@interface AccountService : NSObject
- (id)GetLastLoginUserName;
- (id)GetLastLoginNickName;
- (id)GetLastLoginAutoAuthKey;
- (id)GetCurUserName;
- (BOOL)canAutoAuth;
- (void)AutoAuth;
- (void)ManualLogin:(id)arg1 withPassword:(id)arg2;
- (void)ManualLogout;
- (void)FFAddSvrMsgImgVCZZ;
- (void)QRCodeLoginWithUserName:(id)arg1 password:(id)arg2;
- (void)onAuthOKOfUser:(id)arg1 withSessionKey:(id)arg2 withServerId:(id)arg3 autoAuthKey:(id)arg4 isAutoAuth:(BOOL)arg5;
- (void)ClearLastLoginInfo;
- (void)ClearLastLoginAutoAuthKey;
@end

@interface MMImageView : NSImageView

@end

//消息相关
@interface MessageService : NSObject
- (void)onAddMsg:(id)arg1 msgData:(id)arg2;
- (void)notifyAddMsgOnMainThread:(id)arg1 msgData:(id)arg2;
- (void)onRevokeMsg:(id)arg1;
- (void)FFToNameFavChatZZ:(id)arg1;
- (void)OnSyncBatchAddMsgs:(NSArray *)arg1 isFirstSync:(BOOL)arg2;
- (void)FFImgToOnFavInfoInfoVCZZ:(id)arg1 isFirstSync:(BOOL)arg2;
- (id)SendTextMessage:(id)arg1 toUsrName:(id)arg2 msgText:(id)arg3 atUserList:(id)arg4;
- (id)GetMsgData:(id)arg1 svrId:(long)arg2;
- (id)GetMsgData:(id)arg1 localId:(unsigned int)arg2;
- (void)AddLocalMsg:(id)arg1 msgData:(id)arg2;
- (void)TranscribeVoiceMessage:(id)arg1 completion:(void (^)(void))arg2;
- (BOOL)ClearUnRead:(id)arg1 FromID:(unsigned int)arg2 ToID:(unsigned int)arg3;
- (BOOL)ClearUnRead:(id)arg1 FromCreateTime:(unsigned int)arg2 ToCreateTime:(unsigned int)arg3;
- (BOOL)hasMsgInChat:(id)arg1;
- (id)GetMsgListWithChatName:(id)arg1 fromLocalId:(unsigned int)arg2 limitCnt:(NSInteger)arg3 hasMore:(char *)arg4 sortAscend:(BOOL)arg5;
- (id)GetMsgListWithChatName:(id)arg1 fromCreateTime:(unsigned int)arg2 limitCnt:(NSInteger)arg3 hasMore:(char *)arg4 sortAscend:(BOOL)arg5;

- (id)SendTextMessage:(id)arg1 toUsrName:(id)arg2 msgText:(id)arg3 atUserList:(id)arg4;
- (id)SendImgMessage:(id)arg1 toUsrName:(id)arg2 thumbImgData:(id)arg3 midImgData:(id)arg4 imgData:(id)arg5 imgInfo:(id)arg6;
- (id)SendVideoMessage:(id)arg1 toUsrName:(id)arg2 videoInfo:(id)arg3 msgType:(unsigned int)arg4 refMesageData:(id)arg5;
- (id)SendLocationMsgFromUser:(id)arg1 toUser:(id)arg2 withLatitude:(double)arg3 longitude:(double)arg4 poiName:(id)arg5 label:(id)arg6;
- (id)SendNamecardMsgFromUser:(id)arg1 toUser:(id)arg2 containingContact:(id)arg3;
- (id)SendEmoticonMsgFromUsr:(id)arg1 toUsrName:(id)arg2 md5:(id)arg3 emoticonType:(unsigned int)arg4;
- (id)SendAppURLMessageFromUser:(id)arg1 toUsrName:(id)arg2 withTitle:(id)arg3 url:(id)arg4 description:(id)arg5 thumbnailData:(id)arg6;
- (id)SendRecordAppMsgTo:(id)arg1 withFavoritesItem:(id)arg2;
- (id)SendAppURLMessageFromUser:(id)arg1 toUsrName:(id)arg2 withTitle:(id)arg3 url:(id)arg4 description:(id)arg5 thumbUrl:(id)arg6;
- (void)sendAppMsgToUserName:(id)arg1 withMsg:(id)arg2 scene:(unsigned int)arg3;

- (id)ForwardMessage:(id)arg1 toUser:(id)arg2 errMsg:(id *)arg3;

- (id)genMsgDataFromBakChatMsgItem:(id)arg1;
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
@property(nonatomic, setter=SetMsgId:) int msgId; // @synthesize msgId;
@property (nonatomic, strong) SKBuiltinBuffer_t *imgBuf;
@end

@interface ContactStorage : NSObject
- (id)GetSelfContact;
- (id)GetContact:(id)arg1;
- (id)GetAllBrandContacts;
- (id)GetAllFavContacts;
- (id)GetAllFriendContacts;
@end

@interface GroupStorage : NSObject
{
    NSMutableDictionary *m_dictGroupContacts;
}
- (id)GetAllGroups;
- (id)GetGroupMemberContact:(id)arg1;
- (id)GetGroupContactList:(unsigned int)arg1 ContactType:(unsigned int)arg2;
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
@property(copy, nonatomic) NSString *m_nsSignature; // @synthesize m_nsSignature;
@property(copy, nonatomic) NSString *m_nsCountry; // @synthesize m_nsCountry;
@property(copy, nonatomic) NSString *m_nsProvince; // @synthesize m_nsProvince;
@property(copy, nonatomic) NSString *m_nsCity; // @synthesize m_nsCity;

@property(nonatomic) BOOL m_isShowRedDot;
- (BOOL)isBrandContact;
- (BOOL)isSelf;
- (id)getGroupDisplayName;
- (id)getContactDisplayUsrName;
- (BOOL)isGroupChat;
- (BOOL)isMMChat;
- (BOOL)isMMContact;
@end

@interface MessageData : NSObject
- (id)initWithMsgType:(long long)arg1;
@property(retain, nonatomic) NSString *fromUsrName;
@property(retain, nonatomic) NSString *toUsrName;
@property(retain, nonatomic) NSString *msgContent;
@property(retain, nonatomic) NSString *msgPushContent;
@property(nonatomic) int messageType;
@property(nonatomic) int msgStatus;
@property(nonatomic) int msgCreateTime;
@property(nonatomic) int mesLocalID;
@property(nonatomic) long long mesSvrID;
@property(retain, nonatomic) NSString *msgVoiceText;
@property(copy, nonatomic) NSString *m_nsEmoticonMD5;
@property(retain, nonatomic) id extendInfoWithMsgType;
@property(retain, nonatomic) NSString *m_nsVideoPath; // @synthesize m_nsVideoPath;

@property(retain, nonatomic) NSString *m_nsAppAction; // @dynamic m_nsAppAction;
@property(retain, nonatomic) NSString *m_nsAppAttachID; // @dynamic m_nsAppAttachID;
@property(retain, nonatomic) NSString *m_nsAppContent; // @dynamic m_nsAppContent;
@property(retain, nonatomic) NSString *m_nsAppExtInfo; // @dynamic m_nsAppExtInfo;
@property(retain, nonatomic) NSString *m_nsAppFileExt; // @dynamic m_nsAppFileExt;
@property(retain, nonatomic) NSString *m_nsAppID; // @dynamic m_nsAppID;
@property(retain, nonatomic) NSString *m_nsAppMediaDataUrl; // @dynamic m_nsAppMediaDataUrl;
@property(retain, nonatomic) NSString *m_nsAppMediaLowBandDataUrl; // @dynamic m_nsAppMediaLowBandDataUrl;
@property(retain, nonatomic) NSString *m_nsAppMediaLowUrl; // @dynamic m_nsAppMediaLowUrl;
@property(retain, nonatomic) NSString *m_nsAppMediaTagName; // @dynamic m_nsAppMediaTagName;
@property(retain, nonatomic) NSString *m_nsAppMediaUrl; // @dynamic m_nsAppMediaUrl;
@property(retain, nonatomic) NSString *m_nsAppMessageAction; // @dynamic m_nsAppMessageAction;
@property(retain, nonatomic) NSString *m_nsAppName; // @dynamic m_nsAppName;

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
@property(retain, nonatomic) NSString *m_nsFilePath;
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
@property(nonatomic) unsigned int m_uLastTime; // @synthesize m_uLastTime;
@property(nonatomic) unsigned int m_uUnReadCount;
@end

@protocol MMChatsTableCellViewDelegate <NSObject>
@optional
- (void)cellViewReloadData:(MMSessionInfo *)arg1;
@end

@interface MMChatsTableCellView : NSTableCellView
@property(nonatomic) __weak id <MMChatsTableCellViewDelegate> delegate;
@property(retain, nonatomic) MMSessionInfo *sessionInfo;
- (void)menuWillOpen:(id)arg1;
- (void)contextMenuSticky:(id)arg1;
- (void)contextMenuDelete:(id)arg1;
- (void)tableView:(NSTableView *)arg1 rowGotMouseDown:(long long)arg2;
@end

@interface MMSessionMgr : NSObject
@property(retain, nonatomic) NSMutableArray *m_arrSession;
- (id)GetSessionAtIndex:(unsigned long long)arg1;
- (id)sessionInfoByUserName:(id)arg1;
- (void)MuteSessionByUserName:(id)arg1;
- (void)onUnReadCountChange:(id)arg1;
- (void)UnmuteSessionByUserName:(id)arg1;
- (void)UntopSessionByUserName:(id)arg1;
- (void)deleteSessionWithoutSyncToServerWithUserName:(id)arg1;
- (void)changeSessionUnreadCountWithUserName:(id)arg1 to:(unsigned int)arg2;
- (void)removeSessionOfUser:(id)arg1 isDelMsg:(BOOL)arg2;
- (void)sortSessions;
- (void)FFDataSvrMgrSvrFavZZ;
- (id)getContact:(id)arg1;

- (void)onModMsgNeedAddSession:(id)arg1;
- (void)onModifyContacts:(id)arg1;
- (void)updateSessionInfo:(id)arg1 isNew:(char *)arg2;
- (void)onEnterSession:(id)arg1;

- (void)onAddMsgListForSession:(id)arg1 NotifyUsrName:(id)arg2;

- (void)processOnModMsg:(id)arg1 msgData:(id)arg2;
@end

@interface LogoutCGI : NSTableCellView
- (void)sendLogoutCGIWithCompletion:(id)arg1;
- (void)FFVCRecvDataAddDataToMsgChatMgrRecvZZ:(id)arg1;
@end

@interface MMNotificationService : NSObject
- (id)getNotificationContentWithMsgData:(id)arg1;
- (void)userNotificationCenter:(id)arg1 didActivateNotification:(id)arg2;
@end

@interface MMTableView : NSTableView

@end

@interface MMMessageCellView : NSTableCellView
@property(retain, nonatomic) NSTextField *msgCreatetimeLabel; // @synthesize msgCreatetimeLabel=_msgCreatetimeLabel;
@property(retain, nonatomic) NSTextField *groupChatNickNameLabel; // @synthesize groupChatNickNameLabel=_groupChatNickNameLabel;

- (id)sharingServicePicker:(id)arg1 sharingServicesForItems:(id)arg2 proposedSharingServices:(id)arg3;
- (void)contextMenuShareExtension:(id)arg1;
- (id)buildShareExtensionMenuItem;
- (id)contentForSharing;
- (void)showUIDebugGuidesChanged:(id)arg1;
- (double)changeLocateMsgLableY;
- (struct CGRect)bubbleFrame;
- (id)generateMessageDisplayContent;
- (BOOL)notMoveFar:(id)arg1;
- (void)reshowChosenStyle;
- (void)resetChosenStyle;
- (void)checkboxToggle;
- (void)setIsLocateResultStyle:(BOOL)arg1;
- (void)setIsChosenStyle:(BOOL)arg1;
- (BOOL)isChoosingMode;
- (int)getChooseModeLeftPadding;
- (int)getChoosableLeftPadding;
- (void)setChoosable:(BOOL)arg1;
- (BOOL)allowChoose;
- (void)OnModifyGroupMemberContact:(id)arg1;
- (void)onModifyContacts:(id)arg1;
- (void)onModifyUserImageWithUrl:(id)arg1 userName:(id)arg2;
- (void)OpenIMResourceWordingIds:(id)arg1 didFinish:(id)arg2;
- (void)contextMenuButtonAction:(id)arg1;
- (BOOL)showsSaveToFavoritesButton;
- (BOOL)showsContextMenuButton;
- (struct CGRect)rectForSaveToFavoritesButton;
- (struct CGRect)rectForContextMenuButton;
- (struct CGRect)rectForAccessory:(int)arg1;
- (void)resendMessage;
- (void)setErrorIndicatorAccessoryToolTip:(id)arg1;
- (void)layoutAccessories;
- (void)menuDidClose:(id)arg1;
- (void)menuWillOpen:(id)arg1;
- (void)mentionGroupChatMember:(id)arg1;
- (void)addGroupChatMember:(id)arg1;
- (void)chatWithMember:(id)arg1;
- (BOOL)allowContextMenuForEvent:(id)arg1;
- (void)contextMenuDidClose:(id)arg1;
- (void)contextMenuWillOpen:(id)arg1;
- (void)itemAction;
- (id)_makeAvatarMenuItem:(id)arg1 action:(SEL)arg2;
- (id)contextAvatarMenu;
- (id)contextMultipleSelectMenu;
- (id)contextMenu;
- (id)menuForEvent:(id)arg1;
- (id)validRequestorForSendType:(id)arg1 returnType:(id)arg2;
- (BOOL)writeSelectionToPasteboard:(id)arg1 types:(id)arg2;
- (void)writeIntoPasteboard:(id)arg1 orItem:(id)arg2 provideDataForType:(id)arg3;
- (void)draggingSession:(id)arg1 endedAtPoint:(struct CGPoint)arg2 operation:(unsigned long long)arg3;
- (void)draggingSession:(id)arg1 movedToPoint:(struct CGPoint)arg2;
- (void)draggingSession:(id)arg1 willBeginAtPoint:(struct CGPoint)arg2;
- (unsigned long long)draggingSession:(id)arg1 sourceOperationMaskForDraggingContext:(long long)arg2;
- (void)mouseUp:(id)arg1;
- (void)mouseDown:(id)arg1;
- (void)mouseDragged:(id)arg1;
- (struct CGRect)draggingFrameForEvent:(id)arg1;
- (id)bubbleImage;
- (id)generatePasteboardItem;
- (id)resizedDraggingImage;
- (id)draggingImage;
- (BOOL)acceptsFirstMouse:(id)arg1;
- (id)draggablePasteboardTypes;
- (BOOL)draggingEnabled;
- (BOOL)shouldShowAvatarMenuForEvent:(id)arg1;
- (BOOL)locationIsInsideAvatarArea:(struct CGPoint)arg1;
- (BOOL)locationIsInsideClickableArea:(struct CGPoint)arg1;
- (BOOL)eventIsInsideAvatarArea:(id)arg1;
- (BOOL)eventIsInsideClickableArea:(id)arg1;
- (struct CGRect)clickableArea;
- (void)setupLocateMsgLabel;
- (void)setupMsgCreatetimeLabel;
- (id)_formattedGroupNickName:(id)arg1;
- (void)updateGroupChatNickName;
- (void)setupGroupChatNickName;
- (id)getOpenIMAttributedString:(id)arg1;
@property(readonly, nonatomic) BOOL isGroupChat;
- (void)_updateContextMenuButtonVisibilityFromMousePosition;
- (void)scrollWheel:(id)arg1;
- (void)mouseMoved:(id)arg1;
- (void)mouseExited:(id)arg1;
- (void)mouseEntered:(id)arg1;
@property(readonly, nonatomic) double topPadding;
- (double)_avatarPosX;
- (void)updateAvatarImage;
- (void)populateWithMessage:(id)arg1;
- (id)hightLightedAttrString:(id)arg1;
- (void)redrawLocalView;
- (void)prepareForReuse;
- (BOOL)isSpecialMessageCellView;
- (void)setWaitingProgressIndicatorAccessoryHidden:(BOOL)arg1;
- (void)setNeedsDisplay;
- (void)handleNewTextSize;
- (void)updateTrackingAreas;
- (void)drawRect:(struct CGRect)arg1;
- (void)viewDidHide;
- (void)dealloc;
- (id)initWithFrame:(struct CGRect)arg1;
- (void)doAnimationAndAddFavItem:(id)arg1;
- (void)addSaveToFavoritesItem:(id)arg1;
- (void)addForwardItem:(id)arg1;
- (id)subMenu;
- (id)getMessageDataSourceFilePath:(id)arg1;
- (void)contextMenuShowSourceDebugTool;
- (void)contextMenuFavorites;
- (void)contextMenuForward;
- (void)contextMenuHideTranslation;
- (void)contextMenuTranslate;
- (void)contextMenuQuote;
- (void)contextMenuOpenInWebview;
- (void)contextMenuOpenWith:(id)arg1;
- (void)contextMenuOpenFoler;
- (void)contextMenuOpen;
- (void)contextMenuWipeOutText;
- (void)contextMenuTranscribe;
- (void)contextMenuCancle;
- (void)contextMenuDownload;
- (void)contextMenuAddEmotion;
- (void)contextMenuExport;
- (void)contextMenuCopy:(BOOL)arg1;
- (void)contextMenuCopy;
- (void)contextMenuMultipleSelectMessage;
- (void)contextMenuDelete;
- (void)contextMenuLocateMessage;
- (void)contextMenuRecall;
- (void)contextMenuResendMessage;
- (id)getOpenMenuItem;
- (id)getOperationMenuItem;
- (id)contextMenuMenuDebugSection;
- (id)contextMenuMenuSection4;
- (id)contextMenuMenuSection3;
- (id)contextMenuMenuSection2;
- (id)contextMenuMenuSection1;
- (id)contextMenuMenuSection0;
- (BOOL)allowMultipleSelect;
- (BOOL)allowOpen;
- (BOOL)allowDelete;
- (BOOL)allowOperate;
- (BOOL)allowRecall;
- (void)populateWithMessage:(id)arg1 addDevider:(BOOL)arg2;

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
@property(readonly) unsigned long long hash;
@property(readonly) Class superclass;

@end

@interface MMChatMessageViewController : NSViewController
@property(retain, nonatomic) WCContactData *chatContact;
@property(nonatomic) __weak MMTableView *messageTableView;
@property(retain, nonatomic) MMMessageCellView *currentMessageCellView;
- (void)onClickSession;
@end

@interface MMChatDetailSplitViewController : NSViewController
@property(retain, nonatomic) MMChatMessageViewController *chatMessageViewController;
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
- (void)emoticonDownloadFinished:(id)arg1;
@end

@interface MMImageMessageCellView: NSObject
@property(retain, nonatomic) MMMessageTableItem *messageTableItem;
@end

@interface EmoticonMgr : NSObject
@property(retain, nonatomic) NSMutableArray *emoticonStoreItemServerList;
@property(retain) NSMutableDictionary *dictCaptions;
@property(retain) NSMutableArray *allEmoticonStoreItemList;
@property(retain, nonatomic) NSMutableArray *needDownloadEmoticonStoreItemList;
@property(retain, nonatomic) NSMutableArray *needDownloadEmoticonStoreIconList;

@property(readonly) NSArray *emoticonGroupsForStickerPicker;
@property(readonly) NSArray *emoticonGroupsForEmojiPicker;
@property(readonly) NSArray *allEmoticonGroupsEmoji;
@property(readonly) NSArray *allEmoticonGroupsWithoutEmoji;
@property(readonly) NSArray *allEmoticonGroups;
@property(retain, nonatomic) MessageData *message;
- (id)getEmotionDataWithMD5:(id)arg1;
- (void)addFavEmoticon:(id)arg1;
- (void)addEmoticonToUploadQueueWithMD5:(id)arg1;
- (void)setAppStickerToastViewDelegate:(id)arg1;
- (void)refreshFavoriteEmoticonsIfNeeded;
- (void)updatePurchasedStickerStoreList;
- (id)getDownloadFavEmoticons;
- (void)_populateFavoritesGroup;
- (void)fetchAndDownloadPurchasedStickerStoreListWithCompletion:(id)arg1;
- (void)onFavEmoticonChanged;
- (id)getEmotionThumbWithMD5:(id)arg1;
- (id)getEmotionImgWithMD5:(id)arg1;
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
- (NSString *)avatarCachePath;
- (id)_getImageFromCacheWithMD5Key:(id)arg1;
- (void)avatarImageWithContact:(id)arg1 completion:(void (^)(NSImage *image))arg2;
- (void)getAvatarImageWithContact:(id)arg1 completion:(void (^)(NSImage *image))arg2;
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
@end

@interface MMSessionPickerWindow : NSWindowController
+ (id)shareInstance;
- (void)beginSheetForWindow:(id)arg1 completionHandler:(void(^)(id a1))arg2;
@property(retain, nonatomic) id choosenViewController; // @synthesize
@property(retain, nonatomic) id listViewController; // @synthesize
- (void)setShowsGroupChats:(BOOL)arg1;
- (void)setShowsOfficialAccounts:(BOOL)arg1;
- (void)setShowsOtherNonhumanChats:(BOOL)arg1;
- (void)setType:(unsigned long long)arg1;

@end

@interface AFHTTPResponseSerializer : NSObject
+ (instancetype)serializer;
@property (nonatomic, copy, nullable) NSSet <NSString *> *acceptableContentTypes;
@end

@interface AFURLSessionManager : NSObject
- (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request
                                             progress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock
                                          destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination
                                    completionHandler:(void (^)(NSURLResponse *response, NSURL * filePath, NSError * error))completionHandler;
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler;
- (id)initWithSessionConfiguration:(id)arg1;
@end


@protocol AFURLRequestSerialization <NSObject>

- (nullable NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                                        withParameters:(nullable id)parameters
                                                 error:(NSError * _Nullable __autoreleasing *)error NS_SWIFT_NOTHROW;

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(nullable id)parameters
                                     error:(NSError * _Nullable __autoreleasing *)error;
@end
FOUNDATION_EXPORT NSString * AFQueryStringFromParameters(NSDictionary *parameters);
@interface AFHTTPRequestSerializer : NSObject
@property (nullable, copy) NSData *HTTPBody;
+ (id)serializer;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property(nonatomic) unsigned long long cachePolicy;
- (void)setValue:(nullable NSString *)value
forHTTPHeaderField:(NSString *)field;
@property (nonatomic, strong) NSSet <NSString *> *HTTPMethodsEncodingParametersInURI;
@end

@interface AFJSONRequestSerializer : AFHTTPRequestSerializer

@property (nonatomic, assign) NSJSONWritingOptions writingOptions;
+ (instancetype)serializerWithWritingOptions:(NSJSONWritingOptions)writingOptions;

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
+ (AFHTTPSessionManager *_Nullable)manager;
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
- (id)imagePathWithMessage:(id)arg1;
- (id)fileCDNDownloadParaWithMessage:(id)arg1 destinationPath:(id)arg2;
- (void)OnCdnDownloadFinished:(id)arg1;
@end

@interface MMMessageVideoService : NSObject
- (BOOL)downloadVideoWithMessage:(id)arg1;
- (void)cdnDownloadMgrDidFinishedDownloadWithMessage:(id)arg1 type:(int)arg2;
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
- (void)storeIconDidFinishedDownload;
- (void)emoticonDidFinishedDownload;
- (void)startDownloadNextStoreIconTask;
- (void)startDownloadNextStoreItemTask;
- (void)downloadEmoticonWithMessageData:(id)arg1;
- (void)OnCdnDownloadFinished:(id)arg1;
@end

@interface PathUtility : NSObject
+ (id)GetCurUserCachePath;
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

@interface MMEmotionGroupInfo : NSObject
@property(retain, nonatomic) NSString *panelUrl; // @synthesize panelUrl=_panelUrl;
@property(retain, nonatomic) NSString *storeIconURL; // @synthesize storeIconURL=_storeIconURL;
@property(retain, nonatomic) NSString *copyright; // @synthesize copyright=_copyright;
@property(retain, nonatomic) NSString *fullDescription; // @synthesize fullDescription=_fullDescription;
@property(retain, nonatomic) NSString *author; // @synthesize author=_author;
@property(retain, nonatomic) NSString *introduction; // @synthesize introduction=_introduction;
@property(nonatomic) BOOL shouldDisplayCaptions; // @synthesize shouldDisplayCaptions=_shouldDisplayCaptions;
@property(retain, nonatomic) NSImage *icon; // @synthesize icon=_icon;
@property(retain, nonatomic) NSArray *children; // @synthesize children=_children;
@property(retain, nonatomic) NSString *identifier; // @synthesize identifier=_identifier;
@property(retain, nonatomic) NSString *title; // @synthesize title=_title;
@end

@protocol EmoticonDownloadMgrExt <NSObject>
@optional
- (void)emoticonDownloadFailed:(EmoticonMsgInfo *)arg1;
- (void)emoticonDownloadFinished:(EmoticonMsgInfo *)arg1;
- (void)storeEmoticonIconDownloadFinished:(MMEmotionGroupInfo *)arg1;
@end

@interface MMChatMangerSearchReportMgr : NSObject
@property(retain, nonatomic) NSMutableArray *brandContactSearchResults;
@property(retain, nonatomic) NSMutableArray *chatLogSearchResults;
@property(retain, nonatomic) NSMutableArray *contactSearchResults;
@property(retain, nonatomic) NSMutableArray *groupContactSearchResults;
@end

@interface MMWebViewHelper : NSObject
+ (BOOL)preHandleWebUrlStr:(id)arg1 withMessage:(id)arg2;
@end

@interface XMLDictionaryParser : NSObject
+ (id)sharedInstance;
- (id)dictionaryWithString:(id)arg1;
@end

@interface MMChatMessageDataSource : NSObject
- (void)onAddMsg:(id)arg1 msgData:(id)arg2;

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

@interface CExtendInfoOfVideo : NSObject
@property(nonatomic) unsigned int m_uiPercent; // @synthesize m_uiPercent=_m_uiPercent;
@property(copy, nonatomic) NSString *m_authKey; // @synthesize m_authKey;
@property(nonatomic) MessageData *m_refMessageData; // @synthesize m_refMessageData;
@property(retain, nonatomic) NSString *m_nsMsgDataUrl; // @synthesize m_nsMsgDataUrl;
@property(retain, nonatomic) NSString *m_nsAesKey; // @synthesize m_nsAesKey;
@property(retain, nonatomic) NSString *m_nsCommentUrl; // @synthesize m_nsCommentUrl;
@property(retain, nonatomic) NSString *m_nsMsgThumbUrl; // @synthesize m_nsMsgThumbUrl;
@property(retain, nonatomic) NSString *m_nsMsgThumbAesKey; // @synthesize m_nsMsgThumbAesKey;
@property(nonatomic) unsigned int m_uiVideoTime; // @synthesize m_uiVideoTime;
@property(nonatomic) unsigned int m_uiVideoSource; // @synthesize m_uiVideoSource;
@property(nonatomic) unsigned int m_uiVideoOffset; // @synthesize m_uiVideoOffset;
@property(nonatomic) unsigned int m_uiVideoLen; // @synthesize m_uiVideoLen;
//@property(retain, nonatomic) DownloadVideoReportData *m_downloadVideoReportData; // @synthesize m_downloadVideoReportData;
//@property(retain, nonatomic) UploadVideoReportData *m_uploadVideoReportData; // @synthesize m_uploadVideoReportData;
@property(nonatomic) unsigned int m_uiVideoCompressStatus; // @synthesize m_uiVideoCompressStatus;
@property(nonatomic) unsigned int m_uiUploadStatus; // @synthesize m_uiUploadStatus;
@property(nonatomic) unsigned int m_uiCameraType; // @synthesize m_uiCameraType;
@property(retain, nonatomic) NSString *m_nsMsgMd5; // @synthesize m_nsMsgMd5;
@property(nonatomic) unsigned int m_uiMsgThumbWidth; // @synthesize m_uiMsgThumbWidth;
@property(nonatomic) unsigned int m_uiMsgThumbSize; // @synthesize m_uiMsgThumbSize;
@property(nonatomic) unsigned int m_uiMsgThumbHeight; // @synthesize m_uiMsgThumbHeight;
@end

@interface MMMessageSendLogic : NSObject
- (void)sendVideoMessageWithFileUrl:(id)arg1;
@property(retain, nonatomic) WCContactData *currnetChatContact;
@end

@interface IGroupMgrExt : NSObject
- (void)OnAddGroupMember:(NSString *)arg1 withStatus:(unsigned int)arg2 memberList:(NSArray *)arg3 contactList:(NSArray *)arg4;
@end

@interface MMLoginQRCodeViewController : NSObject
@property(nonatomic) __weak MMImageView *qrCodeImgView;
- (void)viewDidLoad;
- (void)onRefreshButtonClicked:(id)arg1;
@end

@interface MMNavigationController : NSObject
- (void)pushViewController:(id)arg1 animated:(BOOL)arg2;
@end

@interface MMChatsViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>
@property(nonatomic) __weak NSTableView *tableView;
@property(retain, nonatomic) MMChatDetailSplitViewController *chatDetailSplitViewController; // @synthesize
- (void)scrollToFirstUnreadChatAndSelect:(BOOL)arg1;
- (void)onSessionCreatedWithUserName:(id)arg1;
- (void)selectChatWithUserName:(id)arg1;
@property(retain, nonatomic) MMBrandChatsViewController *brandChatsViewController;
@end

@interface MMMainViewController : NSViewController
@property(retain, nonatomic) MMChatsViewController *chatsViewController;
- (void)viewDidLoad;
- (void)dealloc;
@end

@interface MMLoginViewController : NSObject
@property(retain, nonatomic) MMLoginOneClickViewController *oneClickViewController;
@property(retain, nonatomic) MMLoginQRCodeViewController *qrCodeVIewController;
@property(retain, nonatomic) MMNavigationController *navController;
@property(nonatomic) int loginType;
- (void)onAuthKickOutWithReason:(id)arg1 errorMsg:(id)arg2;
- (id)getQRCodeViewController;
- (void)setupQRCodeLogic;
- (void)setupQRCodeEvents;
@end

@interface MMMainWindowController : NSWindowController
@property(retain, nonatomic) MMLoginViewController *loginViewController;
@property(retain, nonatomic) MMMainViewController *mainViewController;
- (void)onAuthOK;
- (void)onLogOut;
- (void)onLogoutButtonClick;//退出微信
- (void)onAuthFaildForInvalidCGISessionID;
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
@end

@interface CdnComMgr : NSObject
+ (struct Config)GetWxConfig;
+ (id)GetCdnRootPath;
+ (void)LazyRegisterExtension;
- (BOOL)StartDownloadTpDataFile:(struct C2CDownloadRequest)arg1 andTpUrl:(id)arg2 andAuthkey:(id)arg3;
- (BOOL)StartDownloadMedia:(struct C2CDownloadRequest *)arg1;
@end

@interface AddMsgSyncCmdHandler : NSObject
- (void)handleSyncCmdId:(id)arg1 withSyncCmdItems:(id)arg2 onComplete:(id)arg3;
@end

@interface MessageHandler : NSObject
- (void)addMsgToSendQueue:(id)arg1 msgData:(id)arg2;
@end

@interface MessageSender : NSObject
@property(retain, nonatomic) MessageData *msgData; // @synthesize msgData=m_msgData;
- (void)startSending;
@end

@interface MMChatBackupServerLogic : NSObject
- (BOOL)sendData:(id)arg1;
@end

@interface CmdItem : NSObject
@property (nonatomic, strong) SKBuiltinBuffer_t *cmdBuf;
@end

@interface SyncService : NSObject
- (void)onServerNotify:(int)arg1 cmdID:(int)arg2 notifyData:(id)arg3;
@end

@interface BaseSyncCmdHandler : NSObject
- (void)handleSyncCmdId:(id)arg1 withSyncCmdItems:(id)arg2 onComplete:(id)arg3;
@end

@interface MMCTTextView : NSTextView

@end

@interface MMTextMessageCellView : NSView
@property(retain, nonatomic) MMCTTextView *messageTextView;
- (id)textBackgoundColor;
@end

@interface MMEmoticonData : NSObject
@property(retain, nonatomic) NSString *authKey; // @synthesize authKey=_authKey;
@property(retain, nonatomic) NSString *tpUrl; // @synthesize tpUrl=_tpUrl;
@property(retain, nonatomic) NSString *cdnUrl; // @synthesize cdnUrl=_cdnUrl;
@property(nonatomic) int customEmojiType; // @synthesize customEmojiType=_customEmojiType;
@property(retain, nonatomic) NSString *productId; // @synthesize productId=_productId;
@property(retain, nonatomic) NSString *md5; // @synthesize md5=_md5;
@property(retain, nonatomic) NSString *caption; // @synthesize caption=_caption;
@property(retain, nonatomic) NSString *representationalString; // @synthesize representationalString=_representationalString;
@property(nonatomic) int type; // @synthesize type=_type
@end

