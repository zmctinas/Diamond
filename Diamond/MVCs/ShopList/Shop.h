//
//  Shop.h
//  Diamond
//
//  Created by Pan on 15/7/14.
//  Copyright (c) 2015年 Pan. All rights reserved.
//
#import "BaseEntity.h"

@interface Shop : BaseEntity


@property (nonatomic) NSInteger shop_id;
@property (nonatomic, strong) NSString *shop_name;/**< 店铺名称*/
@property (nonatomic, strong) NSString *address;/**< 店铺地址*/
@property (nonatomic, strong) NSString *Introduction;/**< 店铺介绍*/
@property (nonatomic, strong) NSArray  *cat_id;/**< NSArray<NSNumber>  店铺类型*/
@property (nonatomic, strong) NSNumber *levels;/**< 店铺等级*/
@property (nonatomic, strong) NSArray  *shop_ad;/**< 店铺广告图URL*/

@property (nonatomic, strong) NSString *sale_start_time;/**< 开门时间*/
@property (nonatomic, strong) NSString *sale_end_time;/**< 打烊时间*/
@property (nonatomic, strong) NSNumber *cityCode;/**< 百度地图的点*/
@property (nonatomic, strong) NSString *easemob;/**< 店主代忙号/环信号*/
@property (nonatomic, strong) NSString *add_time;/**< 添加时间 */
@property (nonatomic, strong) NSNumber *shopcollec;/**< 店铺收藏数*/
@property (nonatomic, strong) NSNumber *isCollected;/**< 是否已收藏本店*/
@property (strong, nonatomic) NSString *phoneNumber;/**< 电话号码*/
@property (strong, nonatomic) NSString *ali_pay;/**< 店铺的支付宝账号*/
@property (strong, nonatomic) NSString *wchat_pay;/**< 店铺的微信账号*/

/**
 *  纬度
 */
@property (nonatomic) double latitude;
/**
 *  经度
 */
@property (nonatomic) double longtitude;
/**
 *  距离
 */
@property (nonatomic) double distance;
/**
 *  是否是热销铺子
 */
@property (nonatomic) BOOL is_hot;
/**
 *  <#Description#>
 */
@property (nonatomic) BOOL is_open;
/**
 *  是否是新铺
 */
@property (nonatomic) BOOL is_new;
/**
 *  是否是小二推荐
 */
@property (nonatomic) BOOL is_recommend;
/**
 *  是否是限时特价
 */
@property (nonatomic) BOOL is_promotion;
/**
 *  省
 */
@property (nonatomic,strong) NSString *province;
/**
 *  市
 */
@property (nonatomic,strong) NSString *city;
/**
 *  区
 */
@property (nonatomic,strong) NSString *district;

@property (nonatomic,strong) NSString *poi_id;
/**
 *  商铺收藏量
 */
//@property (nonatomic,strong) NSString *collec NS_DEPRECATED_IOS(1.1.1, 1.1.2);
/**
 *  浏览量
 */
//@property (nonatomic,strong) NSString *view NS_DEPRECATED_IOS(1.1.1, 1.1.2);
/**
 *  小二昵称
 */
@property (nonatomic,strong) NSString *user_name;
/**
 *  折扣率
 */
@property (nonatomic,strong) NSNumber *discount;
/**
 *  免费配送距离
 */
@property (nonatomic) NSInteger delivery_distance;
/**
 *  多少金额以上免费
 */
@property (nonatomic,strong) NSNumber *delivery_limit;

//@property (nonatomic, strong) NSString *telNumber NS_DEPRECATED_IOS(1.1.1, 1.1.2)

@end
