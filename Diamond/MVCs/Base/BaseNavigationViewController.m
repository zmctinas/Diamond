//
//  BaseNavigationViewController.m
//  Diamond
//
//  Created by Pan on 15/7/15.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseNavigationViewController.h"
#import "Macros.h"
@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.navigationBar.tintColor = UIColorFromRGB(GLOBAL_TINTCOLOR);
        self.navigationBar.barTintColor = [UIColor whiteColor];
    }
    return self;
}



@end
