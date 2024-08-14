//
//  MagicalRecordPatch.m
//  Masters
//
//  Created by Jasf on 14.05.2018.
//  Copyright © 2018 Jam Soft. All rights reserved.
//

#import "MagicalRecordPatch.h"
#import "CalendarApp-Swift.h"
#import "JMSDAOAssembly.h"
//#import "RYNServerMessage.h"
#import "JMSOwnerUser.h"
#import "JMSOwnerUser+JMSFactory.h"
/*
#import "JMSUser.h"
#import "JMSTip.h"
#import "JMSPrivacy.h"
#import "JMSCategory.h"
#import "JMSContactsGroup.h"
#import "JMSPlace.h"
#import "JMSService.h"
#import "JMSChatMessage.h"
#import "JMSChat.h"
#import "JMSEvent.h"
#import "JMSCalendar.h"
 */
#import "NSPredicate2SQL.h"
#import "DSCoreData.h"
#import "RSSwizzle.h"
#import "JMSManagedObjectContext.h"
#import "CalendarApp-Swift.h"


@interface NSNotificationCenter (ConcurrencyPatch)
@end

@implementation NSNotificationCenter (ConcurrencyPatch)
+ (void)initialize {
    SEL selector = @selector(postNotificationName:object:);
    [RSSwizzle
     swizzleInstanceMethod:selector
     inClass:[self class]
     newImpFactory:^id(RSSwizzleInfo *swizzleInfo) {
         return ^void(__unsafe_unretained id Aself, NSString *notificationName, id a2){
             dispatch_block_t block = ^{
                 void (*originalIMP)(__unsafe_unretained id, SEL, id a1, id a2);
                 originalIMP = (__typeof(originalIMP))[swizzleInfo getOriginalImplementation];
                 originalIMP(Aself,selector, notificationName, a2);
             };
             if ([NSThread isMainThread] || ![notificationName containsString:@"notification."]) {
                 block();
             }
             else {
                 dispatch_mainthread(block);
             }
         };
     }
     mode:RSSwizzleModeAlways
     key:NULL];
    
    SEL selV2 = @selector(postNotificationName:object:userInfo:);
    [RSSwizzle
     swizzleInstanceMethod:selV2
     inClass:[self class]
     newImpFactory:^id(RSSwizzleInfo *swizzleInfo) {
         return ^void(__unsafe_unretained id Aself, NSString *notificationName, id a2, id a3){
             dispatch_block_t block = ^{
                 void (*originalIMP)(__unsafe_unretained id, SEL, id a1, id a2, id a3);
                 originalIMP = (__typeof(originalIMP))[swizzleInfo getOriginalImplementation];
                 originalIMP(Aself,selV2, notificationName, a2, a3);
             };
             if ([NSThread isMainThread] || ![notificationName containsString:@"notification."]) {
                 block();
             }
             else {
                 dispatch_mainthread(block);
             }
         };
     }
     mode:RSSwizzleModeAlways
     key:NULL];
}
@end

@implementation NSSQLNumber
- (id)init:(NSNumber *)value {
    if (self = [super init]) {
        _value = value.integerValue;
    }
    return self;
}
+ (NSInteger)fromArray:(NSArray *)array {
    if (array && ![array isKindOfClass:[NSArray class]]) {
        JMSAssert(false);
        return 0;
    }
    NSSQLNumber *value = array.firstObject;
    if (value && ![value isKindOfClass:[NSSQLNumber class]]) {
        JMSAssert(false);
        return 0;
    }
    return value.value;
}
@end

@implementation JMSLogger
+ (NSString *)threadString {
    return @"";
    
    NSString *str = [NSThread currentThread].description;
    NSRange s = [str rangeOfString:@"{"];
    NSRange l = [str rangeOfString:@"}"];
    if (s.location != NSNotFound && l.location != NSNotFound) {
        str = [str substringWithRange:NSMakeRange(s.location+1, l.location-s.location-1)];
        NSArray *comps = [str componentsSeparatedByString:@" "];
        if (comps.count > 2) {
            str = comps[2];
        }
    }
    return [NSString stringWithFormat:@"Thread id: %@", str];
}
@end

