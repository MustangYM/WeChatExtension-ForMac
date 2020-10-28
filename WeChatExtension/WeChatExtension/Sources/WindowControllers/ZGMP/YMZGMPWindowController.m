//
//  YMZGMPWindowController.m
//  WeChatExtension
//
//  Created by MustangYM on 2020/10/21.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import "YMZGMPWindowController.h"
#import "YMThemeManager.h"
#import "NSViewLayoutTool.h"
#import "YMZGMPGroupCell.h"
#import "YMZGMPSessionCell.h"
#import "YMIMContactsManager.h"
#import "YMThemeManager.h"
#import "YMMessageManager.h"
#import "YMZGMPInfoHelper.h"
#import "YMZGMPTimeCell.h"
#import "YMZGMPIllicitCell.h"
#import "YMZGMPPDDCell.h"
#import "YMZGMPTableView.h"
#import "NSMenuItem+Action.h"
#import "YMZGMPBanModel.h"
#import "YMDFAFilter.h"

static NSString *const kNickColumnID = @"kNickColumnID";
static NSString *const kTimeColumnID = @"kTimeColumnID";
static NSString *const kIllicitColumnID = @"kIllicitColumnID";
static NSString *const kPDDColumnID = @"kPDDColumnID";

@interface YMZGMPWindowController () <NSTableViewDelegate, NSTableViewDataSource, YMZGMPTableViewDelegate>
@property (nonatomic, strong) YMZGMPTableView *sessionTableView;
@property (nonatomic, strong) YMZGMPTableView *detailTableView;
@property (nonatomic, strong) NSView *rightContentView;
@property (nonatomic, strong) NSView *rightPlaceholderContentView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSScrollView *scrollView;
@property (nonatomic, strong) NSTableColumn *nameColumn;
@property (nonatomic, strong) NSMutableArray *rightDataArray;
@property (nonatomic, strong) NSProgressIndicator *progress;
@property (nonatomic, strong) NSImageView *defaultImageView;
@property (nonatomic, strong) NSTextField *detailLabel;
@property (nonatomic, assign) NSInteger menuRow;
@property (nonatomic, assign) NSInteger sessionSelectRow;
@property (nonatomic, assign) NSInteger detailSelectRow;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString *currentChatroom;
@end

@implementation YMZGMPWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    [self initSubviews];
    [self setupData];
}

- (void)showWindow:(id)sender
{
    [super showWindow:sender];
    if (self.sessionTableView) {
        [self setupData];
    }
}

