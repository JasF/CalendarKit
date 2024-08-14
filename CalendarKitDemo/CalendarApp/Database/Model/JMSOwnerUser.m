//
//  JMSOwnerUser.m
//  Masters
//
//  Created by Alexander Timonenkov on 01.12.14.
//  Copyright (c) 2014 Jam Soft. All rights reserved.
//

#import "JMSOwnerUser.h"
//#import "JMSPlace.h"
//#import "JMSPrivacy.h"
#import "DSCoreData.h"
//#import "JMSCategory.h"
#import "CalendarApp-Swift.h"
#import "NSDate+JMSHelper.h"
//#import "JMSUIHelper.h"

static NSInteger const kEventCreateRefreshPeriodDefault = 60;

@implementation JMSOwnerUser {
    JMSCountry *_country;
}

+ (void)load {
#ifdef SALON
    [self replaceSetters];
#endif
}

+(EKObjectMapping *)objectMapping
{
    EKObjectMapping *mapping = [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"authLogin", @"birth", @"certificates", @"cid", @"courses", @"education", @"latitude", @"longitude", @"node", @"pushToken", @"salonsEnable", @"cityTz", @"calendar_url", @"stats_url", @"payUrl", @"account_url", @"faq_url", @"emailConfirmed", @"notices", @"notPhoneUrl", @"time_url", @"nameOrder", @"placesDays", @"countryID", @"filterCityID", @"clientAddress", @"clientEnable", @"homeAddress", @"homeComment", @"homeEnable", @"homeVisible", @"homeCommentVisible", @"tariffName", @"tariffLimit", @"onlineUrl", @"payCreditUrl", @"payHistoryUrl" ,@"settings", @"ordersStats", @"tariffInfo", @"viewedTips", @"eventAlarms", @"statsResult", @"subscribe", @"urls", @"realSpecializations", @"specializations"
#ifdef SALON
#else
            ,@"disconts"
#endif
            , @"ext_phone", @"client_to_book", @"client_to_sleep2"
            ,@"clients_all", @"clients_new_cur", @"clients_new_prev", @"clients_sleep_cur", @"clients_sleep_prev", @"senders", @"albums", @"url_recommendation", @"color_rec", @"is_waitinglist", @"interval_waitinglist", @"en_waitinglist", @"tariffEmpty", @"share_color", @"share_month", @"share_days", @"parameters", @"first_counter"
        ]];
        
        /*
        [mapping mapKeyPath:@"visible" toProperty:@"visible" withValueBlock:^id _Nullable(NSString * _Nonnull key, id  _Nullable value) {
            JMSPrivacy *privacy = [EKMapper objectFromExternalRepresentation:value withMapping:[JMSPrivacy objectMapping]];
            return privacy;
        }
               reverseBlock:^id _Nullable(id  _Nullable value) {
                   NSDictionary *dict = [EKSerializer serializeObject:value withMapping:[JMSPrivacy objectMapping]];
                   return dict;
               }];
        
        
        [mapping mapKeyPath:@"categories" toProperty:@"categories" withValueBlock:^id _Nullable(NSString * _Nonnull key, id  _Nullable value) {
            NSArray *array = [EKMapper arrayOfObjectsFromExternalRepresentation:value withMapping:[JMSCategory objectMapping]];
            return array;
        }
               reverseBlock:^id _Nullable(id  _Nullable value) {
                   if (value && ![value isKindOfClass:[NSArray class]]) {
                       JMSAssert(false);
                       return @[];
                   }
                   NSArray *result = [EKSerializer serializeCollection:value withMapping:[JMSCategory objectMapping]];
                   return result;
               }];
         */
    }];
    
    [mapping mapPropertiesFromMappingObject:[super objectMapping]];
    return mapping;
}

- (NSArray *)salons {
    NSArray *salons = @[];//[JMSPlace MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"user.userID == %@ AND type == \"private\"", self.userID] inContext:[DSCoreData sharedInstance].readContext];
    return salons;
}

- (void)setUserID:(NSString *)userID {
    [super setUserID:userID];
}

- (NSString *)userID {
    NSString *userID = [super userID];
    return userID;
}

- (void)setPlacesDays:(NSDictionary *)placesDays {
    _placesDays = placesDays;
}

- (void)setSettings:(NSDictionary *)settings {
    _settings = settings;
}

+ (NSString *)formattedPrice:(NSInteger)price {
    return [self stringWithPrice:price];
}

+ (NSString *)formattedPriceObj:(NSNumber *)price {
    return [self formattedPrice:price.integerValue];
}

+ (NSString *)stringWithPrice:(NSInteger)price {
    NSMutableString *string = [[@(price) stringValue] mutableCopy];
    switch (string.length) {
        case 4:
            [string insertString:@" " atIndex:1];
            break;
        case 5:
            [string insertString:@" " atIndex:2];
            break;
        case 6:
            [string insertString:@" " atIndex:3];
            break;
        case 7:
            [string insertString:@" " atIndex:4];
            [string insertString:@" " atIndex:1];
            break;
        case 8:
            [string insertString:@" " atIndex:5];
            [string insertString:@" " atIndex:2];
            break;
        case 9:
            [string insertString:@" " atIndex:6];
            [string insertString:@" " atIndex:3];
            break;
    }
    
    return string;
}

+ (NSString *)formattedPriceWithCurrency:(NSNumber *)price country:(JMSCountry *)country {
    return [self formattedPriceWithCurrency:price
                             country:country
                        forceDecimal:NO];
}

