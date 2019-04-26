//
//  NSString+Action.h
//  WeChatPlugin
//
//  Created by TK on 2018/5/1.
//  Copyright © 2018年 tk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Action)

- (CGFloat)widthWithFont:(NSFont *)font;
- (NSRect)rectWithFont:(NSFont *)font;
- (NSString *)substringFromString:(NSString *)fromStr;

@end
