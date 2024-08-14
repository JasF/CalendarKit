//
//  JMSManagedObjectContext.m
//  Masters
//
//  Created by Jasf on 16.05.2018.
//  Copyright © 2018 Jam Soft. All rights reserved.
//

#import "JMSManagedObjectContext.h"
#import "CalendarApp-Swift.h"
#import "JMSDAOAssembly.h"
#import "JMSFetchRequest.h"
#import "JMSFetchedResultsController.h"
//#import "JMSEvent.h"

@interface JMSManagedObjectContext ()
@property (strong, nonatomic) NSMutableDictionary *storage;
@property (strong, nonatomic) NSMutableDictionary *setsStorage;
@end

@implementation JMSManagedObjectContext

#pragma mark - Initialization
- (id)init {
    if (self = [super init]) {
        [self initialize];
        return self;
    }
    return self;
}

- (id)initWithConcurrencyType:(id)ct {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (id)initWithContext:(id)ctx {
    if (self = [super initWithContext:ctx]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _storage = [NSMutableDictionary new];
    _setsStorage = [NSMutableDictionary new];
}

#pragma mark - Overriden Methods
- (nullable NSArray *)executeFetchRequest:(JMSFetchRequest *)request error:(NSError **)error {
    JMSAssert([request isKindOfClass:[JMSFetchRequest class]]);
    if (![request isKindOfClass:[JMSFetchRequest class]]) {
        return nil;
    }
    JMSFetchedResultsController *controller = [[JMSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:nil sectionNameKeyPath:nil cacheName:nil];
    [controller performFetch:nil];
    NSArray *array = controller.fetchedObjects;
    return array;
}

#pragma mark - Public Methods
- (void)putObject:(NSBeforeManagedObject *)object {
    @synchronized ([NSObject class]) {
        JMSAssert([object isKindOfClass:[NSBeforeManagedObject class]]);
        if (![object isKindOfClass:[NSBeforeManagedObject class]]) {
            return;
        }
        Class cls = [object class];
        NSMutableArray *array = [self arrayForClass:cls];
        [array addObject:object];
        object.context = self;
    }
}

- (void)addModifiedObject:(NSBeforeManagedObject *)object {
    @synchronized (self) {
        JMSAssert([object isKindOfClass:[NSBeforeManagedObject class]]);
        if (![object isKindOfClass:[NSBeforeManagedObject class]]) {
            return;
        }
        Class cls = [object class];
        NSMutableSet *set = [self setForClass:cls];
        [set addObject:object];
    }
}

- (void)deleteEntity:(NSBeforeManagedObject *)object {
    @synchronized ([NSObject class]) {
        Class cls = [object class];
        NSMutableArray *array = [self arrayForClass:cls];
        NSInteger index = [array indexOfObject:object];
        if (index != NSNotFound) {
            [array addObject:object];
        }
    }
}


- (void)deleteAllWithClass:(Class)cls {
    @synchronized ([NSObject class]) {
        NSMutableArray *array = [self arrayForClass:cls];
        [array removeAllObjects];
    }
}

- (void)save {
    NSMutableArray *keysWithChanges = [NSMutableArray new];
    @synchronized (self) {
#if SQLITE_DISABLED == 1
#else
        
#if TIMING_LOGGING == 1
    NSDate *_methodStart = [NSDate date];
    NSInteger count = 0;
    DDLogInfo(XCODE_COLORS_ESCAPE @"bg0,0,0;" XCODE_COLORS_ESCAPE @"fg240,240,240;" @"SAVING START" XCODE_COLORS_RESET);
#endif
    
    JMSDAOFactory *factory = Managers.shared.daoAssembly.daoFactory;
    for (Class key in _storage.allKeys) {
        NSMutableArray *objects = _storage[key];
        if (!objects.count) {
            continue;
        }
        NSMutableSet *set = _setsStorage[key];
        NSArray *arr = set.allObjects;
        NSMutableArray *copy = [objects mutableCopy];
        [copy removeObjectsInArray:arr];
        JMSBaseDAO *dao = [factory daoForObject:objects.firstObject];
        if (!dao) {
            continue;
        }
        for (NSBeforeManagedObject *object in copy) {
            object.modified = NO;
           // object.cached = YES;
        }
#if TIMING_LOGGING == 1
        count += copy.count;
#endif
        if (copy.count) {
            NSString *className = NSStringFromClass(key);
            [keysWithChanges addObject:className];
            [dao update:copy];
        }
    }
    for (NSString *key in _setsStorage.allKeys) {
        NSMutableSet *set = _setsStorage[key];
        if (!set.count) {
            continue;
        }
        NSArray *objects = set.allObjects;
        JMSBaseDAO *dao = [factory daoForObject:objects.firstObject];
        if (!dao) {
            continue;
        }
        for (NSBeforeManagedObject *object in objects) {
            object.modified = NO;
            //object.cached = YES;
        }
#if TIMING_LOGGING == 1
        count += objects.count;
#endif
        if (objects.count) {
            [dao update:objects];
            NSString *className = NSStringFromClass(key);
            [keysWithChanges addObject:className];
        }
        [set removeAllObjects];
    }
    [_storage removeAllObjects];
    dispatch_background_8(^{
        [JMSFetchedResultsController databasesWithKeysHasChanges:keysWithChanges];
    });
#if TIMING_LOGGING == 1
    /*
    DDLogInfo(XCODE_COLORS_ESCAPE @"bg255,187,218;" @"INCOMING SETTINGS. size: %@: %@" XCODE_COLORS_RESET, @(data.length), JMSLogger.threadString);
    */
    DDLogInfo(XCODE_COLORS_ESCAPE @"bg0,0,0;" XCODE_COLORS_ESCAPE @"fg255,255,255;" @"SAVING TIME: %@; count: %@" XCODE_COLORS_RESET, @([[NSDate date] timeIntervalSinceDate:_methodStart]), @(count));
    if (count > 1000) {
        DDLogInfo(@"LONG OPERATION");
    }
#endif
    
#endif
    }
}

- (void)reset {
    
}

- (NSArray *)allObjectsForClass:(Class)cls {
    NSArray *array = nil;
    @synchronized ([NSObject class]) {
        array =[[self arrayForClass:cls] copy];
    }
    return array;
}

#pragma mark - Private Methods
- (NSMutableArray *)arrayForClass:(Class)cls {
    NSMutableArray *array = nil;
    array = _storage[cls];
    if (!array) {
        array = [NSMutableArray new];
        [_storage setObject:array forKey:cls];
    }
    return array;
}

- (NSMutableSet *)setForClass:(Class)cls {
    NSMutableSet *set = nil;
    set = _setsStorage[cls];
    if (!set) {
        set = [NSMutableSet new];
        [_setsStorage setObject:set forKey:cls];
    }
    return set;
}

@end
