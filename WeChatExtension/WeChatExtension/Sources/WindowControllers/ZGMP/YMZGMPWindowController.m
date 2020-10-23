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

static NSString *const kNickColumnID = @"kNickColumnID";
static NSString *const kTimeColumnID = @"kTimeColumnID";

@interface YMZGMPWindowController () <NSTableViewDelegate, NSTableViewDataSource>
@property (nonatomic, strong) NSTableView *sessionTableView;
@property (nonatomic, strong) NSTableView *detailTableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSScrollView *scrollView;
@property (nonatomic, strong) NSTableColumn *nameColumn;
@property (nonatomic, strong) NSMutableArray *rightDataArray;
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
    [self reloadGroupData];
}

- (void)initSubviews
{
    self.window.title = YMLanguage(@"群管理", @"ZGMP");
    NSScrollView *scrollView = ({
        NSScrollView *scrollView = [[NSScrollView alloc] init];
        scrollView.hasVerticalScroller = YES;
        scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        scrollView;
    });
    self.scrollView = scrollView;
    
    self.sessionTableView = ({
        NSTableView *tableView = [[NSTableView alloc] init];
        tableView.frame = scrollView.bounds;
        tableView.allowsTypeSelect = YES;
        tableView.delegate = self;
        tableView.dataSource = self;
        
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
        NSTableView *tableView = [[NSTableView alloc] init];
        tableView.frame = scrollView.bounds;
        tableView.allowsTypeSelect = YES;
        tableView.delegate = self;
        tableView.dataSource = self;
        
        NSTableColumn *nameColumn = [[NSTableColumn alloc] init];
        nameColumn.title = YMLanguage(@"昵称", @"NICK");
        nameColumn.width = 200;
        nameColumn.identifier = kNickColumnID;
        
        NSTableColumn *timeColumn = [[NSTableColumn alloc] init];
        timeColumn.title = YMLanguage(@"最后发言时间", @"NICK");
        timeColumn.width = 200;
        timeColumn.identifier = kTimeColumnID;
        
        [tableView addTableColumn:nameColumn];
        [tableView addTableColumn:timeColumn];
        
        if ([YMWeChatPluginConfig sharedConfig].usingDarkTheme) {
            [[YMThemeManager shareInstance] changeTheme:tableView color:[YMWeChatPluginConfig sharedConfig].mainChatCellBackgroundColor];
        }
        
        tableView;
    });
    detailScrollView.contentView.documentView = self.detailTableView;
    
    [self.window.contentView addSubview:scrollView];
    [self.window.contentView addSubview:detailScrollView];
    
    [scrollView addConstraint:NSLayoutAttributeLeft constant:20];
    [scrollView addConstraint:NSLayoutAttributeBottom constant:-50];
    [scrollView addWidthConstraint:200];
    [scrollView addConstraint:NSLayoutAttributeTop constant:20];
    
    [detailScrollView addConstraint:NSLayoutAttributeLeft sibling:scrollView attribute:NSLayoutAttributeRight constant:20];
    [detailScrollView addConstraint:NSLayoutAttributeBottom constant:-50];
    [detailScrollView addConstraint:NSLayoutAttributeTop constant:20];
    [detailScrollView addConstraint:NSLayoutAttributeRight constant:-20];
}

- (void)setupData
{
    self.dataArray = [YMIMContactsManager getAllChatroomFromSessionList];
    [self reloadGroupData];
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

- (void)changeChatroom:(NSString *)chatroom
{
    [self.rightDataArray removeAllObjects];
    
    GroupStorage *groupStorage = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("GroupStorage")];
    NSArray *list = [groupStorage GetGroupMemberListWithGroupUserName:chatroom limit:500 filterSelf:YES];
    
    MMChatFTSSearchLogic *logic = [[objc_getClass("MMChatFTSSearchLogic") alloc] init];
    NSMutableArray *array = [NSMutableArray array];
    __weak __typeof (self) wself = self;
    [list enumerateObjectsUsingBlock:^(WCContactData *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [logic doSearchWithKeyword:obj.m_nsNickName chatName:chatroom realFromUser:0x0 messageType:0x0 minMsgCreateTime:0x0 maxMsgCreateTime:0x0 limitCount:0x0 isFromGlobalSearch:'1' completion:^(NSArray *msgs, NSString *chatroom) {
            YMZGMPInfo *info = [[YMZGMPInfo alloc] init];
            info.nick = obj.m_nsRemark.length > 0 ? obj.m_nsRemark : obj.m_nsNickName;
            info.wxid = obj.m_nsUsrName;
            info.male = obj.m_uiSex;
            if (msgs.count > 0) {
                MessageData *msg = msgs[0];
                info.timestamp = msg.msgCreateTime;
            }
            [array addObject:info];
            if (array.count == list.count) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    wself.rightDataArray = [NSMutableArray arrayWithArray:[array sortedArrayUsingComparator:^NSComparisonResult(YMZGMPInfo*  _Nonnull obj1, YMZGMPInfo*  _Nonnull obj2) {
                        NSNumber *number1 = [NSNumber numberWithInt:obj1.timestamp];
                        NSNumber *number2 = [NSNumber numberWithInt:obj2.timestamp];
                        NSComparisonResult result = [number1 compare:number2];
                        return  result == NSOrderedAscending;
                    }]];
                    [wself.detailTableView reloadData];
                });
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
    return 40;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (tableView == self.sessionTableView) {
        YMZGMPGroupCell *cell = [[YMZGMPGroupCell alloc] init];
        if (row < self.dataArray.count) {
            cell.wxid = self.dataArray[row];
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
    
    return [NSView new];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSTableView *tableView = notification.object;
    if (tableView == self.sessionTableView) {
        if (tableView.selectedRow < self.dataArray.count) {
            NSString *usr = self.dataArray[tableView.selectedRow];
            [self changeChatroom:usr];
        }
    }
}

@end
