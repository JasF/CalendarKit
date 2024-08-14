//
//  JMSAbstractUser.m
//  Masters
//
//  Created by Alexander Timonenkov on 21.05.15.
//  Copyright (c) 2015 Jam Soft. All rights reserved.
//

#import "JMSAbstractUser.h"
//#import "JMSService.h"
#import "DSCoreData.h"

@implementation JMSAbstractUser {
    NSString *_avatar;
    NSNumber *_calendar_date_begin;
    NSNumber *_calendar_date_end;
}

+(EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"about", @"active", @"avatar"/*, @"calendar_min_time_event"*//*, @"calendar_periodOfAppointment"*/, @"createDate", @"email", @"experience", @"firstName", @"gender", @"lastActivityDate", @"lastName", @"phone", @"type", @"tz", @"userID", @"version", @"photo", @"per_price", @"uid", @"additionalPhone", @"social"
                                          //, @"fix_times"
                                          //, @"calendar_exclude_days"
                                          //, @"calendar_date_begin"
                                          //, @"calendar_date_end"
                                          //, @"is_appointment"
                                          , /*@"interval_between_events",*/ @"firstNameLc", @"lastNameLc"]];
    }];
}

- (void)setCalendar_date_begin:(NSNumber *)calendar_date_begin {
    _calendar_date_begin = calendar_date_begin;
}

- (NSNumber *)calendar_date_begin {
    if (_calendar_date_begin.integerValue == 0) {
       // return nil;
    }
    return _calendar_date_begin;
}

- (void)setCalendar_date_end:(NSNumber *)calendar_date_end {
    _calendar_date_end = calendar_date_end;
}

- (NSNumber *)calendar_date_end {
    if (_calendar_date_end.integerValue == 0) {
       // return nil;
    }
    return _calendar_date_end;
}

+ (void)load {
    [self replaceSetters];
}

- (NSArray *)services {
    NSArray *services = @[];//[JMSService MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"user.userID == %@ AND type == \"service.user\"", self.userID] inContext:[DSCoreData sharedInstance].readContext];
    return services;
}

- (void)setUserID:(NSString *)userID {
    if (self.cached) {
        if (![_userID isEqualToString:userID]) {
            [self MR_deleteEntityInContext:[DSCoreData sharedInstance].readContext];
            self.cached = NO;
        }
    }
    _userID = userID;
}

- (NSString *)uid {
    if (_uid.length) {
        return _uid;
    }
    return [NSString stringWithFormat:@"_%@", self.userID];
}

- (void)setAvatar:(NSString *)avatar {
    _avatar = avatar;
}

- (NSString *)avatar {
    return _avatar;
}

- (void)setFirstName:(NSString *)firstName {
    _firstName = firstName;
    self.firstNameLc = [firstName lowercaseString];
}

- (void)setLastName:(NSString *)lastName {
    _lastName = lastName;
    self.lastNameLc = [lastName lowercaseString];
}


@end
