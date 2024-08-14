//
//  NSDateFormatter+SQL.m
//  Masters
//
//  Created by Jasf on 01.06.2018.
//  Copyright © 2018 Jam Soft. All rights reserved.
//

#import "RSSwizzle.h"

@interface NSDateFormatter (SQL)
@end

@implementation NSDateFormatter (SQL)

+ (void)load {
    SEL selector = @selector(stringFromDate:);
    [RSSwizzle
     swizzleInstanceMethod:selector
     inClass:[self class]
     newImpFactory:^id(RSSwizzleInfo *swizzleInfo) {
         return ^id(__unsafe_unretained id Aself, id value){
             if ([value isKindOfClass:[NSNumber class]]) {
                 NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[(NSNumber *)value integerValue]];
                 value = date;
             }
             id (*originalIMP)(__unsafe_unretained id, SEL, id);
             originalIMP = (__typeof(originalIMP))[swizzleInfo getOriginalImplementation];
             id res = originalIMP(Aself,selector, value);
             return res;
         };
     }
     mode:RSSwizzleModeAlways
     key:NULL];
}

@end
