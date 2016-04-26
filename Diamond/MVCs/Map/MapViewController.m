//
//  MapViewController.m
//  Diamond
//
//  Created by Pan on 15/8/7.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MapViewController.h"
#import "Annotation.h"

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,getter = isScale) BOOL scale;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.mapView addAnnotation:[self annotation]];
    [self addLeftBarButtonItem];
}

#pragma mark - MapView Delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (!self.isScale)//第一次进入地图时，将地图可视范围缩放到本人所在城市
    {
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate,10000,10000);
        [self.mapView setRegion:region animated:YES];
        self.scale = YES;
    }
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [alert show];
}

- (Annotation *)annotation
{
    Annotation *annotation = [[Annotation alloc]initWithCoordinate:self.location.coordinate
                                                                 title:@""
                                                              subtitle:@""];
    return annotation;
}
@end
