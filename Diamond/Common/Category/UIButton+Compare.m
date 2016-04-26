//
//  UIButton+Compare.m
//  DrivingOrder
//
//  Created by Pan on 15/6/26.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "UIButton+Compare.h"

@implementation UIButton (Compare)

- (NSComparisonResult)compareButton:(UIButton *)button
{
    NSComparisonResult result = [[NSNumber numberWithInteger:self.tag] compare:[NSNumber numberWithInteger:button.tag]];
    return result;
}

@end