+ (NSString *)formattedPriceWithCurrency:(NSNumber *)price
                                 country:(JMSCountry *)country
                            forceDecimal:(BOOL)forceDecimal {
    /*
    if (country == nil) {
        country = [JMSOwnerUser owner].country;
    }
    NSNumberFormatter *formatter = [self priceNumberFormatter:country];
    if (!formatter || !country) {
        return [self formattedPriceObj:price];
    }
    if (!forceDecimal && country.currency_only_int.boolValue) {
        price = @(round(price.doubleValue));
    }
    BOOL handMadeFormatter = NO;
    if (country.currencyView.length) {
        handMadeFormatter = YES;
        formatter.currencySymbol = @"";
    }
    NSString *cds = formatter.currencyDecimalSeparator;
    NSString *text = [formatter stringFromNumber:price];
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
   
    if (!forceDecimal && country.currency_only_int.boolValue) {
        text = [text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@00", cds] withString:@""];
    }
    NSString *space = @" ";
    if (!country.currency_symbol_space.boolValue) {
        space = @"";
    }
    NSString *currencySymbol = country.currency_symbol;
    if (currencySymbol.length == 0) {
        currencySymbol = country.currencyViewModified;
    }
    if (country.currency_symbol_first.boolValue) {
        text = [NSString stringWithFormat:@"%@%@%@", currencySymbol, space, text];
    }
    else {
        text = [NSString stringWithFormat:@"%@%@%@", text, space, currencySymbol];
    }
    return text;
     */
    return @"";
}

+ (NSString *)formattedPriceWithCurrency:(NSNumber *)price {
    return [self formattedPriceWithCurrency:price forceDecimal:NO];
}

+ (NSString *)formattedPriceWithCurrency:(NSNumber *)price
                            forceDecimal:(BOOL)forceDecimal {
    JMSCountry *country = [JMSOwnerUser owner].country;
    return [self formattedPriceWithCurrency:price
                                    country:country
                               forceDecimal:forceDecimal];
}

+ (NSString *)formattedPriceWithCurrencyD:(double)price country:(JMSCountry *)country {
    return [self formattedPriceWithCurrency:@(price)
                                    country:country
                               forceDecimal:NO];
}

+ (NSString *)formattedPriceWithCurrencyD:(double)price {
    return [self formattedPriceWithCurrencyD:price forceDecimal:NO];
}

+ (NSString *)formattedPriceWithCurrencyD:(double)price
                             forceDecimal:(BOOL)forceDecimal {
    return [self formattedPriceWithCurrency:@(price)
                               forceDecimal:forceDecimal];
}

+ (NSNumberFormatter *)priceNumberFormatter {
    JMSCountry *country = [JMSOwnerUser owner].country;
    if (!country) {
        return nil;
    }
    return [self priceNumberFormatter:country];
}

+ (NSNumberFormatter *)priceNumberFormatter:(JMSCountry *)country {
    /*
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    NSString *currency = country.currency;
    NSString *real_lang = country.real_lang_modified;
    if ([[currency lowercaseString] isEqualToString:@"mxn"] || [[currency lowercaseString] isEqualToString:@"ars"] || [[currency lowercaseString] isEqualToString:@"clp"] || [country.name isEqualToString:@"Puerto Rico"] || [country.name isEqualToString:@"Пуэрто-Рико"]) {
        currency = @"USD";
        real_lang = @"en";
    }
    formatter.locale = [NSLocale localeWithLocaleIdentifier:real_lang];
    formatter.currencyCode = currency;
    
    if (country.currencyView.length) {
        formatter.currencySymbol = country.currencyViewModified;
    }
     */
    return [NSNumberFormatter new];
}

- (BOOL)isTarifVip {
    return [self.tariffInfo[@"key"] isEqualToString:@"vip"];
}

- (BOOL)isTarifPremium {
    return [self.tariffInfo[@"key"] isEqualToString:@"pro"];
}

- (BOOL)isTarifTest {
    return [self.tariffInfo[@"key"] isEqualToString:@"trial"];
}

- (BOOL)isTarifFree {
    return [self.tariffInfo[@"key"] isEqualToString:@"free"];
}

- (BOOL)isWithoutTarif {
    return (![self isTarifPremium] && ![self isTarifTest] && ![self isTarifVip]);
}

- (NSDictionary *)tariffInfo {
    if (self.tariffEmpty.boolValue == YES) {
        return nil;
    }
    return _tariffInfo;
}

#if LOGGING_NETWORK == 1
+ (void)enableNetworkLoggingIfNeeded {
    /*
    NSString *loggingEnabled = [JMSOwnerUser cachedOwnerUser].settings[@"settings_logging_enabled"];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    NSInteger number = [[numberFormatter numberFromString:loggingEnabled] integerValue];
#if DEBUG == 1
    number = 1;
#endif
#if FEATURES == 1
    number = 1;
#endif
#if PRIVATE == 1
    number = 1;
#endif
     */
    NSInteger number = 1;
    if (number == 1) {
        //[[NetworkLogging shared] setLoggingEnabled:YES];
    }
    else {
       // [[NetworkLogging shared] setLoggingEnabled:NO];
    }
}
#endif
- (NSArray *)invitedMasters {
    return @[];
}

- (JMSInvitedMaster *)masterByID:(NSString *)masterID {
#ifdef SALON
    JMSUser *user = [JMSUser jms_findSingleWithPredicate:[NSPredicate predicateWithFormat:@"masterID == %@", masterID]];
    if (user == nil) {
        return nil;
    }
    JMSInvitedMaster *master = [JMSInvitedMaster new];
    master.user = user;
    return master;
#else
    return nil;
#endif
}