@import EasyMapping;

/*
@interface JMSManagedObjectContext (Deprecated)
@end

@implementation JMSManagedObjectContext (Deprecated)
- (void)executeFetchRequest:(id)request error:(id)error {
    JMSAssert(false);
}
@end
*/
 
@interface NSFetchedResultsController (Deprecated)
@end

@implementation NSFetchedResultsController (Deprecated)
- (void)performFetch:(id)arg {
    JMSAssert(false);
}
@end

void dispatch_background(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        block();
    });
}

void dispatch_background_1(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        block();
    });
}

void dispatch_background_2(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        block();
    });
}

void dispatch_background_3(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        block();
    });
}

void dispatch_background_4(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        block();
    });
}

void dispatch_background_5(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        block();
    });
}

void dispatch_background_6(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        block();
    });
}

void dispatch_background_7(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        block();
    });
}

void dispatch_background_8(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        block();
    });
}

void dispatch_background_9(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        block();
    });
}

void dispatch_background_10(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        block();
    });
}

void dispatch_background_11(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        block();
    });
}

void dispatch_background_12(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        block();
    });
}

void dispatch_background_13(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        block();
    });
}

void dispatch_background_14(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        block();
    });
}

void dispatch_background_15(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        block();
    });
}

void dispatch_background_16(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        block();
    });
}

void dispatch_background_17(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        block();
    });
}

void dispatch_background_18(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        block();
    });
}

void dispatch_background_19(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        block();
    });
}

void dispatch_background_20(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        block();
    });
}

void dispatch_background_high(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_HIGH), ^{
        block();
    });
}

void dispatch_mainthread(dispatch_block_t block) {
    dispatch_async(dispatch_get_main_queue(), ^{
        block();
    });
}

#if DEBUG == 1
@interface UIAlertView (A)
@end

@implementation UIAlertView (A)
+ (void)initialize {
    SEL selector = @selector(alloc);
    [RSSwizzle
     swizzleInstanceMethod:selector
     inClass:[self class]
     newImpFactory:^id(RSSwizzleInfo *swizzleInfo) {
         // This block will be used as the new implementation.
         return ^id(__unsafe_unretained id Aself){
             // You MUST always cast implementation to the correct function pointer.
             id (*originalIMP)(__unsafe_unretained id, SEL);
             originalIMP = (__typeof(originalIMP))[swizzleInfo getOriginalImplementation];
             // Calling original implementation.
             id res = originalIMP(Aself,selector);
             // Returning modified return value.
             return res;
         };
     }
     mode:RSSwizzleModeAlways
     key:NULL];
}
@end
#endif

static NSMutableArray *g_patchedClasses = nil;
@import EasyMapping;
@implementation NSBeforeManagedObject

- (id)deepCopy {
    NSDictionary *dict = [self toJsonDictionary];
    id result = [EKMapper objectFromExternalRepresentation:dict withMapping:[[self class] objectMapping]];
    return result;
}

void repl_setSettings(id self, SEL _cmd, id value) {
    // do whatever you want with the variables....
    
    // you can work out the name of the variable using - NSStringFromSelector(_cmd)
    // or by looking at the attributes of the property with property_getAttributes(property);
    // There's a V_varName in the property attributes
    // and get it's value using - class_getInstanceVariable ()
    //     Ivar ivar = class_getInstanceVariable([SomeClass class], "_myVarName");
    //     return object_getIvar(self, ivar);
}

static NSArray *g_jsonTypes = nil;
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_jsonTypes = @[@"NSDictionary", @"NSArray", @"NSMutableDictionary", @"NSMutableArray"];
    });
}

