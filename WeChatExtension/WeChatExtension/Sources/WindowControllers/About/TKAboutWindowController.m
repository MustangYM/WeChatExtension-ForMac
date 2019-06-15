//
//  TKAboutWindowController.m
//  WeChatExtension
//
//  Created by WeChatExtension on 2018/5/4.
//  Copyright © 2018年 WeChatExtension. All rights reserved.
//

#import "TKAboutWindowController.h"

@interface TKAboutWindowController ()

@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (weak) IBOutlet NSTextField *versionLabel;

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
    
//    NSString *path = [[NSBundle bundleWithIdentifier:@"MustangYM.WeChatExtension"] pathForResource:@"about" ofType:@"rtfd"];
//    [self.textView readRTFDFromFile:path];
//    self.textView.selectable = YES;
}

@end
