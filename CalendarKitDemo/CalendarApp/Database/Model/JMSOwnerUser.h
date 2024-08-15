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
// в отличии от JMSPlace, взятое из PublicProfile.

/**
 * NSArray of NSNumber
 */
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
- (BOOL)isTarifVip;
- (BOOL)isTarifPremium;
- (BOOL)isTarifTest;
- (BOOL)isTarifFree;
- (BOOL)isWithoutTarif;
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
- (NSString *)settingOnlineUrl;
- (NSNumber *)is_dashboard;
- (NSString *)app_lang;
- (NSString *)region_lang;
- (BOOL)detach_chat_support;
- (NSString *)landing_url;
- (BOOL)hide_sel_app;

- (BOOL)withAMPM;
- (NSString *)date_style1;
- (NSString *)date_style2;
- (NSString *)date_style3;
- (NSString *)date_style4;
- (NSString *)date_style_time;
- (NSString *)date_style6;
- (NSString *)date_style7;
- (NSString *)date_style8;
- (NSString *)date_style9;
- (NSString *)date_style10;
- (NSString *)date_style11;
- (NSString *)date_style12;
- (NSString *)date_style13;
- (NSString *)date_style14;
- (NSString *)date_style15;
- (NSString *)date_style16;
- (NSString *)date_style17;
- (NSString *)date_style18;
- (NSString *)date_style19;
- (NSString *)date_style20;
- (NSString *)date_style21;
- (NSString *)date_style22;
- (NSString *)date_style23;
- (NSString *)date_style24;
- (NSString *)date_style25;
- (NSString *)date_style26;
- (NSString *)date_style27;
- (NSString *)date_style28;
- (NSString *)date_style29;
- (NSString *)date_style30;
- (NSString *)date_style31;
- (NSString *)date_style32;
- (NSString *)date_style33;
- (NSString *)date_style34;
- (NSString *)date_style35;
- (NSString *)sms_date;
- (NSString *)sms_time;

- (NSString *)cliDate_style_time;
- (NSString *)cliDate_style1;
- (NSString *)cliDate_style2;
- (NSString *)cliDate_style4;
- (NSString *)cliDate_style6;
- (NSString *)cliDate_style12;

- (BOOL)canWriteToMinisalon:(NSString *)salonId;
- (BOOL)canChangeScheduleToMinisalon:(NSString *)salonId;
- (BOOL)canWriteNoticesToMinisalon:(NSString *)salonId;
- (BOOL)canWritePhotosToMinisalon:(NSString *)salonId;
#if LOGGING_NETWORK == 1
+ (void)enableNetworkLoggingIfNeeded;
#endif
- (JMSInvitedMaster *)masterByID:(NSString *)masterID;
- (void)showWaitingListViewController:(UINavigationController *)parentViewController;
- (BOOL)isEnglish;
- (BOOL)isRussian;
- (BOOL)isHispany;
- (BOOL)isPortuguese;
- (NSString *)langNameForKey:(NSString *)key;
- (JMSCountry *)country;
- (void)makeCountryNil;
+ (BOOL)withMovingFirstWeekday;
+ (BOOL)firstWeekdaySunday;
+ (BOOL)firstWeekdayMonday;
+ (BOOL)firstWeekdaySaturday;
- (UIColor *)dashboardTopColor;
- (UIColor *)dashboardBottomColor;
- (NSString *)db_bg_color;
- (NSNumber *)db_instagram;
- (BOOL)master_for_minisalon;
- (BOOL)is_invited;
- (NSString *)billing_url;
- (NSInteger)getSettingsWidgetUpdateInterval;
- (BOOL)enable_stats;
- (NSInteger)eventCreateRefreshPeriod;
- (NSString *)sms_template_place;
- (BOOL)dbColorsChangedAlpha;
- (BOOL)dis_push_evening;
- (BOOL)dis_push_morning;
- (BOOL)has_link_in_alarm_sms_template;
- (BOOL)dis_confirm_events;
- (BOOL)dis_manual_confirm_events;
- (BOOL)dis_red_badges_confirm;
- (BOOL)timeline;
- (BOOL)calendar_week;
- (BOOL)is_log;
- (BOOL)dis_price_event_link;
- (BOOL)dis_cancel_event_link;
- (NSNumber *)ny_enabled;
- (NSString *)ny_theme;
- (NSDictionary *)settings_salons;
- (NSDictionary *)dashboard_widgets;
- (NSDictionary *)waitinglist_times;
- (NSDictionary *)deposit;
- (BOOL)deposit_enabled;
- (BOOL)deposit_show_on_web;
- (NSString *)deposit_banner_text;
- (double)deposit_sum;
- (NSInteger)deposit_period; // in seconds
- (NSInteger)deposit_alarm; // in seconds
- (NSString *)deposit_for;
- (NSDictionary *)deposit_methods;
- (NSString *)deposit_phone;
- (NSString *)deposit_card;
- (NSString *)deposit_cashapp;
- (NSString *)deposit_paypal;
- (NSString *)deposit_venmo;
- (NSString *)deposit_zelle;
- (NSString *)def_web_banner;
- (NSInteger)oc_cancel_period;
- (BOOL)oc_is_cancel;
- (BOOL)oc_is_move;
- (BOOL)oc_is_view_price;
- (NSInteger)oc_move_period;
- (BOOL)online_client_to_book;
- (NSString *)social_share_text;
- (BOOL)personal_data;
- (BOOL)check_personal_data;
- (BOOL)external_sms;
- (NSInteger)stats_version;
- (NSString *)privacy_policy;
- (NSString *)offer;
- (NSString *)terms;
- (NSString *)personal_data_distribution;
- (NSString *)personal_data_processing;
- (NSString *)user_agreement;
- (BOOL)is_auth_qr;
- (NSDictionary *)interface_settings;
- (BOOL)is_moder;
- (NSString *)captcha_url;
- (BOOL)is_mindbox;
- (NSArray *)tasks;
- (BOOL)is_screen_check_phone;
- (BOOL)yaBookingEnabled;
- (BOOL)yaBookingExistsForUser;
- (NSString *)yaBookingName;
- (NSString *)yaBookingPlace;
- (NSString *)yaBookingAddress;
- (NSString *)yaBookingLink;
- (BOOL)eventStyleLine;
- (BOOL)eventStyleFill;
- (NSString *)onboarding_promo_url;
@end

@interface JMSOwnerUser (CoreDataGeneratedAccessors)

- (void)insertObject:(JMSPlace *)value inSalonsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSalonsAtIndex:(NSUInteger)idx;
- (void)insertSalons:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSalonsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSalonsAtIndex:(NSUInteger)idx withObject:(JMSPlace *)value;
- (void)replaceSalonsAtIndexes:(NSIndexSet *)indexes withSalons:(NSArray *)values;
- (void)addSalonsObject:(JMSPlace *)value;
- (void)removeSalonsObject:(JMSPlace *)value;
- (void)addSalons:(NSOrderedSet *)values;
- (void)removeSalons:(NSOrderedSet *)values;
@end
