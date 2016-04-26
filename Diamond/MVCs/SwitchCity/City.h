//
//  City.h
//  Diamond
//
//  Created by Pan on 15/8/4.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"

@interface City : BaseEntity

- (instancetype)initWithlatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude;


@property (nonatomic, strong) NSNumber *cityCode;
@property (nonatomic, strong) NSNumber *center_lat;
@property (nonatomic, strong) NSNumber *center_lng;
@property (nonatomic, strong) NSString *center_district;
@property (nonatomic, strong) NSString *cityName;


@end
