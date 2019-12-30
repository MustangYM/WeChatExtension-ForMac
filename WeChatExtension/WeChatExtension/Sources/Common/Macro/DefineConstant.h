//
//  DefineConstant.h
//  WeChatExtension
//
//  Created by WeChatExtension on 2018/4/14.
//  Copyright © 2018年 WeChatExtension. All rights reserved.
//

#ifndef DefineConstant_h
#define DefineConstant_h
#import "TKWeChatPluginConfig.h"
#define kRGBColor(r,g,b,a) [NSColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define YMLocalizedString(key)  [[NSBundle bundleWithIdentifier:@"MustangYM.WeChatExtension"] localizedStringForKey:(key) value:@"" table:nil]
#define WXLocalizedString(key)  [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]
#define YMLanguage(a,b) [[TKWeChatPluginConfig sharedConfig] languageSetting:(a) english:(b)]
#endif /* DefineConstant_h */