- (void)initSubviews
{
    self.window.title = YMLanguage(@"群员监控", @"ZGMP");
    NSScrollView *scrollView = ({
        NSScrollView *scrollView = [[NSScrollView alloc] init];
        scrollView.hasVerticalScroller = YES;
        scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        scrollView;
    });
    self.scrollView = scrollView;
    
    self.sessionTableView = ({
        YMZGMPTableView *tableView = [[YMZGMPTableView alloc] init];
        tableView.frame = scrollView.bounds;
        tableView.allowsTypeSelect = YES;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.zgmpDelegate = self;
        
        NSTableColumn *nameColumn = [[NSTableColumn alloc] init];
        nameColumn.width = 100;
        [tableView addTableColumn:nameColumn];
        self.nameColumn = nameColumn;
        
        if ([YMWeChatPluginConfig sharedConfig].usingDarkTheme) {
            [[YMThemeManager shareInstance] changeTheme:tableView color:[YMWeChatPluginConfig sharedConfig].mainChatCellBackgroundColor];
        }
        tableView;
    });
    scrollView.contentView.documentView = self.sessionTableView;
    
    NSScrollView *detailScrollView = ({
        NSScrollView *scrollView = [[NSScrollView alloc] init];
        scrollView.hasVerticalScroller = YES;
        scrollView.drawsBackground = NO;
        scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        scrollView;
    });
    
    self.detailTableView = ({
        YMZGMPTableView *tableView = [[YMZGMPTableView alloc] init];
        tableView.frame = scrollView.bounds;
        tableView.allowsTypeSelect = YES;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.zgmpDelegate = self;
        
        NSTableColumn *nameColumn = [[NSTableColumn alloc] init];
        nameColumn.title = YMLanguage(@"昵称", @"Nick");
        nameColumn.width = 200;
        nameColumn.identifier = kNickColumnID;
        
        NSTableColumn *timeColumn = [[NSTableColumn alloc] init];
        timeColumn.title = YMLanguage(@"最后发言时间", @"Last message");
        timeColumn.width = 170;
        timeColumn.identifier = kTimeColumnID;
        
        NSTableColumn *illicitColumn = [[NSTableColumn alloc] init];
        illicitColumn.title = YMLanguage(@"违规言论", @"Illicit message");
        illicitColumn.width = 170;
        illicitColumn.identifier = kIllicitColumnID;
        
        NSTableColumn *pddColumn = [[NSTableColumn alloc] init];
        pddColumn.title = YMLanguage(@"拼多多砍一刀", @"Pdd message");
        pddColumn.width = 170;
        pddColumn.identifier = kPDDColumnID;
        
        [tableView addTableColumn:nameColumn];
        [tableView addTableColumn:timeColumn];
        [tableView addTableColumn:illicitColumn];
        [tableView addTableColumn:pddColumn];
        
        if ([YMWeChatPluginConfig sharedConfig].usingDarkTheme) {
            [[YMThemeManager shareInstance] changeTheme:tableView color:[YMWeChatPluginConfig sharedConfig].mainChatCellBackgroundColor];
        }
        tableView;
    });
    detailScrollView.contentView.documentView = self.detailTableView;
    
    self.rightContentView = ({
        NSView *contentView = [[NSView alloc] init];
        contentView.hidden = YES;
        [[YMThemeManager shareInstance] changeTheme:contentView color:[NSColor clearColor]];
        contentView;
    });
    
    self.rightPlaceholderContentView = ({
        NSView *contentView = [[NSView alloc] init];
        contentView.hidden = NO;
        [[YMThemeManager shareInstance] changeTheme:contentView color:YM_RGBA(150, 150, 150, 0.1)];
        
        NSImageView *imageView = [[NSImageView alloc] init];
        imageView.image = [NSImage imageNamed:@"WeChat_Default_Logo"];
        [contentView addSubview:imageView];
        
        [imageView addConstraint:NSLayoutAttributeCenterX constant:0];
        [imageView addConstraint:NSLayoutAttributeCenterY constant:-25];
        [imageView addWidthConstraint:50];
        [imageView addHeightConstraint:50];
        contentView;
    });
    
    self.progress = ({
        NSProgressIndicator *progress = [[NSProgressIndicator alloc] init];
        progress.style = NSProgressIndicatorStyleBar;
        progress.maxValue = 1.0;
        progress.minValue = 0;
        progress.doubleValue = 0.5;
        progress.alphaValue = YMWeChatPluginConfig.sharedConfig.usingDarkTheme ? 1.0 : 0.3;
        progress.hidden = YES;
        [progress startAnimation:nil];
        progress;
    });
    
    self.defaultImageView = ({
        NSImageView *imageView = [[NSImageView alloc] init];
        imageView.image = [NSImage imageNamed:@"WeChat_Default_Logo"];
        imageView;
    });
    
    self.detailLabel = ({
        NSTextField *label = [NSTextField tk_labelWithString:YMLanguage(@"根据本地聊天记录生成榜单，方便私域社群管理。提倡言论自由的理想主义世界，尽量不做为T人依据！", @"Create a list based on local chat logs to facilitate the management of private community and promote the idealistic world of free speech. Try not to use it as a basis for remove the member!")];
        label.textColor = [NSColor blackColor];
        [[label cell] setLineBreakMode:NSLineBreakByTruncatingMiddle];
        [[label cell] setTruncatesLastVisibleLine:YES];
        label.font = [NSFont systemFontOfSize:10];
        label.textColor = [NSColor lightGrayColor];
        label.alignment = NSTextAlignmentCenter;
        label;
    });
    
    [self.window.contentView addSubview:scrollView];
    [self.window.contentView addSubview:self.rightPlaceholderContentView];
    [self.window.contentView addSubview:self.rightContentView];
    [self.window.contentView addSubview:self.detailLabel];
    [self.rightContentView addSubview:detailScrollView];
    [self.detailTableView addSubview:self.progress];
    [self.rightContentView addSubview:self.defaultImageView];
    
    [detailScrollView fillSuperView];
    
    [scrollView addConstraint:NSLayoutAttributeLeft constant:20];
    [scrollView addConstraint:NSLayoutAttributeBottom constant:-50];
    [scrollView addWidthConstraint:250];
    [scrollView addConstraint:NSLayoutAttributeTop constant:20];
    
    [self.rightPlaceholderContentView addConstraint:NSLayoutAttributeLeft sibling:scrollView attribute:NSLayoutAttributeRight constant:20];
    [self.rightPlaceholderContentView addConstraint:NSLayoutAttributeBottom constant:-50];
    [self.rightPlaceholderContentView addConstraint:NSLayoutAttributeTop constant:20];
    [self.rightPlaceholderContentView addConstraint:NSLayoutAttributeRight constant:-20];
    
    [self.rightContentView addConstraint:NSLayoutAttributeLeft sibling:scrollView attribute:NSLayoutAttributeRight constant:20];
    [self.rightContentView addConstraint:NSLayoutAttributeBottom constant:-50];
    [self.rightContentView addConstraint:NSLayoutAttributeTop constant:20];
    [self.rightContentView addConstraint:NSLayoutAttributeRight constant:-20];
    
    [self.detailLabel addConstraint:NSLayoutAttributeBottom constant:-12];
    [self.detailLabel addConstraint:NSLayoutAttributeLeft constant:100];
    [self.detailLabel addConstraint:NSLayoutAttributeRight constant:-100];
    [self.detailLabel addHeightConstraint:20];
    
    [self.progress addConstraint:NSLayoutAttributeCenterX constant:0];
    [self.progress addConstraint:NSLayoutAttributeCenterY constant:0];
    [self.progress addWidthConstraint:200];
    [self.progress addHeightConstraint:20];
    
    [self.defaultImageView addConstraint:NSLayoutAttributeCenterX constant:0];
    [self.defaultImageView addConstraint:NSLayoutAttributeCenterY constant:-25];
    [self.defaultImageView addWidthConstraint:50];
    [self.defaultImageView addHeightConstraint:50];
}

