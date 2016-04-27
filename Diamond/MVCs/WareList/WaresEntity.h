//
//  WaresEntity.h
//  Diamond
//
//  Created by Pan on 15/7/27.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"

/**
 *  商品的实体，所有商品相关的属性都在这里。所有和商品相关的接口都使用这个对象来接数据
 */
@interface WaresEntity : BaseEntity


@property (nonatomic,strong) NSString *goods_name;
@property (nonatomic,strong) NSString *goods_id;
@property (nonatomic,strong) NSArray  *goods_url;/**< 商品图片数组*/

@property (nonatomic,strong) NSNumber *goods_price;/**< 普通价格*/
@property (nonatomic,strong) NSNumber *promotion_price;/**< 特价价格*/
@property (nonatomic,strong) NSNumber *discount;/**< 折扣 */
                                                
@property (nonatomic,strong) NSString *distance;
@property (nonatomic,strong) NSString *introduction;
@property (nonatomic,strong) NSNumber *shop_id;
@property (nonatomic,strong) NSNumber *collec;/**< 商品收藏量*/

@property (nonatomic,strong) NSString *add_time;
@property (nonatomic,strong) NSString *latitude;
@property (nonatomic,strong) NSString *longtitude;
@property (nonatomic,strong) NSString *easemob;
@property (nonatomic,strong) NSString *end_time;
@property (nonatomic,strong) NSString *start_time;

//@property (nonatomic,strong) NSNumber *type_id;/**< 类型id*/
//@property (nonatomic,strong) NSString *type_name;/**< 类型名称 eg.褐色，17码*/
//@property (nonatomic) NSInteger number;/**< 库存*/
@property (nonatomic) BOOL isCollected;/**< 是否已收藏*/

@property (nonatomic) BOOL is_new;/**< 是否新品*/
@property (nonatomic) BOOL is_promotion;/**< 是否特价*/
@property (nonatomic) BOOL is_recommend;/**< 是否推荐*/
@property (nonatomic) BOOL is_sale;/**< 是否在售*/
@property (nonatomic) BOOL is_hot;/**< 是否热销*/

@property (nonatomic,strong) NSArray *type;/**< 商品类型对象集合*/
@property (nonatomic,strong) NSString *brand;
@property (nonatomic,strong) NSString *telNumber;/**< 店铺电话*/
@property (nonatomic,strong) NSString *shop_name;

@property (nonatomic) BOOL is_taoke;/**< 是否淘宝客*/
@property (nonatomic,strong) NSString *externalUrl;/**< 淘宝客链接*/

@end