- (NSNumber *)client_to_sleep2 {
    if (_client_to_sleep2) {
        return _client_to_sleep2;
    }
    return @(0);
}

- (NSNumber *)clients_all {
    if (_clients_all) {
        return _clients_all;
    }
    return @(0);
}
- (NSNumber *)clients_new_cur {
    if (_clients_new_cur) {
        return _clients_new_cur;
    }
    return @(0);
}
- (NSNumber *)clients_new_prev {
    if (_clients_new_prev) {
        return _clients_new_prev;
    }
    return @(0);
}
- (NSNumber *)clients_sleep_cur {
    if (_clients_sleep_cur) {
        return _clients_sleep_cur;
    }
    return @(0);
}
- (NSNumber *)clients_sleep_prev {
    if (_clients_sleep_prev) {
        return _clients_sleep_prev;
    }
    return @(0);
}

- (NSNumber *)en_waitinglist {
    if (_en_waitinglist == nil) {
        return @(NO);
    }
    return _en_waitinglist;
}

- (void)showWaitingListViewController:(UINavigationController *)parentViewController {

}

- (BOOL)canWriteToMinisalon:(NSString *)salonId {
    NSDictionary *params = self.settings_salons[salonId];
    if ([params isKindOfClass:[NSDictionary class]]) {
        NSNumber *is_event_of_salon = params[@"is_event_of_salon"];
        if ([is_event_of_salon isKindOfClass:[NSNumber class]]) {
            return is_event_of_salon.boolValue;
        }
    }
    return NO;
}

- (BOOL)canChangeScheduleToMinisalon:(NSString *)salonId {
    NSDictionary *params = self.settings_salons[salonId];
    if ([params isKindOfClass:[NSDictionary class]]) {
        NSNumber *dis_schedule = params[@"dis_shedule"];
        if ([dis_schedule isKindOfClass:[NSNumber class]]) {
            return !dis_schedule.boolValue;
        }
    }
    return NO;
}

- (BOOL)canWriteNoticesToMinisalon:(NSString *)salonId {
    NSDictionary *params = self.settings_salons[salonId];
    if ([params isKindOfClass:[NSDictionary class]]) {
        NSNumber *dis_edit_notice_event = params[@"dis_edit_notice_event"];
        if ([dis_edit_notice_event isKindOfClass:[NSNumber class]]) {
            return !dis_edit_notice_event.boolValue;
        }
    }
    return NO;
}

- (BOOL)canWritePhotosToMinisalon:(NSString *)salonId {
    NSDictionary *params = self.settings_salons[salonId];
    if ([params isKindOfClass:[NSDictionary class]]) {
        NSNumber *dis_edit_photo_event = params[@"dis_edit_photo_event"];
        if ([dis_edit_photo_event isKindOfClass:[NSNumber class]]) {
            return !dis_edit_photo_event.boolValue;
        }
    }
    return NO;
}

- (NSDictionary *)settings_salons {
    id params = self.parameters[@"settings_salons"];
    if ([params isKindOfClass:[NSDictionary class]]) {
        return(NSDictionary *)params;
    }
    return @{};
}



- (NSString *)settingOnlineUrl {
    return self.parameters[@"settingOnlineUrl"];
}

- (NSNumber *)is_dashboard {
    return self.parameters[@"is_dashboard"];
}

- (NSString *)app_lang {
#if DEBUG == 1
    //return @"pt";
#endif
    NSString *app_lang = self.parameters[@"app_lang"];
    if (app_lang.length) {
        return app_lang;
    }
    return @"";
}

- (NSString *)region_lang {
    NSString *region_lang = self.parameters[@"region_lang"];
    if (region_lang.length) {
        return region_lang;
    }
    return @"";
}

- (BOOL)isEnglish {
    return [self.app_lang isEqualToString:@"en"];
}

- (BOOL)isRussian {
    return [self.app_lang isEqualToString:@"ru"];
}

- (BOOL)isHispany {
    return [self.app_lang isEqualToString:@"es"];
}

- (BOOL)isPortuguese {
    return [self.app_lang isEqualToString:@"pt"];
}

- (NSString *)langNameForKey:(NSString *)key {

    return @"";
}

- (JMSCountry *)country {
    if (!_country) {
        if (self.countryID.length > 0) {
   //         _country = [JMSCountry jms_findSingleWithPredicate:[NSPredicate predicateWithFormat:@"countryID = %@", self.countryID] inContext:[DSCoreData sharedInstance].readContext];
        }
    }
    return _country;
}

- (void)makeCountryNil {
    _country = nil;
}

- (BOOL)withAMPM {
    NSString *string = [JMSOwnerUser styledTimeForDate:[NSDate date]];
    return [string containsString:@" "];
}