- (void)setupData
{
    NSArray *array = [YMIMContactsManager getAllChatroomFromSessionList];
    NSMutableArray *dataArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YMZGMPGroupInfo *info = [[YMZGMPGroupInfo alloc] init];
        info.wxid = obj;
        [dataArray addObject:info];
    }];
    
    [[YMWeChatPluginConfig sharedConfig].banModels enumerateObjectsUsingBlock:^(YMZGMPBanModel * _Nonnull ban, NSUInteger idx, BOOL * _Nonnull stop1) {
        __block BOOL flag = NO;
        [dataArray enumerateObjectsUsingBlock:^(YMZGMPGroupInfo  *_Nonnull info, NSUInteger idx, BOOL * _Nonnull stop2) {
            if ([ban.wxid isEqualToString:info.wxid]) {//Cache命中禁言群
                info.isIgnore = YES;
                flag = YES;
                *stop2 = YES;
            }
        }];
        if (!flag) {//Cache命中，session列表没有，证明此群被删，从cache中取数据显示，否则永远收不到此群消息
            YMZGMPGroupInfo *info = [[YMZGMPGroupInfo alloc] init];
            info.wxid = ban.wxid;
            info.nick = ban.nick;
            info.isIgnore = YES;
            [dataArray insertObject:info atIndex:0];
        }
    }];
    
    self.dataArray = dataArray;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       [self reloadGroupData];
    });
}

- (void)reloadGroupData
{
    [self.sessionTableView reloadData];
    NSString *title = nil;
    if (([YMWeChatPluginConfig sharedConfig].languageType == PluginLanguageTypeZH)) {
        title = [NSString stringWithFormat:@"群聊(%lu)", self.dataArray.count];
    } else {
        title = [NSString stringWithFormat:@"Group(%lu)", self.dataArray.count];
    }
    self.nameColumn.title = title;
}

- (void)reloadDetailData
{
    __weak __typeof (self) wself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.rightDataArray = [NSMutableArray arrayWithArray:[self.rightDataArray sortedArrayUsingComparator:^NSComparisonResult(YMZGMPInfo*  _Nonnull obj1, YMZGMPInfo*  _Nonnull obj2) {
            NSNumber *number1 = [NSNumber numberWithInt:obj1.timestamp];
            NSNumber *number2 = [NSNumber numberWithInt:obj2.timestamp];
            NSComparisonResult result = [number1 compare:number2];
            return  result == NSOrderedAscending;
        }]];
       [wself.detailTableView reloadData];
        wself.progress.hidden = wself.rightDataArray.count > 0;
        wself.defaultImageView.hidden = wself.rightDataArray.count > 0;
    });
}

