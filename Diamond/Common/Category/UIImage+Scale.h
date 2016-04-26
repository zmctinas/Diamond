//
//  UIImage+Scale.h
//  DrivingOrder
//
//  Created by Pan on 15/6/5.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)

- (UIImage *)transformWidth:(CGFloat)width height:(CGFloat)height;

- (double)ratioForImageToScaleWithMaxWidthOrHeight:(CGFloat)widthOrHeight;

- (UIImage *)transformWithRatio:(double)ratio;

- (UIImage *)transformWithMaxWidthOrHeight:(CGFloat)widthOrHeight;

@end
