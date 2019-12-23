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

@end

@implementation TKAboutWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    self.window.backgroundColor = [NSColor whiteColor];
    NSDictionary *localInfo = [[TKWeChatPluginConfig sharedConfig] localInfoPlist];
    if (!localInfo) {
        return;
    }
    NSString *localBundle = localInfo[@"CFBundleShortVersionString"];
    self.versionLabel.stringValue = localBundle;
    self.projectHomepageLabel.stringValue = YMLocalizedString(@"about.projectHomepageLabel");
    
//    NSString *path = [[NSBundle bundleWithIdentifier:@"MustangYM.WeChatExtension"] pathForResource:@"about" ofType:@"rtfd"];
//    [self.textView readRTFDFromFile:path];
//    self.textView.selectable = YES;
}

- (IBAction)didClickHomepageURL:(NSButton *)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/MustangYM/WeChatExtension-ForMac"]];
}

@end
