//
//  NSString+Action.m
//  WeChatPlugin
//
//  Created by TK on 2018/5/1.
//  Copyright © 2018年 tk. All rights reserved.
//

#import "NSString+Action.h"

@implementation NSString (Action)

- (CGFloat)widthWithFont:(NSFont *)font {
    return [self rectWithFont:font].size.width;
}

- (NSRect)rectWithFont:(NSFont *)font {
    return [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font}];
}

- (NSString *)substringFromString:(NSString *)fromStr {
    NSRange range = [self rangeOfString:fromStr];
    if (range.length > 0) {
        return [self substringFromIndex:range.location + range.length];
    }
    return nil;
}
@end
