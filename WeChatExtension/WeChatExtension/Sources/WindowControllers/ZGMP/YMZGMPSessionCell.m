//
//  YMZGMPSessionCell.m
//  WeChatExtension
//
//  Created by MustangYM on 2020/10/22.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import "YMZGMPSessionCell.h"
#import "NSViewLayoutTool.h"
#import "YMZGMPInfoHelper.h"
#import "YMIMContactsManager.h"
#import "YMThemeManager.h"

@interface YMZGMPSessionCell ()
@property (nonatomic, strong) NSImageView *avatar;
@property (nonatomic, strong) NSTextField *nameLabel;
@property (nonatomic, strong) NSBox *bottomLine;
@end

@implementation YMZGMPSessionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initSubViews];
    }
    return self;
}

- (void)_initSubViews
{
    self.avatar = ({
           NSImageView *avatar = [[NSImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
           avatar.wantsLayer = YES;
           avatar.layer.cornerRadius = 3;
           avatar;
       });
       
       self.nameLabel = ({
           NSTextField *label = [NSTextField tk_labelWithString:@""];
           label.textColor = [NSColor blackColor];
           [[label cell] setLineBreakMode:NSLineBreakByCharWrapping];
           [[label cell] setTruncatesLastVisibleLine:YES];
           label.font = [NSFont systemFontOfSize:12];
           label.frame = NSMakeRect(40, 12, 200, 16);
           label;
       });
       
       self.bottomLine = ({
           NSBox *line = [[NSBox alloc] init];
           line.boxType = NSBoxSeparator;
           line.frame = NSMakeRect(0, 0, 200, 0.5);
           if (YMWeChatPluginConfig.sharedConfig.usingDarkTheme) {
               [[YMThemeManager shareInstance] changeTheme:line color:[NSColor lightGrayColor]];
           }
           line;
       });
       
       [self addSubviews:@[self.avatar,
                           self.nameLabel,
                           self.bottomLine]];
}

- (void)setMemberInfo:(YMZGMPInfo *)memberInfo
{
    _memberInfo = memberInfo;
    WCContactData *contact = [YMIMContactsManager getMemberInfo:memberInfo.wxid];
    __weak __typeof (self) wself = self;
    MMAvatarService *avatarService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMAvatarService")];
    [avatarService getAvatarImageWithContact:contact completion:^(NSImage *image) {
        wself.avatar.image = image ?: kImageWithName(@"order_avatar.png");
    }];
    self.nameLabel.stringValue = memberInfo.nick;
}

@end