/*
- (NSString *)date_style1 {
    NSString *result = self.country.format_date[@"mobstyle1"];
    return result;
}

- (NSString *)date_style2 {
    NSString *result = self.country.format_date[@"mobstyle2"];
    return result;
}

- (NSString *)date_style3 {
    NSString *result = self.country.format_date[@"mobstyle3"];
    return result;
}

- (NSString *)date_style4 {
    NSString *result = self.country.format_date[@"mobstyle4"];
    return result;
}

- (NSString *)date_style_time {
    NSString *result = self.country.format_date[@"mobstyle5"];
    return result;
}

- (NSString *)date_style6 {
    NSString *result = self.country.format_date[@"mobstyle6"];
    return result;
}

- (NSString *)date_style7 {
    NSString *result = self.country.format_date[@"mobstyle7"];
    return result;
}

- (NSString *)date_style8 {
    NSString *result = self.country.format_date[@"mobstyle8"];
    return result;
}

- (NSString *)date_style9 {
    NSString *result = self.country.format_date[@"mobstyle9"];
    return result;
}

- (NSString *)date_style10 {
    NSString *result = self.country.format_date[@"mobstyle10"];
    return result;
}

- (NSString *)date_style11 {
    NSString *result = self.country.format_date[@"mobstyle11"];
    return result;
}

- (NSString *)date_style12 {
    NSString *result = self.country.format_date[@"mobstyle12"];
    return result;
}

- (NSString *)date_style13 {
    NSString *result = self.country.format_date[@"mobstyle13"];
    return result;
}

- (NSString *)date_style14 {
    NSString *result = self.country.format_date[@"mobstyle14"];
    return result;
}

- (NSString *)date_style15 {
    NSString *result = self.country.format_date[@"mobstyle15"];
    return result;
}

- (NSString *)date_style16 {
    NSString *result = self.country.format_date[@"mobstyle16"];
    return result;
}

- (NSString *)date_style17 {
    NSString *result = self.country.format_date[@"mobstyle17"];
    return result;
}

- (NSString *)date_style18 {
    NSString *result = self.country.format_date[@"mobstyle18"];
    return result;
}

- (NSString *)date_style19 {
    NSString *result = self.country.format_date[@"mobstyle19"];
    return result;
}

- (NSString *)date_style20 {
    NSString *result = self.country.format_date[@"mobstyle20"];
    return result;
}

- (NSString *)date_style21 {
    NSString *result = self.country.format_date[@"mobstyle21"];
    return result;
}

- (NSString *)date_style22 {
    NSString *result = self.country.format_date[@"mobstyle22"];
    return result;
}

- (NSString *)date_style23 {
    NSString *result = self.country.format_date[@"mobstyle23"];
    return result;
}

- (NSString *)date_style24 {
    NSString *result = self.country.format_date[@"mobstyle24"];
    return result;
}

- (NSString *)date_style25 {
    NSString *result = self.country.format_date[@"mobstyle25"];
    return result;
}

- (NSString *)date_style26 {
    NSString *result = self.country.format_date[@"mobstyle26"];
    return result;
}

- (NSString *)date_style27 {
    NSString *result = self.country.format_date[@"mobstyle27"];
    return result;
}

- (NSString *)date_style28 {
    NSString *result = self.country.format_date[@"mobstyle28"];
    return result;
}

- (NSString *)date_style29 {
    NSString *result = self.country.format_date[@"mobstyle29"];
    return result;
}

- (NSString *)date_style30 {
    NSString *result = self.country.format_date[@"mobstyle30"];
    return result;
}

- (NSString *)date_style31 {
    NSString *result = self.country.format_date[@"mobstyle31"];
    return result;
}

- (NSString *)date_style32 {
    NSString *result = self.country.format_date[@"mobstyle32"];
    return result;
}

- (NSString *)date_style33 {
    NSString *result = self.country.format_date[@"mobstyle33"];
    return result;
}

- (NSString *)date_style34 {
    NSString *result = self.country.format_date[@"mobstyle34"];
    return result;
}

- (NSString *)date_style35 {
    NSString *result = self.country.format_date[@"mobstyle35"];
    return result;
}

- (NSString *)sms_date {
    NSString *result = self.country.format_date[@"sms_date"];
    return result;
}

- (NSString *)sms_time {
    NSString *result = self.country.format_date[@"sms_time"];
    return result;
}

- (NSString *)cliDate_style_time {
    return self.date_style_time;
}

- (NSString *)cliDate_style1 {
    return self.date_style1;
}

- (NSString *)cliDate_style2 {
    return self.date_style2;
}

- (NSString *)cliDate_style4 {
    return self.date_style4;
}

- (NSString *)cliDate_style6 {
    return self.date_style6;
}

- (NSString *)cliDate_style12 {
    return self.date_style12;
}


- (NSString *)formattedName {
    NSMutableArray *items = [NSMutableArray new];
    
    if (self.lastName.length > 0) {
        [items addObject:self.lastName];
    }
    if (self.firstName.length > 0) {
        [items addObject:self.firstName];
    }
    
    if ([JMSOwnerUser firstnameOnFront]) {
        items = [[[items reverseObjectEnumerator] allObjects] mutableCopy];
    }
    return [items componentsJoinedByString:@" "];
}*/

+ (BOOL)withMovingFirstWeekday {
    return YES;
}

+ (BOOL)firstWeekdaySunday {
    return ([NSDate currentCalendar].firstWeekday == 1);
}

+ (BOOL)firstWeekdaySaturday {
    NSInteger firstWeekday = [NSDate currentCalendar].firstWeekday;
    return firstWeekday == 7;
}

+ (BOOL)firstWeekdayMonday {
    return ([NSDate currentCalendar].firstWeekday == 2);
}

+ (NSString *)makeAmPmSmallIfNeeded:(NSString *)source {
    return source;//[source lowercaseString];
}

+ (NSString *)cliStyledTimeForDate:(NSDate *)date {
    return [self styledTimeForDate:date];
}

