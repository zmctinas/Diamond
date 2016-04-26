//
//  QRCodeGenerator.h
//  Diamond
//
//  Created by Pan on 15/7/25.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QRCodeGenerator : NSObject

/**
 *  生成二维码
 *
 *  @param string 需要转换的字符串
 *  @param size   大小
 *
 *  @return 图片
 */
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size;

/**
 *  生成带头像的二维码
 *
 *  @param twoDimensionCode 二维码
 *  @param avatarImage      头像
 *
 *  @return 带头像的二维码
 */
+ (UIImage *)twoDimensionCodeImage:(UIImage *)twoDimensionCode withAvatarImage:(UIImage *)avatarImage;

@end
