//
//  CityModel.h
//  Diamond
//
//  Created by Pan on 15/8/4.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseModel.h"
#import "City.h"
@interface CityModel : BaseModel

@property (nonatomic, strong) NSMutableArray *dataSource;/**< 排序且添加SectionTitle的城市数组*/
@property (nonatomic, strong) NSMutableArray *sectionTitles;/**< 城市按字母排序的字*/
@property (nonatomic, strong) NSArray *cityList;/**< 原始未排序的城市数组,非热门城市*/
@property (nonatomic, strong) NSArray *hotCities;/**< 热门城市*/
@property (nonatomic, strong) NSMutableArray *allCities;/**< 热门城市+非热门城市，由于服务端把热门与非热门城市分开，因此创建此Get属性，便于处理数据。*/

- (void)giveMeCityData;

/**
 *  获取该城市的区域信息
 *
 *  @param cityName 
 */
- (void)giveMeDistrictInfo:(City *)city;

/**
 *  返回优先级高的城市信息
 */
+ (City *)priorCity;
@end
