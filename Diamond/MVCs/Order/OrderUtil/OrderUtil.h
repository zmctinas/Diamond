//
//  OrderUtil.h
//  Diamond
//
//  Created by Pan on 15/9/2.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderEnum.h"

@interface OrderUtil : NSObject

/**
 *  根据订单状态和买家卖家身份来返回相对一的订单状态描述
 *
 *  @param orderOwner 卖家还是买家
 *  @param status     订单状态
 *
 *  @return 
 */
+ (NSString *)statusStringWithOwner:(OrderOwner)orderOwner status:(OrderStatus)status;

/**
 *  把后台传过来的时间戳转换成所需要的时间字符串
 *
 *  @param time 时间戳
 *
 *  @return 直接显示的字符串
 */
+ (NSString *)timeStringWithOrderTime:(NSString *)time;

+ (NSString *)checkBarButtonTitleWithOwner:(OrderOwner)owner status:(OrderStatus)status;
@end
