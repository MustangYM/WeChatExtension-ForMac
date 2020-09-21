//
//  YMAIReplyCell.m
//  WeChatExtension
//
//  Created by MustangYM on 2019/12/3.
//  Copyright © 2019 MustangYM. All rights reserved.
//

#import "YMStrangerCheckCell.h"
#import "YMIMContactsManager.h"

@interface YMStrangerCheckCell ()
@property (nonatomic, strong) NSImageView *avatar;
@property (nonatomic, strong) NSTextField *nameLabel;
@property (nonatomic, strong) NSBox *bottomLine;
@end

@implementation YMStrangerCheckCell
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
           NSImageView *avatar = [[NSImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
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
           label.frame = NSMakeRect(50, 30, 260, 16);
           label;
       });
       
       self.bottomLine = ({
           NSBox *line = [[NSBox alloc] init];
           line.boxType = NSBoxSeparator;
           line.frame = NSMakeRect(0, 0, 300, 1);
           line;
       });
       
       [self addSubviews:@[self.avatar,
                           self.nameLabel,
                           self.bottomLine]];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
   
}

- (void)setWxid:(NSString *)wxid
{
    _wxid = wxid;
    
    if (!wxid) {
        return;
    }
    
    NSString *nickName = @"";
    NSString *avatarUrl = @"";
    
    NSImage *placeholder = kImageWithName(@"order_avatar.png");
    if ([wxid containsString:@"@chatroom"]) {
        MMSessionInfo *info = [YMIMContactsManager getSessionInfo:wxid];
        nickName = info.m_packedInfo.m_contact.m_nsNickName;
        avatarUrl = info.m_packedInfo.m_contact.m_nsHeadImgUrl;
    } else {
        avatarUrl = [YMIMContactsManager getWeChatAvatar:wxid];
        nickName = [YMIMContactsManager getWeChatNickName:wxid];
    }
    
    __weak __typeof (self) wself = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSImage *image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:avatarUrl]];
        dispatch_async(dispatch_get_main_queue(), ^{
            wself.avatar.image = image ?: placeholder;
            wself.nameLabel.stringValue = nickName.length > 0 ? nickName : wxid;
        });
        
    });
}
@end
