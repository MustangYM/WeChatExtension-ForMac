//
//  TKAutoReplyContentView.m
//  WeChatPlugin
//
//  Created by TK on 2017/8/20.
//  Copyright © 2017年 tk. All rights reserved.
//

#import "TKAutoReplyContentView.h"
#import "WeChatPlugin.h"

@interface TKAutoReplyContentView () <NSTextFieldDelegate>

@property (nonatomic, strong) NSTextField *keywordLabel;
@property (nonatomic, strong) NSTextField *keywordTextField;
@property (nonatomic, strong) NSTextField *autoReplyLabel;
@property (nonatomic, strong) NSTextField *autoReplyContentField;
@property (nonatomic, strong) NSButton *enableGroupReplyBtn;
@property (nonatomic, strong) NSButton *enableSingleReplyBtn;
@property (nonatomic, strong) NSButton *enableRegexBtn;
@property (nonatomic, strong) NSTextField *delayField;
@property (nonatomic, strong) NSButton *enableDelayBtn;
@property (nonatomic, strong) NSButton *enableSpecificReplyBtn;
@property (nonatomic, strong) NSButton *selectSessionButton;

@end

@implementation TKAutoReplyContentView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.enableSpecificReplyBtn = ({
        NSButton *btn = [NSButton tk_checkboxWithTitle:TKLocalizedString(@"assistant.autoReply.enableSpecific") target:self action:@selector(clickEnableSpecificReplyBtn:)];
        btn.frame = NSMakeRect(20, 0, 400, 20);
        
        btn;
    });

    self.selectSessionButton = ({
        NSButton *btn = [NSButton tk_buttonWithTitle:TKLocalizedString(@"assistant.autoReply.selectSpecific") target:self action:@selector(clickSelectSessionButton:)];
        btn.frame = NSMakeRect(200, 0, 150, 20);
        btn.bezelStyle = NSBezelStyleTexturedRounded;

        btn;
    });

    self.enableRegexBtn = ({
        NSButton *btn = [NSButton tk_checkboxWithTitle:TKLocalizedString(@"assistant.autoReply.enableRegEx") target:self action:@selector(clickEnableRegexBtn:)];
        btn.frame = NSMakeRect(20, 25, 400, 20);
        
        btn;
    });
    
    self.enableGroupReplyBtn = ({
        NSButton *btn = [NSButton tk_checkboxWithTitle:TKLocalizedString(@"assistant.autoReply.enableGroup") target:self action:@selector(clickEnableGroupBtn:)];
        btn.frame = NSMakeRect(20, 50, 400, 20);
        
        btn;
    });
    
    self.enableSingleReplyBtn = ({
        NSButton *btn = [NSButton tk_checkboxWithTitle:TKLocalizedString(@"assistant.autoReply.enableSingle") target:self action:@selector(clickEnableSingleBtn:)];
        btn.frame = NSMakeRect(200, 50, 400, 20);
        
        btn;
    });
    
    self.enableDelayBtn = ({
        NSButton *btn = [NSButton tk_checkboxWithTitle:TKLocalizedString(@"assistant.autoReply.delay") target:self action:@selector(clickEnableDelayBtn:)];
        btn.frame = NSMakeRect(200, 25, 85, 20);
        
        btn;
    });
    
    self.delayField = ({
        NSTextField *textField = [[NSTextField alloc] init];
        textField.frame = NSMakeRect(CGRectGetMaxX(self.enableDelayBtn.frame), 25, 60, 20);
        textField.placeholderString = TKLocalizedString(@"assistant.autoReply.timeUnit");
        textField.delegate = self;
        textField.alignment = NSTextAlignmentRight;
        NSNumberFormatter * formater = [[NSNumberFormatter alloc] init];
        formater.numberStyle = NSNumberFormatterDecimalStyle;
        formater.minimum = @(0);
        formater.maximum = @(999);
        textField.cell.formatter = formater;
        
        textField;
    });

    self.autoReplyContentField = ({
        NSTextField *textField = [[NSTextField alloc] init];
        textField.frame = NSMakeRect(20, 80, 350, 175);
        textField.placeholderString = TKLocalizedString(@"assistant.autoReply.contentPlaceholder");
        textField.delegate = self;
        
        textField;
    });
    
    self.autoReplyLabel = ({
        NSString *text = [NSString stringWithFormat:@"%@: ",TKLocalizedString(@"assistant.autoReply.content")];
        NSTextField *label = [NSTextField tk_labelWithString:text];
        label.frame = NSMakeRect(20, 260, 350, 20);
        
        label;
    });
    
    self.keywordTextField = ({
        NSTextField *textField = [[NSTextField alloc] init];
        textField.frame = NSMakeRect(20, 300, 350, 50);
        textField.placeholderString = TKLocalizedString(@"assistant.autoReply.keywordPlaceholder");
        textField.delegate = self;
        
        textField;
    });
    
    self.keywordLabel = ({
         NSString *text = [NSString stringWithFormat:@"%@: ",TKLocalizedString(@"assistant.autoReply.keyword")];
        NSTextField *label = [NSTextField tk_labelWithString:text];
        label.frame = NSMakeRect(20, 355, 350, 20);
        
        label;
    });
    
    [self addSubviews:@[self.enableRegexBtn,
                        self.enableGroupReplyBtn,
                        self.enableSingleReplyBtn,
                        self.autoReplyContentField,
                        self.autoReplyLabel,
                        self.keywordTextField,
                        self.keywordLabel,
                        self.delayField,
                        self.enableDelayBtn,
                        self.enableSpecificReplyBtn,
                        self.selectSessionButton]];
}

