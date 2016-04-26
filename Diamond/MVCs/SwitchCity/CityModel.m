//
//  CityModel.m
//  Diamond
//
//  Created by Pan on 15/8/4.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "CityModel.h"
#import "WebService+Other.h"
#import "ChineseToPinyin.h"
#import "CityResponse.h"
@implementation CityModel

- (void)giveMeCityData
{
    [self.webService getCityList:^(BOOL isSuccess, NSString *message, id result)
    {
        if (isSuccess && !message)
        {
            CityResponse *response = result;
            self.cityList = response.city;
            self.hotCities = response.hot;
            self.dataSource = [self sortDataArray:response.city];
            [[NSNotificationCenter defaultCenter] postNotificationName:CITY_LIST_NOTIFICATION object:nil];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
        }
    }];
}

- (void)giveMeDistrictInfo:(City *)city
{
    [self.webService getDistrict:city.cityName completion:^(BOOL isSuccess, NSString *message, id result) {
        if (isSuccess && !message)
        {
            [UserSession sharedInstance].districts = result;
            [[NSNotificationCenter defaultCenter] postNotificationName:DISTRICT_LIST_NOTIFIATION object:nil];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
        }
    }];
}

+ (City *)priorCity
{
    //定位City
    City *locatedCity = [[City alloc]init];
    locatedCity.cityName = [Util stringWithoutLastCharacter:[PSLocationManager sharedInstance].city];
    NSLog(@"%@0.0.0",[PSLocationManager sharedInstance].city);
    NSLog(@"%@0.0.0",[PSLocationManager sharedInstance].district);
    locatedCity.center_lat = @([PSLocationManager sharedInstance].currentLocation.coordinate.latitude);
    locatedCity.center_lng = @([PSLocationManager sharedInstance].currentLocation.coordinate.longitude);
    
    //手选City
    City *choosedCity =  [UserSession sharedInstance].choosedCity;
    if (IS_NULL(locatedCity.cityName) && IS_NULL(choosedCity))
    {
        City *defaultCity = [[City alloc] initWithlatitude:[NSNumber numberWithDouble:30.271817172] longitude:[NSNumber numberWithDouble:120.131567876]];
//        defaultCity.cityName = @"杭州";
        return defaultCity;
    }
    return choosedCity ? choosedCity : locatedCity;
}

- (NSMutableArray *)sortDataArray:(NSArray *)dataArray
{
    //建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    
    [self.sectionTitles removeAllObjects];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    
    //返回27，是a－z和＃
    NSInteger highSection = [self.sectionTitles count];
    //tableView 会被分成27个section
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i <= highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    //名字分section
    for (City *city in dataArray) {
        //cityName是实现中文拼音检索的核心.
        NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:city.cityName];
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:city];
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(City *obj1, City *obj2) {
            NSString *firstLetter1 = [ChineseToPinyin pinyinFromChineseString:obj1.cityName];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [ChineseToPinyin pinyinFromChineseString:obj2.cityName];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    return sortedArray;
}


- (NSMutableArray *)sectionTitles
{
    if (!_sectionTitles)
    {
        _sectionTitles = [NSMutableArray array];
    }
    return _sectionTitles;
}

- (NSMutableArray *)allCities
{
    _allCities = [NSMutableArray arrayWithArray:_cityList];
    [_allCities addObjectsFromArray:_hotCities];
    return _allCities;
}


@end
