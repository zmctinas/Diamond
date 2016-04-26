//
//  NSDate+Calendar.m
//  AntCalendar
//
//  Created by hudezhi on 15/5/27.
//  Copyright (c) 2015年 hudezhi. All rights reserved.
//

#import "NSDate+Calendar.h"

@interface NSDate(Calendar_Private)

-(NSDate*)dateFromYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
@end

@implementation NSDate(Calendar)

+(NSCalendar*)calendar {
    static NSCalendar* cal;
    if (nil == cal) {
        //@ change to the first day in a month
        //@Note: we need to set the time zone to 'GMT', otherwise, the date will not right(one day offset)
        
        cal = [NSCalendar currentCalendar];
        [cal setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    }
    return cal;
}

-(NSDate*)firstDateOfTheMonth {
    NSDateComponents *comps = [[NSDate calendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    [comps setDay:1];
    NSDate *firstDayOfMonthDate = [[NSDate calendar] dateFromComponents:comps];
    return firstDayOfMonthDate;
}

- (NSDate *)lastDateOfTheMonth
{
    NSDateComponents *comps = [[NSDate calendar]components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    
    NSInteger dayOfMonthCount = 31;
    
    if (comps.month == 2)
    {
        if ([self isLeapYear:comps.year])
        {
            dayOfMonthCount = 29;
        }
        else
        {
            dayOfMonthCount = 28;
        }
    }else if (comps.month == 4 || comps.month == 6 || comps.month == 9 ||comps.month == 11)
    {
        dayOfMonthCount = 30;
    }
    
    [comps setDay:dayOfMonthCount];
    [comps setHour:23];
    [comps setMinute:59];
    [comps setSecond:59];
    NSDate *lastDateOfTheMonth = [[NSDate calendar] dateFromComponents:comps];
    return lastDateOfTheMonth;
}

-(NSDate*)dateOfCurrentMonthAtIdx:(NSInteger)idx {
    NSDate* firstDate = [self firstDateOfTheMonth];
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.day = idx;
    
    return [[NSDate calendar] dateByAddingComponents:components toDate:firstDate options:0];
}

-(NSDate*)firstDateAfterMonthes:(NSInteger)count {
    NSDate* firstDate = [self firstDateOfTheMonth];
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.month = count;
    
    return [[NSDate calendar] dateByAddingComponents:components toDate:firstDate options:0];
}

-(NSInteger)monthesToDate:(NSDate*)toDate {
    if(toDate == nil)
        return 0;
    
    NSDateComponents* components = [[NSDate calendar] components:NSCalendarUnitMonth fromDate:[self firstDateOfTheMonth]  toDate:[toDate firstDateOfTheMonth] options:0];
    return components.month;
}

-(NSDateComponents*)components {
    return [[NSDate calendar] components:( NSCalendarUnitMonth |  NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:self];
}

-(NSInteger)day {
    NSDateComponents* components = [[NSDate calendar] components:(NSCalendarUnitDay) fromDate:self];
    return components.day;
}

-(NSInteger)weekDay {
    NSDateComponents *comps = [[NSDate calendar]  components:NSCalendarUnitWeekday fromDate:self];
    return [comps weekday] - 1;
}

-(NSInteger)month {
    NSDateComponents* components = [[NSDate calendar] components:(NSCalendarUnitMonth) fromDate:self];
    return components.month;
}

-(NSInteger)year {
    NSDateComponents* components = [[NSDate calendar] components:(NSCalendarUnitYear) fromDate:self];
    return components.year;
}

-(BOOL)isYMDEqualToDate:(NSDate*)date {
    if(date == nil)
        return NO;
    
    NSDateComponents* c1 = [self components];
    NSDateComponents* c2 = [date components];
    
    return (c1.year == c2.year && c1.month == c2.month && c1.day == c2.day);
}

-(BOOL)isBeforeDate:(NSDate*)date {
    NSDate* d1 = [self standardizationDate];
    NSDate* d2 = [date standardizationDate];
    
    NSDateComponents* c3 = [[NSDate calendar] components: NSCalendarUnitDay fromDate:d1 toDate:d2 options:0];
    return (c3.day > 0);
}

-(NSString*)monthString {
    NSInteger monthIdx = [self month];
    
    NSArray* months = @[@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月",];
    
    return months[monthIdx - 1];
}

/*
-(NSDate*)firstDateOfPrevMonth {
    return [self firstDateAfterMonthes:-1];
}

-(NSDate*)firstDateOfNextMonth {
    return [self firstDateAfterMonthes:+1];
}
*/

/////@ return the days in a month
+ (NSInteger)numberOfDaysInMonthForDate:(NSDate *)fromDate {
    NSRange range = [[NSDate calendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:fromDate];
    return range.length;
}

-(NSDate*)dateByAddingdays:(NSInteger)dayCount {
    NSDate* dt = [self standardizationDate];
    
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.day = dayCount;
    
    return [[NSDate calendar] dateByAddingComponents:components toDate:dt options:0];
}

-(NSDate*)standardizationDate {
    NSDateComponents* c1 = [self components];
    NSDate* d1 = [self dateFromYear:c1.year month:c1.month day:c1.day];
    
    return d1;
}

- (NSInteger)daysFromDate:(NSDate *)date
{
    NSDateComponents *comps = [[NSDate calendar] components:NSCalendarUnitDay fromDate:date toDate:self options:NSCalendarWrapComponents];
    NSInteger days = comps.day;
    return days;
}

#pragma mark - private

-(NSDate*)dateFromYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    
    NSString* dateStr = [NSString stringWithFormat:@"%d-%02d-%02d 00:00:00", (int)year, (int)month, (int)day];
    
    return [formatter dateFromString:dateStr];
}

- (BOOL)isLeapYear:(NSInteger)year
{
    BOOL isLeapYear;
    if (year % 100)
    {
        isLeapYear = (year % 400) ? NO : YES;
    }
    else
    {
        isLeapYear = (year % 4) ? NO : YES;
    }
    return isLeapYear;
}

@end


//===============================================================================================================

@implementation NSString (Date)

-(NSDate*)dateWithFormat:(NSString*)format {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    
    return [formatter dateFromString:self];
}
@end