+ (void)printAllTypes:(id)object key:(NSString *)key {
    DDLogInfo(@"key: %@", key);
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)object;
        for (NSString *key in [dict allKeys]) {
            id v = dict[key];
            [self printAllTypes:v key:key];
        }
    }
    else if ([object isKindOfClass:[NSArray class]]) {
        NSArray *ar = (NSArray *)object;
        for (id obj in ar) {
            [self printAllTypes:obj key:key];
        }
    }
    else {
        DDLogInfo(@"vType: %@", [object class]);
    }
}

+ (NSString *)jsonFromObject:(id)object {
    DDLogInfo(@"into json conv: %@", NSStringFromClass([object class]));
    DDLogInfo(@"raw data: %@", object);
    [self printAllTypes:object key:@"^^^ROOT"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    DDLogInfo(@"out json conv");
    return string;
}

+ (void)replaceSetters {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_patchedClasses = [NSMutableArray new];
    });
    [g_patchedClasses addObject:[self class]];
    unsigned int numberOfProperties;
    objc_property_t *propertyArray = class_copyPropertyList([self class], &numberOfProperties);
    for (NSUInteger i = 0; i < numberOfProperties; i++) {
        objc_property_t property = propertyArray[i];
        NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
        const char * type = property_getAttributes(property);
        NSString * typeString = [NSString stringWithUTF8String:type];
        NSArray * attributes = [typeString componentsSeparatedByString:@","];
        NSString * typeAttribute = [attributes objectAtIndex:0];
        NSString * propertyType = [typeAttribute substringFromIndex:1];
        NSArray *components = [propertyType componentsSeparatedByString:@"\""];
        NSString *typeName = nil;
        NSNumber *isJsonType = @(NO);
        NSNumber *isDate = @(NO);
        NSNumber *isJMS = @(NO);
        if (components.count > 2) {
            typeName = components[1];
            if ([g_jsonTypes containsObject:typeName]) {
                isJsonType = @(YES);
            }
            else if (typeName.length > 3 && [[typeName substringToIndex:3] isEqualToString:@"JMS"]) {
                isJMS = @(YES);
            }
            else {
                isDate = @([typeName isEqualToString:@"NSDate"]);
            }
        }
        name = [NSString stringWithFormat:@"set%@%@:", [name substringToIndex:1].uppercaseString, [name substringFromIndex:1]];
        SEL selector = NSSelectorFromString(name);
        [RSSwizzle
         swizzleInstanceMethod:selector
         inClass:[self class]
         newImpFactory:^id(RSSwizzleInfo *swizzleInfo) {
             // This block will be used as the new implementation.
             return ^void(__unsafe_unretained NSBeforeManagedObject * aSelf, id value){
                 // DO NOT USE BASE TYPE! ONLY ID (like NSNUMBER *) is supported!
#if DEBUG == 1
                 //DDLogVerbose(@"name: %@", name);
#endif
                 if (!aSelf.context) {
                     if (isJMS.boolValue && [value isKindOfClass:[NSString class]]) {
                         Class mp = NSClassFromString(typeName);
                         if (![mp conformsToProtocol:@protocol(EKMappingProtocol)]) {
                             JMSAssert(false);
                             return;
                         }
                         NSString *str = (NSString *)value;
                         NSError *error = nil;
                         id object = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding]
                                                                     options:0
                                                                       error:&error];
                         if (error) {
                             value = nil;
                             JMSAssert(false);
                         }
                         else if ([object isKindOfClass:[NSDictionary class]]) {
                             EKObjectMapping *mapping = [mp objectMapping];
                             id nativeObject = [EKMapper objectFromExternalRepresentation:object withMapping:mapping];
                             JMSAssert(nativeObject);
                             value = nativeObject;
                         }
                         else {
                             JMSAssert(false);
                             value = nil;
                         }
                     }
                     else if (isDate.boolValue) {
                         if (value && ![value isKindOfClass:[NSDate class]]) {
                             if ([value isKindOfClass:[NSNumber class]]) {
                                 NSNumber *num = (NSNumber *)value;
                                 NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:num.doubleValue];
                                 value = date;
                             }
                             else {
                                 JMSAssert(false);
                                 value = nil;
                             }
                         }
                     }
                     else if ([value isKindOfClass:[NSString class]] && isJsonType.boolValue) {
                         NSString *str = (NSString *)value;
                         NSError *error = nil;
                         id object = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding]
                                                                     options:0
                                                                       error:&error];
                         if (error) {
                             JMSAssert(false);
                             value = nil;
                         }
                         else if (![object isKindOfClass:NSClassFromString(typeName)]) {
                             JMSAssert(false);
                             value = nil;
                         }
                         else {
                             value = object;
                         }
                     }
                 }
                 else if (value == nil) {
                     if (components.count > 1 && [components[1] isEqualToString:@"NSString"]) {
                         value = @"";
                     }
                 }
                 void (*originalIMP)(__unsafe_unretained id, SEL, id);
                 originalIMP = (__typeof(originalIMP))[swizzleInfo getOriginalImplementation];
                 originalIMP(aSelf,selector,value);
                 if (aSelf.context && !aSelf.modified) {
                     aSelf.modified = YES;
                     [aSelf.context addModifiedObject:aSelf];
                 }
             };
         }
         mode:RSSwizzleModeAlways
         key:NULL];
    }
}


