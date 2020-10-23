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

@interface YMZGMPWindowController () <NSTableViewDelegate, NSTableViewDataSource>
@property (nonatomic, strong) NSTableView *sessionTableView;
@property (nonatomic, strong) NSTableView *detailTableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSScrollView *scrollView;
@property (nonatomic, strong) NSTableColumn *nameColumn;
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
        
        NSTableColumn *timeColumn = [[NSTableColumn alloc] init];
        timeColumn.title = YMLanguage(@"最后发言时间", @"NICK");
        timeColumn.width = 200;
        
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
    GroupStorage *groupStorage = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("GroupStorage")];
    NSArray *list = [groupStorage GetGroupMemberListWithGroupUserName:chatroom limit:500 filterSelf:YES];
    
}

#pragma mark - NSTableViewDelegate & NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 50.f;
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
    
    return [[YMZGMPSessionCell alloc] init];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSTableView *tableView = notification.object;
    if (tableView.selectedRow < self.dataArray.count) {
        NSString *usr = self.dataArray[tableView.selectedRow];
        [self changeChatroom:usr];
    }
}

@end
