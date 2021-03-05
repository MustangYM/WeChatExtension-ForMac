//
//  YMAIReplyWindowController.m
//  WeChatExtension
//
//  Created by MustangYM on 2019/12/3.
//  Copyright © 2019 MustangYM. All rights reserved.
//

#import "YMStrangerCheckWindowController.h"
#import "YMStrangerCheckCell.h"
#import "YMAutoReplyModel.h"
#import "YMWeChatPluginConfig.h"
#import "YMIMContactsManager.h"
#import "YMMessageManager.h"

@interface YMStrangerCheckWindowController ()<NSTabViewDelegate, NSTableViewDataSource>
@property (nonatomic, strong) NSTableView *tableView;
@property (nonatomic, strong) NSButton *addButton;
@property (nonatomic, strong) NSButton *reduceButton;
@property (nonatomic, strong) YMAIAutoModel *AIModel;
@property (nonatomic, assign) NSInteger currentIdx;
@property (nonatomic, strong) NSTextField *desLabel;
@property (nonatomic, strong) YMIMContactsManager *contactMgr;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSProgressIndicator *progress;
@property (nonatomic, strong) NSTextField *indicatorLabel;
@end

@implementation YMStrangerCheckWindowController

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self initSubviews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowShouldClosed:) name:NSWindowWillCloseNotification object:nil];
}

- (void)windowShouldClosed:(NSNotification *)notification
{
    if (notification.object != self.window) {
        return;
    }
    [self.timer invalidate];
    self.timer = nil;
    self.progress.hidden = YES;
    self.indicatorLabel.hidden = YES;
    self.addButton.enabled = YES;
}

- (void)initSubviews
{
    self.window.title = YMLanguage(@"检测僵尸粉", @"Stranger Check");
    NSInteger leftSpace = -50;
    NSScrollView *scrollView = ({
        NSScrollView *scrollView = [[NSScrollView alloc] init];
        scrollView.hasVerticalScroller = YES;
        scrollView.frame = NSMakeRect(80 + leftSpace, 50, 300, 335);
        scrollView.autoresizingMask = NSViewWidthSizable ;
        
        scrollView;
    });
    
    self.tableView = ({
        NSTableView *tableView = [[NSTableView alloc] init];
        tableView.frame = scrollView.bounds;
        tableView.allowsTypeSelect = YES;
        tableView.delegate = self;
        tableView.dataSource = self;
        NSTableColumn *column = [[NSTableColumn alloc] init];
        column.title = YMLanguage(@"僵尸粉列表", @"Stranger List");
        column.width = 300;
        [tableView addTableColumn:column];
        tableView;
    });
    
    self.addButton = ({
        NSButton *btn = [NSButton tk_buttonWithTitle:YMLanguage(@"开始检测", @"Start") target:self action:@selector(onCheckStranger)];
        btn.frame = NSMakeRect(240, 10, 100, 40);
        btn.bezelStyle = NSBezelStyleTexturedRounded;
        btn;
    });
    
    
    
    self.desLabel = ({
        NSTextField *label = [NSTextField tk_labelWithString:YMLanguage(@"· 检测时对方无任何感知。\n· 只提供扫描功能，删ta与否，且行且珍惜。\n· 切勿在检测群里发消息，否则会露馅!", @"Through the silent group pulling detection, delete the group chat after detection, and do not send messages in the group!!!")];
        label.textColor = [NSColor grayColor];
        [[label cell] setLineBreakMode:NSLineBreakByCharWrapping];
        [[label cell] setTruncatesLastVisibleLine:YES];
        label.font = [NSFont systemFontOfSize:12];
        label.frame = NSMakeRect(30, 385, 300, 70);
        label;
    });

    
    self.progress = ({
        NSProgressIndicator *progress = [[NSProgressIndicator alloc] initWithFrame:CGRectMake(30, 20, 20, 20)];
        progress.style = NSProgressIndicatorStyleSpinning;
        progress.hidden = YES;
        progress;
    });
    
    self.indicatorLabel = ({
        NSTextField *label = [NSTextField tk_labelWithString:YMLanguage(@"1/998 检测还需大约20分钟", @"")];
        label.textColor = kRGBColor(39, 162, 20, 1.0);
        [[label cell] setLineBreakMode:NSLineBreakByCharWrapping];
        [[label cell] setTruncatesLastVisibleLine:YES];
        label.font = [NSFont systemFontOfSize:12];
        label.frame = NSMakeRect(60, 0, 180, 40);
        label.hidden = YES;
        label;
    });
    
    scrollView.contentView.documentView = self.tableView;
    [self.window.contentView addSubviews:@[scrollView,
                                           self.progress,
                                           self.indicatorLabel,
                                           self.addButton,
                                           self.desLabel]];
    [self.progress startAnimation:nil];
}

