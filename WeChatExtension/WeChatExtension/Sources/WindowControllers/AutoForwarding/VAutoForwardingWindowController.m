//
//  VAutoForwardingWindowController.m
//  WeChatExtension
//
//  Created by Wetoria V on 2020/7/8.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import "VAutoForwardingWindowController.h"
#import "VAutoForwardingModel.h"
#import "YMAIReplyCell.h"
#import "YMThemeManager.h"

@interface VAutoForwardingWindowController ()<NSWindowDelegate, NSTableViewDelegate, NSTableViewDataSource>

@property (nonatomic, strong) VAutoForwardingModel *vmodel;

@property (nonatomic, strong) NSTableView *forwardingFromTableView;
@property (nonatomic, strong) NSButton *addButton;
@property (nonatomic, strong) NSButton *reduceButton;
@property (nonatomic, assign) NSInteger currentIdx;

@property (nonatomic, strong) NSTableView *forwardingToTableView;
@property (nonatomic, strong) NSButton *forwardingToAddButton;
@property (nonatomic, strong) NSButton *forwardingToReduceButton;
@property (nonatomic, assign) NSInteger forwardingToCurrentIdx;

@property (nonatomic, strong) NSButton *enableButton;
@property (nonatomic, strong) NSButton *enableAllFirendButton;
@property (nonatomic, strong) NSImageView *arrowImageView;
@end

@implementation VAutoForwardingWindowController

- (void)windowDidLoad
{
    [super windowDidLoad];
    if ([[YMWeChatPluginConfig sharedConfig] VAutoForwardingModel]) {
        self.vmodel = [[YMWeChatPluginConfig sharedConfig] VAutoForwardingModel];
    } else {
        self.vmodel = [VAutoForwardingModel new];
        [[YMWeChatPluginConfig sharedConfig] saveAutoForwardingModel:self.vmodel];
    }

    [self initSubviews];
    [self setup];
}

- (void)showWindow:(id)sender
{
    [super showWindow:sender];
    [self.forwardingFromTableView reloadData];
    [self.forwardingToTableView reloadData];
}

