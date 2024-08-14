//
//  JMSFetchedResultsController.m
//  Masters
//
//  Created by Jasf on 16.05.2018.
//  Copyright © 2018 Jam Soft. All rights reserved.
//

#import "JMSFetchedResultsController.h"
//#import "JMSChatMessage.h"
#import "CalendarApp-Swift.h"

@interface JMSDefaultSectionInfo ()
@end

@implementation JMSDefaultSectionInfo
@synthesize name;
@synthesize indexTitle;
@synthesize numberOfObjects;
@synthesize objects;
@end

static NSMutableDictionary *frcDictionary = nil;

@interface JMSFetchedResultsController ()
@property (assign, nonatomic) BOOL hasChanges;
@property (assign, nonatomic) BOOL paused;
@property (assign) BOOL deallocing;
@end

@implementation JMSFetchedResultsController

- (void)dealloc {
    _deallocing = YES;
    @synchronized (frcDictionary) {
        NSMutableArray *array = [[self class] arrayWithEntityName:self.fetchRequest.entityName];
        NSInteger index = [array indexOfObject:[NSValue valueWithNonretainedObject:self]];
        //JMSAssert(index != NSNotFound);
        if (index != NSNotFound) {
            [array removeObjectAtIndex:index];
        }
    }
#if DEBUG == 1
    //DDLogInfo(XCODE_COLORS_ESCAPE @"bg0,0,0;" XCODE_COLORS_ESCAPE @"fg240,240,240;" @"FETCHEDRESONC DEALLOC" XCODE_COLORS_RESET);
#endif
}

+ (void)databasesWithKeysHasChanges:(NSArray *)keys {
    /*
    @synchronized (frcDictionary) {
        for (NSString *key in keys) {
            NSArray *fetchedControllers = [self arrayWithEntityName:key];
            if (!fetchedControllers.count) {
                continue;
            }
            for (NSValue *storage in fetchedControllers) {
                JMSFetchedResultsController *controller = storage.nonretainedObjectValue;
                [controller handleDatabaseChanged];
            }
        }
    }
     */
}

- (void)pause {
    //_paused = YES;
}

- (void)resume {
    /*
    _paused = NO;
    if (_delegate && _hasChanges) {
        _hasChanges = NO;
        [self processHandleChanges];
    }
     */
}

- (void)handleDatabaseChanged {
    /*
    if (!self.delegate || _paused) {
        self.hasChanges = YES;
        return;
    }
    [self processHandleChanges];
     */
}

- (void)processHandleChanges {
    /*
    if (_deallocing) {
        return;
    }
    @weakify(self);
    dispatch_background(^{
        @strongify(self);
        [self doHandleDatabaseChanged];
    });
     */
}

- (void)doHandleDatabaseChanged {
    /*
    if (_deallocing) {
        return;
    }
    NSArray *array = [self performFetchInternal:nil];
    
    NSArray *sections = [self constructSectionsWithObjects:array];
    dispatch_mainthread(^{
        self.fetchedObjects = array;
        self.sections = sections;
#if DEBUG == 1
        JMSDefaultSectionInfo *info = sections.firstObject;
        JMSChatMessage *message = info.objects.firstObject;
        if ([message isKindOfClass:[JMSChatMessage class]]) {
            DDLogInfo(@"message is: %@", message.text);
        }
#endif
        if ([self.delegate respondsToSelector:@selector(controllerWillChangeContent:)]) {
            [self.delegate controllerWillChangeContent:self];
        }
        if ([self.delegate respondsToSelector:@selector(controllerDidChangeContent:)]) {
            [self.delegate controllerDidChangeContent:self];
        }
    });
    DDLogInfo(@"fetched change from database! delegate is: %@; key: %@; ", _delegate, self.fetchRequest.entityName);
     */
    
    
}

+ (void)deleteCacheWithName:(NSString *)name {
    // do nothing
}

- (id)init {
    if (self = [super init]) {
#if DEBUG == 1
        //DDLogInfo(XCODE_COLORS_ESCAPE @"bg0,0,0;" XCODE_COLORS_ESCAPE @"fg240,240,240;" @"FETCHEDRESONC INIT SIMPLE" XCODE_COLORS_RESET);
#endif
    }
    return self;
}

+ (NSMutableArray *)arrayWithEntityName:(NSString *)entityName {
    JMSAssert(entityName);
    NSMutableArray *array = frcDictionary[entityName];
    if (!array) {
        array = [NSMutableArray new];
        [frcDictionary setObject:array forKey:entityName];
    }
    return array;
}

- (void)putToStorage {
    /*
    @synchronized (frcDictionary) {
        NSMutableArray *array = [[self class] arrayWithEntityName:_fetchRequest.entityName];
        [array addObject:[NSValue valueWithNonretainedObject:self]];
        
#if DEBUG == 1
        [self calculateGlobalObjects];
#endif
    }
     */
}

