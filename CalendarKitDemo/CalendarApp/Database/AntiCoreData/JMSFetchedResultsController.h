//
//  JMSFetchedResultsController.h
//  Masters
//
//  Created by Jasf on 16.05.2018.
//  Copyright © 2018 Jam Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "JMSFetchRequest.h"

@class JMSFetchedResultsController;

@protocol JMSFetchedResultsSectionInfo <NSFetchedResultsSectionInfo>
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *indexTitle;
@property (nonatomic) NSUInteger numberOfObjects;
@property (nonatomic) NSArray *objects;
@end

@interface JMSDefaultSectionInfo : NSObject <JMSFetchedResultsSectionInfo>
@end

@protocol JMSFetchedResultsControllerDelegate <NSObject>
typedef NS_ENUM(NSUInteger, JMSFetchedResultsChangeType) {
    JMSFetchedResultsChangeInsert = 1,
    JMSFetchedResultsChangeDelete = 2,
    JMSFetchedResultsChangeMove = 3,
    JMSFetchedResultsChangeUpdate = 4
};
- (void)controller:(JMSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(JMSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
- (void)controller:(JMSFetchedResultsController *)controller didChangeSection:(id <JMSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(JMSFetchedResultsChangeType)type;
- (void)controllerWillChangeContent:(JMSFetchedResultsController *)controller;
- (void)controllerDidChangeContent:(JMSFetchedResultsController *)controller;
- (NSString *)controller:(JMSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName API_AVAILABLE(macosx(10.12),ios(4.0));

@end


@interface JMSNSFetchedResultsController : NSFetchedResultsController
@end

@interface JMSFetchedResultsController : NSObject
@property (nonatomic) NSArray<id<JMSFetchedResultsSectionInfo>> *sections;
@property (weak, nonatomic) id<JMSFetchedResultsControllerDelegate> delegate;
@property (strong, nonatomic) NSArray *fetchedObjects;
@property (strong, nonatomic) NSString *sectionNameKeyPath;
@property (strong, nonatomic) NSString *cacheName;
@property (strong, nonatomic) JMSFetchRequest *fetchRequest;
+ (void)databasesWithKeysHasChanges:(NSArray *)keys;
+ (void)deleteCacheWithName:(NSString *)name;
- (instancetype)initWithFetchRequest:(JMSFetchRequest *)fetchRequest managedObjectContext: (JMSManagedObjectContext *)context sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)name;
- (BOOL)performFetch:(NSError **)error;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForObject:(id)object;
- (void)pause;
- (void)resume;
- (void)insertFirstSection;
@end
