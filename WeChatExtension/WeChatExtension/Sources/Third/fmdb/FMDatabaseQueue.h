//
//  FMDatabaseQueue.h
//  fmdb
//
//  Created by August Mueller on 6/22/11.
//  Copyright 2011 Flying Meat Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

NS_ASSUME_NONNULL_BEGIN

/** To perform queries and updates on multiple threads, you'll want to use @c FMDatabaseQueue .

 Using a single instance of @c FMDatabase from multiple threads at once is a bad idea.  It has always been OK to make a @c FMDatabase  object *per thread*.  Just don't share a single instance across threads, and definitely not across multiple threads at the same time.

 Instead, use @c FMDatabaseQueue . Here's how to use it:

 First, make your queue.

@code
FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:aPath];
@endcode

 Then use it like so:

@code
[queue inDatabase:^(FMDatabase *db) {
    [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:1]];
    [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:2]];
    [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:3]];

    FMResultSet *rs = [db executeQuery:@"select * from foo"];
    while ([rs next]) {
        //…
    }
}];
@endcode

 An easy way to wrap things up in a transaction can be done like this:

@code
[queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
    [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:1]];
    [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:2]];
    [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:3]];

    // if (whoopsSomethingWrongHappened) {
    //     *rollback = YES;
    //     return;
    // }

    // etc…
    [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:4]];
}];
@endcode

 @c FMDatabaseQueue will run the blocks on a serialized queue (hence the name of the class).  So if you call @c FMDatabaseQueue 's methods from multiple threads at the same time, they will be executed in the order they are received.  This way queries and updates won't step on each other's toes, and every one is happy.

 @warning Do not instantiate a single @c FMDatabase  object and use it across multiple threads. Use @c FMDatabaseQueue  instead.
 
 @warning The calls to @c FMDatabaseQueue 's methods are blocking.  So even though you are passing along blocks, they will **not** be run on another thread.

 @sa FMDatabase

 */

@interface FMDatabaseQueue : NSObject

/** Path of database */

@property (atomic, retain, nullable) NSString *path;

/** Open flags */

@property (atomic, readonly) int openFlags;

/**  Custom virtual file system name */

@property (atomic, copy, nullable) NSString *vfsName;

///----------------------------------------------------
/// @name Initialization, opening, and closing of queue
///----------------------------------------------------

/** Create queue using path.
 
 @param aPath The file path of the database.
 
 @return The @c FMDatabaseQueue  object. @c nil  on error.
 */

+ (nullable instancetype)databaseQueueWithPath:(NSString * _Nullable)aPath;

/** Create queue using file URL.
 
 @param url The file @c NSURL  of the database.
 
 @return The @c FMDatabaseQueue  object. @c nil  on error.
 */

+ (nullable instancetype)databaseQueueWithURL:(NSURL * _Nullable)url;

/** Create queue using path and specified flags.
 
 @param aPath The file path of the database.
 @param openFlags Flags passed to the openWithFlags method of the database.
 
 @return The @c FMDatabaseQueue  object. @c nil  on error.
 */
+ (nullable instancetype)databaseQueueWithPath:(NSString * _Nullable)aPath flags:(int)openFlags;

/** Create queue using file URL and specified flags.
 
 @param url The file @c NSURL  of the database.
 @param openFlags Flags passed to the openWithFlags method of the database.
 
 @return The @c FMDatabaseQueue  object. @c nil  on error.
 */
+ (nullable instancetype)databaseQueueWithURL:(NSURL * _Nullable)url flags:(int)openFlags;

/** Create queue using path.
 
 @param aPath The file path of the database.
 
 @return The @c FMDatabaseQueue  object. @c nil  on error.
 */

- (nullable instancetype)initWithPath:(NSString * _Nullable)aPath;

/** Create queue using file URL.
 
 @param url The file `NSURL of the database.
 
 @return The @c FMDatabaseQueue  object. @c nil  on error.
 */

- (nullable instancetype)initWithURL:(NSURL * _Nullable)url;

/** Create queue using path and specified flags.
 
 @param aPath The file path of the database.
 @param openFlags Flags passed to the openWithFlags method of the database.
 
 @return The @c FMDatabaseQueue  object. @c nil  on error.
 */

- (nullable instancetype)initWithPath:(NSString * _Nullable)aPath flags:(int)openFlags;

/** Create queue using file URL and specified flags.
 
 @param url The file path of the database.
 @param openFlags Flags passed to the openWithFlags method of the database.
 
 @return The @c FMDatabaseQueue  object. @c nil  on error.
 */

- (nullable instancetype)initWithURL:(NSURL * _Nullable)url flags:(int)openFlags;

/** Create queue using path and specified flags.
 
 @param aPath The file path of the database.
 @param openFlags Flags passed to the openWithFlags method of the database
 @param vfsName The name of a custom virtual file system
 
 @return The @c FMDatabaseQueue  object. @c nil  on error.
 */

- (nullable instancetype)initWithPath:(NSString * _Nullable)aPath flags:(int)openFlags vfs:(NSString * _Nullable)vfsName;

