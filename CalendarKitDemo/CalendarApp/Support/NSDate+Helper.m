#import "NSDate+Helper.h"
#import "NSDate+JMSHelper.h"
#import "JMSApplicationAssembly.h"


static NSCalendar *calendar;
static NSDateFormatter *displayFormatter;

@implementation NSDate (Helper)

+ (void)load {
    @autoreleasepool {
        [[JMSApplicationAssembly shared] managers];
        calendar = [NSCalendar currentCalendar];
        displayFormatter = [[NSDateFormatter alloc] init];
    }
}

/*
 * This guy can be a little unreliable and produce unexpected results,
 * you're better off using daysAgoAgainstMidnight
 */
- (NSUInteger)daysAgo {
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit) 
											   fromDate:self
												 toDate:[NSDate date]
												options:0];
	return [components day];
}

- (NSUInteger)daysAgoAgainstMidnight {
	// get a midnight version of ourself:
	NSDateFormatter *mdf = [[NSDateFormatter alloc] init];
	[mdf setDateFormat:@"yyyy-MM-dd"];
	NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:self]];

	
	return (NSInteger)[midnight timeIntervalSinceNow] / (60*60*24) *-1;
}

- (NSDate*) dateByAppendDays: (NSUInteger) days{
    
	NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
	
	[componentsToAdd setDay: days];
	NSDate *date = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];

    return date;
}

- (NSDate*) dateByAppendMonths: (NSUInteger) months{
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
	
	[componentsToAdd setMonth: months];
	NSDate *date = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
    
    return date;
}

- (NSDate*) dateByAppendYears: (NSUInteger) years{
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
	
	[componentsToAdd setYear: years];
	NSDate *date = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
    
    return date;
}

- (NSString *)stringDaysAgo {
	return [self stringDaysAgoAgainstMidnight:YES];
}

- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag {
	NSUInteger daysAgo = (flag) ? [self daysAgoAgainstMidnight] : [self daysAgo];
	NSString *text = nil;
	switch (daysAgo) {
		case 0:
			text = @"Today";
			break;
		case 1:
			text = @"Yesterday";
			break;
		default:
			text = [NSString stringWithFormat:@"%lu days ago", (unsigned long)daysAgo];
	}
	return text;
}

- (NSUInteger)weekday {
    NSDateComponents *weekdayComponents = nil;//[calendar componentsInTimeZone:[JTTimeZone timeZone] fromDate:self];//[calendar components:(NSWeekdayCalendarUnit) fromDate:self];
    NSInteger result = [weekdayComponents weekday];
    if ([NSDateCalibrator shared].hasNovemberBug) {
        BOOL needCorrect = NO;
        NSInteger month = self.month;
        if ([@[@(11), @(12), @(1), @(2), @(3)] containsObject:@(month)]) {
            needCorrect = YES;
        }
        if (needCorrect) {
            result += 1;
            if (result > 7) {
                result -= 7;
            }
        }
    }
    return result;
}
- (NSUInteger)weekdayCorrected {
    NSInteger result = [self weekdayStartedWithMonday];
    if ([NSDateCalibrator shared].hasMovingBack) {
        result += 1;
    }
    if (result > 7) {
        result -= 7;
    }
    return result;
}

- (NSUInteger)weekdayStartedWithMonday {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:self];
    
    NSInteger result = [components weekday];
    
    if (result == 1) {
        result = 7;
    } else {
        result = result - 1;
    }
    return result;
}

+ (NSDate *)dateFromString:(NSString *)string {
	return [NSDate dateFromString:string withFormat:[NSDate dbFormatString]];
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
	NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
	[inputFormatter setDateFormat:format];
	NSDate *date = [inputFormatter dateFromString:string];

	return date;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
	return [date stringWithFormat:format];
}

+ (NSString *)stringFromDate:(NSDate *)date {
	return [date string];
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed alwaysDisplayTime:(BOOL)displayTime
{
    /* 
	 * if the date is in today, display 12-hour time with meridian,
	 * if it is within the last 7 days, display weekday name (Friday)
	 * if within the calendar year, display as Jan 23
	 * else display as Nov 11, 2008
	 */
	
	NSDate *today = [NSDate date];
    NSDateComponents *offsetComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
													 fromDate:today];
	
	NSDate *midnight = [calendar dateFromComponents:offsetComponents];
	
	NSString *displayString = nil;
	
	// comparing against midnight
	if ([date compare:midnight] == NSOrderedDescending) {
		if (prefixed) {
			[displayFormatter setDateFormat:@"'at' h:mm a"]; // at 11:30 am
		} else {
			[displayFormatter setDateFormat:@"h:mm a"]; // 11:30 am
		}
	} else {
		// check if date is within last 7 days
		NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
		[componentsToSubtract setDay:-7];
		NSDate *lastweek = [calendar dateByAddingComponents:componentsToSubtract toDate:today options:0];
		
		if ([date compare:lastweek] == NSOrderedDescending) {
            if (displayTime)
                [displayFormatter setDateFormat:@"EEEE h:mm a"]; // Tuesday
            else
                [displayFormatter setDateFormat:@"EEEE"]; // Tuesday
		} else {
			// check if same calendar year
			NSInteger thisYear = [offsetComponents year];
			
			NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
														   fromDate:date];
			NSInteger thatYear = [dateComponents year];			
			if (thatYear >= thisYear) {
                if (displayTime)
                    [displayFormatter setDateFormat:@"MMM d h:mm a"];
                else
                    [displayFormatter setDateFormat:@"MMM d"];
			} else {
                if (displayTime)
                    [displayFormatter setDateFormat:@"MMM d, yyyy h:mm a"];
                else
                    [displayFormatter setDateFormat:@"MMM d, yyyy"];
			}
		}
		if (prefixed) {
			NSString *dateFormat = [displayFormatter dateFormat];
			NSString *prefix = @"'on' ";
			[displayFormatter setDateFormat:[prefix stringByAppendingString:dateFormat]];
		}
	}
	
	// use display formatter to return formatted date string
	displayString = [displayFormatter stringFromDate:date];
	return displayString;
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed {
    // preserve prior behavior
	return [self stringForDisplayFromDate:date prefixed:prefixed alwaysDisplayTime:NO];
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date {
	return [self stringForDisplayFromDate:date prefixed:NO];
}

- (NSString *)stringWithFormat:(NSString *)format {
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:format];
	NSString *timestamp_str = [outputFormatter stringFromDate:self];
	return timestamp_str;
}

