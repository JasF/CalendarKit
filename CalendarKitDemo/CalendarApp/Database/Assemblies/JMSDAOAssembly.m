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
/*

- (JMSUserDAO *)userDAO {
    static JMSUserDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSUserDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

- (JMSRynServerMessageDAO *)rynServerMessageDAO {
    static JMSRynServerMessageDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSRynServerMessageDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

- (JMSTipDAO *)tipDAO {
    static JMSTipDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSTipDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

- (JMSPrivacyDAO *)privacyDAO {
    static JMSPrivacyDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSPrivacyDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

- (JMSCategoryDAO *)categoryDAO {
    static JMSCategoryDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSCategoryDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

- (JMSContactsGroupDAO *)contactsGroupDAO {
    static JMSContactsGroupDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSContactsGroupDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

- (JMSPlaceDAO *)placeDAO {
    static JMSPlaceDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSPlaceDAO alloc] init:[self databaseFactory]];
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

- (JMSChatMessageDAO *)chatMessageDAO {
    static JMSChatMessageDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSChatMessageDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

- (JMSChatDAO *)chatDAO {
    static JMSChatDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSChatDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

- (JMSEventDAO *)eventDAO {
    static JMSEventDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSEventDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

- (JMSCalendarDAO *)calendarDAO {
    static JMSCalendarDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSCalendarDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

- (JMSSpecializationsDAO *)specializationsDAO {
    static JMSSpecializationsDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSSpecializationsDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

- (JMSCountryDAO *)countryDAO {
    static JMSCountryDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSCountryDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

- (JMSMetroDAO *)metroDAO {
    static JMSMetroDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSMetroDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

- (JMSContactDAO *)contactDAO {
    static JMSContactDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSContactDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

- (JMSPhotoDAO *)photoDAO {
    static JMSPhotoDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSPhotoDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

- (JMSEventMetroDAO *)eventMetroDAO {
    static JMSEventMetroDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSEventMetroDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

- (JMSFoundUserDAO *)foundUserDAO {
    static JMSFoundUserDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSFoundUserDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

- (JMSRecommendationDAO *)recommendationDAO {
    static JMSRecommendationDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSRecommendationDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

- (JMSSuggestPlaceDAO *)suggestPlaceDAO {
    static JMSSuggestPlaceDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSSuggestPlaceDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

- (JMSUserContactDAO *)userContactDAO {
    static JMSUserContactDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSUserContactDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

- (JMSSmsDAO *)smsDAO {
    static JMSSmsDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSSmsDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

- (JMSExpenseDAO *)expenseDAO {
    static JMSExpenseDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSExpenseDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

- (JMSDayDAO *)dayDAO {
    static JMSDayDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSDayDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

#ifdef SALON
- (JMSSalonOwnerUserDAO *)salonOwnerUserDAO {
    static JMSSalonOwnerUserDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSSalonOwnerUserDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}
#endif

- (JMSStatisticsDAO *)statisticsDAO {
    static JMSStatisticsDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSStatisticsDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

- (JMSGoodsCategoryDAO *)goodsCategoryDAO {
    static JMSGoodsCategoryDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSGoodsCategoryDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

- (JMSProductDAO *)productDAO {
    static JMSProductDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSProductDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

- (JMSWaitingListDAO *)waitingListDAO {
    static JMSWaitingListDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSWaitingListDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

- (JMSLogDAO *)logDAO {
    static JMSLogDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSLogDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

- (JMSResourceDAO *)resourceDAO {
    static JMSResourceDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSResourceDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

- (JMSSNDBLogDAO *)sndbLogDAO {
    static JMSSNDBLogDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSSNDBLogDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

- (JMSExpenseCategoryDAO *)expenseCategoryDAO {
    static JMSExpenseCategoryDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSExpenseCategoryDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}

- (JMSExpenseProviderDAO *)expenseProviderDAO {
    static JMSExpenseProviderDAO *shared = nil;
    if (shared == nil) {
        shared = [[JMSExpenseProviderDAO alloc] init:[self databaseFactory]];
    }
    return shared;
}
 */

@end
