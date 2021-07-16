//
//  YMThemeSettingWindowViewController.m
//  WeChatGirlFriend
//
//  Created by MustangYM on 2021/7/2.
//  Copyright © 2021 YY Inc. All rights reserved.
//

#import "YMThemeSettingWindowViewController.h"
#import "YMJNWCollectionView.h"
#import "YMThemCell.h"
#import "TCBlobDownloadManager.h"
#import "YMCacheManager.h"
#import "YMThemeConfigModel.h"
#import "NSDictionary+Safe.h"
#import "NSViewLayoutTool.h"
#import "YMWeChatPluginConfig.h"
#import "YMRemoteControlManager.h"

static NSString *const kConfigUrl = @"https://gitee.com/MustangYM/we-chat-extension-source/raw/master/Pictures/ThemeConfig.plist";

@interface YMThemeSettingWindowViewController ()<YMJNWCollectionViewDataSource, YMJNWCollectionViewGridLayoutDelegate, YMJNWCollectionViewDelegate>
@property (nonatomic, strong) YMJNWCollectionView *collectionView;
@property (nonatomic, strong) TCBlobDownloadManager *downloader;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak) IBOutlet NSButton *sureButton;
@end

@implementation YMThemeSettingWindowViewController

- (void)windowDidLoad {
    [super windowDidLoad];
    [self setupUI];
    [self requestMainConfig];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowWillClose:) name:NSWindowWillCloseNotification object:nil];
}

- (void)windowWillClose:(NSNotification *)notification
{
    if (notification.object != self.window) {
        return;
    }
    [self requestMainConfig];
}

- (IBAction)onSureButtonClick:(id)sender {
    [self.dataArray enumerateObjectsUsingBlock:^(YMThemeConfigModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelected) {
            [[NSUserDefaults standardUserDefaults] setObject:obj.url forKey:@"kSKINURL"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSString *msg = nil;
            msg = YMLanguage(@"确定换肤, 重启生效!",@"Turn on Pink mode and restart to take effect!");
            NSAlert *alert = [NSAlert alertWithMessageText:YMLanguage(@"警告", @"WARNING")
                                             defaultButton:YMLanguage(@"取消", @"cancel")                       alternateButton:YMLanguage(@"确定重启",@"restart")
                                               otherButton:nil                              informativeTextWithFormat:@"%@", msg];
            NSUInteger action = [alert runModal];
            if (action == NSAlertAlternateReturn) {
                __weak __typeof (self) wself = self;
                [[YMWeChatPluginConfig sharedConfig] setSkinMode:YES];
                [[YMWeChatPluginConfig sharedConfig] setDarkMode:NO] ;
                [[YMWeChatPluginConfig sharedConfig] setBlackMode:NO];
                [[YMWeChatPluginConfig sharedConfig] setFuzzyMode:NO];
                [[YMWeChatPluginConfig sharedConfig] setPinkMode:NO] ;
                [wself restartWeChat];
            }
            *stop = YES;
        }
    }];
}

- (void)restartWeChat
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *cmd = @"killall WeChat && sleep 2s && open /Applications/WeChat.app";
        [YMRemoteControlManager executeShellCommand:cmd];
    });
}

