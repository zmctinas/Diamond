//
//  NSDate+Time.h
//  DrivingOrder
//
//  Created by Pan on 15/6/4.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Time)

- (NSDateComponents *)timeComponents;

- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)second;

- (NSDate *)dateAfterHour:(NSInteger)hour;

@end
