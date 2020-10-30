//
//  YMDFAFilter.m
//  WeChatExtension
//
//  Created by MustangYM on 2020/10/27.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import "YMDFAFilter.h"

@interface YMDFAFilter ()
@property (nonatomic,strong) NSMutableDictionary *keyword_chains;
@property (nonatomic,  copy) NSString *delimit;
@end

@implementation YMDFAFilter
+ (instancetype)shareInstance
{
    static id share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[self alloc] init];
    });
    return share;
}

- (instancetype)init{
    if(self == [super init]){
        _delimit = @"\x00";
        [self parseSensitiveWords];
    }
    return self;
}

- (void)parseSensitiveWords
{
    NSString *path = [[NSBundle bundleWithIdentifier:@"MustangYM.WeChatExtension"] pathForResource:@"shieldwords" ofType:@"txt"];
    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *keyWordList = [content componentsSeparatedByString:@","];
    for (NSString *keyword in keyWordList) {
        [self addSensitiveWords:keyword];
    }
}

- (void)addSensitiveWords:(NSString *)keyword
{
    keyword = keyword.lowercaseString;
    keyword = [keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(keyword.length <= 0){
        return;
    }
    
    NSMutableDictionary *node = self.keyword_chains;
    for (int i = 0; i < keyword.length; i ++) {
        NSString *word = [keyword substringWithRange:NSMakeRange(i, 1)];
        if (node[word] == nil) {
            node[word] = [NSMutableDictionary dictionary];
        }
        node = node[word];
    }
    
    [node setValue:@0 forKey:self.delimit];
}

- (BOOL)filterSensitiveWords:(NSString *)message
{
    NSString *replaceKey = @([[NSDate date] timeIntervalSince1970]).stringValue;
    message = message.lowercaseString;
    NSMutableArray *retArray = [[NSMutableArray alloc] init];
    NSInteger start = 0;
    while (start < message.length) {
        NSMutableDictionary *level = self.keyword_chains.mutableCopy;
        NSInteger step_ins = 0;
        NSString *message_chars = [message substringWithRange:NSMakeRange(start, message.length - start)];
        for(int i = 0; i < message_chars.length; i++) {
            NSString *chars_i = [message_chars substringWithRange:NSMakeRange(i, 1)];
            if([level.allKeys containsObject:chars_i]) {
                step_ins += 1;
                NSDictionary *level_char_dict = level[chars_i];
                if(![level_char_dict.allKeys containsObject:self.delimit]){
                    level = level_char_dict.mutableCopy;
                } else {
                    NSMutableString *ret_str = [[NSMutableString alloc] init];
                    for(int i = 0; i < step_ins; i++){
                        [ret_str appendString:replaceKey];
                    }
                    [retArray addObject:ret_str];
                    start += (step_ins - 1);
                    break;
                }
            } else {
                [retArray addObject:[NSString stringWithFormat:@"%C",[message characterAtIndex:start]]];
                break;
            }
        }
        start ++;
    }
    NSString *str = [retArray componentsJoinedByString:@""];
    return [str containsString:replaceKey];
}

- (NSMutableDictionary *)keyword_chains
{
    if(_keyword_chains == nil){
        _keyword_chains = [NSMutableDictionary dictionary];
    }
    return _keyword_chains;
}

@end
