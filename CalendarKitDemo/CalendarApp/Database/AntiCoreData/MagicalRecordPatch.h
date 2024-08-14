//
//  MagicalRecordPatch.h
//  Masters
//
//  Created by Jasf on 14.05.2018.
//  Copyright © 2018 Jam Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JMSFetchRequest;
@class JMSFetchedResultsController;
@class JMSManagedObjectContext;

@interface JMSLogger : NSObject
+ (NSString *)threadString;
@end

void dispatch_background(dispatch_block_t block);
void dispatch_background_1(dispatch_block_t block);
void dispatch_background_2(dispatch_block_t block);
void dispatch_background_3(dispatch_block_t block);
void dispatch_background_4(dispatch_block_t block);
void dispatch_background_5(dispatch_block_t block);
void dispatch_background_6(dispatch_block_t block);
void dispatch_background_7(dispatch_block_t block);
void dispatch_background_8(dispatch_block_t block);
void dispatch_background_9(dispatch_block_t block);
void dispatch_background_10(dispatch_block_t block);
void dispatch_background_11(dispatch_block_t block);
void dispatch_background_12(dispatch_block_t block);
void dispatch_background_13(dispatch_block_t block);
void dispatch_background_14(dispatch_block_t block);
void dispatch_background_15(dispatch_block_t block);
void dispatch_background_16(dispatch_block_t block);
void dispatch_background_17(dispatch_block_t block);
void dispatch_background_18(dispatch_block_t block);
void dispatch_background_19(dispatch_block_t block);
void dispatch_background_20(dispatch_block_t block);
void dispatch_background_high(dispatch_block_t block);
void dispatch_mainthread(dispatch_block_t block);

@interface NSBeforeManagedObject : NSObject
@property (strong, nonatomic) JMSManagedObjectContext *context;
@property (assign, nonatomic) BOOL modified;
@property (assign, nonatomic) BOOL cached; // Means exists in database
+ (NSString *)jsonFromObject:(id)object;
- (NSDictionary *)toJsonDictionary;
- (id)deepCopy;
@end

@interface NSSQLNumber : NSBeforeManagedObject
@property (nonatomic) NSInteger value;
+ (NSInteger)fromArray:(NSArray *)array;
- (id)init:(NSNumber *)value;
@end

@interface NSBeforeManagedObject (NSPatch)
+ (void)replaceSetters;
+ (instancetype)MR_findFirstWithPredicate:(NSPredicate *)searchterm sortedBy:(NSString *)property ascending:(BOOL)ascending inContext:(id)context;
+ (NSArray *)MR_findAllWithPredicate:(NSPredicate *)searchTerm inContext:(id)context;
+ (NSArray *)MR_findAllWithPredicate:(NSPredicate *)searchTerm whereClause:(NSString *)clause inContext:(id)context;
+ (id)jms_findSingleWithPredicate:(NSPredicate *)searchTerm;
+ (id)jms_findSingleWithPredicate:(NSPredicate *)searchTerm inContext:(id)context;
+ (id)jms_findSingleOrCreateWithPredicate:(NSPredicate *)searchTerm inContext:(id)context;
+ (NSArray *) MR_findAllWithPredicate:(NSPredicate *)searchterm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(id)context;
+ (NSArray *) MR_findAllWithPredicate:(NSPredicate *)searchterm sortDescriptors:(NSArray *)descriptors;

+ (id) MR_createEntityInContext:(JMSManagedObjectContext *)context;
+ (JMSFetchRequest *) MR_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm;
+ (JMSFetchRequest *) MR_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(id)context;


+ (NSArray *) MR_findAllWithPredicate:(NSPredicate *)searchterm;
- (BOOL) MR_deleteEntityInContext:(JMSManagedObjectContext *)context;
+ (NSArray *) MR_findAllInContext:(JMSManagedObjectContext *)context;
+ (BOOL) MR_deleteAllMatchingPredicate:(NSPredicate *)predicate;
+ (BOOL) MR_deleteAllMatchingPredicate:(NSPredicate *)predicate inContext:(JMSManagedObjectContext *)context;
+ (BOOL) MR_deleteAllMatchingPredicate:(NSPredicate *)predicate whereClause:(NSString *)clause inContext:(JMSManagedObjectContext *)context;

- (BOOL)MR_deleteEntity;
+ (NSArray *)MR_findAll;
+ (instancetype) MR_findFirstWithPredicate:(NSPredicate *)searchterm;
+ (void)MR_truncateAll;
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(JMSManagedObjectContext *)context;
+ (id) MR_createEntityInContext:(JMSManagedObjectContext *)context;
+ (instancetype) MR_findFirstWithPredicate:(NSPredicate *)searchterm inContext:(JMSManagedObjectContext *)context;

+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(JMSManagedObjectContext *)context;
+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(JMSManagedObjectContext *)context;
+ (NSArray *) sql_findAllWithClause:(NSString *)clause parameters:(NSDictionary *)parameters;
+ (void)createIndexIfNotExists:(NSString *)name columns:(NSArray *)columns;
+ (void)injectSqlScripts:(NSArray *)scripts parameters:(NSArray *)parameters;
@end

@interface NSObject (Ext)
- (NSDictionary *)toDictionary;
- (BOOL)isFault;
- (id)valueForKey:(NSString *)key;
- (id)objectID;
- (id)initWithContext:(id)ctx;
- (id)managedObjectContext;
- (NSDictionary *)as_dict;
@end

@interface MagicalRecordPatch : NSObject
@end
