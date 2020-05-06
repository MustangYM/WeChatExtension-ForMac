//
//  YMAIReplyWindowController.m
//  WeChatExtension
//
//  Created by MustangYM on 2019/12/3.
//  Copyright © 2019 MustangYM. All rights reserved.
//

#import "YMAIReplyWindowController.h"
#import "YMAIReplyCell.h"
#import "YMAutoReplyModel.h"
#import "TKWeChatPluginConfig.h"

@interface YMAIReplyWindowController ()<NSTabViewDelegate, NSTableViewDataSource>
@property (nonatomic, strong) NSTableView *tableView;
@property (nonatomic, strong) NSButton *addButton;
@property (nonatomic, strong) NSButton *reduceButton;
@property (nonatomic, strong) YMAIAutoModel *AIModel;
@property (nonatomic, assign) NSInteger currentIdx;
@property (nonatomic, strong) NSTextField *desLabel;
@end

@implementation YMAIReplyWindowController

- (void)windowDidLoad
{
    [super windowDidLoad];
    if ([[TKWeChatPluginConfig sharedConfig] AIReplyModel]) {
        self.AIModel = [[TKWeChatPluginConfig sharedConfig] AIReplyModel];
    } else {
        self.AIModel = [YMAIAutoModel new];
        [[TKWeChatPluginConfig sharedConfig] saveAIAutoReplyModel:self.AIModel];
    }
    [self initSubviews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowShouldClosed:) name:NSWindowWillCloseNotification object:nil];
}

- (void)windowShouldClosed:(NSNotification *)notification
{
    if (notification.object != self.window) {
        return;
    }
    if (self.AIModel) {
        [[TKWeChatPluginConfig sharedConfig] saveAIAutoReplyModel:self.AIModel];
    }
}

- (void)initSubviews
{
    self.window.title = YMLocalizedString(@"assistant.autoReply.aiTitle");
    NSInteger leftSpace = -50;
    NSScrollView *scrollView = ({
        NSScrollView *scrollView = [[NSScrollView alloc] init];
        scrollView.hasVerticalScroller = YES;
        scrollView.frame = NSMakeRect(80 + leftSpace, 50, 300, 375);
        scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        
        scrollView;
    });
    
    self.tableView = ({
        NSTableView *tableView = [[NSTableView alloc] init];
        tableView.frame = scrollView.bounds;
        tableView.allowsTypeSelect = YES;
        tableView.delegate = self;
        tableView.dataSource = self;
        NSTableColumn *column = [[NSTableColumn alloc] init];
        column.title = YMLocalizedString(@"assistant.autoReply.list");
        column.width = 300;
        [tableView addTableColumn:column];
        tableView;
    });
    
    self.addButton = ({
        NSButton *btn = [NSButton tk_buttonWithTitle:@"＋" target:self action:@selector(addModel)];
        btn.frame = NSMakeRect(80 + leftSpace, 10, 40, 40);
        btn.bezelStyle = NSBezelStyleTexturedRounded;
        
        btn;
    });
    
    self.reduceButton = ({
        NSButton *btn = [NSButton tk_buttonWithTitle:@"－" target:self action:@selector(reduceModel)];
        btn.frame = NSMakeRect(130 + leftSpace + 200, 10, 40, 40);
        btn.bezelStyle = NSBezelStyleTexturedRounded;
        btn.enabled = NO;
        btn;
    });
    
    self.desLabel = ({
        NSTextField *label = [NSTextField tk_labelWithString:YMLocalizedString(@"assistant.autoReply.aiDes")];
        label.textColor = kRGBColor(39, 162, 20, 1.0);
        [[label cell] setLineBreakMode:NSLineBreakByCharWrapping];
        [[label cell] setTruncatesLastVisibleLine:YES];
        label.font = [NSFont systemFontOfSize:12];
        label.frame = NSMakeRect(80, 400, 300, 50);
        label;
    });

    
    scrollView.contentView.documentView = self.tableView;
    [self.window.contentView addSubviews:@[scrollView,
                                           self.addButton,
                                           self.reduceButton,
                                           self.desLabel]];
}

- (void)addModel
{
    MMSessionPickerWindow *picker = [objc_getClass("MMSessionPickerWindow") shareInstance];
    [picker setType:1];
    [picker setShowsGroupChats:0x1];
    [picker setShowsOtherNonhumanChats:0];
    [picker setShowsOfficialAccounts:0];
    MMSessionPickerLogic *logic = [picker.listViewController valueForKey:@"m_logic"];
    NSMutableOrderedSet *orderSet = [logic valueForKey:@"_selectedUserNamesSet"];
    
    [orderSet addObjectsFromArray:self.AIModel.specificContacts];
    [picker.choosenViewController setValue:self.AIModel.specificContacts forKey:@"selectedUserNames"];
    [picker beginSheetForWindow:self.window completionHandler:^(NSOrderedSet *a1) {
        NSMutableArray *array = [NSMutableArray array];
        [a1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array addObject:obj];
        }];
        self.AIModel.specificContacts = [array copy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           [self.tableView reloadData];
        });
    }];
}

- (void)reduceModel
{
    if (self.currentIdx< self.AIModel.specificContacts.count) {
        NSMutableArray *array = [NSMutableArray array];
        [self.AIModel.specificContacts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx != self.currentIdx) {
                [array addObject:obj];
            }
        }];
        self.AIModel.specificContacts = [array copy];
    }
    [self.tableView reloadData];
}

#pragma mark -
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.AIModel.specificContacts.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    YMAIReplyCell *cell = [[YMAIReplyCell alloc] init];
    cell.frame = NSMakeRect(0, 0, self.tableView.frame.size.width, 40);
    if (row < self.AIModel.specificContacts.count) {
        cell.wxid = self.AIModel.specificContacts[row];
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

@end
