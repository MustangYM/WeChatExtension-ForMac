//
//  YMZGMPInfoHelper.m
//  WeChatExtension
//
//  Created by MustangYM on 2020/10/22.
//  Copyright © 2020 MustangYM. All rights reserved.
//

#import "YMZGMPInfoHelper.h"
#import "FMDB.h"

static NSString *const DBNAME = @"chatroom_data.db";

@implementation YMZGMPGroupInfo

@end

@implementation YMZGMPInfo

@end

@implementation YMZGMPInfoHelper
+ (void)saveChatroomMember:(NSString *)chatroom member:(YMZGMPInfo *)model
{
    if (!chatroom || chatroom.length == 0) {
        return;
    }
    FMDatabase *dataBase = [self creatDataBase:chatroom];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (kWxid, kUserName, kAvatar, kTimestamp) VALUES ()", chatroom];
    if ([dataBase executeUpdate:@""]) {
        
    }
}

+ (FMDatabase *)creatDataBase:(NSString *)chatroom
{
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *FMDBPath = [docsPath stringByAppendingPathComponent:DBNAME];
    FMDatabase *database = [FMDatabase databaseWithPath:FMDBPath];
    [self creatDataBase:database];
    return database;
}

+ (void)createTable:(FMDatabase *)Database chatroom:(NSString *)chatroom
{
    if ([Database open]) {
        if (![Database tableExists:chatroom]) {
            if ([Database executeUpdate:@"create table userinfo (kWxid text, kUserName text, kAvatar text, kTimestamp text)"]) {
            } else {
                NSLog(@"FMDB创表失败");
            }
        } else {
            NSLog(@"FMDB表已存在");
        }
    } else {
        NSLog(@"FMDB打开失败");
    }
}

@end
