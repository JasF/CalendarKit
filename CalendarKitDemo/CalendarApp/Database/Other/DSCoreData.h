#import "Singleton.h"

@interface DSCoreData : Singleton

@property (readonly, strong, nonatomic) JMSManagedObjectContext * masterContext;
@property (readonly, strong, nonatomic) JMSManagedObjectContext * readContext;
@property (readonly, strong, nonatomic) JMSManagedObjectContext * readSecondContext;
@property (readonly, strong, nonatomic) JMSManagedObjectContext * writeContext;
@property (readonly, strong, nonatomic) JMSManagedObjectContext * backgroundContext;
@property (readonly, strong, nonatomic) JMSManagedObjectContext * threadContext;
//@property (readonly, strong, nonatomic) NSManagedObjectModel   * managedObjectModel;
//@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator * persistentStoreCoordinator;

+ (dispatch_queue_t) ds_background_save_queue;

- (void) initialize;
- (void) deleteFiles;
- (void) resetContext;

- (void) saveContext;
- (void) saveContextWithCompletion:(dispatch_block_t)completion;
- (void) saveContext:(JMSManagedObjectContext *)context withCompletion:(dispatch_block_t)completion;

- (void) saveReadContextWithCompletion:(dispatch_block_t)completion;

- (void) saveBackgroundContextWithCompletion:(dispatch_block_t)completion;
- (void) saveBackgroundContext;

- (void) syncSaveBackgroundContextWithCompletion:(dispatch_block_t)completion;
- (void) recreateDatabase;

@end
