//
//  CityResponse.h
//  Diamond
//
//  Created by Pan on 15/8/4.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"

@interface CityResponse : BaseEntity

@property (nonatomic, strong) NSArray *hot;/**< 热门城市列表*/
@property (nonatomic, strong) NSArray *city;/**< 城市列表*/


@end
