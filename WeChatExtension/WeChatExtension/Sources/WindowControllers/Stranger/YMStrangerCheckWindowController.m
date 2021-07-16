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
#import "NSViewLayoutTool.h"

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAddStranger:) name:@"k_MONITER_STRANGE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBusy) name:@"k_MONITER_BUSY" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)onBusy
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *zhMsg = [NSString stringWithFormat:@"休息一会, 十分钟后再检测!",self.dataArray.count];
           NSString *enMsg = [NSString stringWithFormat:@"Take a break and test again in ten minutes!"];
           NSAlert *alert = [NSAlert alertWithMessageText:YMLanguage(@"警告", @"WARNING")
                                            defaultButton:YMLanguage(@"取消", @"cancel")                       alternateButton:YMLanguage(@"确定",@"sure")
                                              otherButton:nil                              informativeTextWithFormat:@"%@", YMLanguage(zhMsg, enMsg)];
           NSUInteger action = [alert runModal];
           
           [[NSUserDefaults standardUserDefaults] setInteger:self.dataArray.count forKey:@"kPreCheckCount"];
           [[NSUserDefaults standardUserDefaults] synchronize];
           
           [self.timer invalidate];
           self.timer = nil;
           self.progress.hidden = YES;
           self.indicatorLabel.hidden = YES;
           self.addButton.enabled = YES;
    });
}

- (void)onAddStranger:(NSNotification *)ntf
{
    if (ntf.object) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.dataArray addObject:ntf.object];
            [self.tableView reloadData];
            
            NSString *str = [NSString stringWithFormat:@"%@(%lu)",YMLanguage(@"无感知检测", @"Silent detection"),(unsigned long)self.dataArray.count];
            [self.desLabel setStringValue:str];
            
            MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
            if ([sessionMgr respondsToSelector:@selector(onMsgDeletedForSession:)]) {
                [sessionMgr onMsgDeletedForSession:ntf.object];
            }
        });
    }
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
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
}

- (void)initSubviews
{
    self.window.title = YMLanguage(@"检测僵尸粉", @"Stranger Check");
    NSInteger leftSpace = 10;
    NSScrollView *scrollView = ({
        NSScrollView *scrollView = [[NSScrollView alloc] init];
        scrollView.hasVerticalScroller = YES;
        scrollView.frame = NSMakeRect(80 + leftSpace, 50, 300, 380);
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
        NSTextField *label = [NSTextField tk_labelWithString:YMLanguage(@"无感知检测", @"Silent detection")];
        label.textColor = [NSColor grayColor];
        [[label cell] setLineBreakMode:NSLineBreakByCharWrapping];
        [[label cell] setAlignment:NSTextAlignmentCenter];
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
        NSTextField *label = [NSTextField tk_labelWithString:YMLanguage(@"", @"")];
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
    
    [self.desLabel addConstraint:NSLayoutAttributeTop constant:0];
    [self.desLabel addConstraint:NSLayoutAttributeCenterX constant:0];
    [self.desLabel addWidthConstraint:300];
    [self.desLabel addHeightConstraint:70];
    
    [scrollView addConstraint:NSLayoutAttributeTop constant:30];
    [scrollView addConstraint:NSLayoutAttributeLeft constant:10];
    [scrollView addConstraint:NSLayoutAttributeRight constant:-10];
    [scrollView addConstraint:NSLayoutAttributeBottom constant:-80];
    
    [self.progress startAnimation:nil];
}

- (void)onCheckStranger
{
    NSInteger flag = [[NSUserDefaults standardUserDefaults] integerForKey:@"kPreCheckCount"];
    if (flag > 0) {
        NSString *zhMsg = [NSString stringWithFormat:@"是否继续上次暂停的检测任务?",self.dataArray.count];
        NSString *enMsg = [NSString stringWithFormat:@"Do you want to continue the last suspended detection task?"];
        NSAlert *alert = [NSAlert alertWithMessageText:YMLanguage(@"警告", @"WARNING")
                                         defaultButton:YMLanguage(@"取消", @"cancel")                       alternateButton:YMLanguage(@"确定",@"sure")
                                           otherButton:nil                              informativeTextWithFormat:@"%@", YMLanguage(zhMsg, enMsg)];
        NSUInteger action = [alert runModal];
        if (action == NSAlertAlternateReturn ) {
            [self isCoontinueCheck:YES];
        }
    } else {
        [self isCoontinueCheck:NO];
    }
}

- (void)isCoontinueCheck:(BOOL)flag
{
    ContactStorage *contactStorage = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("ContactStorage")];
    __block int64_t i = 0;
    self.addButton.enabled = NO;
    NSArray *contacts = [YMIMContactsManager getAllFriendContactsWithOutChatroom];
    
    NSInteger preCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"kPreCheckCount"];
    NSMutableArray *tempArray;
    if (flag) {
        tempArray = [NSMutableArray arrayWithArray:[contacts subarrayWithRange:NSMakeRange(preCount, contacts.count - preCount - 1)]];
    } else {
        tempArray = [NSMutableArray arrayWithArray:contacts];
    }
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (tempArray.count <= 1) {
            [self onRelease];
            return;
        }
        
        i++;
        int64_t min = (tempArray.count * 1 * 2) / 60;
        
        NSString *enMsg = [NSString stringWithFormat:@"%lld/%ld %lld minutes to scan", i, contacts.count, min];
        NSString *zhMsg = @"";
        if (min > 0) {
            zhMsg = [NSString stringWithFormat:@"%lld/%ld 检测还需约%lld分钟", i, contacts.count, min];
        } else {
            zhMsg = [NSString stringWithFormat:@"%lld/%ld 检测还需约%lu秒", i, contacts.count, tempArray.count * 1 * 2];
        }
        [self.indicatorLabel setStringValue:YMLanguage(zhMsg, enMsg)];
        self.progress.hidden = NO;
        self.indicatorLabel.hidden = NO;
        
        WCContactData *contactData = [tempArray firstObject];
        
        WCContactData *data = [YMIMContactsManager getMemberInfo:contactData.m_nsUsrName];
        
        [[YMMessageManager shareManager] sendTextMessage:@"وُحخ ̷̴̐خ ̷̴̐خ ̷̴̐خ امارتيخ ̷̴̐خ" toUsrName:data.m_nsUsrName delay:0];
        if (tempArray.count > 0) {
            [tempArray  removeObjectAtIndex:0];
        }
    }];
    
    self.timer = timer;
    [timer fire];
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
