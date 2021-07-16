//
//  YMThemCell.m
//  WeChatGirlFriend
//
//  Created by MustangYM on 2021/7/2.
//  Copyright © 2021 YY Inc. All rights reserved.
//

#import "YMThemCell.h"
#import "UIImageView+WebCache.h"
#import "YMThemeConfigModel.h"
#import "NSViewLayoutTool.h"
#import "YMThemeManager.h"

@interface YMThemCell()
@property (nonatomic, strong) NSImageView *imageView;
@property (nonatomic, strong) NSImageView *selectImageView;
@property (nonatomic, strong) NSTextField *label;
@end

@implementation YMThemCell
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
    self.layer.cornerRadius = 10;
    if (self.imageView == nil) {
        self.imageView = [[NSImageView alloc] init];
        self.imageView.imageScaling = NSScaleToFit;
        [self addSubview:self.imageView];
        [self.imageView fillSuperView];
    }
    
    if (self.label == nil) {
        YMJNWCollectionViewCell *view = [[YMJNWCollectionViewCell alloc] init];
        view.layer.cornerRadius = 10;
        [[YMThemeManager shareInstance] changeTheme:view color:kRGBColor(42, 43, 53, 0.3)];
        [self addSubview:view];
        
        [view addConstraint:NSLayoutAttributeBottom constant:0];
        [view addConstraint:NSLayoutAttributeLeft constant:0];
        [view addConstraint:NSLayoutAttributeRight constant:0];
        [view addHeightConstraint:80];
        
        NSTextField *label = [NSTextField tk_labelWithString:@""];
        label.textColor = [NSColor whiteColor];
        [[label cell] setLineBreakMode:NSLineBreakByCharWrapping];
        [[label cell] setTruncatesLastVisibleLine:YES];
        label.font = [NSFont systemFontOfSize:14];
        self.label = label;
        [view addSubview:label];
        
        [label addConstraint:NSLayoutAttributeBottom constant:-5];
        [label addConstraint:NSLayoutAttributeLeft constant:5];
        [label addConstraint:NSLayoutAttributeRight constant:-5];
        [label addHeightConstraint:40];
    }
    
    if (self.selectImageView == nil) {
        self.selectImageView = [[NSImageView alloc] init];
        self.selectImageView.image = kImageWithName(@"select_nor");
        [self addSubview:self.selectImageView];
        [self.selectImageView addConstraint:NSLayoutAttributeRight constant:-20];
        [self.selectImageView addConstraint:NSLayoutAttributeTop constant:20];
        [self.selectImageView addHeightConstraint:20];
        [self.selectImageView addWidthConstraint:20];
    }
}

- (void)reloadBy:(YMThemeConfigModel *)model;
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:kImageWithName(@"placeholder")];
    self.label.stringValue = model.desc;
    if (model.isSelected) {
        self.selectImageView.image = kImageWithName(@"select_pre");
    } else {
        self.selectImageView.image = kImageWithName(@"select_nor");
    }
}
@end
