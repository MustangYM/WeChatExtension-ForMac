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
#import "TKWeChatPluginConfig.h"
#import "YMIMContactsManager.h"

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
        NSButton *btn = [NSButton tk_buttonWithTitle:@"开始检测" target:self action:@selector(onCheckStranger)];
        btn.frame = NSMakeRect(130, 10, 100, 40);
        btn.bezelStyle = NSBezelStyleTexturedRounded;
        
        btn;
    });
    
    self.desLabel = ({
        NSTextField *label = [NSTextField tk_labelWithString:YMLanguage(@"通过静默拉群检测，切勿在在群里发消息！！！检测完删除群聊即可。", @"Through the silent group pulling detection, delete the group chat after detection, and do not send messages in the group!!!")];
        label.textColor = kRGBColor(39, 162, 20, 1.0);
        [[label cell] setLineBreakMode:NSLineBreakByCharWrapping];
        [[label cell] setTruncatesLastVisibleLine:YES];
        label.font = [NSFont systemFontOfSize:12];
        label.frame = NSMakeRect(10, 400, 300, 50);
        label;
    });

    
    scrollView.contentView.documentView = self.tableView;
    [self.window.contentView addSubviews:@[scrollView,
                                           self.addButton,
                                           self.desLabel]];
}

- (void)onCheckStranger
{
    self.contactMgr = [YMIMContactsManager shareInstance];
    __weak __typeof (self) wself = self;
    self.contactMgr.onVerifyMsgBlock = ^(NSString *userName) {
        if (![wself.dataArray containsObject:userName]) {
            [wself.dataArray addObject:userName];
            [wself.tableView reloadData];
        }
    };
    
    GroupStorage *groupStorage = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("GroupStorage")];

    MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
    NSArray *sessions = sessionMgr.m_arrSession;

    NSMutableArray *successArray = [NSMutableArray array];
    [sessions enumerateObjectsUsingBlock:^(MMSessionInfo *_Nonnull sessionInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        if (sessionInfo.m_packedInfo.m_contact.m_uiSex != 0 && ![sessionInfo.m_nsUserName containsString:@"@chatroom"]) {
            GroupMember *member = [[objc_getClass("GroupMember") alloc] init];
            member.m_nsMemberName = sessionInfo.m_nsUserName;
            [successArray addObject:member];
            if (idx == 1) {
                *stop = YES;
            }
        }
    }];
    
    [groupStorage CreateGroupChatWithTopic:nil groupMembers:[NSArray arrayWithArray:successArray] completion:^(NSString *chatroom) {
        NSLog(@"验证-创群成功%@",chatroom);
        
        if (chatroom.length < 1) {
             NSLog(@"验证-创群失败%@",chatroom);
            return ;
        }
        
        NSArray *contacts = [YMIMContactsManager getAllFriendContactsWithOutChatroom];
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:contacts];
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            if (tempArray.count == 0) {
                [wself.timer invalidate];
                wself.timer = nil;
            }

            WCContactData *contactData = [tempArray firstObject];
            GroupMember *member = [[objc_getClass("GroupMember") alloc] init];
            member.m_nsMemberName = contactData.m_nsUsrName;
            [groupStorage AddGroupMembers:@[member] withGroupUserName:chatroom completion:^(NSString *str) {
                NSLog(@"验证-添加成功");
            }];

            NSLog(@"验证-添加群聊%@",contactData.m_nsUsrName);

            if (tempArray.count > 0) {
                [tempArray  removeObjectAtIndex:0];
            }
        }];
        wself.timer = timer;
        [timer fire];
    }];
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
