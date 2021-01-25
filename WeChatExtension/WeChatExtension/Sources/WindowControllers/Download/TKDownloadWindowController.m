//
//  TKDownloadWindowController.m
//  WeChatExtension
//
//  Created by WeChatExtension on 2018/4/28.
//  Copyright © 2018年 WeChatExtension. All rights reserved.
//

#import "TKDownloadWindowController.h"
#import "YMVersionManager.h"
#import "YMRemoteControlManager.h"

typedef NS_ENUM(NSUInteger, TKDownloadState) {
    TKDownloadStateProgress,
    TKDownloadStateFinish,
    TKDownloadStateError
};

@interface TKDownloadWindowController ()

@property (weak) IBOutlet NSTextField *titleLabel;
@property (weak) IBOutlet NSButton *installButton;
@property (weak) IBOutlet NSProgressIndicator *progressView;
@property (weak) IBOutlet NSTextField *progressLabel;
@property (nonatomic, assign) TKDownloadState downloadState;
@property (nonatomic, copy) NSString *filePath;

@end

@implementation TKDownloadWindowController

+ (instancetype)downloadWindowController
{
    static TKDownloadWindowController *windowController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        windowController = [[TKDownloadWindowController alloc] initWithWindowNibName:@"TKDownloadWindowController"];
    });
    return windowController;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [self setup];
}

- (void)setup
{
    [self downloadPlugin];
}

- (void)setupInstallBtnTitle:(NSString *)text
{
    self.installButton.title = text;
    
    CGFloat stringWidth = [text widthWithFont:self.installButton.font];
    self.installButton.width = stringWidth + 40;
    self.installButton.x = 430 - stringWidth - 40;
}

- (void)downloadPlugin
{
    self.downloadState = TKDownloadStateProgress;
    self.window.title = YMLocalizedString(@"assistant.download.title");
    self.titleLabel.stringValue = YMLocalizedString(@"assistant.download.update");
    self.progressView.doubleValue = 0;
    [self setupInstallBtnTitle:YMLocalizedString(@"assistant.download.cancel")];
    
    [[YMVersionManager shareManager] downloadPluginProgress:^(NSProgress *downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView.minValue = 0;
            self.progressView.maxValue = downloadProgress.totalUnitCount / 1024.0;
            self.progressView.doubleValue = downloadProgress.completedUnitCount  / 1024.0;
            CGFloat currentCount = downloadProgress.completedUnitCount / 1024.0 / 1024.0;
            CGFloat totalCount = downloadProgress.totalUnitCount / 1024.0 / 1024.0;
            self.progressLabel.stringValue = [NSString stringWithFormat:@"%.2lf MB / %.2lf MB", currentCount, totalCount];
        });
    } completionHandler:^(NSString *filePath, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                self.downloadState = TKDownloadStateError;
                if (error.code == NSURLErrorCancelled) {
                    self.titleLabel.stringValue = YMLocalizedString(@"assistant.download.cancelTitle");
                    [self setupInstallBtnTitle:YMLocalizedString(@"assistant.download.reDownload")];
                    self.progressLabel.stringValue = @"";
                } else {
                    self.titleLabel.stringValue = YMLocalizedString(@"assistant.download.error");
                    [self setupInstallBtnTitle:YMLocalizedString(@"assistant.download.reInstall")];
                }
                return;
            }
            self.downloadState = TKDownloadStateFinish;
            [self setupInstallBtnTitle:YMLocalizedString(@"assistant.download.relaunch")];
            self.titleLabel.stringValue = YMLocalizedString(@"assistant.download.install");
            self.filePath = filePath;
        });
    }];
}

- (IBAction)clickInstallButton:(NSButton *)sender
{
    switch (self.downloadState) {
        case TKDownloadStateProgress: {
            [[YMVersionManager shareManager] cancelDownload];
            break;
        }
        case TKDownloadStateFinish: {
            NSString *directoryName = [self.filePath stringByDeletingLastPathComponent];
            NSString *fileName = [[self.filePath lastPathComponent] stringByDeletingPathExtension];
            NSString *cmdString = [NSString stringWithFormat:@"cd %@ && unzip -n %@.zip && ./%@/Update.sh",directoryName, fileName, fileName];
            [YMRemoteControlManager executeShellCommand:cmdString];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *cmd = @"killall WeChat && sleep 2s && open /Applications/WeChat.app";
                [YMRemoteControlManager executeShellCommand:cmd];
            });
            break;
        }
        case TKDownloadStateError: {
            [self downloadPlugin];
            break;
        }
        default:
            break;
    }
}

@end
