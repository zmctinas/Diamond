//
//  OrderListEntity.h
//  Diamond
//
//  Created by Pan on 15/8/31.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"
#import "OrderEnum.h"

@interface OrderListEntity : BaseEntity

@property (strong, nonatomic) NSArray *list;/**< 本订单的商品*/

#pragma mark - 两个接口公用的属性
@property (strong, nonatomic) NSString *out_trade_no;/**< 商户订单号*/
@property (strong, nonatomic) NSNumber *count_no;/**< 该订单商品总数*/
@property (strong, nonatomic) NSNumber *total_fee;/**< 总计价格*/
@property (strong, nonatomic) NSNumber *delivery_fee;/**< 运费*/
@property (strong, nonatomic) NSString *introduction;/**< 订单备注*/
@property (strong, nonatomic) NSString *add_time;/**< 下单时间*/
@property (strong, nonatomic) NSNumber *old_total_fee;/**< 旧的价格*/

@property (nonatomic) OrderStatus status;


#pragma mark - getBuyerOrderList接口专用属性
@property (strong, nonatomic) NSNumber *shop_id;
@property (strong, nonatomic) NSString *shop_name;
@property (strong, nonatomic) NSString *seller_easemob;/**< 卖家订单号*/


#pragma mark - getSellerOrderList接口专用属性
@property (strong, nonatomic) NSString *buyer_easemob;/**< 卖家订单号*/


@end


@interface OrderWare : BaseEntity

@property (nonatomic,strong) NSString *goods_id;
@property (nonatomic,strong) NSString *goods_name;
@property (nonatomic,strong) NSString *goods_url;/**< 商品图片数组*/
@property (nonatomic,strong) NSNumber *type_id;/**< 类型id*/
@property (nonatomic,strong) NSString *type_name;/**< 类型名称 eg.褐色，17码*/
@property (nonatomic,strong) NSNumber *price;/**< 旧的价格*/
@property (nonatomic,strong) NSNumber *nowprice;/**< 普通价格*/
@property (nonatomic,strong) NSNumber *number;/**< 单品购买数量*/
@property (nonatomic,strong) NSNumber *discount;/**< 折扣率0.0 - 10  10代表不打折*/
@end