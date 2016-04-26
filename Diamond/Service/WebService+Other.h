//
//  WebService+Other.h
//  Diamond
//
//  Created by Pan on 15/7/20.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "WebService.h"
#import "City.h"
#import "RequestEntity.h"
@interface WebService (Other)

/**
 *  获取主页轮播数据
 *
 *  @param latituede   经度
 *  @param longtituede 纬度
 *  @param completion  完成回调
 */
- (void)getCarouselWithLatitude:(double)latitude
                     longtitude:(double)longtituede
                       district:(NSString *)district
                     completion:(DMCompletionBlock)completion;

/**
 *  获取城市信息
 *
 *  @param completion 完成回调
 */
- (void)getCityList:(DMCompletionBlock)completion;

/**
 *  搜索
 *
 *  @param requestInfo 请求数据
 *  @param completion  完成回调
 */
- (void)search:(RequestEntity *)requestInfo completion:(DMCompletionBlock)completion;

/**
 *  获取区域信息
 *
 *  @param cityName   城市名
 *  @param completion 完成回调
 */
- (void)getDistrict:(NSString *)cityName completion:(DMCompletionBlock)completion;
@end
