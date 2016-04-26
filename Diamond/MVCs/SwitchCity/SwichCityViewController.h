//
//  SwichCityViewController.h
//  Diamond
//
//  Created by Pan on 15/8/4.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseViewController.h"
#import "City.h"

@protocol SwichCityDelegate <NSObject>

- (void)didSelectedCity:(City *)city;

@end


@interface SwichCityViewController : BaseViewController

@property (nonatomic, weak) id<SwichCityDelegate> delegate;


@end