+ (NSString *)styledTimeForDate:(NSDate *)date {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    JMSOwnerUser *owner = [JMSOwnerUser owner];
    NSString *style = owner.date_style_time;
    BOOL freeStyle = NO;
    if ([style isEqualToString:@"short"]) {
        [formatter setTimeStyle:NSDateFormatterShortStyle];
    }
    else if ([style isEqualToString:@"medium"]) {
        [formatter setTimeStyle:NSDateFormatterMediumStyle];
    }
    else if ([style isEqualToString:@"long"]) {
        [formatter setTimeStyle:NSDateFormatterLongStyle];
    }
    else {
        freeStyle = YES;
        formatter.dateFormat = style;
    }
    NSString *result = [formatter stringFromDate:date];
    if (freeStyle && [style containsString:@"a"] && [[owner app_lang] isEqualToString:@"ru"]) {
        result = [self updateAmPmFromRus:result];
    }
    return result;
}

+ (NSString *)updateAmPmFromRus:(NSString *)string {
    string = [string stringByReplacingOccurrencesOfString:@"ДП" withString:@"AM"];
    string = [string stringByReplacingOccurrencesOfString:@"ПП" withString:@"PM"];
    return string;
}

+ (BOOL)firstnameOnFront {
    if ([[JMSOwnerUser owner].app_lang isEqualToString:@"en"]) {
        return YES;
    }
    return NO;
}

- (NSString *)db_bg_color {
    //return nil;
  
    return self.parameters[@"db_bg_color"];
}

- (NSNumber *)db_instagram {
    return self.parameters[@"db_instagram"];
}

- (UIColor *)dashboardTopColor {
    return nil;
}

- (UIColor *)dashboardBottomColor {
    return nil;
     
    /*
     let colorsString = savedColorsString()
     if colorsString.count == 0 {
         #if SALON
         cell.gradientLayer?.colors = [UIColor(hexRGB: 0xe6497b).cgColor, UIColor(hexRGB: 0xe27662).cgColor]
         #else
         cell.gradientLayer?.colors = [UIColor(hexRGB: 0xbf479d).cgColor, UIColor(hexRGB: 0xd84887).cgColor]
         #endif
     }
     else {
         let tuple = colorsString.colorsTupleFromHTMLString()
         cell.gradientLayer?.colors = [tuple.0.cgColor, tuple.1.cgColor]
     }stringValue    String    "#2e4969ff,#1c2f42ff"    
     */
}

- (BOOL)master_for_minisalon {
    return self.is_invited;
}

- (BOOL)is_invited {
    return [self.parameters[@"is_invited"] boolValue];
}

- (NSString *)billing_url {
    return self.parameters[@"billing_url"];
}

- (NSInteger)getSettingsWidgetUpdateInterval {
    NSString *resultString = self.settings[@"settings_widget_update_interval"];
    if ([resultString isKindOfClass:[NSString class]]) {
        return [resultString intValue];
    }
    return 1;
}

- (BOOL)enable_stats {
    NSNumber *enable_stats = self.parameters[@"enable_stats"];
    if ([enable_stats isKindOfClass:[NSNumber class]]) {
        return enable_stats.boolValue;
    }
    return NO;
}

- (NSInteger)eventCreateRefreshPeriod {
    NSDictionary *dictionary = self.settings[@"settings_salon_create_event_refresh_period"];
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        NSString *value = dictionary[@"refresh_period"];
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
            return [value intValue];
        }
    }
    return kEventCreateRefreshPeriodDefault;
}

- (NSString *)sms_template_place {
    NSString *result = @"";//self.country.sms_template_place;
    return result;
}

- (BOOL)detach_chat_support {
    NSNumber *detach_chat_support = self.parameters[@"detach_chat_support"];
    if ([detach_chat_support isKindOfClass:[NSNumber class]]) {
        return detach_chat_support.boolValue;
    }
    return NO;
}

- (BOOL)dbColorsChangedAlpha {
    if ([self.db_bg_color containsString:@"ff8e93"] ||
        [self.db_bg_color containsString:@"e8a7a7"]) {
        return YES;
    }
    return NO;
}

- (NSString *)landing_url {
    NSString *landing_url = self.parameters[@"landing_url"];
    if ([landing_url isKindOfClass:[NSString class]]) {
        return landing_url;
    }
    return nil;
}

- (BOOL)hide_sel_app {
    NSNumber *hide_sel_app = self.parameters[@"hide_sel_app"];
    if ([hide_sel_app isKindOfClass:[NSNumber class]]) {
        return hide_sel_app.boolValue;
    }
    return NO;
}
- (BOOL)dis_push_evening {
    NSString *dis_push_evening = self.parameters[@"dis_push_evening"];
    if ([dis_push_evening isKindOfClass:[NSNumber class]]) {
        return dis_push_evening.boolValue;
    }
    return NO;
}

- (BOOL)dis_push_morning {
    NSString *dis_push_morning = self.parameters[@"dis_push_morning"];
    if ([dis_push_morning isKindOfClass:[NSNumber class]]) {
        return dis_push_morning.boolValue;
    }
    return NO;
}

- (NSArray *) smsKidsArray {
    if ([[self.settings objectForKey:@"settings_sms"] isKindOfClass:[NSArray class]]) {
        return [self.settings objectForKey:@"settings_sms"];
    }
    return @[];
}

- (NSArray *) smsTemplatesArray {
    if ([[self.notices objectForKey:@"templates"] isKindOfClass:[NSArray class]]) {
        return [self.notices objectForKey:@"templates"];
    }
    return @[];
}

