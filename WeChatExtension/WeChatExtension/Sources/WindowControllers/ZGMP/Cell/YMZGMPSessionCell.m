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
           avatar;
       });
       
       self.nameLabel = ({
           NSTextField *label = [NSTextField tk_labelWithString:@""];
           label.editable = YES;
           label.textColor = [NSColor blackColor];
           [[label cell] setLineBreakMode:NSLineBreakByCharWrapping];
           [[label cell] setTruncatesLastVisibleLine:YES];
           label.font = [NSFont systemFontOfSize:12];
           label.frame = NSMakeRect(40, 12, 200, 16);
           label;
       });
       
       self.bottomLine = ({
           NSBox *line = [[NSBox alloc] init];
           line.frame = NSMakeRect(0, 0, 300, 0.5);
           [[YMThemeManager shareInstance] changeTheme:line color:YM_RGBA(242, 242, 242, 1.0)];
           line;
       });
       
       [self addSubviews:@[self.avatar,
                           self.nameLabel,
                           self.bottomLine]];
    
    [self.bottomLine addConstraint:NSLayoutAttributeLeft constant:0];
    [self.bottomLine addConstraint:NSLayoutAttributeBottom constant:0];
    [self.bottomLine addConstraint:NSLayoutAttributeRight constant:0];
    [self.bottomLine addHeightConstraint:0.5];
}

- (void)setMemberInfo:(YMZGMPInfo *)memberInfo
{
    _memberInfo = memberInfo;
    if (!memberInfo.contact) {
        return;
    }
    __weak __typeof (self) wself = self;
    MMAvatarService *avatarService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMAvatarService")];
    [avatarService getAvatarImageWithContact:memberInfo.contact completion:^(NSImage *image) {
        wself.avatar.image = image ?: kImageWithName(@"order_avatar.png");
    }];
    self.nameLabel.stringValue = memberInfo.contact.m_nsRemark.length > 0 ? memberInfo.contact.m_nsRemark : memberInfo.contact.m_nsNickName;
    if (memberInfo.timestamp <= 0) {
        [[YMThemeManager shareInstance] changeTheme:self color:YM_RGBA(99, 99, 99, 0.2)];
    } else {
        [[YMThemeManager shareInstance] changeTheme:self color:[NSColor clearColor]];
    }
}

@end
