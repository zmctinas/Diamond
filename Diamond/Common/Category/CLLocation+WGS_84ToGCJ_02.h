//
//  CLLocation+WGS_84ToGCJ_02.h
//  HowFar
//
//  Created by 潘晟 on 15-4-8.
//  Copyright (c) 2015年 ShawnPan. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (WGS_84ToGCJ_02)

+ (BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;

+ (CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;

@end
