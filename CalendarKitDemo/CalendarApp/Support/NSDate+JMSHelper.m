#import "NSDate+JMSHelper.h"
//#import "JTTimeZone.h"
#import "NSDate+MTDates.h"

static const unsigned componentFlags = (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal);


@implementation NSDateCalibrator
+ (instancetype)shared {
    static NSDateCalibrator *sharedInstance = nil;
    if (sharedInstance == nil) {
        sharedInstance = [NSDateCalibrator new];
        [sharedInstance update];
        [sharedInstance updateNovemberBug];
    }
    return sharedInstance;
}

- (void)update {
    self.hasMovingBack = NO;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    [components setYear:2019];
    [components setMonth:8];
    [components setDay:1];
    
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    // Generate a new NSDate from components3.
    NSDate *thursdayDate = [[NSDate currentCalendar] dateFromComponents:components]; // Четверг
    if (thursdayDate.weekdayStartedFromOne == 3) {
        self.hasMovingBack = YES;
    }
}

- (void)updateNovemberBug {
    if (self.hasMovingBack) {
        return;
    }
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    [components setYear:2019];
    [components setMonth:11];
    [components setDay:1];
    
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *fridayDate = [[NSDate currentCalendar] dateFromComponents:components]; // Пятница
    if (fridayDate.weekdayStartedFromOne == 4) {
        self.hasNovemberBug = YES;
    }
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}
@end

@implementation NSDate (JMSHelper)

// Courtesy of Lukasz Margielewski
// Updated via Holger Haenisch
+ (NSCalendar *) currentCalendar
{
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar) {
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    }
    //sharedCalendar.timeZone = [JTTimeZone timeZone];
    return sharedCalendar;
}

+ (NSDate *) dateFromFormat:(NSString *)format value:(NSString *)value
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter dateFromString:value];
}

- (BOOL)isToday {
    NSDateComponents *day = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    NSDateComponents *today = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    
    return [day year] == [today year]
    && [day month] == [today month]
    && [day day] == [today day];
}

- (BOOL)isPastDay {
    if ([self timeIntervalSinceNow] < 0.0 && ![self isToday]) {
        return YES;
    }
    
    return NO;
}

-(NSString*) monthNameString
{
    NSDateFormatter *formate = [NSDateFormatter new];
    
    NSArray *monthNames = [formate standaloneMonthSymbols];
    
    NSString *monthName = [monthNames objectAtIndex:(self.month - 1)];
    
    return monthName;
}

- (NSString *)specialMonthNameString {
    switch (self.month - 1) {
        case 0: return L(@"jan_spec");
        case 1: return L(@"feb_spec");
        case 2: return L(@"mar_spec");
        case 3: return L(@"ap_spec");
        case 4: return L(@"may_spec");
        case 5: return L(@"jun_spec");
        case 6: return L(@"jul_spec");
        case 7: return L(@"aug_spec");
        case 8: return L(@"sep_spec");
        case 9: return L(@"oct_spec");
        case 10: return L(@"nov_spec");
        case 11: return L(@"dec_spec");
        default: assert(false); return @"";
    }
}

- (NSString *)fullMonthNameString {
    switch (self.month - 1) {
        case 0: return L(@"january");
        case 1: return L(@"february");
        case 2: return L(@"march");
        case 3: return L(@"april");
        case 4: return L(@"may");
        case 5: return L(@"june");
        case 6: return L(@"july");
        case 7: return L(@"august");
        case 8: return L(@"september");
        case 9: return L(@"october");
        case 10: return L(@"november");
        case 11: return L(@"december");
        default: assert(false); return @"";
    }
}
- (NSString *)monthNameShortString {
    switch (self.month - 1) {
        case 0:  return [NSString stringWithFormat:@"%@.", L(@"jan_short")];
        case 1:  return [NSString stringWithFormat:@"%@.", L(@"feb_short")];
        case 2:  return [NSString stringWithFormat:@"%@.", L(@"mar_short")];
        case 3:  return [NSString stringWithFormat:@"%@.", L(@"apr_short")];
        case 4:  return [NSString stringWithFormat:@"%@.", L(@"may_short")];
        case 5:  return [NSString stringWithFormat:@"%@.", L(@"jun_short")];
        case 6:  return [NSString stringWithFormat:@"%@.", L(@"jul_short")];
        case 7:  return [NSString stringWithFormat:@"%@.", L(@"aug_short")];
        case 8:  return [NSString stringWithFormat:@"%@.", L(@"sep_short")];
        case 9:  return [NSString stringWithFormat:@"%@.", L(@"oct_short")];
        case 10:  return [NSString stringWithFormat:@"%@.", L(@"nov_short")];
        case 11:  return [NSString stringWithFormat:@"%@.", L(@"dec_short")];
        default: assert(false); return @"";
    }
}
- (NSString *)monthNameShortStringWD {
    switch (self.month - 1) {
        case 0: return L(@"jan_short");
        case 1: return L(@"feb_short");
        case 2: return L(@"mar_short");
        case 3: return L(@"apr_short");
        case 4: return L(@"may_short");
        case 5: return L(@"jun_short");
        case 6: return L(@"jul_short");
        case 7: return L(@"aug_short");
        case 8: return L(@"sep_short");
        case 9: return L(@"oct_short");
        case 10: return L(@"nov_short");
        case 11: return L(@"dec_short");
        default: assert(false); return @"";
    }
}