- (BOOL)has_link_in_alarm_sms_template {
    NSMutableDictionary * templateInfo = nil;
    for (NSDictionary * _templateInfo in self.smsKidsArray) {
        if ([[_templateInfo objectForKey:@"key"] isEqualToString:@"alarm"]) {
            templateInfo = [NSMutableDictionary dictionaryWithDictionary:_templateInfo];
            break;
        }
    }
    for (NSDictionary * _templateInfo in self.smsTemplatesArray) {
        if ([[_templateInfo objectForKey:@"key"] isEqualToString:@"alarm"]) {
            templateInfo = [NSMutableDictionary dictionaryWithDictionary:_templateInfo];
            break;
        }
    }
    NSString *text = templateInfo[@"text"];
    if ([text containsString:@"{link}"]) {
        return YES;
    }
    return NO;
}

- (BOOL)dis_manual_confirm_events {
    NSNumber *dis_manual_confirm_events = self.parameters[@"dis_manual_confirm_events"];
    if ([dis_manual_confirm_events isKindOfClass:[NSNumber class]]) {
        return dis_manual_confirm_events.boolValue;
    }
    return NO;
}

- (BOOL)dis_red_badges_confirm {
#if DEBUG == 1
    //return NO;
#endif
    NSNumber *dis_red_badges_confirm = self.parameters[@"dis_red_badges_confirm"];
    if ([dis_red_badges_confirm isKindOfClass:[NSNumber class]]) {
        return dis_red_badges_confirm.boolValue;
    }
    return NO;
}

- (BOOL)timeline {
    NSNumber *timeline = self.parameters[@"timeline"];
    if ([timeline isKindOfClass:[NSNumber class]]) {
        return timeline.boolValue;
    }
    return NO;
}

- (BOOL)calendar_week {
    NSNumber *calendar_week = self.parameters[@"calendar_week"];
    if ([calendar_week isKindOfClass:[NSNumber class]]) {
        return calendar_week.boolValue;
    }
    return NO;
}


- (BOOL)is_log {
    NSNumber *is_log = self.parameters[@"is_log"];
    if ([is_log isKindOfClass:[NSNumber class]]) {
        return is_log.boolValue;
    }
    return NO;
}

- (BOOL)dis_price_event_link {
    NSNumber *dis_price_event_link = self.parameters[@"dis_price_event_link"];
    if ([dis_price_event_link isKindOfClass:[NSNumber class]]) {
        return dis_price_event_link.boolValue;
    }
    return NO;
}

- (BOOL)dis_cancel_event_link {
    NSNumber *dis_cancel_event_link = self.parameters[@"dis_cancel_event_link"];
    if ([dis_cancel_event_link isKindOfClass:[NSNumber class]]) {
        return dis_cancel_event_link.boolValue;
    }
    return NO;
}

- (NSNumber *)ny_enabled {
    NSNumber *ny_enabled = self.parameters[@"ny_enabled"];
    if ([ny_enabled isKindOfClass:[NSNumber class]]) {
        return ny_enabled;
    }
    return nil;
}

- (NSString *)ny_theme {
    NSString *ny_theme = self.parameters[@"ny_theme"];
    if ([ny_theme isKindOfClass:[NSString class]]) {
        return ny_theme;
    }
    return nil;
}

- (NSDictionary *)waitinglist_times {
    NSDictionary *waitinglist_times = self.parameters[@"waitinglist_times"];
    if ([waitinglist_times isKindOfClass:[NSDictionary class]]) {
        return waitinglist_times;
    }
    return nil;
}
- (NSString *)payUrl {
    return [self patchedURL:_payUrl];
}

- (NSString *)account_url {
    return [self patchedURL:_account_url];
}

- (NSString *)calendar_url {
    return [self patchedURL:_calendar_url];
}

- (NSString *)stats_url {
    return [self patchedURL:_stats_url];
}

- (NSString *)stats_url_orig {
    NSString *string = self.parameters[@"stats_url_orig"];
    if ([string isKindOfClass:[NSString class]]) {
        return string;
    }
    return @"";
}

- (NSString *)payCreditUrl {
    return [self patchedURL:_payCreditUrl];
}

- (NSString *)payHistoryUrl {
    return [self patchedURL:_payHistoryUrl];
}

- (NSString *)patchedURL:(NSString *)urlString {
    return nil;
}

- (NSDictionary *)dashboard_widgets {
    return self.parameters[@"dashboard_widgets"];
}

- (NSDictionary *)deposit {
    NSDictionary *result = self.parameters[@"deposit"];
    if (![result isKindOfClass:[NSDictionary class]]) {
        return @{};
    }
    return result;
}

- (BOOL)deposit_enabled {
#if CLIENT == 1
    if ([@(YES) boolValue]) {
        return NO;
    }
#endif
    NSNumber *is_enabled = self.deposit[@"is"];
    if (is_enabled.boolValue) {
        return YES;
    }
    return NO;
}

- (BOOL)deposit_show_on_web {
    NSNumber *is_web = self.deposit[@"is_web"];
    if (is_web.boolValue) {
        return YES;
    }
    return NO;
}

- (NSString *)deposit_banner_text {
    NSString *web_banner = self.deposit[@"web_banner"];
    if ([web_banner isKindOfClass:[NSString class]]) {
        return web_banner;
    }
    return @"";
}

- (double)deposit_sum {
    NSNumber *sum = self.deposit[@"sum"];
    if ([sum isKindOfClass:[NSNumber class]]) {
        return sum.doubleValue;
    }
    return 0.0;
}

- (NSInteger)deposit_period { // in seconds
    NSNumber *period = self.deposit[@"period"];
    if ([period isKindOfClass:[NSNumber class]]) {
        return period.integerValue;
    }
    return 0;
}

