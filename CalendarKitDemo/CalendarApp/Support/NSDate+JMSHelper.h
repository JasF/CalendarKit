#import <Foundation/Foundation.h>

#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926

@interface NSDateCalibrator : NSObject
@property (nonatomic) BOOL hasMovingBack;
@property (nonatomic) BOOL hasNovemberBug;
- (void)update;
+ (instancetype)shared;
@end

@interface NSDate (JMSHelper)

+ (NSCalendar *)currentCalendar;
- (NSString *)listFormattedString;

- (BOOL)isToday;
- (BOOL)isPastDay;
- (BOOL)isYeasterday;
- (BOOL)isTomorrow;
- (BOOL)isPastMonth;
- (BOOL)isCurrentMonth;
- (BOOL)isFutureMonth;
- (BOOL)isCurrentYear;
- (BOOL)isFuture;
- (BOOL)isPast;
- (NSDate *)toLocalTime;
- (NSDate *)toGlobalTime;
+ (NSDate *) dateYearOffset:(NSInteger)offset fromDate:(NSDate *)date;
- (NSString *)dateString;
- (NSString*)monthNameString;
- (NSString*)specialMonthNameString;
- (NSString*)fullMonthNameString;
- (NSString*)monthNameShortString;
- (NSString*)monthNameShortStringWD;
- (NSString*)monthNameShortSpecialString;
- (NSString*)shortDayNameByDayNumber;
- (NSString*)shortDayNameByDayNumberWD;
- (NSString *)dayNameFull;
/**
 Returns a new date with first second of the day of the receiver.
 */
- (NSDate *) jms_beginningOfDay;

/**
 Returns a new date with the last second of the day of the receiver.
 */
- (NSDate *) jms_endOfDay;

- (NSDate *) jms_beginningOfMonth;

- (NSDate *) jms_endOfMonth;

- (NSDate *)jms_beginningOfYear;
    
// Adjusting dates
- (NSDate *) dateByAddingYears: (NSInteger) dYears;
- (NSDate *) dateBySubtractingYears: (NSInteger) dYears;
- (NSDate *) dateByAddingMonths: (NSInteger) dMonths;
- (NSDate *) dateBySubtractingMonths: (NSInteger) dMonths;
- (NSDate *) dateByAddingDays: (NSInteger) dDays;
- (NSDate *) dateBySubtractingDays: (NSInteger) dDays;
- (NSDate *) dateByAddingHours: (NSInteger) dHours;
- (NSDate *) dateBySubtractingHours: (NSInteger) dHours;
- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes;

+ (NSDate *) currentDateForTime:(NSUInteger)minutes;
+ (NSDate *) date:(NSDate*) date forTime:(NSUInteger)_minutes;
- (NSString *) time;
+ (NSDate *) dateFromFormat:(NSString *)format value:(NSString *)value;
+ (NSString *)translateDateString:(NSString *)msgArrivedDate
               from:(NSString *)fromTimeZone
                 to:(NSString *)toTimeZone;
+ (NSDate *)translateDate:(NSDate *)msgArrivedDate
                             from:(NSString *)fromTimeZone
                               to:(NSString *)toTimeZone;


+ (NSDate *) birthForCurrentYear:(NSString *)origBirth;
+ (NSString *) dayNameByDayNumber:(NSInteger)dayNumber;
+ (NSString *) fullDayNameByDayNumber:(NSInteger)dayNumber;
+ (NSString *) shortDayNameByDayNumber:(NSInteger)dayNumber;
+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;
+ (NSDate *)dateFromISO8601String:(NSString *)string;
- (NSString *)hoursAndMinutes;
- (NSString *)monthAndDays;
- (NSInteger)daysSinceDate:(NSDate *)date;
- (NSInteger)monthsSinceDate:(NSDate *)date;
- (NSInteger)daysSince1970;
+ (NSDate *)dateByDaysSince1970:(NSInteger)daysCount;
// Decomposing dates
@property (readonly) NSInteger nearestHour;
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger week;
@property (readonly) NSUInteger weekday;
@property (readonly) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger weekdayStartedFromOne; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger year;

@end