- (id)init {
    if (self = [super init]) {
        @synchronized(g_patchedClasses) {
            if (![g_patchedClasses containsObject:[self class]]) {
                [[self class] replaceSetters];
            }
        }
    }
    return self;
}

- (id)initWithContext:(id)ctx {
    if (self = [self init]) {
        
    }
    return self;
}

@end

@implementation NSObject (Ext)
- (NSDictionary *)as_dict {
    if ([self isKindOfClass:[NSDictionary class]]) {
        return(NSDictionary *)self;
    }
    else if ([self isKindOfClass:[NSString class]]) {
        return [NSJSONSerialization JSONObjectWithData:[(NSString *)self dataUsingEncoding:NSUTF8StringEncoding] options:0 error:0];
    }
    return @{};
}
    
- (id)managedObjectContext {
    return nil;
}
- (id)initWithContext:(id)ctx {
    if (self = [self init]) {
        
    }
    return self;
}

- (NSDictionary *)toDictionary {
    JMSAssert([self conformsToProtocol:@protocol(EKMappingProtocol)]);
    if (![self conformsToProtocol:@protocol(EKMappingProtocol)]) {
        return @{};
    }
    NSDictionary *dictionary = [EKSerializer serializeObject:self withMapping:[[self class] objectMapping]];
    return dictionary;
}

- (NSDictionary *)toJsonDictionary {
    JMSAssert([self conformsToProtocol:@protocol(EKMappingProtocol)]);
    if (![self conformsToProtocol:@protocol(EKMappingProtocol)]) {
        return @{};
    }
    NSDictionary *dictionary = [EKSerializer serializeObject:self
                                                 withMapping:[[self class] objectMapping]
                                                     options:EKSOJsonCompatible];
    return dictionary;
}
    
- (id)objectID {
    JMSAssert(false);
    return @(0);
}
/*
- (id)valueForKey:(NSString *)key {
    JMSAssert(false);
    return @"some";
}
*/
- (BOOL)isFault {
    return NO;
}
@end

@interface DynamicStorage : NSObject
@property NSMutableDictionary *dict;
@property NSMutableDictionary *daos;
@end

@implementation DynamicStorage

- (id)init {
    if (self = [super init]) {
        _dict = [NSMutableDictionary new];
        _daos = [NSMutableDictionary new];
    }
    return self;
}
+ (instancetype)shared {
    static DynamicStorage *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [DynamicStorage new];
    });
    return sharedInstance;
}

- (JMSBaseDAO *)daoForEntityClass:(Class)cls {
    JMSBaseDAO *dao = nil;
    @synchronized ([NSObject class]) {
        NSValue *v = [NSValue valueWithNonretainedObject:cls];
        dao = _daos[v];
        if (!dao) {
            JMSDAOFactory *factory = Managers.shared.daoAssembly.daoFactory;
            dao = [factory daoForClass:cls];
            [_daos setObject:dao forKey:v];
        }
    }
    return dao;
}
@end

