//
//  TKUtility.m
//  WeChatPlugin
//
//  Created by TK on 2019/1/12.
//  Copyright © 2019 tk. All rights reserved.
//

#import "TKUtility.h"

@implementation TKUtility

+ (BOOL)isLargerOrEqualVersion:(NSString *)version {
    NSDictionary *dict = [NSBundle mainBundle].infoDictionary;
    if ([dict[@"CFBundleShortVersionString"] compare:version options:NSNumericSearch] == NSOrderedAscending) {
        return NO;
    } else {
        return YES;
    }
}
@end
