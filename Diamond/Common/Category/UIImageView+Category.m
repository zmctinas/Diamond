//
//  UIImageView+Category.m
//  Diamond
//
//  Created by Leon Hu on 15/8/8.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "UIImageView+Category.h"

@implementation UIImageView (Category)

- (void)setDefaultLoadingImage
{
    [self setImage:[UIImage imageNamed:@"seller_home_pic_jiazai"]];
}

- (void)setDefaultHeaderImage
{
    [self setImage:[UIImage imageNamed:@"seller_home_touxiang"]];
}

@end
