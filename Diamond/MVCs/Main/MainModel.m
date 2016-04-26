//
//  MainModel.m
//  Diamond
//
//  Created by Pan on 15/7/20.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "MainModel.h"
#import "WebService+Other.h"
#import "CarouselEntity.h"

@interface MainModel()



@end

@implementation MainModel

- (void)giveMeCarouselData:(City *)city district:(NSString *)district
{
    [self.webService getCarouselWithLatitude:[city.center_lat doubleValue]
                                  longtitude:[city.center_lng doubleValue]
                                    district:district
                                  completion:^(BOOL isSuccess, NSString *message, id result) {
                                      if (isSuccess && !message)
                                      {
                                          self.carouselDatas = result;
                                          [self.imageURLs removeAllObjects];
                                          for (CarouselEntity *entity in result)
                                          {
                                              NSURL *imageRUL = [Util urlWithPath:entity.image_url];
                                              [self.imageURLs addObject:imageRUL];
                                          }
                                          [[NSNotificationCenter defaultCenter] postNotificationName:BANNER_DATA_GETTED_NOTIFICATION object:nil];
                                      }
                                      else
                                      {
                                          [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
                                      }

                                  }];
}

#pragma mark - Getter and Setter

- (NSMutableArray *)imageURLs
{
    if (!_imageURLs)
    {
        _imageURLs = [NSMutableArray array];
    }
    return _imageURLs;
}


@end