- (void)clickEnableSpecificReplyBtn:(NSButton *)btn {
    self.selectSessionButton.hidden = !btn.state;
    self.enableGroupReplyBtn.hidden = btn.state;
    self.enableSingleReplyBtn.hidden = btn.state;
    if (btn.state) {
        [self selectSessionAction];
    }
    self.model.enableSpecificReply = btn.state;
}

- (void)clickSelectSessionButton:(NSButton *)btn {
    [self selectSessionAction];
}

- (void)clickEnableRegexBtn:(NSButton *)btn {
    self.model.enableRegex = btn.state;
}

- (void)clickEnableGroupBtn:(NSButton *)btn {
    self.model.enableGroupReply = btn.state;
    if (btn.state) {
        self.model.enable = YES;
    } else if(!self.model.enableSingleReply) {
        self.model.enable = NO;
    }
    
    if (self.endEdit) self.endEdit();
}

- (void)clickEnableSingleBtn:(NSButton *)btn {
    self.model.enableSingleReply = btn.state;
    if (btn.state) {
        self.model.enable = YES;
    } else if(!self.model.enableGroupReply) {
        self.model.enable = NO;
    }
    if (self.endEdit) self.endEdit();
}

- (void)clickEnableDelayBtn:(NSButton *)btn {
    self.model.enableDelay = btn.state;
}

- (void)viewDidMoveToSuperview {
    [super viewDidMoveToSuperview];
    self.layer.backgroundColor = [kBG2 CGColor];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [TK_RGBA(0, 0, 0, 0.1) CGColor];
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    [self.layer setNeedsDisplay];
}

- (void)setModel:(TKAutoReplyModel *)model {
    _model = model;
    self.keywordTextField.stringValue = model.keyword != nil ? model.keyword : @"";
    self.autoReplyContentField.stringValue = model.replyContent != nil ? model.replyContent : @"";
    self.enableGroupReplyBtn.state = model.enableGroupReply;
    self.enableSingleReplyBtn.state = model.enableSingleReply;
    self.enableRegexBtn.state = model.enableRegex;
    self.enableDelayBtn.state = model.enableDelay;
    self.delayField.stringValue = [NSString stringWithFormat:@"%ld",model.delayTime];
    self.enableSpecificReplyBtn.state = model.enableSpecificReply;
    
    self.selectSessionButton.hidden = !model.enableSpecificReply;
    self.enableGroupReplyBtn.hidden = model.enableSpecificReply;
    self.enableSingleReplyBtn.hidden = model.enableSpecificReply;
}

- (void)selectSessionAction {
    MMSessionPickerWindow *picker = [objc_getClass("MMSessionPickerWindow") shareInstance];
    [picker setType:1];
    [picker setShowsGroupChats:0x1];
    [picker setShowsOtherNonhumanChats:0];
    [picker setShowsOfficialAccounts:0];
    MMSessionPickerLogic *logic = [picker.listViewController valueForKey:@"m_logic"];
    NSMutableOrderedSet *orderSet = [logic valueForKey:@"_selectedUserNamesSet"];

    [orderSet addObjectsFromArray:self.model.specificContacts];
    [picker.choosenViewController setValue:self.model.specificContacts forKey:@"selectedUserNames"];
    [picker beginSheetForWindow:self.window completionHandler:^(NSOrderedSet *a1) {
        NSMutableArray *array = [NSMutableArray array];
        [a1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [array addObject:obj];
        }];
        self.model.specificContacts = [array copy];
    }];
}

- (void)controlTextDidEndEditing:(NSNotification *)notification {
    if (self.endEdit) self.endEdit();
}

- (void)controlTextDidChange:(NSNotification *)notification {
    NSControl *control = notification.object;
    if (control == self.keywordTextField) {
        self.model.keyword = self.keywordTextField.stringValue;
    } else if (control == self.autoReplyContentField) {
        self.model.replyContent = self.autoReplyContentField.stringValue;
    } else if (control == self.delayField) {
        self.model.delayTime = [self.delayField.stringValue integerValue];
    }
}

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector {
    BOOL result = NO;
    
    if (commandSelector == @selector(insertNewline:)) {
        [textView insertNewlineIgnoringFieldEditor:self];
        result = YES;
    } else if (commandSelector == @selector(insertTab:)) {
        if (control == self.keywordTextField) {
            [self.autoReplyContentField becomeFirstResponder];
        } else if (control == self.autoReplyContentField) {
            [self.keywordTextField becomeFirstResponder];
        }
    }
    
    return result;
}

@end
