//
//  JMSDAOAssembly.m
//  Masters
//
//  Created by Jasf on 16.05.2018.
//  Copyright © 2018 Jam Soft. All rights reserved.
//

#import "JMSDAOAssembly.h"
#import "CalendarApp-Swift.h"
//#import "JMSSNDBLog.h"

@import FMDB;

@implementation JMSDAOAssembly

+ (instancetype)shared {
    static JMSDAOAssembly *shared = nil;
    if (shared == nil) {
        shared = [JMSDAOAssembly new];
    }
    return shared;
}

- (JMSDAOFactory *)daoFactory {
    static JMSDAOFactory *shared = nil;
    if (shared == nil) {
        shared = [[JMSDAOFactory alloc] init:self];
    }
    return shared;
}

- (JMSOwnerUserDAO *)ownerUserDAO {
    static JMSOwnerUserDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSOwnerUserDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}


- (JMSDatabase *)databaseFactory {
    static JMSDatabase *shared = nil;
    if (shared == nil) {
        shared = [JMSDatabase new];
    }
    return shared;
}

- (JMSColorDAO *)colorDAO {
    static JMSColorDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSColorDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}
- (JMSTransportDAO *)transportDAO {
    static JMSTransportDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSTransportDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}
- (JMSServiceDAO *)serviceDAO {
    static JMSServiceDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSServiceDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}
- (JMSClientDAO *)clientDAO {
    static JMSClientDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSClientDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

@end