- (NSString *)monthNameShortSpecialString {
    switch (self.month - 1) {
        case 0: return L(@"jan_short2");
        case 1: return L(@"feb_short2");
        case 2: return L(@"mar_short2");
        case 3: return L(@"apr_short2");
        case 4: return L(@"may_short2");
        case 5: return L(@"jun_short2");
        case 6: return L(@"jul_short2");
        case 7: return L(@"aug_short2");
        case 8: return L(@"sep_short2");
        case 9: return L(@"oct_short2");
        case 10: return L(@"nov_short2");
        case 11: return L(@"dec_short2");
        default: assert(false); return @"";
    }
}

- (BOOL)isYeasterday {
    NSDateComponents *day = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    NSDateComponents *today = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    
    return [day year] == [today year]
    && [day month] == [today month]
    && [day day] == [today day] - 1;
}

- (BOOL)isTomorrow {
    NSDateComponents *day = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    
    NSDateComponents *today = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    
    return [day year] == [today year]
    && [day month] == [today month]
    && [day day] == [today day] + 1;
}

- (BOOL)isPastMonth {
    NSDateComponents *day = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    NSDateComponents *today = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    
    return [day year] < [today year] || [day month] < [today month];
}

- (BOOL)isCurrentMonth {
    NSDateComponents *day = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    NSDateComponents *today = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    
    return [day year] == [today year] || [day month] == [today month];
}

- (BOOL)isCurrentYear {
    NSDateComponents *day = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    NSDateComponents *today = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    
    return [day year] == [today year];
}

- (BOOL)isFutureMonth {
    NSDateComponents *day = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    NSDateComponents *today = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    
    return [day year] > [today year] || [day month] > [today month];
}

- (BOOL)isFuture
{
    return [self timeIntervalSinceNow] > 0.0;
}

- (BOOL) isPast
{
    return [self timeIntervalSinceDate:[NSDate date]] < 0;
}

+ (NSDate *)dateFromISO8601String:(NSString *)string {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [formatter setLocale:posix];
    NSDate *date = [formatter dateFromString:string];
    return date;
}

- (NSDate *)toLocalTime {
    NSCalendar *gregorian = [NSDate currentCalendar];
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    
    NSDateComponents *today = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:self];
    
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setCalendar:gregorian];
    [dateComps setTimeZone:tz];
    [dateComps setYear:[today year]];
    [dateComps setMonth:[today month]];
    [dateComps setDay:[today day]];
    [dateComps setHour:[today hour]];
    [dateComps setMinute:[today minute]];
    
    NSDate *result = [dateComps date];
    
    return result;
}

- (NSInteger)daysSinceDate:(NSDate *)date
{
    NSDateComponents *components = [[NSDate currentCalendar] components:NSCalendarUnitDay fromDate:date toDate:self options:0];
    NSInteger day = [components day];
    return day;
}

- (NSInteger)monthsSinceDate:(NSDate *)date {
    return [self mt_monthsSinceDate:date];
}

- (NSDate *)toGlobalTime {
    NSCalendar *gregorian = [NSDate currentCalendar];
    NSTimeZone *tz = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    NSDateComponents *today = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute fromDate:self];
    
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setCalendar:gregorian];
    [dateComps setYear:[today year]];
    [dateComps setMonth:[today month]];
    [dateComps setDay:[today day]];
    [dateComps setTimeZone:tz];
    [dateComps setHour:[today hour]];
    [dateComps setMinute:[today minute]];
    
    NSDate *result = [dateComps date];
    
    return result;
}

