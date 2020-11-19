//
//  YMAIReplyCell.m
//  WeChatExtension
//
//  Created by MustangYM on 2019/12/3.
//  Copyright © 2019 MustangYM. All rights reserved.
//

#import "YMAIReplyCell.h"
#import "YMIMContactsManager.h"
#import "YMThemeManager.h"
#import "NSViewLayoutTool.h"
#import "YMZGMPInfoHelper.h"
#import "YMCacheManager.h"

@interface YMAIReplyCell ()
@property (nonatomic, strong) NSImageView *avatar;
@property (nonatomic, strong) NSTextField *nameLabel;
@property (nonatomic, strong) NSBox *bottomLine;
@property (nonatomic, strong) NSImageView *lock;
@property (nonatomic, strong) NSView *lockContentView;
@end

@implementation YMAIReplyCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initSubViews];
        [self.window makeFirstResponder:self];

    }
    return self;
}

- (void)_initSubViews
{
    self.avatar = ({
        NSImageView *avatar = [[NSImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
        avatar.wantsLayer = YES;
        avatar.layer.cornerRadius = 3;
        avatar;
    });
    
    self.lockContentView = ({
        NSView *view = [[NSView alloc] init];
        view.hidden = YES;
        [[YMThemeManager shareInstance] changeTheme:view color:YM_RGBA(150, 150, 150, 0.5)];
        
        NSImageView *lock = [[NSImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
        lock.image = kImageWithName(@"lock.png");
        lock.wantsLayer = YES;
        lock.layer.cornerRadius = 3;
        
        [view addSubview:lock];
        [lock addConstraint:NSLayoutAttributeCenterX constant:0];
        [lock addConstraint:NSLayoutAttributeCenterY constant:0];
        [lock addHeightConstraint:40];
        [lock addWidthConstraint:40];
        
        view;
    });
    
    self.nameLabel = ({
        NSTextField *label = [NSTextField tk_labelWithString:@""];
        label.textColor = [NSColor blackColor];
        [[label cell] setLineBreakMode:NSLineBreakByCharWrapping];
        [[label cell] setTruncatesLastVisibleLine:YES];
        label.font = [NSFont systemFontOfSize:12];
        label.frame = NSMakeRect(50, 30, 260, 16);
        label;
    });
    
    self.bottomLine = ({
        NSBox *line = [[NSBox alloc] init];
        line.boxType = NSBoxSeparator;
        line.frame = NSMakeRect(0, 0, 300, 0.5);
        if (YMWeChatPluginConfig.sharedConfig.usingDarkTheme) {
            [[YMThemeManager shareInstance] changeTheme:line color:[NSColor lightGrayColor]];
        }
        line;
    });
    
    [self addSubviews:@[self.avatar,
                        self.nameLabel,
                        self.bottomLine]];
    [self addSubview:self.lockContentView];
    [self.lockContentView fillSuperView];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
   
}

- (void)onUpdateCell
{
}

- (void)setInfo:(YMZGMPGroupInfo *)info
{
    _info = info;
    if (!info.wxid) {
        return;
    }
    self.wxid = info.wxid;
    self.lockContentView.hidden = !info.isIgnore;
    info.nick = self.nameLabel.stringValue;
    [self onUpdateCell];
}

- (void)setWxid:(NSString *)wxid
{
    _wxid = wxid;
    
    if (!wxid) {
        return;
    }
    
    NSString *nickName = @"";
    WCContactData *contact = nil;
    
    if ([wxid containsString:@"@chatroom"]) {
        MMSessionInfo *info = [YMIMContactsManager getSessionInfo:wxid];
        nickName = info.m_packedInfo.m_contact.m_nsNickName.length > 0 ? info.m_packedInfo.m_contact.m_nsNickName : (self.info.nick ?: YMLanguage(@"未定义群名", @"No Group Name"));
        GroupStorage *groupStorage = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("GroupStorage")];
        contact = [groupStorage GetGroupContact:wxid];
        if (!contact) nickName = YMLanguage(@"无效群", @"Invalid Group Name");
    } else {
        nickName = [YMIMContactsManager getWeChatNickName:wxid];
        contact = [YMIMContactsManager getMemberInfo:wxid];
    }
    
    __weak __typeof (self) wself = self;
    MMAvatarService *avatarService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMAvatarService")];
    [avatarService getAvatarImageWithContact:contact completion:^(NSImage *image) {
        wself.avatar.image = image ?: kImageWithName(@"order_avatar.png");
    }];
    self.nameLabel.stringValue = nickName.length > 0 ? nickName : wxid;
}
@end
