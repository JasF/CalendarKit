//
//  JMSAbstractUser.h
//  Masters
//
//  Created by Alexander Timonenkov on 21.05.15.
//  Copyright (c) 2015 Jam Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MagicalRecordPatch.h"

@class JMSService;
@import EasyMapping;

@interface JMSAbstractUser : NSBeforeManagedObject <EKMappingProtocol>

@property (nonatomic, retain) NSString * about;
@property (nonatomic, retain) NSString * active;
@property (nonatomic, retain) NSString * avatar;
@property (nonatomic) NSString *per_price;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * experience;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * firstNameLc;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSDate * lastActivityDate;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * lastNameLc;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * additionalPhone;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * tz;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSNumber * version;
@property (nonatomic, retain) NSString * photo;
@property (nonatomic, retain) NSArray *services;
@property (nonatomic, retain) NSString *uid;
@property (nonatomic, retain) NSNumber *is_salon;
//@property (nonatomic, retain) NSNumber * calendar_min_time_event;
//@property (nonatomic, retain) NSNumber * calendar_periodOfAppointment;
//@property (nonatomic) NSNumber * interval_between_events;
//@property (nonatomic, retain) NSArray *fix_times;
//@property (nonatomic, retain) NSNumber *calendar_exclude_days;
//@property (nonatomic, retain) NSNumber *calendar_date_begin;
//@property (nonatomic, retain) NSNumber *calendar_date_end;
//@property (nonatomic, retain) NSNumber *is_appointment;

/**
 * @param array of dictionaries {id, name, url}
 */
@property (nonatomic, retain) NSArray *social;
@end

@interface JMSAbstractUser (CoreDataGeneratedAccessors)

- (void)insertObject:(JMSService *)value inServicesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromServicesAtIndex:(NSUInteger)idx;
- (void)insertServices:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeServicesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInServicesAtIndex:(NSUInteger)idx withObject:(JMSService *)value;
- (void)replaceServicesAtIndexes:(NSIndexSet *)indexes withServices:(NSArray *)values;
- (void)addServicesObject:(JMSService *)value;
- (void)removeServicesObject:(JMSService *)value;
- (void)addServices:(NSOrderedSet *)values;
- (void)removeServices:(NSOrderedSet *)values;
@end