+ (NSDate *) dateYearOffset:(NSInteger)offset fromDate:(NSDate *)date
{
    NSCalendar *calendar = [NSDate currentCalendar];
    
    NSDateComponents *beginningOffsetComponents = [[NSDateComponents alloc] init];
    [beginningOffsetComponents setYear:offset];
    
    NSDate * newDate = [calendar dateByAddingComponents:beginningOffsetComponents toDate:date options:0];
    return newDate;
}

+ (NSDate *) currentDateForTime:(NSUInteger)_minutes
{
    return [NSDate date:[NSDate date] forTime:_minutes];
}

+  (NSDate *) date:(NSDate*) date forTime:(NSUInteger)_minutes
{
    NSUInteger _hours = _minutes/60;
    _minutes = _minutes - _hours*60;
    
    NSString * hours = _hours >= 10 ? [NSString stringWithFormat:@"%ld", _hours] : [NSString stringWithFormat:@"0%ld", _hours];
    NSString * minutes = _minutes >= 10 ? [NSString stringWithFormat:@"%ld", _minutes] : [NSString stringWithFormat:@"0%ld", _minutes];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd.MM.yyyy";
    NSString * dateBase = [formatter stringFromDate:date];
    NSString * dateFull = [NSString stringWithFormat:@"%@ %@:%@", dateBase, hours, minutes];
    
    formatter.dateFormat = @"dd.MM.yyyy H:mm";
    
    return [formatter dateFromString:dateFull];
}


- (NSString *) time
{
    return nil;//[JMSOwnerUser styledTimeForDate:self];
}



#pragma mark - Decomposing Dates -

- (NSInteger) nearestHour
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    NSDateComponents *components = [[NSDate currentCalendar] components:NSCalendarUnitHour fromDate:newDate];
    return components.hour;
}

- (NSInteger) hour
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.hour;
}

- (NSInteger) minute
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.minute;
}

- (NSInteger) seconds
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.second;
}

- (NSInteger) day
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.day;
}

- (NSInteger) month
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.month;
}

- (NSInteger) week
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.week;
}

- (NSString *)hoursAndMinutes {
    return @"";//[JMSOwnerUser styledTimeForDate:self];
    /*
    NSString *hours = [@(self.hour) stringValue];
    if (hours.length == 1) {
        hours = [NSString stringWithFormat:@"0%@", hours];
    }
    NSString *minutes = [@(self.minute) stringValue];
    if (minutes.length == 1) {
        minutes = [NSString stringWithFormat:@"0%@", minutes];
    }
    return [NSString stringWithFormat:@"%@:%@", hours, minutes];
     */
}

- (NSString *)monthAndDays {
    NSString *month = [@(self.month) stringValue];
    if (month.length == 1) {
        month = [NSString stringWithFormat:@"0%@", month];
    }
    NSString *days = [@(self.day) stringValue];
    if (days.length == 1) {
        days = [NSString stringWithFormat:@"0%@", days];
    }
    return [NSString stringWithFormat:@"%@.%@", days, month];
}

- (NSInteger)weekdayStartedFromOne {
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

- (NSUInteger) weekday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:self];
    NSInteger result = [components weekday];
    return result;
}

- (NSInteger) nthWeekday // e.g. 2nd Tuesday of the month is 2
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.weekdayOrdinal;
}

- (NSInteger) year
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.year;
}



#pragma mark - Adjusting Dates -

// Thaks, rsjohnson
- (NSDate *) dateByAddingYears: (NSInteger) dYears
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:dYears];
    NSDate *newDate = [[NSDate currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *) dateBySubtractingYears: (NSInteger) dYears
{
    return [self dateByAddingYears:-dYears];
}

- (NSDate *) dateByAddingMonths: (NSInteger) dMonths
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:dMonths];
    NSDate *newDate = [[NSDate currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *) dateBySubtractingMonths: (NSInteger) dMonths
{
    return [self dateByAddingMonths:-dMonths];
}

// Courtesy of dedan who mentions issues with Daylight Savings
- (NSDate *) dateByAddingDays: (NSInteger) dDays
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:dDays];
    NSDate *newDate = [NSDate date];//[[JMSCalendarHelper sharedInstance].calendar dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

- (NSDate *) dateBySubtractingDays: (NSInteger) dDays
{
    return [self dateByAddingDays: (dDays * -1)];
}