@implementation MagicalRecordPatch

@end


@implementation NSBeforeManagedObject (NSPatch)

+ (NSArray *)MR_findAll {
    return [self MR_findAllInContext:[DSCoreData sharedInstance].readContext];
}

+ (BOOL) MR_truncateAll
{
    return [self MR_truncateAllInContext:nil];
}

+ (BOOL) MR_truncateAllInContext:(JMSManagedObjectContext *)context
{
    return [self MR_deleteAllMatchingPredicate:nil inContext:nil];
}

+ (NSArray *) MR_findAllWithPredicate:(NSPredicate *)searchterm {
    return [self MR_findAllWithPredicate:searchterm inContext:[DSCoreData sharedInstance].readContext];
}

+ (NSArray *) MR_findAllWithPredicate:(NSPredicate *)searchterm sortDescriptors:(NSArray *)descriptors {
    NSArray *array = [self MR_findAllWithPredicate:searchterm];
    if (descriptors.count) {
        array = [array sortedArrayUsingDescriptors:descriptors];
    }
    return array;
}

+ (NSArray *) MR_findAllWithPredicate:(NSPredicate *)searchterm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(JMSManagedObjectContext *)context
{
    NSArray *components = [sortTerm componentsSeparatedByString:@","];
    if (!components.count && sortTerm.length) {
        components = @[sortTerm];
    }
    NSMutableArray *descriptors = [NSMutableArray new];
    for (NSString *key in components) {
        [descriptors addObject: [NSSortDescriptor sortDescriptorWithKey:key ascending:ascending] ];
    }
    return [self MR_findAllWithPredicate:searchterm sortDescriptors:descriptors];
}


+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(JMSManagedObjectContext *)context
{
    NSArray *array = [self MR_findAllWithPredicate:nil sortedBy:sortTerm ascending:ascending inContext:context];
    return array;
}

+ (instancetype) MR_findFirstWithPredicate:(NSPredicate *)searchterm {
    return [self MR_findFirstWithPredicate:searchterm inContext:[DSCoreData sharedInstance].readContext];
}

+ (instancetype) MR_findFirstWithPredicate:(NSPredicate *)searchterm inContext:(JMSManagedObjectContext *)context {
    return [self MR_findFirstWithPredicate:searchterm sortedBy:nil ascending:NO inContext:context];
}

+ (instancetype) MR_findFirstWithPredicate:(NSPredicate *)searchterm sortedBy:(NSString *)sortTerm ascending:(BOOL)ascending inContext:(JMSManagedObjectContext *)context
{
    NSArray *array = [self MR_findAllWithPredicate:searchterm sortedBy:sortTerm ascending:ascending inContext:context];
    return array.firstObject;
}

+ (JMSFetchRequest *) MR_requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(id)context
{
    JMSFetchRequest *request = [JMSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:sortTerm ascending:ascending]];
    request.predicate = searchTerm;
    return request;
}

+ (NSFetchRequest *)MR_createFetchRequestInContext:(JMSManagedObjectContext *)context
{
    JMSAssert(false);
    return nil;
}

- (BOOL)MR_deleteEntity {
    return [self MR_deleteEntityInContext:[DSCoreData sharedInstance].readContext];
}

- (BOOL) MR_deleteEntityInContext:(JMSManagedObjectContext *)context
{
    JMSAssert(context);
    JMSBaseDAO *dao = [DynamicStorage.shared daoForEntityClass:[self class]];
    [self MR_deleteEntityInContext:context dao:dao];
    return YES;
}



+ (NSArray *) MR_findAllInContext:(JMSManagedObjectContext *)context
{
    return [self MR_findAllWithPredicate:nil inContext:context];//[self MR_executeFetchRequest:[self MR_requestAllInContext:context] inContext:context];
}

+ (BOOL) MR_deleteAllMatchingPredicate:(NSPredicate *)predicate {
    return [self MR_deleteAllMatchingPredicate:predicate inContext:[DSCoreData sharedInstance].readContext];
}