- (void)resetContent
{
    [self.rightDataArray removeAllObjects];
    self.page = 0;
    [self reloadDetailData];
    self.rightContentView.hidden = NO;
    self.rightPlaceholderContentView.hidden = YES;
}

- (void)changeChatroom:(NSString *)chatroom
{
    GroupStorage *groupStorage = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("GroupStorage")];
    NSArray *list = [groupStorage GetGroupMemberListWithGroupUserName:chatroom limit:500 filterSelf:YES];
    
    NSInteger loc = self.page == 0 ? 0 : self.page * 20 + 1;
    NSUInteger length = 20;
    if (loc + 20 > list.count) {
        length = list.count - loc;
    }
    
    if (length <= 0 || loc >= list.count) {
        return;
    }

    NSArray *limitArray = [list subarrayWithRange:NSMakeRange(loc, length)];
    
    MMChatFTSSearchLogic *logic = [[objc_getClass("MMChatFTSSearchLogic") alloc] init];
    NSMutableArray *array = [NSMutableArray array];
    __weak __typeof (self) wself = self;
    
    [limitArray enumerateObjectsUsingBlock:^(WCContactData *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [logic doSearchWithKeyword:obj.m_nsNickName chatName:chatroom realFromUser:0x0 messageType:0x0 minMsgCreateTime:0x0 maxMsgCreateTime:0x0 limitCount:0x0 isFromGlobalSearch:'1' completion:^(NSArray *msgs, NSString *chatroom) {
            //违规词汇
            __block int sensitive = 0;
            __block int pdd = 0;
            [msgs enumerateObjectsUsingBlock:^(MessageData *_Nonnull msgData, NSUInteger idx, BOOL * _Nonnull stop) {
                if (msgData.messageType == 1 && [[YMDFAFilter shareInstance] filterSensitiveWords:msgData.msgContent]) {
                    sensitive++;
                } else if (msgData.messageType == 49 && [msgData.extendInfoWithMsgType isKindOfClass:objc_getClass("CExtendInfoOfAPP")]) {
                    CExtendInfoOfAPP *app = (CExtendInfoOfAPP *)msgData.extendInfoWithMsgType;
                    if ([app.m_nsTitle containsString:@"拼多多"] || [app.m_nsDesc containsString:@"拼多多"]) {
                        pdd++;
                    }
                }
            }];

            YMZGMPInfo *info = [[YMZGMPInfo alloc] init];
            info.contact = obj;
            info.sensitive = sensitive;
            info.pdd = pdd;
            info.totalMsgs = msgs.count;
            if (msgs.count > 0) {
                MessageData *msg = msgs[0];
                info.timestamp = msg.msgCreateTime;
            }
            [array addObject:info];
            if (array.count == limitArray.count) {
              NSArray *temp = [NSArray arrayWithArray:[array sortedArrayUsingComparator:^NSComparisonResult(YMZGMPInfo*  _Nonnull obj1, YMZGMPInfo*  _Nonnull obj2) {
                   NSNumber *number1 = [NSNumber numberWithInt:obj1.timestamp];
                   NSNumber *number2 = [NSNumber numberWithInt:obj2.timestamp];
                   NSComparisonResult result = [number1 compare:number2];
                   return  result == NSOrderedAscending;
               }]];
                [wself.rightDataArray addObjectsFromArray:temp];
                [wself reloadDetailData];
                wself.page ++;
            }
        }];
    }];
}

