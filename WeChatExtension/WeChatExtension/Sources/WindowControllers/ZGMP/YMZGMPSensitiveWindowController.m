//
//  YMZGMPSensitiveWindowController.m
//  WeChatExtension
//
//  Created by MustangYM on 2021/1/14.
//  Copyright © 2021 MustangYM. All rights reserved.
//

#import "YMZGMPSensitiveWindowController.h"
#import "YMSensitiveTableView.h"
#import "YMThemeManager.h"
#import "NSViewLayoutTool.h"
#import "YMZGMPSensitiveCell.h"

@interface YMZGMPSensitiveWindowController ()<NSTableViewDelegate, NSTableViewDataSource>
@property (nonatomic, strong) YMSensitiveTableView *tableView;
@property (nonatomic, strong) NSScrollView *scrollView;
@property (nonatomic, strong) NSImage *avatar;
@property (nonatomic, strong) NSTextField *detailLabel;
@property (nonatomic, strong) NSImageView *defaultImageView;
@end

@implementation YMZGMPSensitiveWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    [self initSubviews];
}

- (void)setInfo:(YMZGMPInfo *)info
{
    _info = info;
    __weak __typeof (self) wself = self;
    MMAvatarService *avatarService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMAvatarService")];
    [avatarService getAvatarImageWithContact:info.contact completion:^(NSImage *image) {
        wself.avatar = image ?: kImageWithName(@"order_avatar.png");
        [wself.tableView reloadData];
    }];
    self.defaultImageView.hidden = info.sensitiveMsgs.count > 0;
    
    NSString *title = nil;
    if ([YMWeChatPluginConfig sharedConfig].languageType == PluginLanguageTypeZH) {
       title = [NSString stringWithFormat:@"敏感言论(%lu)",info.sensitiveMsgs.count];
    } else {
        title = [NSString stringWithFormat:@"Violation(%lu)",info.sensitiveMsgs.count];
    }
    self.window.title = title;
}

#pragma mark - NSTableViewDelegate & NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
   return self.info.sensitiveMsgs.count;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 50.f;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
   YMZGMPSensitiveCell *cell = [[YMZGMPSensitiveCell alloc] init];
    if (row < self.info.sensitiveMsgs.count) {
        MessageData *info = self.info.sensitiveMsgs[row];
        cell.msgData = info;
        cell.avatar = self.avatar;
    }
    return cell;
}

#pragma mark - View
- (void)initSubviews
{
    self.window.title = YMLanguage(@"敏感言论", @"Violation");
    NSScrollView *scrollView = ({
        NSScrollView *scrollView = [[NSScrollView alloc] init];
        scrollView.hasVerticalScroller = YES;
        scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        scrollView;
    });
    self.scrollView = scrollView;
    
    self.tableView = ({
        YMSensitiveTableView *tableView = [[YMSensitiveTableView alloc] init];
        tableView.frame = scrollView.bounds;
        tableView.allowsTypeSelect = YES;
        tableView.delegate = self;
        tableView.dataSource = self;
        NSTableColumn *nameColumn = [[NSTableColumn alloc] init];
        nameColumn.title = YMLanguage(@"遵纪守法和遵守社会公德", @"Don't do something");
        nameColumn.width = 100;
        [tableView addTableColumn:nameColumn];
        if ([YMWeChatPluginConfig sharedConfig].usingDarkTheme) {
            [[YMThemeManager shareInstance] changeTheme:tableView color:[YMWeChatPluginConfig sharedConfig].mainChatCellBackgroundColor];
        }
        tableView;
    });
    scrollView.contentView.documentView = self.tableView;
    
    self.detailLabel = ({
          NSTextField *label = [NSTextField tk_labelWithString:YMLanguage(@"别看你今天闹得欢, 小心今后拉清单!", @"Too young, too simple, sometimes naive!")];
          label.textColor = [NSColor blackColor];
          [[label cell] setLineBreakMode:NSLineBreakByTruncatingMiddle];
          [[label cell] setTruncatesLastVisibleLine:YES];
          label.font = [NSFont systemFontOfSize:10];
          label.textColor = [NSColor lightGrayColor];
          label.alignment = NSTextAlignmentCenter;
          label;
      });
    
    self.defaultImageView = ({
        NSImageView *imageView = [[NSImageView alloc] init];
        imageView.image = kImageWithName(@"WeChatIcon_128.png");
        imageView.alphaValue = 0.5;
        imageView;
    });
    
    [self.window.contentView addSubview:scrollView];
    [scrollView addConstraint:NSLayoutAttributeLeft constant:20];
    [scrollView addConstraint:NSLayoutAttributeBottom constant:-50];
    [scrollView addConstraint:NSLayoutAttributeRight constant:-20];
    [scrollView addConstraint:NSLayoutAttributeTop constant:20];
    
    [self.window.contentView addSubview:self.detailLabel];
    [self.detailLabel addConstraint:NSLayoutAttributeBottom constant:-12];
    [self.detailLabel addConstraint:NSLayoutAttributeLeft constant:100];
    [self.detailLabel addConstraint:NSLayoutAttributeRight constant:-100];
    [self.detailLabel addHeightConstraint:20];
    
    [self.window.contentView addSubview:self.defaultImageView];
    [self.defaultImageView addConstraint:NSLayoutAttributeCenterX constant:0];
    [self.defaultImageView addConstraint:NSLayoutAttributeCenterY constant:-25];
    [self.defaultImageView addWidthConstraint:50];
    [self.defaultImageView addHeightConstraint:50];
}

@end
