//
//  QSDatabasePool.h
//  QSDB
//
//  Created by August Mueller on 6/22/11.
//  Copyright 2011 Flying Meat Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

/*

                         ***README OR SUFFER***
Before using QSDatabasePool, please consider using QSDatabaseQueue instead.

If you really really really know what you're doing and QSDatabasePool is what
you really really need (ie, you're using a read only database), OK you can use
it.  But just be careful not to deadlock!

For an example on deadlocking, search for:
ONLY_USE_THE_POOL_IF_YOU_ARE_DOING_READS_OTHERWISE_YOULL_DEADLOCK_USE_QSDatabaseQUEUE_INSTEAD
in the main.m file.

*/



@class QSDatabase;

@interface QSDatabasePool : NSObject {
    NSString            *_path;
    
    dispatch_queue_t    _lockQueue;
    
    NSMutableArray      *_databaseInPool;
    NSMutableArray      *_databaseOutPool;
    
    __unsafe_unretained id _delegate;
    
    NSUInteger          _maximumNumberOfDatabasesToCreate;
}

@property (atomic, retain) NSString *path;
@property (atomic, assign) id delegate;
@property (atomic, assign) NSUInteger maximumNumberOfDatabasesToCreate;

+ (id)databasePoolWithPath:(NSString*)aPath;
- (id)initWithPath:(NSString*)aPath;

- (NSUInteger)countOfCheckedInDatabases;
- (NSUInteger)countOfCheckedOutDatabases;
- (NSUInteger)countOfOpenDatabases;
- (void)releaseAllDatabases;

- (void)inDatabase:(void (^)(QSDatabase *db))block;

- (void)inTransaction:(void (^)(QSDatabase *db, BOOL *rollback))block;
- (void)inDeferredTransaction:(void (^)(QSDatabase *db, BOOL *rollback))block;

#if SQLITE_VERSION_NUMBER >= 3007000
// NOTE: you can not nest these, since calling it will pull another database out of the pool and you'll get a deadlock.
// If you need to nest, use QSDatabase's startSavePointWithName:error: instead.
- (NSError*)inSavePoint:(void (^)(QSDatabase *db, BOOL *rollback))block;
#endif

@end


@interface NSObject (QSDatabasePoolDelegate)

- (BOOL)databasePool:(QSDatabasePool*)pool shouldAddDatabaseToPool:(QSDatabase*)database;

@end

