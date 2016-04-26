//
//  UIButton+Category_h.m
//  Diamond
//
//  Created by Leon Hu on 15/9/30.
//  Copyright © 2015年 Pan. All rights reserved.
//

#import "UIButton+Category.h"

@implementation UIButton (Category)

- (void)setDefaultLoadingImage
{
    [self setImage:[UIImage imageNamed:@"seller_home_pic_jiazai"] forState:UIControlStateNormal];
}

@end
