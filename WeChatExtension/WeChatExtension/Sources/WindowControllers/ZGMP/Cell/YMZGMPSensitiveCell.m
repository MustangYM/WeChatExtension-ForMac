//
//  YMZGMPSensitiveCell.m
//  WeChatExtension
//
//  Created by MustangYM on 2021/1/14.
//  Copyright © 2021 MustangYM. All rights reserved.
//

#import "YMZGMPSensitiveCell.h"
#import "NSViewLayoutTool.h"
#import "YMZGMPInfoHelper.h"
#import "YMIMContactsManager.h"
#import "YMThemeManager.h"

@interface YMZGMPSensitiveCell()
@property (nonatomic, strong) NSImageView *avatarImageView;
@property (nonatomic, strong) NSTextField *nameLabel;
@property (nonatomic, strong) NSTextField *timeLabel;
@property (nonatomic, strong) NSBox *bottomLine;
@end

@implementation YMZGMPSensitiveCell
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
    self.avatarImageView = ({
        NSImageView *avatar = [[NSImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
        avatar.layer.cornerRadius = 5;
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
    
    self.timeLabel = ({
           NSTextField *label = [NSTextField tk_labelWithString:@""];
           label.editable = YES;
           label.textColor = [NSColor blackColor];
           [[label cell] setLineBreakMode:NSLineBreakByCharWrapping];
           [[label cell] setTruncatesLastVisibleLine:YES];
           label.font = [NSFont systemFontOfSize:10];
           label.frame = NSMakeRect(40, 12, 200, 16);
           label;
       });
    
    self.bottomLine = ({
        NSBox *line = [[NSBox alloc] init];
        line.frame = NSMakeRect(0, 0, 300, 0.5);
        [[YMThemeManager shareInstance] changeTheme:line color:YM_RGBA(242, 242, 242, 1.0)];
        line;
    });
    
    [self addSubviews:@[self.avatarImageView,
                        self.nameLabel,
                        self.bottomLine,
                        self.timeLabel]];
    
    [self.bottomLine addConstraint:NSLayoutAttributeLeft constant:0];
    [self.bottomLine addConstraint:NSLayoutAttributeBottom constant:0];
    [self.bottomLine addConstraint:NSLayoutAttributeRight constant:0];
    [self.bottomLine addHeightConstraint:0.5];
    
    [self.nameLabel addConstraint:NSLayoutAttributeLeft constant:60];
    [self.nameLabel addConstraint:NSLayoutAttributeTop constant:5];
    [self.nameLabel addConstraint:NSLayoutAttributeRight constant:-10];
    [self.nameLabel addHeightConstraint:16];
    
    [self.timeLabel addConstraint:NSLayoutAttributeLeft constant:60];
    [self.timeLabel addConstraint:NSLayoutAttributeBottom constant:-5];
    [self.timeLabel addConstraint:NSLayoutAttributeRight constant:-10];
    [self.timeLabel addHeightConstraint:16];
}

- (void)setMsgData:(MessageData *)msgData
{
    _msgData = msgData;
    NSString *msgStr = @"";
    if ([msgData.msgContent containsString:@":\n"]) {
        NSArray *msgs = [msgData.msgContent componentsSeparatedByString:@":\n"];
        if (msgs.count > 1) {
            msgStr = msgs[1];
        }
    } else {
        msgStr = msgData.msgContent;
    }
    NSLog(@"---%@",msgData.msgContent);
    self.nameLabel.stringValue = msgStr;
    self.timeLabel.stringValue = [self UTCchangeDate:@(msgData.msgCreateTime).stringValue];
}

- (void)setAvatar:(NSImage *)avatar
{
    _avatar = avatar;
    self.avatarImageView.image = self.avatar ?: kImageWithName(@"order_avatar.png");
}

- (NSString *)UTCchangeDate:(NSString *)utc
{
    NSTimeInterval time = [utc doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY年MM月dd日 HH:mm:ss"];
    NSString *timeStr = [dateformatter stringFromDate:date];
    return timeStr;
}

//- (void)setMemberInfo:(YMZGMPInfo *)memberInfo
//{
//    _memberInfo = memberInfo;
//    if (!memberInfo.contact) {
//        return;
//    }
//    __weak __typeof (self) wself = self;
//    MMAvatarService *avatarService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMAvatarService")];
//    [avatarService getAvatarImageWithContact:memberInfo.contact completion:^(NSImage *image) {
//        wself.avatar.image = image ?: kImageWithName(@"order_avatar.png");
//    }];
//    self.nameLabel.stringValue = memberInfo.contact.m_nsRemark.length > 0 ? memberInfo.contact.m_nsRemark : memberInfo.contact.m_nsNickName;
//    if (memberInfo.timestamp <= 0) {
//        [[YMThemeManager shareInstance] changeTheme:self color:YM_RGBA(99, 99, 99, 0.2)];
//    } else {
//        [[YMThemeManager shareInstance] changeTheme:self color:[NSColor clearColor]];
//    }
//}
@end
