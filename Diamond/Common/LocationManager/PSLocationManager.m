//
//  PSLocationManager.m
//  Diamond
//
//  Created by Pan on 15/7/22.
//  Copyright (c) 2015年 Pan. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "PSLocationManager.h"
#import "Macros.h"

NSString * const CURRENT_LOCATION_UPDATE_NOTIFICATION = @"定位信息改变了";
NSString * const PLACEMARK_UPDATE_NOTIFICATION = @"反编码更新";


@interface PSLocationManager()<CLLocationManagerDelegate>


@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation PSLocationManager

static PSLocationManager *sharedInstance = nil;

+ (PSLocationManager *)sharedInstance
{
    static dispatch_once_t onceQueue;
    
    dispatch_once(&onceQueue, ^{
        sharedInstance = [[PSLocationManager alloc] init];
    });
    
    return sharedInstance;
}


- (void)startLocation
{
    int status = [CLLocationManager authorizationStatus];
    if (status >= kCLAuthorizationStatusAuthorizedAlways){[self.locationManager startUpdatingLocation]; return;}
    if (status == kCLAuthorizationStatusNotDetermined){[self.locationManager requestWhenInUseAuthorization]; return;}
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您没有开启定位权限，请到系统设置中开启定位权限，否则将无法正常使用本app" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)stopLocating
{
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    //定位权限改变时，如果是变成允许，那么就开始更新位置
    if (status >= kCLAuthorizationStatusAuthorizedAlways){[self.locationManager startUpdatingLocation];}
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations firstObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //反编码地理位置
    [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *array, NSError *error) {
        if (!error && array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            self.placemark = placemark;
            self.province = placemark.administrativeArea;
            self.city = placemark.locality;
            self.district = placemark.subLocality;
            [[NSNotificationCenter defaultCenter] postNotificationName:PLACEMARK_UPDATE_NOTIFICATION object:nil];
        }
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:CURRENT_LOCATION_UPDATE_NOTIFICATION object:nil];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    DLog(@"%@",error.localizedDescription);
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager)
    {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 3.0;
        _locationManager.delegate = self;
    }
    return _locationManager;
}
@end