+ (BOOL) MR_deleteAllMatchingPredicate:(NSPredicate *)predicate inContext:(JMSManagedObjectContext *)context
{
    return [self MR_deleteAllMatchingPredicate:predicate
                                   whereClause:nil
                                     inContext:context];
}

+ (void)createIndexIfNotExists:(NSString *)name columns:(NSArray *)columns {
    JMSBaseDAO *dao = [DynamicStorage.shared daoForEntityClass:[self class]];
    JMSAssert(dao);
    if (!dao) {
        return;
    }
    [dao createIndexIfNotExists:name columns:columns];
}

+ (BOOL) MR_deleteAllMatchingPredicate:(NSPredicate *)predicate whereClause:(NSString *)clause inContext:(JMSManagedObjectContext *)context {
    if ([[self class] isEqual:[JMSOwnerUser class]]) {
        [JMSOwnerUser deleteOwnerUser];
    }
    JMSBaseDAO *dao = [DynamicStorage.shared daoForEntityClass:[self class]];
    JMSAssert(dao);
    BOOL hasChanges = NO;
    if (predicate) {
        NSArray *daoObjects = [self sql_findAllWithPredicate:predicate inContext:context clause:&clause];
        for (NSBeforeManagedObject *object in daoObjects) {
            [context deleteEntity:object];
            hasChanges = YES;
        }
        if (daoObjects.count) {
            [dao deleteObjects:daoObjects];
        }
    }
    else {
        hasChanges = YES;
        [dao deleteAll];
        [context deleteAllWithClass:[self class]];
    }
    
    if (hasChanges) {
        dispatch_background(^{
            [JMSFetchedResultsController databasesWithKeysHasChanges:@[NSStringFromClass(self)]];
        });
    }
    
    return YES;
}


- (void)MR_deleteEntityInContext:(JMSManagedObjectContext *)context dao:(JMSBaseDAO *)dao {
    JMSAssert(context && dao);
#if SQLITE_DISABLED == 1
#else
    [context deleteEntity:self];
    [dao delete:self];
    
#endif
}

+ (NSArray *)sql_findAllWithPredicate:(NSPredicate *)searchTerm inContext:(JMSManagedObjectContext *)context clause:(NSString **)clauseStorage
{
#if DEBUG == 1
    //@synchronized (self) {
#endif
    if (context == nil) {
        context = [DSCoreData shared].readContext;
    }
#if EVENTS_LOGGING == 1
    NSDate *eventDate = [NSDate date];
#endif
#if SQLITE_DISABLED == 1
    return @[];
#endif
    NSString *clause = nil;
    if (clauseStorage) {
        clause = *clauseStorage;
    }
    if (!clause.length && searchTerm) {
#if DEBUG == 1
        if ([NSStringFromClass(self) isEqualToString:@"RYNServerMessage"]) {
            //DDLogInfo(@"!");
        }
        else {
            //DDLogInfo(@"!");
        }
#endif
        clause = SQLWhereClauseForPredictate(searchTerm);
        if (!clause) {
            JMSAssert(false);
            return @[];
        }
    }
    
    JMSBaseDAO *dao = [DynamicStorage.shared daoForEntityClass:[self class]];
    JMSAssert(dao);
    if (!dao) {
        return nil;
    }
    
    NSArray *objects = nil;
    NSArray *contexted = [context allObjectsForClass:[self class]];
    if (clause) {
        NSString *attribute = searchTerm.sqlAttribute;
        NSDictionary *attributes = searchTerm.sqlAttributes;
        objects = [dao objectsWithWhereClause:clause attribute:attribute attributes:attributes];
        if (contexted.count && searchTerm) {
            contexted = [contexted filteredArrayUsingPredicate:searchTerm];
        }
    }
    else {
        objects = [dao allObjects];
    }
    objects = [objects arrayByAddingObjectsFromArray:contexted];
    for (NSBeforeManagedObject *object in objects) {
        object.context = context;
    }
    
    if (clauseStorage) {
        *clauseStorage = clause;
    }
#if EVENTS_LOGGING == 1
    if ([self isEqual:[JMSEvent class]]) {
        DDLogInfo(XCODE_COLORS_ESCAPE @"bg0,0,0;" XCODE_COLORS_ESCAPE @"fg240,240,240;" @"EVENTS REQUEST WITH OBJECTS: %@; time: %@" XCODE_COLORS_RESET, @(objects.count), @([[NSDate date] timeIntervalSinceDate:eventDate]));
    }
#endif
    return objects;
#if DEBUG == 1
    //}
    //return @[];
#endif
}