- (void)initSubviews
{
    NSScrollView *scrollView = ({
        NSScrollView *scrollView = [[NSScrollView alloc] init];
        scrollView.hasVerticalScroller = YES;
        scrollView.frame = NSMakeRect(30, 80, 200, 375);
        scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        
        scrollView;
    });
    
    self.forwardingFromTableView = ({
        NSTableView *tableView = [[NSTableView alloc] init];
        tableView.frame = scrollView.bounds;
        tableView.allowsTypeSelect = YES;
        tableView.delegate = self;
        tableView.dataSource = self;
        NSTableColumn *column = [[NSTableColumn alloc] init];
        column.title = YMLocalizedString(@"assistant.autoForwarding.forwardingFromList");
        column.width = 200;
        [tableView addTableColumn:column];
        if ([YMWeChatPluginConfig sharedConfig].usingDarkTheme) {
            [[YMThemeManager shareInstance] changeTheme:tableView color:[YMWeChatPluginConfig sharedConfig].mainChatCellBackgroundColor];
        }
        tableView;
    });
    
    self.addButton = ({
        NSButton *btn = [NSButton tk_buttonWithTitle:@"＋" target:self action:@selector(addModel)];
        btn.frame = NSMakeRect(30, 40, 40, 40);
        btn.bezelStyle = NSBezelStyleTexturedRounded;
        
        btn;
    });

    self.reduceButton = ({
        NSButton *btn = [NSButton tk_buttonWithTitle:@"－" target:self action:@selector(reduceModel)];
        btn.frame = NSMakeRect(80, 40, 40, 40);
        btn.bezelStyle = NSBezelStyleTexturedRounded;
        btn.enabled = NO;
        
        btn;
    });
    
    NSScrollView *forwardingToScrollView = ({
           NSScrollView *forwardingToScrollView = [[NSScrollView alloc] init];
           forwardingToScrollView.hasVerticalScroller = YES;
           forwardingToScrollView.frame = NSMakeRect(360, 80, 200, 375);
           forwardingToScrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
           
           forwardingToScrollView;
       });

    self.forwardingToTableView = ({
        NSTableView *forwardingToTableView = [[NSTableView alloc] init];
        forwardingToTableView.frame = forwardingToScrollView.bounds;
        forwardingToTableView.allowsTypeSelect = YES;
        forwardingToTableView.delegate = self;
        forwardingToTableView.dataSource = self;
        NSTableColumn *column = [[NSTableColumn alloc] init];
        column.title = YMLocalizedString(@"assistant.autoForwarding.forwardingToList");
        column.width = 200;
        [forwardingToTableView addTableColumn:column];
        if ([YMWeChatPluginConfig sharedConfig].usingDarkTheme) {
            [[YMThemeManager shareInstance] changeTheme:forwardingToTableView color:[YMWeChatPluginConfig sharedConfig].mainChatCellBackgroundColor];
        }
        forwardingToTableView;
    });
    
    self.forwardingToAddButton = ({
        NSButton *btn = [NSButton tk_buttonWithTitle:@"＋" target:self action:@selector(forwardingToAdd)];
        btn.frame = NSMakeRect(360, 40, 40, 40);
        btn.bezelStyle = NSBezelStyleTexturedRounded;
        
        btn;
    });

    self.forwardingToReduceButton = ({
        NSButton *btn = [NSButton tk_buttonWithTitle:@"－" target:self action:@selector(forwardingToReduce)];
        btn.frame = NSMakeRect(410, 40, 40, 40);
        btn.bezelStyle = NSBezelStyleTexturedRounded;
        btn.enabled = NO;
        
        btn;
    });


    self.enableButton = ({
        NSButton *btn = [NSButton tk_checkboxWithTitle:YMLocalizedString(@"assistant.autoForwarding.enable") target:self action:@selector(clickEnableBtn:)];
        btn.frame = NSMakeRect(30, 5, 230, 20);
        btn.state = [[YMWeChatPluginConfig sharedConfig] autoForwardingEnable];
        [YMThemeManager changeButtonTheme:btn];
        btn;
    });

    self.enableAllFirendButton = ({
        NSButton *btn = [NSButton tk_checkboxWithTitle:YMLocalizedString(@"assistant.autoForwarding.enableAllFriend") target:self action:@selector(clickEnableAllFriendBtn:)];
        btn.frame = NSMakeRect(30, 25, 230, 20);
        btn.state = [[YMWeChatPluginConfig sharedConfig] autoForwardingAllFriend];
        [YMThemeManager changeButtonTheme:btn];
        btn;
    });

    scrollView.contentView.documentView = self.forwardingFromTableView;
    forwardingToScrollView.contentView.documentView = self.forwardingToTableView;
    
    
    self.arrowImageView = ({
        NSImage *arrowImage = kImageWithName(@"arrow_forward.png");
        NSImageView *imageView = nil;
        if (@available(macOS 10.12, *)) {
            imageView = [NSImageView imageViewWithImage:arrowImage];
            imageView.frame = NSMakeRect(240, 260, 100, 40);
        } else {
            imageView = [[NSImageView alloc] init];
            imageView.image = arrowImage;
        }
        imageView;
    });
    
    
    [self.window.contentView addSubviews:@[scrollView,
                                           forwardingToScrollView,
                                           self.addButton,
                                           self.enableButton,
                                           self.forwardingToAddButton,
                                           self.forwardingToReduceButton,
                                           self.enableAllFirendButton,
                                           self.reduceButton,
                                           self.arrowImageView]];
}

- (void)setup
{
    self.window.title = YMLocalizedString(@"assistant.autoForwarding.title");
    self.window.contentView.layer.backgroundColor = [kBG1 CGColor];
    [self.window.contentView.layer setNeedsDisplay];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowShouldClosed:) name:NSWindowWillCloseNotification object:nil];
}

- (void)windowShouldClosed:(NSNotification *)notification
{
    if (notification.object != self.window) {
        return;
    }
    if (self.vmodel) {
        [[YMWeChatPluginConfig sharedConfig] saveAutoForwardingModel:self.vmodel];
    }

}

- (void)clickEnableBtn:(NSButton *)btn
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_AUTO_FORWARDING_CHANGE object:nil];
}

- (void)clickEnableAllFriendBtn:(NSButton *)btn
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_AUTO_FORWARDING_ALL_FRIEND_CHANGE object:nil];
}

# pragma mark - Forwarding from
- (void)addModel
{
    MMSessionPickerWindow *picker = [objc_getClass("MMSessionPickerWindow") shareInstance];
    [picker setType:2];
    [picker setShowsGroupChats:0x1];
    [picker setShowsOtherNonhumanChats:0];
    [picker setShowsOfficialAccounts:0];
    MMSessionPickerLogic *logic = [picker.listViewController valueForKey:@"m_logic"];
    NSMutableOrderedSet *orderSet = nil;
    if (LargerOrEqualLongVersion(@"2.4.2.148")) {
        orderSet = [logic valueForKey:@"_groupsForSearch"];
        [picker setPreSelectedUserNames:self.vmodel.forwardingFromContacts];
    } else {
        orderSet = [logic valueForKey:@"_selectedUserNamesSet"];
        [orderSet addObjectsFromArray:self.vmodel.forwardingFromContacts];
        [picker.choosenViewController setValue:self.vmodel.forwardingFromContacts forKey:@"selectedUserNames"];
    }
    
    if (!orderSet) {
        orderSet = [NSMutableOrderedSet new];
    }

    [picker beginSheetForWindow:self.window completionHandler:^(NSOrderedSet *a1) {
        NSMutableArray *array = [NSMutableArray array];
        [a1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array addObject:obj];
        }];
        self.vmodel.forwardingFromContacts = [array copy];
        NSLog(@"%@", self.vmodel.forwardingToContacts);
        NSLog(@"%@", self.vmodel.forwardingFromContacts);
        dispatch_async(dispatch_get_main_queue(), ^{
           [self.forwardingFromTableView reloadData];
        });
    }];
}

