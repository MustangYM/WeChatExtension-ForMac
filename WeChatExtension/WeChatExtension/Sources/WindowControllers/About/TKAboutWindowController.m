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

@end

@implementation TKAboutWindowController

- (void)windowDidLoad
{
    [super windowDidLoad];
    self.titleLabel.stringValue = YMLanguage(@"微信小助手", @"WeChat Assistant");
    self.homePageTitleLabel.stringValue = YMLanguage(@"项目主页:", @"Project Homepage:");
    self.window.backgroundColor = [NSColor whiteColor];
    NSDictionary *localInfo = [[TKWeChatPluginConfig sharedConfig] localInfoPlist];
    if (!localInfo) {
        return;
    }
    NSString *localBundle = localInfo[@"CFBundleShortVersionString"];
    self.versionLabel.stringValue = localBundle;
    
    NSBundle *bundle = [NSBundle bundleWithIdentifier:@"MustangYM.WeChatExtension"];
    NSString *imgPath= [bundle pathForImageResource:@"aliPayCode.png"];
    NSImage *placeholder = [[NSImage alloc] initWithContentsOfFile:imgPath];
    self.aliPay.image = placeholder;
}

- (IBAction)didClickHomepageURL:(NSButton *)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/MustangYM/WeChatExtension-ForMac"]];
}

@end
