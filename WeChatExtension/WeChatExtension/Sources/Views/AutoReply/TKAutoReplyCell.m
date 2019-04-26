//
//  TKAutoReplyCell.m
//  WeChatPlugin
//
//  Created by TK on 2017/8/21.
//  Copyright © 2017年 tk. All rights reserved.
//

#import "TKAutoReplyCell.h"

@interface TKAutoReplyCell ()

@property (nonatomic, strong) NSButton *selectBtn;
@property (nonatomic, strong) NSTextField *keywordLabel;
@property (nonatomic, strong) NSTextField *replyContentLabel;
@property (nonatomic, strong) NSBox *bottomLine;

@end

@implementation TKAutoReplyCell

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.selectBtn = ({
        NSButton *btn = [NSButton tk_checkboxWithTitle:@"" target:self action:@selector(clickSelectBtn:)];
        btn.frame = NSMakeRect(5, 15, 20, 20);
        
        btn;
    });

    self.keywordLabel = ({
        NSTextField *label = [NSTextField tk_labelWithString:@""];
        label.placeholderString = TKLocalizedString(@"assistant.autoReply.keyword");
        [[label cell] setLineBreakMode:NSLineBreakByCharWrapping];
        [[label cell] setTruncatesLastVisibleLine:YES];
        label.font = [NSFont systemFontOfSize:10];
        label.frame = NSMakeRect(30, 30, 160, 15);
        
        label;
    });
    
    self.replyContentLabel = ({
        NSTextField *label = [NSTextField tk_labelWithString:@""];
        label.placeholderString = TKLocalizedString(@"assistant.autoReply.content");
        [[label cell] setLineBreakMode:NSLineBreakByCharWrapping];
        [[label cell] setTruncatesLastVisibleLine:YES];
        label.frame = NSMakeRect(30, 10, 160, 15);
        
        label;
    });
    
    self.bottomLine = ({
        NSBox *v = [[NSBox alloc] init];
        v.boxType = NSBoxSeparator;
        v.frame = NSMakeRect(0, 0, 200, 1);
        
        v;
    });
    
    [self addSubviews:@[self.selectBtn,
                        self.keywordLabel,
                        self.replyContentLabel,
                        self.bottomLine]];
}

- (void)clickSelectBtn:(NSButton *)btn {
    self.model.enable = btn.state;
    if (!self.model.enableSingleReply && !self.model.enableGroupReply && btn.state == YES) {
        self.model.enableSingleReply = YES;
        if (self.updateModel) self.updateModel();
    }
}

- (void)setModel:(TKAutoReplyModel *)model {
    _model = model;
    if (model.keyword == nil && model.replyContent == nil) return;
    
    self.selectBtn.state = model.enable;
    self.keywordLabel.stringValue = model.keyword != nil ? model.keyword : @"";
    self.replyContentLabel.stringValue = model.replyContent != nil ? model.replyContent : @"";
}

@end
