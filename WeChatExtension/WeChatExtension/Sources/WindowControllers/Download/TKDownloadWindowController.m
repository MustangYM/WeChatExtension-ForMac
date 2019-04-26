//
//  TKDownloadWindowController.m
//  WeChatPlugin
//
//  Created by TK on 2018/4/28.
//  Copyright © 2018年 tk. All rights reserved.
//

#import "TKDownloadWindowController.h"
#import "TKVersionManager.h"
#import "TKRemoteControlManager.h"

typedef NS_ENUM(NSUInteger, TKDownloadState) {
    TKDownloadStateProgress,
    TKDownloadStateFinish,
    TKDownloadStateError,
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

+ (instancetype)downloadWindowController {
    static TKDownloadWindowController *windowController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        windowController = [[TKDownloadWindowController alloc] initWithWindowNibName:@"TKDownloadWindowController"];
    });
    return windowController;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self setup];
}

- (void)setup {
    [self downloadPlugin];
}

- (void)setupInstallBtnTitle:(NSString *)text {
    self.installButton.title = text;
    
    CGFloat stringWidth = [text widthWithFont:self.installButton.font];
    self.installButton.width = stringWidth + 40;
    self.installButton.x = 430 - stringWidth - 40;
}

- (void)downloadPlugin {
    self.downloadState = TKDownloadStateProgress;
    self.window.title = TKLocalizedString(@"assistant.download.title");
    self.titleLabel.stringValue = TKLocalizedString(@"assistant.download.update");
    self.progressView.doubleValue = 0;
    [self setupInstallBtnTitle:TKLocalizedString(@"assistant.download.cancel")];
    
    [[TKVersionManager shareManager] downloadPluginProgress:^(NSProgress *downloadProgress) {
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
                    self.titleLabel.stringValue = TKLocalizedString(@"assistant.download.cancelTitle");
                    [self setupInstallBtnTitle:TKLocalizedString(@"assistant.download.reDownload")];
                    self.progressLabel.stringValue = @"";
                } else {
                    self.titleLabel.stringValue = TKLocalizedString(@"assistant.download.error");
                    [self setupInstallBtnTitle:TKLocalizedString(@"assistant.download.reInstall")];
                }
                return;
            }
            self.downloadState = TKDownloadStateFinish;
            [self setupInstallBtnTitle:TKLocalizedString(@"assistant.download.relaunch")];
            self.titleLabel.stringValue = TKLocalizedString(@"assistant.download.install");
            self.filePath = filePath;
        });
    }];
}

- (IBAction)clickInstallButton:(NSButton *)sender {
    switch (self.downloadState) {
        case TKDownloadStateProgress: {
            [[TKVersionManager shareManager] cancelDownload];
            break;
        }
        case TKDownloadStateFinish: {
            NSString *directoryName = [self.filePath stringByDeletingLastPathComponent];
            NSString *fileName = [[self.filePath lastPathComponent] stringByDeletingPathExtension];
            NSString *cmdString = [NSString stringWithFormat:@"cd %@ && unzip -n %@.zip && ./%@/Other/Update.sh && killall WeChat && sleep 2s && open /Applications/WeChat.app",directoryName, fileName, fileName];
            [TKRemoteControlManager executeShellCommand:cmdString];
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
