//
//  PSLocationManager.h
//  Diamond
//
//  Created by Pan on 15/7/22.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern NSString * const CURRENT_LOCATION_UPDATE_NOTIFICATION;
extern NSString * const PLACEMARK_UPDATE_NOTIFICATION;

@interface PSLocationManager : NSObject


@property (nonatomic, strong) CLLocation  *currentLocation;/**< 当前位置*/
@property (nonatomic, strong) NSString    *province;/**< 省*/
@property (nonatomic, strong) NSString    *city;/**< 市*/
@property (nonatomic, strong) NSString    *district;/**< 区*/
@property (nonatomic, strong) CLPlacemark *placemark;/**< 地理经纬度反编码获得的地点*/

+ (PSLocationManager *)sharedInstance;/**< 单例*/

/**
 *  开始定位
 */
- (void)startLocation;

/**
 *  停止定位
 */
- (void)stopLocating;

@end