- (NSInteger)deposit_alarm { // in seconds
    NSNumber *alarm = self.deposit[@"alarm"];
    if ([alarm isKindOfClass:[NSNumber class]]) {
        return alarm.integerValue;
    }
    return 0;
}

- (NSString *)deposit_for {
    NSString *isFor = self.deposit[@"for"];
    if ([isFor isKindOfClass:[NSString class]]) {
        return isFor;
    }
    return @"";
}

- (NSDictionary *)deposit_methods {
    NSDictionary *methods = self.deposit[@"methods"];
    if ([methods isKindOfClass:[NSDictionary class]]) {
        return methods;
    }
    return @{};
}

- (NSString *)deposit_phone {
    NSString *result = [self deposit_methods][@"phone"];
    if ([result isKindOfClass:[NSString class]]) {
        return result;
    }
    return @"";
}

- (NSString *)deposit_card {
    NSString *result = [self deposit_methods][@"card"];
    if ([result isKindOfClass:[NSString class]]) {
        return result;
    }
    return @"";
}

- (NSString *)deposit_cashapp {
    NSString *result = [self deposit_methods][@"cashapp"];
    if ([result isKindOfClass:[NSString class]]) {
        return result;
    }
    return @"";
}

- (NSString *)deposit_paypal {
    NSString *result = [self deposit_methods][@"paypal"];
    if ([result isKindOfClass:[NSString class]]) {
        return result;
    }
    return @"";
}

- (NSString *)deposit_venmo {
    NSString *result = [self deposit_methods][@"venmo"];
    if ([result isKindOfClass:[NSString class]]) {
        return result;
    }
    return @"";
}

- (NSString *)deposit_zelle {
    NSString *result = [self deposit_methods][@"zelle"];
    if ([result isKindOfClass:[NSString class]]) {
        return result;
    }
    return @"";
}

- (NSString *)def_web_banner {
    NSString *result = [self deposit][@"def_web_banner"];
    if ([result isKindOfClass:[NSString class]]) {
        return result;
    }
    return @"";
}

- (NSDictionary *)online_client {
    NSDictionary *result = self.parameters[@"online_client"];
    if ([result isKindOfClass:[NSDictionary class]]) {
        return result;
    }
    return @{};
}

- (NSInteger)oc_cancel_period {
    NSNumber *result = [self online_client][@"cancel_period"];
    if ([result isKindOfClass:[NSNumber class]]) {
        return result.integerValue;
    }
    return 0;
}

- (BOOL)oc_is_cancel {
    NSNumber *result = [self online_client][@"is_cancel"];
    if ([result isKindOfClass:[NSNumber class]]) {
        return result.boolValue;
    }
    return NO;
}

- (BOOL)oc_is_move {
    NSNumber *result = [self online_client][@"is_move"];
    if ([result isKindOfClass:[NSNumber class]]) {
        return result.boolValue;
    }
    return NO;
}

- (BOOL)oc_is_view_price {
    NSNumber *result = [self online_client][@"is_view_price"];
    if ([result isKindOfClass:[NSNumber class]]) {
        return result.boolValue;
    }
    return NO;
}

- (NSInteger)oc_move_period {
    NSNumber *result = [self online_client][@"move_period"];
    if ([result isKindOfClass:[NSNumber class]]) {
        return result.integerValue;
    }
    return 0;
}

- (BOOL)online_client_to_book {
    NSNumber *result = self.parameters[@"online_client_to_book"];
    if ([result isKindOfClass:[NSNumber class]]) {
        return result.boolValue;
    }
    return NO;
}

- (NSString *)social_share_text {
    NSString *result = self.parameters[@"social_share_text"];
    if ([result isKindOfClass:[NSString class]]) {
        return result;
    }
    return @"";
}

- (BOOL)personal_data {
    NSNumber *result = self.parameters[@"personal_data"];
    if ([result isKindOfClass:[NSNumber class]]) {
        return result.boolValue;
    }
    return NO;
}

- (BOOL)check_personal_data {
    NSNumber *result = self.parameters[@"check_personal_data"];
    if ([result isKindOfClass:[NSNumber class]]) {
        return result.boolValue;
    }
    return NO;
}

- (BOOL)external_sms {
    NSNumber *result = self.parameters[@"external_sms"];
    if ([result isKindOfClass:[NSNumber class]]) {
        return result.boolValue;
    }
    return NO;
}

- (NSInteger)stats_version {
    NSNumber *result = self.parameters[@"stats_version"];
    if ([result isKindOfClass:[NSNumber class]]) {
        return result.integerValue;
    }
    return 1;
}

- (NSString *)privacy_policy {
    NSDictionary *dictionary = self.parameters[@"jam_docs"];
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        NSString *result = dictionary[@"privacy_policy"];
        if ([result isKindOfClass:[NSString class]]) {
            return result;
        }
    }
    return @"";
}

- (NSString *)offer {
    NSDictionary *dictionary = self.parameters[@"jam_docs"];
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        NSString *result = dictionary[@"offer"];
        if ([result isKindOfClass:[NSString class]]) {
            return result;
        }
    }
    return @"";
}

- (NSString *)terms {
    NSDictionary *dictionary = self.parameters[@"jam_docs"];
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        NSString *result = dictionary[@"terms"];
        if ([result isKindOfClass:[NSString class]]) {
            return result;
        }
    }
    return @"";
}

- (NSString *)personal_data_distribution {
    NSDictionary *dictionary = self.parameters[@"jam_docs"];
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        NSString *result = dictionary[@"personal_data_distribution"];
        if ([result isKindOfClass:[NSString class]]) {
            return result;
        }
    }
    return @"";
}