- (void)onCheckStranger
{
    //wxid_twv3erlvwmtx21
//    [[YMMessageManager shareManager] sendImageMessage:@"" toUserName:@"wxid_twv3erlvwmtx21"];
        //wxid_0168281683015    wxid_rf9u664z4mj712
        ContactStorage *contactStorage = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("ContactStorage")];
    __block int64_t i = 0;
    self.addButton.enabled = NO;
    NSArray *contacts = [YMIMContactsManager getAllFriendContactsWithOutChatroom];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:contacts];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (tempArray.count <= 1) {
            [self onRelease];
            return;
        }
        
        i++;
        int64_t min = tempArray.count * 1 / 60;
        
        NSString *enMsg = [NSString stringWithFormat:@"%lld/%ld %lld minutes to scan", i, contacts.count, min];
        NSString *zhMsg = [NSString stringWithFormat:@"%lld/%ld 检测还需约%lld分钟", i, contacts.count, min];
        [self.indicatorLabel setStringValue:YMLanguage(zhMsg, enMsg)];
        self.progress.hidden = NO;
        self.indicatorLabel.hidden = NO;
        
        WCContactData *contactData = [tempArray firstObject];
        
        WCContactData *data = [YMIMContactsManager getMemberInfo:contactData.m_nsUsrName];
        MMFriendRequestMgr *requestMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMFriendRequestMgr")];
        MMVerifyContactWrap *verifyWrap = [objc_getClass("MMVerifyContactWrap") new];
        verifyWrap.usrName = contactData.m_nsUsrName;
        verifyWrap.verifyContact = data;
        __weak __typeof (self) wself = self;
        [requestMgr sendVerifyUserRequestWithUserName:contactData.m_nsUsrName opCode:1 verifyMsg:nil ticket:nil verifyContactWrap:verifyWrap completion:^(int a, int b, NSString *c, NSString *d){
            //不是好友 1 2 id @"
            //是好友 1 0 id @""
            if (b == 2) {
                [wself.dataArray addObject:contactData.m_nsUsrName];
                [wself.tableView reloadData];
            }
        }];

        
        if (tempArray.count > 0) {
            [tempArray  removeObjectAtIndex:0];
        }
    }];
    self.timer = timer;
    [timer fire];
    
//    self.contactMgr = [YMIMContactsManager shareInstance];
//    __weak __typeof (self) wself = self;
//    self.contactMgr.onVerifyMsgBlock = ^(NSString *userName) {
//        if (![wself.dataArray containsObject:userName]) {
//            [wself.dataArray addObject:userName];
//            [wself.tableView reloadData];
//        }
//    };

