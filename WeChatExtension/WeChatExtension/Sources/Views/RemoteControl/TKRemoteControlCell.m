//
//  TKRemoteControlCell.m
//  WeChatPlugin
//
//  Created by TK on 2017/8/8.
//  Copyright © 2017年 tk. All rights reserved.
//

#import "TKRemoteControlCell.h"
#import "TKRemoteControlModel.h"

@interface TKRemoteControlCell () <NSTextFieldDelegate>

@property (nonatomic, strong) NSButton *selectBtn;
@property (nonatomic, strong) NSTextField *textField;
@property (nonatomic, strong) TKRemoteControlModel *model;

@end

@implementation TKRemoteControlCell

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
        btn.frame = NSMakeRect(50, 10, 150, 30);
        
        btn;
    });
    
    self.textField = ({
        NSTextField *v = [[NSTextField alloc] init];
        v.frame = NSMakeRect(200, 10, 250, 30);
        v.placeholderString = TKLocalizedString(@"assistant.remoteControl.contentPlaceHodler");
        v.layer.cornerRadius = 10;
        v.layer.masksToBounds = YES;
        [v.layer setNeedsDisplay];
        v.editable = YES;
        v.delegate = self;
        
        v;
    });
    
    [self addSubviews:@[self.selectBtn, self.textField]];
}

- (void)clickSelectBtn:(NSButton *)btn {
    self.model.enable = btn.state;
}

- (void)setupWithData:(id)data {
    TKRemoteControlModel *model = data;
    self.model = model;
    self.selectBtn.title = TKLocalizedString(model.function);
    self.selectBtn.state = model.enable;
    self.textField.stringValue = model.keyword;
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
    NSString *string = control.stringValue;
    self.model.keyword = string;
    return YES;
}

@end
