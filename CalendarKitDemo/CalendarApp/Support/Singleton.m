#import "Singleton.h"

@implementation Singleton

static NSMutableDictionary *instances = nil;

+ (void)initialize
{
    if(!instances)
    {
        instances = [NSMutableDictionary dictionary];
    }
}

+ (instancetype)sharedInstance
{
    id instance = nil;
    
    @synchronized(self)
    {
        NSString *selfClassString = NSStringFromClass(self);
        
        if (instances[selfClassString] == nil)
        {
            instances[selfClassString] = [[self alloc] init];
        }
        instance = instances[selfClassString];
    }
    
    return instance;
}

+ (instancetype)shared {
    return [self sharedInstance];
}

@end
