//
//  JMSFetchRequest.m
//  Masters
//
//  Created by Jasf on 16.05.2018.
//  Copyright © 2018 Jam Soft. All rights reserved.
//

#import "JMSFetchRequest.h"
#import "CalendarApp-Swift.h"

@implementation JMSFetchRequest

+ (instancetype)fetchRequestWithEntityName:(NSString*)entityName {
    JMSFetchRequest *request = [[JMSFetchRequest alloc] initWithEntityName:entityName];
    return request;
}
- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (instancetype)initWithEntityName:(NSString*)entityName {
    if (self = [self init]) {
        self.entityName = entityName;
    }
    return self;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    JMSAssert(false);
    return nil;
}

- (NSString *)entityName {
    if (_entityName.length) {
        return _entityName;
    }
    if ([_entity isKindOfClass:[JMSEntityDescription class]]) {
        JMSEntityDescription *desc = (JMSEntityDescription *)_entity;
        return desc.name;
    }
    else if ([_entity isKindOfClass:[NSEntityDescription class]]) {
        NSEntityDescription *desc = (NSEntityDescription *)_entity;
        return desc.name;
    }
    JMSAssert(false);
    return nil;
}
@end
