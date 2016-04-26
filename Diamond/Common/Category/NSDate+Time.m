//
//  NSDate+Time.m
//  DrivingOrder
//
//  Created by Pan on 15/6/4.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "NSDate+Time.h"

@implementation NSDate (Time)

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

-(NSDateComponents*)timeComponents {
    return [[NSDate calendar] components:( NSCalendarUnitHour |  NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self];
}

-(NSInteger)hour {
    NSDateComponents* components = [[NSDate calendar] components:(NSCalendarUnitHour) fromDate:self];
    return components.hour;
}

-(NSInteger)minute {
    NSDateComponents *comps = [[NSDate calendar]  components:NSCalendarUnitMinute fromDate:self];
    return comps.minute;
}

-(NSInteger)second {
    NSDateComponents* components = [[NSDate calendar] components:(NSCalendarUnitSecond) fromDate:self];
    return components.second;
}


- (NSDate *)dateAfterHour:(NSInteger)hour
{
    NSDateComponents *components = [[NSDateComponents alloc]init];
    components.hour = hour;
    return [[NSDate calendar] dateByAddingComponents:components toDate:self options:0];
}


@end
