//
//  Annotation.m
//  HowFar
//
//  Created by ShawnPan on 15/4/27.
//  Copyright (c) 2015年 ShawnPan. All rights reserved.
//

#import "Annotation.h"
@interface Annotation()

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, readwrite, copy) NSString *subtitle;

@end

@implementation Annotation

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle
{
    self = [super init];
    if (self)
    {
        self.coordinate = coordinate;
        self.title = title;
        self.subtitle = subtitle;
    }
    return self;
}


@end
