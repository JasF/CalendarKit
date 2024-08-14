
#import <Foundation/Foundation.h>

@interface NSDate (Helper)

- (NSUInteger)daysAgo;
- (NSUInteger)daysAgoAgainstMidnight;
- (NSString *)stringDaysAgo;
- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag;
- (NSUInteger)weekday;
- (NSUInteger)weekdayStartedWithMonday;
- (NSUInteger)weekdayCorrected;

+ (NSDate *)dateFromString:(NSString *)string;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)string;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed alwaysDisplayTime:(BOOL)displayTime;

- (NSString *)string;
- (NSString*)stringMediumStyle;
- (NSString *)stringWithFormat:(NSString *)format;
- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;

- (NSDate *) beginningOfMonth;
- (NSDate *)beginningOfWeek;
- (NSDate *)beginningOfDay;
- (NSDate *)endOfWeek;

- (NSDate*) dateByAppendDays: (NSUInteger) days;
- (NSDate*) dateByAppendMonths: (NSUInteger) months;
- (NSDate*) dateByAppendYears: (NSUInteger) years;

+ (NSString *)dateFormatString;
+ (NSString *)timeFormatString;
+ (NSString *)timestampFormatString;
+ (NSString *)dbFormatString;

+ (NSInteger) getPeriodInDaysBetweenDate: (NSDate*) startDate AndDate: (NSDate*) endDate;
+ (NSInteger) getPeriodInMonthsBetweenDate: (NSDate*) startDate AndDate: (NSDate*) endDate;
+ (NSInteger) getPeriodInYearsBetweenDate: (NSDate*) startDate AndDate: (NSDate*) endDate;
+ (NSInteger) getDaysCountInYearForDate: (NSDate*) date;

- (NSString*) stringByISO8601;
+ (NSString *)iso8601FormatString;
+ (NSDate *)dateByISO8601String:(NSString *)string;
@end
