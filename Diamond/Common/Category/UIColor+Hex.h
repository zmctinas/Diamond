//
//  UIColor+Hex.h
//  Diamond
//
//  Created by Leon Hu on 15/10/23.
//  Copyright © 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

//默认alpha值为1
+ (UIColor *)colorWithHexString:(NSString *)color;

@end