- (void)setupUI
{
    self.window.maxSize = CGSizeMake(1200, 720);
    self.window.minSize = CGSizeMake(1200, 720);
    
    YMJNWCollectionView *collectionView = [[YMJNWCollectionView alloc] init];
    self.collectionView = collectionView;
    collectionView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.window.contentView addSubview:collectionView];
    
    [collectionView addConstraint:NSLayoutAttributeLeft constant:30];
    [collectionView addConstraint:NSLayoutAttributeBottom constant:-100];
    [collectionView addConstraint:NSLayoutAttributeTop constant:100];
    [collectionView addConstraint:NSLayoutAttributeRight constant:-30];
    
    NSVisualEffectView *effectView = [[NSVisualEffectView alloc] init];
    effectView.blendingMode = NSVisualEffectBlendingModeBehindWindow;
    if (@available(macOS 10.11, *)) {
        effectView.material = NSVisualEffectMaterialMediumLight;
    } else {
        // Fallback on earlier versions
    }
    effectView.state = NSVisualEffectStateActive;
    effectView.frame = CGRectMake(0, 0, 1200, 720);
    
    NSView *firstSubView = collectionView.subviews[0];
    [collectionView addSubview:effectView positioned:NSWindowBelow relativeTo:firstSubView];
    
    [effectView addConstraint:NSLayoutAttributeLeft constant:30];
    [effectView addConstraint:NSLayoutAttributeBottom constant:-30];
    [effectView addConstraint:NSLayoutAttributeTop constant:100];
    [effectView addConstraint:NSLayoutAttributeRight constant:-30];
    
    YMJNWCollectionViewGridLayout *gridLayout = [[YMJNWCollectionViewGridLayout alloc] init];
    gridLayout.delegate = self;;
    gridLayout.itemSize = CGSizeMake(550, 400);
    gridLayout.verticalSpacing = 10.f;
    collectionView.collectionViewLayout = gridLayout;
    
    [collectionView registerClass:YMThemCell.class forCellWithReuseIdentifier:@"YMThemCell"];
}

- (void)requestMainConfig
{
    NSString *filePath = [[YMCacheManager shareManager] filePathWithName:[NSString stringWithFormat:@"%.0f.plist",[[NSDate date] timeIntervalSince1970]]];
    self.downloader = [TCBlobDownloadManager sharedInstance];
    [self.downloader startDownloadWithURL:[NSURL URLWithString:kConfigUrl] customPath:filePath firstResponse:^(NSURLResponse *response) {
        
    } progress:^(uint64_t receivedLength, uint64_t totalLength, NSInteger remainingTime, float progress) {
        
    } error:^(NSError *error) {
        
    } complete:^(BOOL downloadFinished, NSString *pathToFile) {
        [self parseConfigFile:pathToFile];
    }];
}

- (void)parseConfigFile:(NSString *)file
{
    [self.dataArray removeAllObjects];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:file];
    NSArray *data = [dict arrayForKey:@"data"];
    NSMutableArray *temp = [NSMutableArray array];
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSDictionary.class]) {
            NSDictionary *dic = (NSDictionary *)obj;
            YMThemeConfigModel *model = [YMThemeConfigModel modelWith:dic];
            if (model) {
                [temp addObject:model];
            }
        }
    }];
    [self.dataArray addObjectsFromArray:temp];
    [self.collectionView reloadData];
}

#pragma mark - Delegate

- (YMJNWCollectionViewCell *)collectionView:(YMJNWCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YMThemCell *cell = (YMThemCell *)[collectionView dequeueReusableCellWithIdentifier:@"YMThemCell"];
    if (@available(macOS 10.11, *)) {
        if (indexPath.item < self.dataArray.count) {
            YMThemeConfigModel *model = self.dataArray[indexPath.item];
            [cell reloadBy:model];
        }
    } 
    return cell;
}

- (NSUInteger)collectionView:(YMJNWCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}



- (void)collectionView:(YMJNWCollectionView *)collectionView mouseDownInItemAtIndexPath:(NSIndexPath *)indexPath withEvent:(NSEvent *)event
{
    [self.dataArray enumerateObjectsUsingBlock:^(YMThemeConfigModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isSelected = NO;
    }];
    
    if (@available(macOS 10.11, *)) {
        if (indexPath.item < self.dataArray.count) {
            YMThemeConfigModel *model = self.dataArray[indexPath.item];
            model.isSelected = YES;
        }
    }
    [collectionView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        YMJNWCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        CAKeyframeAnimation *rotationAnimation = [CAKeyframeAnimation animation];
        rotationAnimation.keyPath = @"transform.scale";
        rotationAnimation.duration = 0.3;
        rotationAnimation.values = @[@1.01,@1.02,@1.01,@1.0];
        rotationAnimation.repeatCount = 1;
        [cell.layer addAnimation:rotationAnimation forKey:nil];
    });
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
