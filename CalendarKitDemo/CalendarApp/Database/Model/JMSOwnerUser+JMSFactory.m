//
//  JMSOwnerUser+JMSFactory.m
//  Masters
//
//  Created by Roman Dvoinev on 05/08/14.
//  Copyright (c) 2014 Jam Soft. All rights reserved.
//

#import "JMSOwnerUser+JMSFactory.h"

@implementation JMSOwnerUser (JMSFactory)

#ifdef SALON
#define OWNERUSERCLASS JMSSalonOwnerUser
#else
#define OWNERUSERCLASS JMSOwnerUser
#endif

static OWNERUSERCLASS *ownerUserSharedInstance = nil;

+ (void)deleteOwnerUser {
    ownerUserSharedInstance = nil;
}

+ (OWNERUSERCLASS *)cachedOwnerUser {
    return ownerUserSharedInstance;
}

+ (OWNERUSERCLASS *)getUserFromArray:(NSArray *)array {
    for (OWNERUSERCLASS *user in array) {
        if (user.cid.length > 0) {
            return user;
        }
    }
    return array.firstObject;
}

+ (OWNERUSERCLASS *)ownerUserInContext:(JMSManagedObjectContext *)context
{
    if (ownerUserSharedInstance.cached) {
        return ownerUserSharedInstance;
    }
    NSArray *array = [OWNERUSERCLASS MR_findAllInContext:context];
    ownerUserSharedInstance = [self getUserFromArray:array];
    if (!ownerUserSharedInstance) {
        ownerUserSharedInstance = [OWNERUSERCLASS MR_createEntityInContext:context];
    }
    //jms_setLocale(ownerUserSharedInstance.app_lang);
    return ownerUserSharedInstance;
}

+ (JMSOwnerUser *)owner {
    return [self ownerUserInContext:[DSCoreData sharedInstance].readContext];
}

@end
