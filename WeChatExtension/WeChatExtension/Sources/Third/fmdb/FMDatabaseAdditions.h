//
//  FMDatabaseAdditions.h
//  fmdb
//
//  Created by August Mueller on 10/30/05.
//  Copyright 2005 Flying Meat Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

NS_ASSUME_NONNULL_BEGIN

/** Category of additions for @c FMDatabase  class.
 
 See also

 - @c FMDatabase 
 */

@interface FMDatabase (FMDatabaseAdditions)

///----------------------------------------
/// @name Return results of SQL to variable
///----------------------------------------

/** Return @c int  value for query
 
 @param query The SQL query to be performed, followed by a list of parameters that will be bound to the `?` placeholders in the SQL query.

 @return @c int  value.
 
 @note This is not available from Swift.
 */

- (int)intForQuery:(NSString*)query, ...;

/** Return @c long  value for query

 @param query The SQL query to be performed, followed by a list of parameters that will be bound to the `?` placeholders in the SQL query.

 @return @c long  value.
 
 @note This is not available from Swift.
 */

- (long)longForQuery:(NSString*)query, ...;

/** Return `BOOL` value for query

 @param query The SQL query to be performed, followed by a list of parameters that will be bound to the `?` placeholders in the SQL query.

 @return `BOOL` value.
 
 @note This is not available from Swift.
 */

- (BOOL)boolForQuery:(NSString*)query, ...;

/** Return `double` value for query

 @param query The SQL query to be performed, followed by a list of parameters that will be bound to the `?` placeholders in the SQL query.

 @return `double` value.
 
 @note This is not available from Swift.
 */

- (double)doubleForQuery:(NSString*)query, ...;

/** Return @c NSString  value for query

 @param query The SQL query to be performed, followed by a list of parameters that will be bound to the `?` placeholders in the SQL query.

 @return @c NSString  value.
 
 @note This is not available from Swift.
 */

- (NSString * _Nullable)stringForQuery:(NSString*)query, ...;

/** Return @c NSData  value for query

 @param query The SQL query to be performed, followed by a list of parameters that will be bound to the `?` placeholders in the SQL query.

 @return @c NSData  value.
 
 @note This is not available from Swift.
 */

- (NSData * _Nullable)dataForQuery:(NSString*)query, ...;

/** Return @c NSDate  value for query

 @param query The SQL query to be performed, followed by a list of parameters that will be bound to the `?` placeholders in the SQL query.

 @return @c NSDate  value.
 
 @note This is not available from Swift.
 */

- (NSDate * _Nullable)dateForQuery:(NSString*)query, ...;


// Notice that there's no dataNoCopyForQuery:.
// That would be a bad idea, because we close out the result set, and then what
// happens to the data that we just didn't copy?  Who knows, not I.


///--------------------------------
/// @name Schema related operations
///--------------------------------

/** Does table exist in database?

 @param tableName The name of the table being looked for.

 @return @c YES if table found; @c NO if not found.
 */

- (BOOL)tableExists:(NSString*)tableName;

/** The schema of the database.
 
 This will be the schema for the entire database. For each entity, each row of the result set will include the following fields:
 
 - `type` - The type of entity (e.g. table, index, view, or trigger)
 - `name` - The name of the object
 - `tbl_name` - The name of the table to which the object references
 - `rootpage` - The page number of the root b-tree page for tables and indices
 - `sql` - The SQL that created the entity

 @return `FMResultSet` of schema; @c nil  on error.
 
 @see [SQLite File Format](https://sqlite.org/fileformat.html)
 */

- (FMResultSet * _Nullable)getSchema;

/** The schema of the database.

 This will be the schema for a particular table as report by SQLite `PRAGMA`, for example:
 
    PRAGMA table_info('employees')
 
 This will report:
 
 - `cid` - The column ID number
 - `name` - The name of the column
 - `type` - The data type specified for the column
 - `notnull` - whether the field is defined as NOT NULL (i.e. values required)
 - `dflt_value` - The default value for the column
 - `pk` - Whether the field is part of the primary key of the table

 @param tableName The name of the table for whom the schema will be returned.
 
 @return `FMResultSet` of schema; @c nil  on error.
 
 @see [table_info](https://sqlite.org/pragma.html#pragma_table_info)
 */

- (FMResultSet * _Nullable)getTableSchema:(NSString*)tableName;

/** Test to see if particular column exists for particular table in database
 
 @param columnName The name of the column.
 
 @param tableName The name of the table.
 
 @return @c YES if column exists in table in question; @c NO otherwise.
 */

- (BOOL)columnExists:(NSString*)columnName inTableWithName:(NSString*)tableName;

/** Test to see if particular column exists for particular table in database

 @param columnName The name of the column.

 @param tableName The name of the table.

 @return @c YES if column exists in table in question; @c NO otherwise.
 
 @see columnExists:inTableWithName:
 
 @warning Deprecated - use `<columnExists:inTableWithName:>` instead.
 */

- (BOOL)columnExists:(NSString*)tableName columnName:(NSString*)columnName __deprecated_msg("Use columnExists:inTableWithName: instead");


/** Validate SQL statement
 
 This validates SQL statement by performing `sqlite3_prepare_v2`, but not returning the results, but instead immediately calling `sqlite3_finalize`.
 
 @param sql The SQL statement being validated.
 
 @param error This is a pointer to a @c NSError  object that will receive the autoreleased @c NSError  object if there was any error. If this is @c nil , no @c NSError  result will be returned.
 
 @return @c YES if validation succeeded without incident; @c NO otherwise.
 
 */

- (BOOL)validateSQL:(NSString*)sql error:(NSError * _Nullable __autoreleasing *)error;


///-----------------------------------
/// @name Application identifier tasks
///-----------------------------------

/** Retrieve application ID
 
 @return The `uint32_t` numeric value of the application ID.
 
 @see setApplicationID:
 */

@property (nonatomic) uint32_t applicationID;

#if TARGET_OS_MAC && !TARGET_OS_IPHONE

/** Retrieve application ID string

 @see setApplicationIDString:
 */

@property (nonatomic, retain) NSString *applicationIDString;

#endif

///-----------------------------------
/// @name user version identifier tasks
///-----------------------------------

/** Retrieve user version
 
 @see setUserVersion:
 */

@property (nonatomic) uint32_t userVersion;

@end

NS_ASSUME_NONNULL_END