- (void)reduceModel
{
    if (self.currentIdx < self.vmodel.forwardingFromContacts.count) {
        NSMutableArray *array = [NSMutableArray array];
        [self.vmodel.forwardingFromContacts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx != self.currentIdx) {
                [array addObject:obj];
            }
        }];
        self.vmodel.forwardingFromContacts = [array copy];
    }
    [self.forwardingFromTableView reloadData];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    NSInteger count = 0;
    if (tableView == self.forwardingFromTableView) {
        NSLog(@"FROM");
        count = self.vmodel.forwardingFromContacts.count;
    } else if (tableView == self.forwardingToTableView) {
        NSLog(@"TO");
        count = self.vmodel.forwardingToContacts.count;
    }
    return count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    YMAIReplyCell *cell = [[YMAIReplyCell alloc] init];
    if (tableView == self.forwardingFromTableView) {
        NSLog(@"FROM");
        cell.frame = NSMakeRect(0, 0, self.forwardingFromTableView.frame.size.width, 40);
        if (row < self.vmodel.forwardingFromContacts.count) {
            cell.wxid = self.vmodel.forwardingFromContacts[row];
        }
    } else if (tableView == self.forwardingToTableView) {
        NSLog(@"TO");
        cell.frame = NSMakeRect(0, 0, self.forwardingToTableView.frame.size.width, 40);
        if (row < self.vmodel.forwardingToContacts.count) {
            cell.wxid = self.vmodel.forwardingToContacts[row];
        }
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
    if (tableView == self.forwardingFromTableView) {
        self.reduceButton.enabled = tableView.selectedRow != -1;
        if (tableView.selectedRow != -1) {
            self.currentIdx = tableView.selectedRow;
        }
    } else if (tableView == self.forwardingToTableView) {
        self.forwardingToReduceButton.enabled = tableView.selectedRow != -1;
        if (tableView.selectedRow != -1) {
            self.forwardingToCurrentIdx = tableView.selectedRow;
        }
    }
}

# pragma mark - Forwarding to
- (void)forwardingToAdd
{
    MMSessionPickerWindow *picker = [objc_getClass("MMSessionPickerWindow") shareInstance];
    [picker setType:2];
    [picker setShowsGroupChats:0x1];
    [picker setShowsOtherNonhumanChats:0];
    [picker setShowsOfficialAccounts:0];
    MMSessionPickerLogic *logic = [picker.listViewController valueForKey:@"m_logic"];
    NSMutableOrderedSet *orderSet = nil;
    if (LargerOrEqualLongVersion(@"2.4.2.148")) {
        orderSet = [logic valueForKey:@"_groupsForSearch"];
        [picker setPreSelectedUserNames:self.vmodel.forwardingToContacts];
    } else {
       orderSet = [logic valueForKey:@"_selectedUserNamesSet"];
        [orderSet addObjectsFromArray:self.vmodel.forwardingToContacts];
        [picker.choosenViewController setValue:self.vmodel.forwardingToContacts forKey:@"selectedUserNames"];
    }
    
    if (!orderSet) {
        orderSet = [NSMutableOrderedSet new];
    }
    
    [picker beginSheetForWindow:self.window completionHandler:^(NSOrderedSet *a1) {
        NSMutableArray *array = [NSMutableArray array];
        [a1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array addObject:obj];
        }];
        self.vmodel.forwardingToContacts = [array copy];
        NSLog(@"%@", self.vmodel.forwardingToContacts);
        NSLog(@"%@", self.vmodel.forwardingFromContacts);
        dispatch_async(dispatch_get_main_queue(), ^{
           [self.forwardingToTableView reloadData];
        });
    }];
}

- (void)forwardingToReduce
{
    if (self.forwardingToCurrentIdx < self.vmodel.forwardingToContacts.count) {
        NSMutableArray *array = [NSMutableArray array];
        [self.vmodel.forwardingToContacts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx != self.forwardingToCurrentIdx) {
                [array addObject:obj];
            }
        }];
        self.vmodel.forwardingToContacts = [array copy];
    }
    [self.forwardingToTableView reloadData];
}

@end