+ (NSArray *)sql_findAllWithClause:(NSString *)clause parameters:(NSDictionary *)parameters {
    JMSBaseDAO *dao = [DynamicStorage.shared daoForEntityClass:[self class]];
    JMSAssert(dao);
    if (!dao) {
        return nil;
    }
    NSArray *objects = [dao objectsWithClause:clause parameters:parameters];
    for (NSBeforeManagedObject *object in objects) {
        object.context = nil;
    }
    return objects;
}

+ (NSArray *)MR_findAllWithPredicate:(NSPredicate *)searchTerm inContext:(JMSManagedObjectContext *)context {
    return [self MR_findAllWithPredicate:searchTerm whereClause:nil inContext:context];
}

+ (NSArray *)MR_findAllWithPredicate:(NSPredicate *)searchTerm whereClause:(NSString *)clause inContext:(id)context {
    NSArray *objects = [self sql_findAllWithPredicate:searchTerm inContext:context clause:&clause];
    return objects;
}

+ (id)jms_findSingleWithPredicate:(NSPredicate *)searchTerm
                        inContext:(JMSManagedObjectContext *)context {
    NSArray *results = [self MR_findAllWithPredicate:searchTerm inContext:context];
    
    if (results.count > 1) {
        //JMSAssert(false);
    }
    
    if (results.count > 0) {
        return results[0];
    }
    
    return nil;
}

+ (id)jms_findSingleWithPredicate:(NSPredicate *)searchTerm {
    return [self jms_findSingleWithPredicate:searchTerm
            inContext:[DSCoreData sharedInstance].readContext];
}

+ (void)handleObjectCreated:(NSBeforeManagedObject *)object inContext:(JMSManagedObjectContext *)context {
    JMSAssert(context && [context isKindOfClass:[JMSManagedObjectContext class]]);
    [context putObject:object];
}

+ (id)jms_findSingleOrCreateWithPredicate:(NSPredicate *)searchTerm inContext:(JMSManagedObjectContext *)context {
    id result = [self jms_findSingleWithPredicate:searchTerm inContext:context];
    if (!result) {
        result = [self doCreateInContext:context];
    }
    return result;
}

+ (id) MR_createEntityInContext:(JMSManagedObjectContext *)context
{
    id object = [self doCreateInContext:context];
    return object;
}

+ (id)doCreateInContext:(JMSManagedObjectContext *)context {
    id object = [[[self class] alloc] init];
    [self handleObjectCreated:object inContext:context];
    return object;
}

+ (NSDictionary *)toDictionary {
    return @{};
}


+ (NSArray *) MR_executeFetchRequest:(NSFetchRequest *)request inContext:(JMSManagedObjectContext *)context
{
    JMSAssert(false);
    return nil;
}

+ (NSArray *) MR_findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm inContext:(JMSManagedObjectContext *)context
{
    NSArray *array = [self MR_findAllWithPredicate:searchTerm sortedBy:sortTerm ascending:ascending inContext:context];
    return array;
}


+ (void)injectSqlScripts:(NSArray *)scripts parameters:(NSArray *)parameters {
    JMSBaseDAO *dao = [DynamicStorage.shared daoForEntityClass:[self class]];
    if (!dao) {
        return;
    }
    [dao injectSqlScripts:scripts parameters:parameters];
}

@end