- (NSString *)personal_data_processing {
    NSDictionary *dictionary = self.parameters[@"jam_docs"];
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        NSString *result = dictionary[@"personal_data_processing"];
        if ([result isKindOfClass:[NSString class]]) {
            return result;
        }
    }
    return @"";
}

- (NSString *)user_agreement {
    NSDictionary *dictionary = self.parameters[@"jam_docs"];
    if ([dictionary isKindOfClass:[NSDictionary class]]) {
        NSString *result = dictionary[@"user_agrement"];
        if ([result isKindOfClass:[NSString class]]) {
            return result;
        }
    }
    return @"";
}

- (BOOL)is_auth_qr {
    NSNumber *result = self.parameters[@"is_auth_qr"];
    if ([result isKindOfClass:[NSNumber class]]) {
        return result.boolValue;
    }
    return NO;
}

- (NSDictionary *)interface_settings {
#if CLIENT == 1
    return @{};
#endif
    
#ifdef SALON
    return @{};
#endif
    NSDictionary *result = self.parameters[@"interface_settings"];
    if ([result isKindOfClass:[NSDictionary class]]) {
        return result;
    }
    return @{};
}

- (BOOL)is_moder {
    NSNumber *result = self.parameters[@"is_moder"];
    if ([result isKindOfClass:[NSNumber class]]) {
        return result.boolValue;
    }
    return NO;
}

- (NSString *)captcha_url {
    NSString *result = self.parameters[@"captcha_url"];
    if ([result isKindOfClass:[NSString class]]) {
        return result;
    }
    return @"";
}

- (BOOL)is_mindbox {
#if FEATURES == 1
    return NO;
#endif
    NSNumber *result = self.parameters[@"is_mindbox"];
    if ([result isKindOfClass:[NSNumber class]]) {
        return result.boolValue;
    }
    return NO;
}

- (NSArray *)tasks {
    NSArray *tasks = self.parameters[@"tasks"];
    if ([tasks isKindOfClass:[NSArray class]]) {
        return tasks;
    }
    return @[];
}

- (BOOL)is_screen_check_phone {
    NSNumber *result = self.parameters[@"is_screen_check_phone"];
    if ([result isKindOfClass:[NSNumber class]]) {
        return result.boolValue;
    }
    return NO;
}

- (BOOL)yaBookingEnabled {
    NSDictionary *yaBooking = self.parameters[@"ya_booking"];
    if ([yaBooking isKindOfClass:[NSDictionary class]]) {
        NSNumber *enabled = yaBooking[@"enabled"];
        if ([enabled isKindOfClass:[NSNumber class]]) {
            return enabled.boolValue;
        }
    }
    return NO;
}

- (BOOL)yaBookingExistsForUser {
    NSDictionary *yaBooking = self.parameters[@"ya_booking"];
    return yaBooking != nil;
}

- (BOOL)eventStyleLine {
    NSDictionary *eventColor = self.parameters[@"event_color"];
    if ([eventColor isKindOfClass:[NSDictionary class]]) {
        NSNumber *line = eventColor[@"line"];
        if ([line isKindOfClass:[NSNumber class]]) {
            return line.boolValue;
        }
    }
    return NO;
}

- (NSString *)yaBookingName {
    NSDictionary *yaBooking = self.parameters[@"ya_booking"];
    if ([yaBooking isKindOfClass:[NSDictionary class]]) {
        NSString *name = yaBooking[@"name"];
        if ([name isKindOfClass:[NSString class]]) {
            return name;
        }
    }
    return @"";
}

- (NSString *)yaBookingPlace {
    NSDictionary *yaBooking = self.parameters[@"ya_booking"];
    if ([yaBooking isKindOfClass:[NSDictionary class]]) {
        NSString *place = yaBooking[@"place"];
        if ([place isKindOfClass:[NSString class]]) {
            return place;
        }
    }
    return @"";
}

- (NSString *)yaBookingAddress {
    NSDictionary *yaBooking = self.parameters[@"ya_booking"];
    if ([yaBooking isKindOfClass:[NSDictionary class]]) {
        NSString *address = yaBooking[@"address"];
        if ([address isKindOfClass:[NSString class]]) {
            return address;
        }
    }
    return @"";
}

- (NSString *)yaBookingLink {
    NSDictionary *yaBooking = self.parameters[@"ya_booking"];
    if ([yaBooking isKindOfClass:[NSDictionary class]]) {
        NSString *link = yaBooking[@"link"];
        if ([link isKindOfClass:[NSString class]]) {
            return link;
        }
    }
    return @"";
}

- (BOOL)eventStyleFill {
    NSDictionary *eventColor = self.parameters[@"event_color"];
    if ([eventColor isKindOfClass:[NSDictionary class]]) {
        NSNumber *fill = eventColor[@"fill"];
        if ([fill isKindOfClass:[NSNumber class]]) {
            return fill.boolValue;
        }
    }
    return NO;
}

- (NSString *)onboarding_promo_url {
    NSString *result = self.parameters[@"onboarding_promo_url"];
    if ([result isKindOfClass:[NSString class]]) {
        return result;
    }
    return @"";
}

@end

@implementation NSString (B)

- (NSArray *)colorsTupleFromHTMLString {
    NSArray *components = [self componentsSeparatedByString:@","];
    if (components.count != 2) {
        return @[UIColor.blackColor, UIColor.blackColor];
    }
    return @[];
}

@end

