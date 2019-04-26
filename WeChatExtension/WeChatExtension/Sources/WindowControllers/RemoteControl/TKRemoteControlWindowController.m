//
//  TKRemoteControlWindowController.m
//  WeChatPlugin
//
//  Created by TK on 2017/8/8.
//  Copyright © 2017年 tk. All rights reserved.
//

#import "TKRemoteControlWindowController.h"
#import "TKRemoteControlModel.h"
#import "TKWeChatPluginConfig.h"
#import "TKRemoteControlCell.h"

@interface TKRemoteControlWindowController () <NSWindowDelegate, NSTabViewDelegate, NSTableViewDelegate, NSTableViewDataSource>

@property (nonatomic, weak) IBOutlet NSTabView *tabView;
@property (nonatomic, strong) NSTableView *tableView;
@property (nonatomic, strong) NSArray *remoteControlModels;

@end

@implementation TKRemoteControlWindowController

- (void)windowDidLoad {
    [super windowDidLoad];

    [self setup];
    [self initSubviews];
}

- (void)initSubviews {
    CGFloat scrollViewWidth = self.tabView.frame.size.width -100;
    CGFloat scrollViewHeight = self.tabView.frame.size.height -110;
    
    self.tableView = ({
        NSTableView *tableView = [[NSTableView alloc] init];
        tableView.frame = NSMakeRect(0, 0, scrollViewWidth, scrollViewHeight);
        tableView.headerView = nil;
        tableView.delegate = self;
        tableView.dataSource = self;
        NSTableColumn *column = [[NSTableColumn alloc] init];
        column.width = scrollViewWidth - 50;
        [tableView addTableColumn:column];
        tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
        tableView.backgroundColor = [NSColor clearColor];

        tableView;
    });
    
    NSScrollView *scrollView = ({
        NSScrollView *view = [[NSScrollView alloc] initWithFrame:NSMakeRect(50, 50, scrollViewWidth, scrollViewHeight)];
        view.documentView = self.tableView;
        view.hasVerticalScroller = YES;
        view.autohidesScrollers = YES;
        view.drawsBackground = NO;

        view;
    });

    [self.tabView addSubview:scrollView];
}

- (void)setup {
    self.window.contentView.layer.backgroundColor = [NSColor whiteColor].CGColor;
    [self.window.contentView.layer setNeedsDisplay];
    self.remoteControlModels = [[TKWeChatPluginConfig sharedConfig] remoteControlModels][0];
}

/**
 关闭窗口事件

 */
- (BOOL)windowShouldClose:(id)sender {
    [[TKWeChatPluginConfig sharedConfig] saveRemoteControlModels];
    return YES;
}

#pragma mark - NSTableViewDataSource && NSTableViewDelegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.remoteControlModels.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    TKRemoteControlCell *cell = [[TKRemoteControlCell alloc] init];
    cell.frame = NSMakeRect(0, 0, self.tabView.frame.size.width, 40);
    [cell setupWithData:self.remoteControlModels[row]];

    return cell;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 50;
}

#pragma mark - NSTabViewDelegate
- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem {
    NSInteger selectTabIndex = [tabViewItem.identifier integerValue];
    self.remoteControlModels = [[TKWeChatPluginConfig sharedConfig] remoteControlModels][selectTabIndex];
    [self.tableView reloadData];
}

@end
