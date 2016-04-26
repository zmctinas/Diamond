//
//  City.m
//  Diamond
//
//  Created by Pan on 15/8/4.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "City.h"

@implementation City

- (instancetype)initWithlatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude
{
    self = [super init];
    if (self)
    {
        _center_lat = latitude;
        _center_lng = longitude;
    }
    return self;
}

@end