/** Create queue using file URL and specified flags.
 
 @param url The file `NSURL of the database.
 @param openFlags Flags passed to the openWithFlags method of the database
 @param vfsName The name of a custom virtual file system
 
 @return The @c FMDatabaseQueue  object. @c nil  on error.
 */

- (nullable instancetype)initWithURL:(NSURL * _Nullable)url flags:(int)openFlags vfs:(NSString * _Nullable)vfsName;

/** Returns the Class of 'FMDatabase' subclass, that will be used to instantiate database object.
 
 Subclasses can override this method to return specified Class of 'FMDatabase' subclass.
 
 @return The Class of 'FMDatabase' subclass, that will be used to instantiate database object.
 */

+ (Class)databaseClass;

/** Close database used by queue. */

- (void)close;

/** Interupt pending database operation. */

- (void)interrupt;

///-----------------------------------------------
/// @name Dispatching database operations to queue
///-----------------------------------------------

/** Synchronously perform database operations on queue.
 
 @param block The code to be run on the queue of @c FMDatabaseQueue 
 */

- (void)inDatabase:(__attribute__((noescape)) void (^)(FMDatabase *db))block;

/** Synchronously perform database operations on queue, using transactions.

 @param block The code to be run on the queue of @c FMDatabaseQueue 
 
 @warning    Unlike SQLite's `BEGIN TRANSACTION`, this method currently performs
             an exclusive transaction, not a deferred transaction. This behavior
             is likely to change in future versions of FMDB, whereby this method
             will likely eventually adopt standard SQLite behavior and perform
             deferred transactions. If you really need exclusive tranaction, it is
             recommended that you use `inExclusiveTransaction`, instead, not only
             to make your intent explicit, but also to future-proof your code.

 */

- (void)inTransaction:(__attribute__((noescape)) void (^)(FMDatabase *db, BOOL *rollback))block;

/** Synchronously perform database operations on queue, using deferred transactions.
 
 @param block The code to be run on the queue of @c FMDatabaseQueue 
 */

- (void)inDeferredTransaction:(__attribute__((noescape)) void (^)(FMDatabase *db, BOOL *rollback))block;

/** Synchronously perform database operations on queue, using exclusive transactions.
 
 @param block The code to be run on the queue of @c FMDatabaseQueue 
 */

- (void)inExclusiveTransaction:(__attribute__((noescape)) void (^)(FMDatabase *db, BOOL *rollback))block;

/** Synchronously perform database operations on queue, using immediate transactions.

 @param block The code to be run on the queue of @c FMDatabaseQueue 
 */

- (void)inImmediateTransaction:(__attribute__((noescape)) void (^)(FMDatabase *db, BOOL *rollback))block;

///-----------------------------------------------
/// @name Dispatching database operations to queue
///-----------------------------------------------

/** Synchronously perform database operations using save point.

 @param block The code to be run on the queue of @c FMDatabaseQueue 
 */

// NOTE: you can not nest these, since calling it will pull another database out of the pool and you'll get a deadlock.
// If you need to nest, use FMDatabase's startSavePointWithName:error: instead.
- (NSError * _Nullable)inSavePoint:(__attribute__((noescape)) void (^)(FMDatabase *db, BOOL *rollback))block;

///-----------------
/// @name Checkpoint
///-----------------

/** Performs a WAL checkpoint
 
 @param checkpointMode The checkpoint mode for sqlite3_wal_checkpoint_v2
 @param error The NSError corresponding to the error, if any.
 @return YES on success, otherwise NO.
 */
- (BOOL)checkpoint:(FMDBCheckpointMode)checkpointMode error:(NSError * _Nullable *)error;

/** Performs a WAL checkpoint
 
 @param checkpointMode The checkpoint mode for sqlite3_wal_checkpoint_v2
 @param name The db name for sqlite3_wal_checkpoint_v2
 @param error The NSError corresponding to the error, if any.
 @return YES on success, otherwise NO.
 */
- (BOOL)checkpoint:(FMDBCheckpointMode)checkpointMode name:(NSString * _Nullable)name error:(NSError * _Nullable *)error;

/** Performs a WAL checkpoint
 
 @param checkpointMode The checkpoint mode for sqlite3_wal_checkpoint_v2
 @param name The db name for sqlite3_wal_checkpoint_v2
 @param error The NSError corresponding to the error, if any.
 @param logFrameCount If not NULL, then this is set to the total number of frames in the log file or to -1 if the checkpoint could not run because of an error or because the database is not in WAL mode.
 @param checkpointCount If not NULL, then this is set to the total number of checkpointed frames in the log file (including any that were already checkpointed before the function was called) or to -1 if the checkpoint could not run due to an error or because the database is not in WAL mode.
 @return YES on success, otherwise NO.
 */
- (BOOL)checkpoint:(FMDBCheckpointMode)checkpointMode name:(NSString * _Nullable)name logFrameCount:(int * _Nullable)logFrameCount checkpointCount:(int * _Nullable)checkpointCount error:(NSError * _Nullable *)error;

@end

NS_ASSUME_NONNULL_END
