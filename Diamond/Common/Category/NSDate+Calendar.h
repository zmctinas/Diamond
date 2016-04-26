//
//  NSDate+Calendar.h
//  AntCalendar
//
//  Created by hudezhi on 15/5/27.
//  Copyright (c) 2015年 hudezhi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate(Calendar)

- (NSDate *)firstDateOfTheMonth;
- (NSDate *)lastDateOfTheMonth;

-(NSDate*)dateOfCurrentMonthAtIdx:(NSInteger)idx;
-(NSDate*)firstDateAfterMonthes:(NSInteger)count;

// 这个标准化是把后面的 时分秒归零为00:00:00
-(NSDate*)standardizationDate;
-(NSDate*)dateByAddingdays:(NSInteger)dayCount;

// 暂时不用~
//-(NSDate*)firstDateOfPrevMonth;
//-(NSDate*)firstDateOfNextMonth;

-(NSInteger)monthesToDate:(NSDate*)toDate;

+ (NSInteger)numberOfDaysInMonthForDate:(NSDate *)fromDate;


-(NSDateComponents*)components;
-(NSInteger)day;
-(NSInteger)weekDay;
-(NSInteger)month;
-(NSInteger)year;

-(BOOL)isYMDEqualToDate:(NSDate*)date;
-(BOOL)isBeforeDate:(NSDate*)date;  // 这个比较也是忽略时分秒的

-(NSString*)monthString;

- (NSInteger)daysFromDate:(NSDate *)date;

@end


@interface NSString (Date)
-(NSDate*)dateWithFormat:(NSString*)format;
@end
