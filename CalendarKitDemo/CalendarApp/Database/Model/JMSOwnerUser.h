//
//  JMSOwnerUser.h
//  Masters
//
//  Created by Alexander Timonenkov on 01.12.14.
//  Copyright (c) 2014 Jam Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "JMSAbstractUser.h"

@class JMSPlace, JMSPrivacy, JMSInvitedMaster, JMSCountry;
@import EasyMapping;


@interface NSString (B)
- (NSArray *)colorsTupleFromHTMLString;
@end
/**
 * @param statsResult NSDictionary. Format: {
 *   examples NSArray for block 'Что ищем сегодня' in clientside home controller.
 *   count_masters NSNumber
 *   popular_queries NSArray
 * }
 */
@interface JMSOwnerUser : JMSAbstractUser <EKMappingProtocol>
+ (BOOL)firstnameOnFront;
@property (nonatomic, retain) NSString * authLogin;
@property (nonatomic, retain) NSDate * birth;
@property (nonatomic, retain) NSArray *certificates;
@property (nonatomic, retain) NSString * cid;
@property (nonatomic, retain) NSArray *courses;
@property (nonatomic, retain) NSArray *education;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * node;
@property (nonatomic, retain) NSString * pushToken;
@property (nonatomic, retain) NSArray *realSpecializations;
@property (nonatomic, retain) NSNumber * salonsEnable;
@property (nonatomic, retain) NSArray *specializations;
@property (nonatomic, retain) NSArray *categories;
@property (nonatomic, retain) NSArray *salons;
@property (nonatomic, retain) NSString *cityTz;
@property (nonatomic, retain) NSString *calendar_url;
@property (nonatomic, retain) NSString *stats_url;
@property (nonatomic, retain) NSString *stats_url_orig;
@property (nonatomic, retain) NSString * payUrl;
@property (nonatomic, retain) NSString * account_url;
@property (nonatomic, retain) NSString *faq_url;
@property (nonatomic, retain) NSDictionary * statsResult;
@property (nonatomic, retain) NSNumber * emailConfirmed;
@property (nonatomic, retain) NSArray *subscribe;
@property (nonatomic, retain) NSDictionary *settings;
@property (nonatomic, retain) NSDictionary *urls;
@property (nonatomic, retain) NSDictionary * notices;
@property (nonatomic, retain) NSString * notPhoneUrl;
@property (nonatomic, retain) NSString * time_url;
@property (nonatomic, retain) NSString * nameOrder;
@property (nonatomic, retain) NSDictionary * placesDays; // рабочее время по дням, взятое из PrivateProfile
@property (nonatomic) NSString *ext_phone;
@property (nonatomic) NSNumber *client_to_book;
@property (nonatomic) NSNumber *client_to_sleep2;
@property (nonatomic) NSNumber *clients_all;
@property (nonatomic) NSNumber *clients_new_cur;
@property (nonatomic) NSNumber *clients_new_prev;
@property (nonatomic) NSNumber *clients_sleep_cur;
@property (nonatomic) NSNumber *clients_sleep_prev;
@property (nonatomic) NSArray *senders;
@property (nonatomic) NSArray *albums;
@property (nonatomic) NSString *url_recommendation;
@property (nonatomic) NSString *color_rec; // settings_colors_recommendation
@property (nonatomic) NSNumber *is_waitinglist;
@property (nonatomic) NSNumber *interval_waitinglist;
#ifdef SALON
#else
@property (nonatomic, strong) NSArray *disconts;
#endif
@property (nonatomic, retain) NSArray * eventAlarms;

// Location
@property (nonatomic, retain) NSString * countryID;
@property (nonatomic, retain) NSString * filterCityID;

// Places
@property (nonatomic, retain) NSString * clientAddress;
@property (nonatomic, retain) NSNumber * clientEnable;
@property (nonatomic, retain) NSString * homeAddress;
@property (nonatomic, retain) NSString * homeComment;
@property (nonatomic, retain) NSNumber * homeEnable;
@property (nonatomic, retain) NSNumber * homeVisible;
@property (nonatomic, retain) NSNumber * homeCommentVisible;

// Tips
@property (nonatomic, retain) NSArray * viewedTips;

// Orders
@property (nonatomic, retain) NSDictionary * ordersStats;
@property (nonatomic, retain) NSString * tariffName;
@property (nonatomic, retain) NSString * tariffLimit;

@property (nonatomic, strong) NSDictionary * tariffInfo;
@property (nonatomic, strong) NSString * onlineUrl;
@property (nonatomic, strong) NSString * payCreditUrl;
@property (nonatomic, strong) NSString * payHistoryUrl;
@property (nonatomic, strong) NSNumber * en_waitinglist;
@property (nonatomic, strong) NSNumber * tariffEmpty;
@property (nonatomic, strong) NSString * share_color;
@property (nonatomic, strong) NSNumber * share_month;
@property (nonatomic, strong) NSString * share_days;
@property (nonatomic, strong) NSDictionary *parameters;

@property (nonatomic, strong) NSNumber *first_counter;
@property (nonatomic, strong) NSNumber *second_counter;
@property (nonatomic, strong) NSNumber *third_counter;
@property (nonatomic, strong) NSNumber *fourth_counter;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *surname;

@end