- (NSDate *) dateByAddingHours: (NSInteger) dHours
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *) dateBySubtractingHours: (NSInteger) dHours
{
    return [self dateByAddingHours: (dHours * -1)];
}

- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes
{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes
{
    return [self dateByAddingMinutes: (dMinutes * -1)];
}

- (NSDateComponents *) componentsWithOffsetFromDate: (NSDate *) aDate
{
    NSDateComponents *dTime = [[NSDate currentCalendar] components:componentFlags fromDate:aDate toDate:self options:0];
    return dTime;
}

+ (NSString *)translateDateString:(NSString *)msgArrivedDate
               from:(NSString *)fromTimeZone
                 to:(NSString *)toTimeZone {
    NSDate *date = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if([fromTimeZone isEqualToString:@"UTC"]) {
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    }
    
    if([fromTimeZone isEqualToString:@"GMT"]) {
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    }
    
    if([msgArrivedDate length] > 0) {
        date = [dateFormatter dateFromString:msgArrivedDate];
    } else {
        date = [NSDate date];
    }
    
    if([toTimeZone isEqualToString:@"UTC"]) {
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    }
    
    if([toTimeZone isEqualToString:@"GMT"]) {
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    }
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSDate *)translateDate:(NSDate *)msgArrivedDate
                     from:(NSString *)fromTimeZone
                       to:(NSString *)toTimeZone
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString * dateString = [NSDate translateDateString:[formatter stringFromDate:msgArrivedDate] from:fromTimeZone to:toTimeZone];
    return [formatter dateFromString:dateString];
}


- (NSString *) listFormattedString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (self.year == [NSDate date].year) {
        [formatter setDateFormat:@"d MMMM"];
    } else {
        [formatter setDateFormat:@"dd.MM.yy"];
    }
    return [formatter stringFromDate:self];
}



#pragma mark -

- (NSDate *) jms_beginningOfDay {
    NSDate *result = [[NSDate currentCalendar] startOfDayForDate:self];
    return result;
}

- (NSDate *) jms_endOfDay {
    NSDateComponents *components = [NSDateComponents new];
    components.day = 1;
    components.second = -1;
    NSDate *result = [[NSDate currentCalendar] dateByAddingComponents:components toDate:[self jms_beginningOfDay] options:0];
    return result;
}

- (NSString *)shortDayNameByDayNumber
{
    NSInteger weekday = self.weekdayStartedFromOne;
    if ([NSDateCalibrator shared].hasMovingBack) {
        weekday += 1;
    }
    if (weekday > 7) {
        weekday -= 7;
    }
    switch (weekday) {
        case 1:
            return L(@"pnd");
        case 2:
            return L(@"vtd");
        case 3:
            return L(@"srd");
        case 4:
            return L(@"ctd");
        case 5:
            return L(@"ptd");
        case 6:
            return L(@"sbd");
        case 7:
            return L(@"vsd");
    }
    return @"";
}

- (NSString *)shortDayNameByDayNumberWD
{
    NSInteger weekday = self.weekdayStartedFromOne;
    if ([NSDateCalibrator shared].hasMovingBack) {
        weekday += 1;
    }
    if (weekday > 7) {
        weekday -= 7;
    }
    switch (weekday) {
        case 1:
            return L(@"pn");
        case 2:
            return L(@"vt");
        case 3:
            return L(@"sr");
        case 4:
            return L(@"ct");
        case 5:
            return L(@"pt");
        case 6:
            return L(@"sb");
        case 7:
            return L(@"vs");
    }
    return @"";
}

- (NSString *)dayNameFull
{
    NSInteger weekday = self.weekdayStartedFromOne;
    if ([NSDateCalibrator shared].hasMovingBack) {
        weekday += 1;
    }
    if (weekday > 7) {
        weekday -= 7;
    }
    switch (weekday) {
        case 1:
            return L(@"fpn");
        case 2:
            return L(@"fvt");
        case 3:
            return L(@"fsr");
        case 4:
            return L(@"fct");
        case 5:
            return L(@"fpt");
        case 6:
            return L(@"fsb");
        case 7:
            return L(@"fvs");
    }
    return @"";
}

+ (NSDate*) birthForCurrentYear:(NSString *)origBirth
{
    NSDateFormatter * formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy.MM.dd";
    
    NSCalendar *calendar = [NSDate currentCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[formatter dateFromString:origBirth]];
    [components setYear:[NSDate date].year];
    [components setMonth:[NSDate date].month];
    return [calendar dateFromComponents:components];
}


