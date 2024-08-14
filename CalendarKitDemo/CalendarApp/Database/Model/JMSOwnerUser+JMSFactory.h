//
//  JMSOwnerUser+JMSFactory.h
//  Masters
//
//  Created by Roman Dvoinev on 05/08/14.
//  Copyright (c) 2014 Jam Soft. All rights reserved.
//

#import "JMSOwnerUser.h"

@interface JMSOwnerUser (JMSFactory)

+ (JMSOwnerUser *)owner;
+ (JMSOwnerUser *)ownerUserInContext:(JMSManagedObjectContext *)context;
+ (JMSOwnerUser *)cachedOwnerUser;
+ (void)deleteOwnerUser;

@end