#if DEBUG == 1
- (void)calculateGlobalObjects {
    NSInteger count = 0;
    for (NSString *key in [frcDictionary allKeys]) {
        NSMutableArray *array = frcDictionary[key];
        count += array.count;
    }
}
#endif

- (instancetype)initWithFetchRequest:(JMSFetchRequest *)fetchRequest managedObjectContext: (JMSManagedObjectContext *)context sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)name {
    if (self = [self init]) {
        _sectionNameKeyPath = sectionNameKeyPath;
        _cacheName = name;
        _fetchRequest = fetchRequest;
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            frcDictionary = [NSMutableDictionary new];
        });
        [self putToStorage];
    }
    return self;
}

- (BOOL)performFetch:(NSError **)error {
    NSArray *array = [self performFetchInternal:error];
    if (!array) {
        _fetchRequest = nil;
        _sections = nil;
        return NO;
    }
    _fetchedObjects = array;
    NSArray *sections = [self constructSectionsWithObjects:array];
    _sections = sections;
    return YES;
}

- (NSArray *)performFetchInternal:(NSError **)error {
    if (!_fetchRequest) {
        return nil;
    }
    Class cls = NSClassFromString(_fetchRequest.entityName);
    if (!cls) {
        return nil;
    }
    NSArray *results = nil;
    if (_fetchRequest.sortDescriptors.count) {
        results = [cls MR_findAllWithPredicate:_fetchRequest.predicate sortDescriptors:_fetchRequest.sortDescriptors];
    }
    else {
        results = [cls MR_findAllWithPredicate:_fetchRequest.predicate];
    }
    if (_fetchRequest.fetchLimit > 0) {
        results = [results subarrayWithRange:NSMakeRange(0, MIN(results.count, _fetchRequest.fetchLimit))];
    }
    return results.count ? results : @[];
}

- (NSArray *)constructSectionsWithObjects:(NSArray *)objects {
    NSMutableArray *sections = [NSMutableArray new];
    if (_sectionNameKeyPath) {
        NSMutableDictionary *map = [NSMutableDictionary new];
        NSMutableArray *orderedStorages = [NSMutableArray new];
        NSMutableArray *orderedValues = [NSMutableArray new];
        for (NSBeforeManagedObject *object in objects) {
            id sectionValue = [object valueForKeyPath:_sectionNameKeyPath];
            if (!sectionValue) {
                JMSAssert(false);
                continue;
            }
            NSMutableArray *storage = [map objectForKey:sectionValue];
            if (!storage) {
                storage = [NSMutableArray new];
                [map setObject:storage forKey:sectionValue];
                [orderedStorages addObject:storage];
                [orderedValues addObject:sectionValue];
            }
            [storage addObject:object];
        }
        
        int i=0;
        for (NSMutableArray *storage in orderedStorages) {
            JMSDefaultSectionInfo *info = [JMSDefaultSectionInfo new];
            id value = orderedValues[i];
            info.name = [NSString stringWithFormat:@"%@", value];
            info.indexTitle = @"";
            info.numberOfObjects = storage.count;
            info.objects = storage;
            [sections addObject:info];
            ++i;
        }
    }
    else {
        JMSDefaultSectionInfo *info = [JMSDefaultSectionInfo new];
        info.name = @"";
        info.indexTitle = @"";
        info.numberOfObjects = objects.count;
        info.objects = objects;
        return @[info];
    }
    return sections;
}

- (void)insertFirstSection {
    JMSDefaultSectionInfo *info = [JMSDefaultSectionInfo new];
    NSMutableArray *sections = [_sections mutableCopy];
    [sections insertObject:info atIndex:0];
    _sections = sections;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    //JMSAssert(_sections.count > indexPath.section);
    if (_sections.count <= indexPath.section) {
        return nil;
    }
    id<JMSFetchedResultsSectionInfo> info = _sections[indexPath.section];
    //JMSAssert(info.numberOfObjects > indexPath.row && info.objects.count > indexPath.row);
    if (info.objects.count <= indexPath.row) {
        return nil;
    }
    id object = info.objects[indexPath.row];
    return object;
}

- (NSIndexPath *)indexPathForObject:(id)object {
    for (id<JMSFetchedResultsSectionInfo> info in _sections) {
        NSInteger index = [info.objects indexOfObject:object];
        if (index != NSNotFound) {
            NSInteger section = [_sections indexOfObject:info];
            return [NSIndexPath indexPathForRow:index inSection:section];
        }
    }
    NSInteger index = [_fetchedObjects indexOfObject:object];
    if (index == NSNotFound) {
        return nil;
    }
    return [NSIndexPath indexPathForRow:index inSection:0];
}

@end