#pragma mark - NSTableViewDelegate & NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if (tableView == self.sessionTableView) {
        return self.dataArray.count;
    }
    
    return self.rightDataArray.count;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    if (tableView == self.sessionTableView) {
        return 50.f;
    }
    
    return 40.f;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (tableView == self.sessionTableView) {
        YMZGMPGroupCell *cell = [[YMZGMPGroupCell alloc] init];
        if (row < self.dataArray.count) {
            YMZGMPGroupInfo *info = self.dataArray[row];
            cell.info = info;
        }
        return cell;
    }
    
    if ([tableColumn.identifier isEqualToString:kNickColumnID]) {
        YMZGMPSessionCell *cell = [[YMZGMPSessionCell alloc] init];
        if (row < self.rightDataArray.count) {
            cell.memberInfo = self.rightDataArray[row];
        }
        return cell;
    }
    
    if ([tableColumn.identifier isEqualToString:kTimeColumnID]) {
        YMZGMPTimeCell *cell = [[YMZGMPTimeCell alloc] init];
        if (row < self.rightDataArray.count) {
            cell.memberInfo = self.rightDataArray[row];
        }
        return cell;
    }
    
    if ([tableColumn.identifier isEqualToString:kIllicitColumnID]) {
        YMZGMPIllicitCell *cell = [[YMZGMPIllicitCell alloc] init];
        if (row < self.rightDataArray.count) {
            cell.memberInfo = self.rightDataArray[row];
        }
        return cell;
    }
    
    if ([tableColumn.identifier isEqualToString:kPDDColumnID]) {
        YMZGMPPDDCell *cell = [[YMZGMPPDDCell alloc] init];
        if (row < self.rightDataArray.count) {
            cell.memberInfo = self.rightDataArray[row];
        }
        return cell;
    }
    
    return [[NSView alloc] init];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSTableView *tableView = notification.object;
    if (tableView == self.sessionTableView) {
        self.sessionSelectRow = tableView.selectedRow;
        if (tableView.selectedRow < self.dataArray.count) {
            YMZGMPGroupInfo *info = self.dataArray[tableView.selectedRow];
            self.currentChatroom = info.wxid;
            [self resetContent];
            [self changeChatroom:info.wxid];
        }
    } else {
        self.detailSelectRow = tableView.selectedRow;
    }
}

#pragma mark - YMZGMPTableViewDelegate
- (NSMenu *)ym_menuForTableView:(YMZGMPTableView *)tableView selectRow:(NSInteger)row
{
    if (tableView == self.sessionTableView) {
        self.menuRow = row;
          YMZGMPGroupInfo *oriInfo = self.dataArray[row];
          NSString *title = nil;
          if (oriInfo.isIgnore) {
              title = YMLanguage(@"允许消息", @"Allow Msg");
          } else {
              title = YMLanguage(@"拒收消息", @"Reject Msg");
          }
          
          NSMenu *menu = [[NSMenu alloc] init];
          NSMenuItem *item1 = [NSMenuItem menuItemWithTitle:title action:@selector(refuseMsg) target:self keyEquivalent:@"" state:NO];
          [menu addItems:@[item1]];
          return menu;
    }
    return nil;
}

- (void)ym_doubleClickForTableView:(YMZGMPTableView *)tableView
{
    if (tableView == self.detailTableView) {
        YMZGMPGroupInfo *groupInfo = self.dataArray[self.sessionSelectRow];
        YMZGMPInfo *info = self.rightDataArray[self.detailSelectRow];
        MMSessionInfo *sessionInfo = [YMIMContactsManager getSessionInfo:groupInfo.wxid];
        
        WindowCenter *windowCenter = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("WindowCenter")];
        MMChatManagerWindowController *window = [windowCenter getWindowController:@"MMChatManagerWindowController" makeIfNecessary:0x1];
        window.chatContact = sessionInfo.m_packedInfo.m_contact;
        window.searchKey = info.contact.m_nsNickName;
        [window pushWindow:self];
        [window showWindow:self];
    }
}

- (void)refuseMsg
{
    YMZGMPGroupInfo *oriInfo = self.dataArray[self.menuRow];
    oriInfo.isIgnore = !oriInfo.isIgnore;
    [self.sessionTableView reloadData];
    [[YMWeChatPluginConfig sharedConfig] saveBanGroup:oriInfo];
}

#pragma mark - Refresh
//TO DO logic分离，tableView区分，菊花，窗口Ntf去掉
- (void)ym_loadingFooterForTableView:(YMZGMPTableView *)tableView
{
    if (tableView == self.detailTableView) {
        [self changeChatroom:self.currentChatroom];
    }
}

- (NSMutableArray *)rightDataArray
{
    if (!_rightDataArray) {
        _rightDataArray = [NSMutableArray array];
    }
    return _rightDataArray;
}
@end
