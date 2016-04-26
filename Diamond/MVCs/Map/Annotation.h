//
//  Annotation.h
//  HowFar
//
//  Created by ShawnPan on 15/4/27.
//  Copyright (c) 2015年 ShawnPan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject<MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;


- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                             title:(NSString *)title
                          subtitle:(NSString *)subtitle;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
