//
//  MainModel.h
//  Diamond
//
//  Created by Pan on 15/7/20.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseModel.h"
#import "City.h"
#import <CoreLocation/CoreLocation.h>

@interface MainModel : BaseModel


@property (nonatomic, strong) NSArray *carouselDatas;/**< 接口回传的数据数组，CarouselEntity*/

@property (nonatomic, strong) NSMutableArray *imageURLs;/**< 轮播图片的URL*/

- (void)giveMeCarouselData:(City *)city district:(NSString *)district;

@end
