//
//  JMSManagedObjectContext.h
//  Masters
//
//  Created by Jasf on 16.05.2018.
//  Copyright © 2018 Jam Soft. All rights reserved.
//

@import CoreData;

@interface JMSManagedObjectContext : NSObject
- (void)putObject:(NSBeforeManagedObject *)object;
- (NSArray *)allObjectsForClass:(Class)cls;
- (void)addModifiedObject:(NSBeforeManagedObject *)object;
- (void)deleteEntity:(NSBeforeManagedObject *)object;
- (void)deleteAllWithClass:(Class)cls;
- (void)save;
- (void)reset;
- (NSArray *)executeFetchRequest:(JMSFetchRequest *)request error:(NSError **)error;
@end
