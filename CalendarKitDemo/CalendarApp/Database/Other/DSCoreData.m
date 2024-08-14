#import "DSCoreData.h"
//#import "JMSWizardViewController.h"
#import "CalendarApp-Swift.h"
#import "JMSManagedObjectContext.h"

@interface DSCoreData()
@end

@implementation DSCoreData

@synthesize masterContext              = _masterContext;
@synthesize readContext                = _readContext;
@synthesize writeContext               = _writeContext;
@synthesize backgroundContext          = _backgroundContext;

+ (instancetype)sharedInstance {
    return [super sharedInstance];
}

+ (dispatch_queue_t) ds_background_save_queue
{
    return dispatch_queue_create("com.app.requestCoreData", NULL);
}

- (JMSManagedObjectContext *) writeContext
{
    return _readContext;
}

- (void) saveContextWithCompletion:(dispatch_block_t)completion
{
    @synchronized ([NSObject class]) {
        [_readContext save];
        [_masterContext save];
    }
    if (completion) {
        completion();
    }
}

- (void) saveWriteContextWithCompletion:(dispatch_block_t)completion
{
    JMSAssert(false);
}

- (void) saveReadContextWithCompletion:(dispatch_block_t)completion
{
    [self saveContextWithCompletion:completion];
}

- (void) saveContext
{
    [self saveContextWithCompletion:nil];
}



#pragma mark - Initialize -

- (id) init
{
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void) deleteFiles
{
    DDLogInfo(@"deleting database files");
    NSArray *daos = [[[Managers shared] daoFactory] allDaos];
    for (JMSBaseDAO *dao in daos) {
        [dao close];
        [dao deleteDatabaseFile];
    }
    [JMSOwnerUser deleteOwnerUser];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       // [JMSWizardViewController resetWizard];
    });
    
    for (JMSBaseDAO *dao in daos) {
        [dao open];
    }
    //[JMSUserSettings shared].dashboardBanners = @[];
    DDLogInfo(@"database files deleted");
}

- (void) initialize
{
    if (_readContext) {
        return;
    }
    
    _readContext = [JMSManagedObjectContext new];
    _masterContext = _readContext;
    _writeContext = _readContext;
}

- (void) saveBackgroundContextWithCompletion:(dispatch_block_t)completion
{
}

- (void) saveBackgroundContext
{
    [self saveBackgroundContextWithCompletion:nil];
}

- (void) syncSaveBackgroundContextWithCompletion:(dispatch_block_t)completion
{
    JMSAssert(false);
    [_readContext save];
}

- (void) resetContext
{
    [_writeContext reset];
    [_backgroundContext reset];
    [_readContext reset];
    [_masterContext reset];
    [_readContext reset];
}

- (JMSManagedObjectContext *) backgroundContext
{
    return _readContext;
}

- (JMSManagedObjectContext *) threadContext
{
    return _readContext;//[JMSManagedObjectContext MR_contextWithParent:_readContext];
}

- (void) saveContext:(JMSManagedObjectContext *)context withCompletion:(dispatch_block_t)completion
{
    if (context == self.readContext) {
        [self saveReadContextWithCompletion:completion];
    } else {
        JMSAssert(false);
    }
    
}

- (void)recreateDatabase
{
    DDLogInfo(@"Recreate database...");
    [[DSCoreData sharedInstance] deleteFiles];
    [[DSCoreData sharedInstance] initialize];
}


@end
