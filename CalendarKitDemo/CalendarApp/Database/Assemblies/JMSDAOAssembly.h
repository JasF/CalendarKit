//
//  JMSDAOAssembly.h
//  Masters
//
//  Created by Jasf on 16.05.2018.
//  Copyright © 2018 Jam Soft. All rights reserved.
//

@import CoreFoundation;
@class JMSUserDAO;
@class JMSOwnerUserDAO;
@class JMSRynServerMessageDAO;
@class JMSTipDAO;
@class JMSPrivacyDAO;
@class JMSCategoryDAO;
@class JMSContactsGroupDAO;
@class JMSPlaceDAO;
@class JMSServiceDAO;
@class JMSChatMessageDAO;
@class JMSChatDAO;
@class JMSEventDAO;
@class JMSCalendarDAO;
@class JMSDAOFactory;
@class JMSSpecializationsDAO;
@class JMSCountryDAO;
@class JMSMetroDAO;
@class JMSContactDAO;
@class JMSPhotoDAO;
@class JMSEventMetroDAO;
@class JMSFoundUserDAO;
@class JMSRecommendationDAO;
@class JMSSuggestPlaceDAO;
@class JMSUserContactDAO;
@class JMSSmsDAO;
@class JMSExpenseDAO;
@class JMSDayDAO;
@class JMSDatabase;
#ifdef SALON
@class JMSSalonOwnerUserDAO;
#endif
@class JMSStatistics;
@class JMSResourceDAO;
@class JMSSNDBLogDAO;
@class JMSExpenseCategoryDAO;
@class JMSExpenseProviderDAO;
@class JMSColorDAO;
@class JMSTransportDAO;
@class JMSServiceDAO;
@class JMSClientDAO;

@interface JMSDAOAssembly : NSObject
+ (instancetype)shared;
- (JMSDAOFactory *)daoFactory;
- (JMSDatabase *)databaseFactory;
- (JMSOwnerUserDAO *)ownerUserDAO;
- (JMSColorDAO *)colorDAO;
- (JMSTransportDAO *)transportDAO;
- (JMSServiceDAO *)serviceDAO;
- (JMSClientDAO *)clientDAO;
/*
- (JMSUserDAO *)userDAO;
- (JMSRynServerMessageDAO *)rynServerMessageDAO;
- (JMSTipDAO *)tipDAO;
- (JMSPrivacyDAO *)privacyDAO;
- (JMSCategoryDAO *)categoryDAO;
- (JMSContactsGroupDAO *)contactsGroupDAO;
- (JMSPlaceDAO *)placeDAO;
- (JMSServiceDAO *)serviceDAO;
- (JMSChatMessageDAO *)chatMessageDAO;
- (JMSChatDAO *)chatDAO;
- (JMSEventDAO *)eventDAO;
- (JMSCalendarDAO *)calendarDAO;
- (JMSSpecializationsDAO *)specializationsDAO;
- (JMSCountryDAO *)countryDAO;
- (JMSMetroDAO *)metroDAO;
- (JMSContactDAO *)contactDAO;
- (JMSPhotoDAO *)photoDAO;
- (JMSEventMetroDAO *)eventMetroDAO;
- (JMSFoundUserDAO *)foundUserDAO;
- (JMSRecommendationDAO *)recommendationDAO;
- (JMSSuggestPlaceDAO *)suggestPlaceDAO;
- (JMSUserContactDAO *)userContactDAO;
- (JMSSmsDAO *)smsDAO;
- (JMSExpenseDAO *)expenseDAO;
- (JMSDayDAO *)dayDAO;
#ifdef SALON
- (JMSSalonOwnerUserDAO *)salonOwnerUserDAO;
#endif
- (JMSStatistics *)statisticsDAO;
- (JMSSNDBLogDAO *)sndbLogDAO;
- (JMSExpenseCategoryDAO *)expenseCategoryDAO;
- (JMSExpenseProviderDAO *)expenseProviderDAO;
 */
@end
