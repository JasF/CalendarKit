#import <Foundation/Foundation.h>

@interface Singleton : NSObject

+ (instancetype)initialize;
+ (instancetype)sharedInstance;
+ (instancetype)shared;

@end
