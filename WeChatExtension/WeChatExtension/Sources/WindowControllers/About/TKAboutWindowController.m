//
//  TKAboutWindowController.m
//  WeChatPlugin
//
//  Created by TK on 2018/5/4.
//  Copyright © 2018年 tk. All rights reserved.
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
    NSString *localBundle = localInfo[@"CFBundleShortVersionString"];
    self.versionLabel.stringValue = localBundle;
    
    NSString *path = [[NSBundle bundleWithIdentifier:@"tk.WeChatPlugin"] pathForResource:@"about" ofType:@"rtfd"];
    [self.textView readRTFDFromFile:path];
    self.textView.selectable = YES;
}

@end
