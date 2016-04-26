//
//  Util.h
//  DrivingOrder
//
//  Created by Pan on 15/5/30.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Macros.h"
#import <CoreLocation/CoreLocation.h>
#import "ShopEnum.h"


@interface Util : NSObject
/**
 *  output a formatted string @"yyyy-MM-dd HH:mm:ss"
 *
 *  @param date
 *
 *  @return  string by Formatted @"yyyy-MM-dd HH:mm:ss"
 */
+ (NSString *)stringFormDate:(NSDate *)date;
+ (NSString *)stringFormDate:(NSDate *)date WithFormater:(NSString *)formatter;

/**
 *  将图片转化为Base64的String
 *
 *  @param image UIImage
 *
 *  @return Base64编码的NSString
 */
+ (NSString *)base64StringWithImage:(UIImage *)image;

/**
 *  output a formatted date @"yyyy-MM-dd HH:mm:ss"
 *
 *  @param date
 *
 *  @return  date by Formatted @"yyyy-MM-dd HH:mm:ss"
 */
+(NSDate *)dateFromString:(NSString*)string;


/**
 *  NSString值为Unicode格式的字符串编码(如\\u7E8C)转换成中文
 *
 *  @param unicodeStr
 *
 *  @return
 */
+ (NSString *)replaceUnicode:(NSString *)unicodeStr;

/**
 *  获取目标字符串的MD5值
 *
 *  @param src 目标字符串
 *
 *  @return MD5字符串
 */
+ (NSString *)md5:(NSString *)src;

/**
 *  根据经纬度计算两个点之间的距离
 *
 *  @param location  自己的坐标
 *  @param otherLocation 对方的坐标
 *
 *  @return 距离 米
 */
+ (double)distanceBetweenLocation:(CLLocation *)location AndLocation:(CLLocation *)otherLocation;


+ (NSString *)stringWithDistance:(double)distance;
/**
 *  删除字符串最后一个字。
 *
 *  @param aString 传入字符串  如 浙江省
 *
 *  @return 传出字符串  如 浙江
 */
+ (NSString *)stringWithoutLastCharacter:(NSString *)aString;

/**
 *  仅限本项目使用，将path组装成URL
 *
 *  @param path 路径
 *
 *  @return 完整的URL
 */
+ (NSString *)urlStringWithPath:(NSString *)path;

/**
 *  仅限本项目使用，将path组装成URL
 *
 *  @param path 路径
 *
 *  @return 完整的URL
 */
+ (NSURL *)urlWithPath:(NSString *)path;

/**
 *  返回带删除线的AttributedString
 *
 *  @param string 原始String
 *
 *  @return AttributedString
 */
+ (NSAttributedString *)deleteLineStyleString:(NSString *)string;

/**
 *  统一的显示价格的方式
 *
 *  @param price double
 *
 *  @return NSString
 */
+ (NSString *)priceStringWithPrice:(CGFloat)price;

/**
 *  调用系统自带拨打电话功能
 *
 *  @param phoneNumber 电话号码
 */
+ (void)callWithPhoneNumber:(NSString *)phoneNumber;

/**
 *  验证输入的手机号码是否正确
 *
 *  @param phoneNumber
 *
 *  @return 
 */
+ (BOOL)evaluatePhoneNumber:(NSString *)phoneNumber;

/**
 *  倒计时文字
 *
 *  @param date 结束日期
 *
 *  @return 倒计时文字
 */
+ (NSString *)countDownStringWithDate:(NSDate *)date;

/**
 *  获取店铺类型的名字
 *
 *  @param type
 *
 *  @return 如“美食”
 */
+ (NSString *)shopTitleWithType:(NSInteger)type;

+ (NSString *)shareUrlWithShopId:(NSNumber *)shopId;
@end