//    GroupStorage *groupStorage = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("GroupStorage")];
//
//    MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
//    NSArray *sessions = sessionMgr.m_arrSession;
//
//    NSMutableArray *successArray = [NSMutableArray array];
//    NSString *currentUsrName = [objc_getClass("CUtility") GetCurrentUserName];
//    [sessions enumerateObjectsUsingBlock:^(MMSessionInfo *_Nonnull sessionInfo, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (sessionInfo.m_packedInfo.m_contact.m_uiSex != 0 && ![sessionInfo.m_nsUserName containsString:@"@chatroom"] && ![currentUsrName isEqualToString:sessionInfo.m_nsUserName]) {
//            GroupMember *member = [[objc_getClass("GroupMember") alloc] init];
//            member.m_nsMemberName = sessionInfo.m_nsUserName;
//            [successArray addObject:member];
//            if (successArray.count == 2) {
//                *stop = YES;
//            }
//        }
//    }];
//
//    [groupStorage CreateGroupChatWithTopic:nil groupMembers:[NSArray arrayWithArray:successArray] completion:^(NSString *chatroom) {
//        NSLog(@"验证-创群成功%@",chatroom);
//        if (chatroom.length < 1) {
//            NSLog(@"验证-创群失败%@",chatroom);
//            NSAlert *alert = [NSAlert alertWithMessageText:YMLanguage(@"警告", @"WARNING")
//                                             defaultButton:YMLanguage(@"取消", @"cancel")                       alternateButton:YMLanguage(@"确定",@"sure")
//                                               otherButton:nil                              informativeTextWithFormat:@"%@", YMLanguage(@"检测失败, 微信系统繁忙, 过一个小时后再试!", @"Detection failed, system busy!")];
//            NSUInteger action = [alert runModal];
//            return ;
//        }
//
//        wself.currentChatroom = chatroom;
//        __block int64_t i = 0;
//        wself.addButton.enabled = NO;
//    NSArray *contacts = [YMIMContactsManager getAllFriendContactsWithOutChatroom];
//        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:contacts];
//
//        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//            if (tempArray.count <= 1) {
//                [wself onRelease:groupStorage];
//                return;
//            }
//
//            i++;
//            int64_t min = tempArray.count * 5 / 60;
//
//            NSString *enMsg = [NSString stringWithFormat:@"%lld/%ld %lld minutes to scan", i, contacts.count, min];
//            NSString *zhMsg = [NSString stringWithFormat:@"%lld/%ld 检测还需约%lld分钟", i, contacts.count, min];
//            [wself.indicatorLabel setStringValue:YMLanguage(zhMsg, enMsg)];
//            wself.progress.hidden = NO;
//            wself.indicatorLabel.hidden = NO;
//
//            WCContactData *contactData = [tempArray firstObject];
//            GroupMember *member = [[objc_getClass("GroupMember") alloc] init];
//            member.m_nsMemberName = contactData.m_nsUsrName;
//            [groupStorage AddGroupMembers:@[member] withGroupUserName:chatroom completion:^(NSString *str) {
//                NSLog(@"验证-添加成功");
//            }];
//
//            NSLog(@"验证-添加群聊%@",contactData.m_nsUsrName);
//
//            if (tempArray.count > 0) {
//                [tempArray  removeObjectAtIndex:0];
//        }
//    }];
//        wself.timer = timer;
//        [timer fire];
//    }];
}

- (void)onRelease
{
    [self.timer invalidate];
    self.timer = nil;
    self.progress.hidden = YES;
    self.indicatorLabel.hidden = YES;
    self.addButton.enabled = YES;
    
    NSString *zhMsg = [NSString stringWithFormat:@"检测完成! 总共发现%ld个僵尸粉",self.dataArray.count];
    NSString *enMsg = [NSString stringWithFormat:@"Scan complete! %ld strangers found",self.dataArray.count];
    NSAlert *alert = [NSAlert alertWithMessageText:YMLanguage(@"警告", @"WARNING")
                                     defaultButton:YMLanguage(@"取消", @"cancel")                       alternateButton:YMLanguage(@"确定",@"sure")
                                       otherButton:nil                              informativeTextWithFormat:@"%@", YMLanguage(zhMsg, enMsg)];
    NSUInteger action = [alert runModal];
}

#pragma mark -
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.dataArray.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    YMStrangerCheckCell *cell = [[YMStrangerCheckCell alloc] init];
    cell.frame = NSMakeRect(0, 0, self.tableView.frame.size.width, 40);
    if (row < self.dataArray.count) {
        cell.wxid = self.dataArray[row];
    }
    return cell;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 50;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSTableView *tableView = notification.object;
    self.reduceButton.enabled = tableView.selectedRow != -1;
    if (tableView.selectedRow != -1) {
        self.currentIdx = tableView.selectedRow;
    }
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
