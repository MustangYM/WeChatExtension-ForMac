//
//  TKAboutWindowController.m
//  WeChatExtension
//
//  Created by WeChatExtension on 2018/5/4.
//  Copyright © 2018年 WeChatExtension. All rights reserved.
//

#import "TKAboutWindowController.h"

@interface TKAboutWindowController ()

@property (weak) IBOutlet NSTextField *versionLabel;
@property (weak) IBOutlet NSTextField *projectHomepageLabel;
@property (weak) IBOutlet NSTextField *titleLabel;
@property (weak) IBOutlet NSTextField *homePageTitleLabel;
@property (weak) IBOutlet NSImageView *aliPay;
@property (weak) IBOutlet NSTextField *WeiboLabel;
@property (weak) IBOutlet NSImageView *WeChatPayImageView;

@end

@implementation TKAboutWindowController

- (void)windowDidLoad
{
    [super windowDidLoad];
    self.titleLabel.stringValue = YMLanguage(@"微信小助手", @"WeChat Assistant");
    self.homePageTitleLabel.stringValue = YMLanguage(@"唯一主页:", @"Only Homepage:");
    self.WeiboLabel.stringValue = YMLanguage(@"微博:", @"Weibo:");
    self.window.backgroundColor = [NSColor whiteColor];
    NSDictionary *localInfo = [[YMWeChatPluginConfig sharedConfig] localInfoPlist];
    if (!localInfo) {
        return;
    }
    NSString *localBundle = localInfo[@"CFBundleShortVersionString"];
    self.versionLabel.stringValue = [NSString stringWithFormat:@"V %@",localBundle];
    
    self.aliPay.image = kImageWithName(@"aliPayCode.png");
    
    self.WeChatPayImageView.image = kImageWithName(@"WeChatPayCode.png");
}

- (IBAction)didClickHomepageURL:(NSButton *)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/MustangYM/WeChatExtension-ForMac"]];
}

- (IBAction)didClickWeiBo:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://weibo.com/2868079432/profile?rightmod=1&wvr=6&mod=personinfo&is_all=1"]];
}

@end