#pragma mark -

- (NSDate *) jms_beginningOfMonth {
    NSCalendar *calendar = [NSDate currentCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    
    return [calendar dateFromComponents:components];
}

- (NSDate *)jms_beginningOfYear {
    NSCalendar *calendar = [NSDate currentCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:self];
    
    return [calendar dateFromComponents:components];
}

- (NSDate *) jms_endOfMonth {
    NSCalendar *calendar = [NSDate currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    //components.timeZone = nil;//[JMSCalendarHelper sharedInstance].timeZone;
    components.month = 1;
    
    return [[calendar dateByAddingComponents:components toDate:[self jms_beginningOfMonth] options:0] dateByAddingTimeInterval:-1];
}



#pragma mark -

+ (NSString *) dayNameByDayNumber:(NSInteger)dayNumber
{
    if ([NSDateCalibrator shared].hasMovingBack) {
        dayNumber += 1;
    }
    if (dayNumber > 7) {
        dayNumber -= 7;
    }
    switch (dayNumber) {
        case 1:
            return L(@"bpn");
        case 2:
            return L(@"bvt");
        case 3:
            return L(@"bsr");
        case 4:
            return L(@"bct");
        case 5:
            return L(@"bpt");
        case 6:
            return L(@"bsb");
        case 7:
            return L(@"bvs");
    }
    return @"";
}

+ (NSString *) shortDayNameByDayNumber:(NSInteger)dayNumber
{
    if ([NSDateCalibrator shared].hasMovingBack) {
        dayNumber += 1;
    }
    if (dayNumber > 7) {
        dayNumber -= 7;
    }
    switch (dayNumber) {
        case 2:
            return L(@"dh.m");
        case 3:
            return L(@"dm.t");
        case 4:
            return L(@"dm.w");
        case 5:
            return L(@"dm.tu");
        case 6:
            return L(@"dm.f");
        case 7:
            return L(@"dm.s");
        case 1:
            return L(@"dm.su");
    }
    return @"";
}

+ (NSString *) fullDayNameByDayNumber:(NSInteger)dayNumber
{
    if ([NSDateCalibrator shared].hasMovingBack) {
        dayNumber += 1;
    }
    if (dayNumber > 7) {
        dayNumber -= 7;
    }
    switch (dayNumber) {
        case 1:
            return L(@"Monday");
        case 2:
            return L(@"Tuesday");
        case 3:
            return L(@"Wednesday");
        case 4:
            return L(@"Thursday");
        case 5:
            return L(@"Friday");
        case 6:
            return L(@"Saturday");
        case 7:
            return L(@"Sunday");
    }
    return @"";
}

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSDate currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

- (NSString *)dateString {
    NSString *month = [NSString stringWithFormat:@"%@", @(self.month)];
    NSString *day = [NSString stringWithFormat:@"%@", @(self.day)];
    NSString *hour = [NSString stringWithFormat:@"%@", @(self.hour)];
    NSString *minute = [NSString stringWithFormat:@"%@", @(self.minute)];
    NSString *seconds = [NSString stringWithFormat:@"%@", @(self.seconds)];
    if (month.length == 1) {
        month = [@"0" stringByAppendingString:month];
    }
    if (day.length == 1) {
        day = [@"0" stringByAppendingString:day];
    }
    if (hour.length == 1) {
        hour = [@"0" stringByAppendingString:hour];
    }
    if (minute.length == 1) {
        minute = [@"0" stringByAppendingString:minute];
    }
    if (seconds.length == 1) {
        seconds = [@"0" stringByAppendingString:seconds];
    }
    
    NSString *dateString = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%2@", @(self.year), month, day, hour, minute, seconds];
    return dateString;
}

+ (NSDate *)date1970 {
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    [components setYear:1970];
    [components setMonth:1];
    [components setDay:1];
    
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    // Generate a new NSDate from components3.
    NSDate *date = [[NSDate currentCalendar] dateFromComponents:components];
    return date;
}

- (NSInteger)daysSince1970 {
    NSDate *date1970 = [[self class] date1970];
    date1970 = [date1970 jms_beginningOfDay];
    NSInteger result = [self daysSinceDate:date1970];
    return result;
}

+ (NSDate *)dateByDaysSince1970:(NSInteger)daysCount {
    NSDate *date = [self date1970];
    NSDate *resultDate = [date dateByAddingDays:daysCount];
    return resultDate;
}

@end