- (NSString *)string {
	return [self stringWithFormat:[NSDate dbFormatString]];
}

- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateStyle:dateStyle];
	[outputFormatter setTimeStyle:timeStyle];
	NSString *outputString = [outputFormatter stringFromDate:self];

	return outputString;
}

- (NSDate *)beginningOfWeek {
	// largely borrowed from "Date and Time Programming Guide for Cocoa"
	// we'll use the default calendar and hope for the best
	
    NSDate *beginningOfWeek = nil;
	BOOL ok = [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&beginningOfWeek
						   interval:NULL forDate:self];
	if (ok) {
		return beginningOfWeek;
	} 
	
	// couldn't calc via range, so try to grab Sunday, assuming gregorian style
	// Get the weekday component of the current date
	NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
	
	/*
	 Create a date components to represent the number of days to subtract from the current date.
	 The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today's Sunday, subtract 0 days.)
	 */
	NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
	[componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 1)];
	beginningOfWeek = nil;
	beginningOfWeek = [calendar dateByAddingComponents:componentsToSubtract toDate:self options:0];

	
	//normalize to midnight, extract the year, month, and day components and create a new date from those components.
	NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
											   fromDate:beginningOfWeek];
	return [calendar dateFromComponents:components];
}

- (NSDate *)beginningOfDay {
    // Get the weekday component of the current date
	NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
											   fromDate:self];
	return [calendar dateFromComponents:components];
}

- (NSDate *)endOfWeek {
    // Get the weekday component of the current date
	NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
	NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
	// to get the end of week for a particular date, add (7 - weekday) days
	[componentsToAdd setDay:(7 - [weekdayComponents weekday])];
	NSDate *endOfWeek = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];

	
	return endOfWeek;
}

- (NSDate *) beginningOfMonth {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate: self];
    [comp setDay:1];
    return [gregorian dateFromComponents:comp];
}

+ (NSString *)dateFormatString {
	return @"yyyy-MM-dd";
}

+ (NSString *)timeFormatString {
	return @"HH:mm:ss";
}

+ (NSString *)timestampFormatString {
	return @"yyyy-MM-dd HH:mm:ss";
}

// preserving for compatibility
+ (NSString *)dbFormatString {	
	return [NSDate timestampFormatString];
}

- (NSString*) stringMediumStyle{
    return  [self stringWithDateStyle:NSDateFormatterMediumStyle timeStyle: NSDateFormatterNoStyle];
}

+ (NSInteger) getPeriodInDaysBetweenDate: (NSDate*) startDate AndDate: (NSDate*) endDate{
   
    NSInteger dayCount = 0;
    
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
	NSUInteger unitFlags = NSDayCalendarUnit;
    
	NSDateComponents *components = [gregorian components: unitFlags
												fromDate: [startDate beginningOfDay]
												  toDate: [endDate beginningOfDay]
                                                 options:0];
	dayCount = [components day];
    
    return dayCount;
}

+ (NSInteger) getPeriodInMonthsBetweenDate: (NSDate*) startDate AndDate: (NSDate*) endDate{
    
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
	NSUInteger unitFlags = NSMonthCalendarUnit;
    
	NSDateComponents *components = [gregorian components: unitFlags
												fromDate: startDate
												  toDate: endDate options:0];
    
    return [components month];
}

+ (NSInteger) getPeriodInYearsBetweenDate: (NSDate*) startDate AndDate: (NSDate*) endDate{
    
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
	NSUInteger unitFlags = NSYearCalendarUnit;
    
	NSDateComponents *components = [gregorian components: unitFlags
												fromDate: startDate
												  toDate: endDate options:0];
    
    return [components year];
}

+ (NSInteger) getDaysCountInYearForDate: (NSDate*) date{
    
	NSUInteger days = 0;
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDateComponents *components = [calendar components:NSYearCalendarUnit fromDate:date];
    NSUInteger months = [calendar rangeOfUnit:NSMonthCalendarUnit
                                       inUnit:NSYearCalendarUnit
                                      forDate: date].length;
    for (int i = 1; i <= months; i++) {
        components.month = i;
        NSDate *month = [calendar dateFromComponents:components];
        days += [calendar rangeOfUnit:NSDayCalendarUnit
                               inUnit:NSMonthCalendarUnit
                              forDate:month].length;
    }
    
    //NSLog(@"days count in year %d for date %@", days, date);
    return days;
}

+ (NSString*) iso8601FormatString{
    return  @"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ";
}

- (NSString*) stringByISO8601{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat: [NSDate iso8601FormatString]];
    
    return [dateFormatter stringFromDate: self];
}
+ (NSDate *)dateByISO8601String:(NSString *)string {
    return [self dateFromISO8601String:string];
}
@end
