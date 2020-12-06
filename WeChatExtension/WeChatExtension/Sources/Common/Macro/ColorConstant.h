//
//  Color.h
//  WeChatExtension
//
//  Created by WeChatExtension on 2019/8/20.
//  Copyright © 2019年 WeChatExtension. All rights reserved.
//

#ifndef Color_h
#define Color_h

#define YM_RGBA(r, g, b, a) [NSColor colorWithRed:(r) / 255.0 \
green:(g) / 255.0 \
blue:(b) / 255.0 \
alpha:(a)]

#define TK_RGB(r, g, b) YM_RGBA(r, g, b, 1.0)
#define TK_GRAYA(c, a) YM_RGBA(c, c, c, a)
#define TK_GRAY(c) TK_GRAYA(c, 1.0)

#define kBG1 TK_GRAY(0xec)
#define kBG2 TK_GRAY(0xe3)
#define kBG3 TK_GRAYA(0x2a, 0.5)
#define kBG4 TK_GRAYA(0x7a, 0.5)

#endif /* Color_h */
