//
//  OrderDetailEntity.h
//  Diamond
//
//  Created by Pan on 15/9/1.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"
#import "OrderEnum.h"
#import "ReceiveGoodsAddressEntity.h"
#import "OrderListEntity.h"

@interface OrderDetailEntity : BaseEntity

@property (strong, nonatomic) ReceiveGoodsAddressEntity *consigneeAddress;
@property (strong, nonatomic) NSArray *list;/**< <OrderWare> */

@property (strong, nonatomic) NSString *out_trade_no;/**< 商户订单号*/
@property (strong, nonatomic) NSNumber *count_no;/**< 该订单商品总数*/
@property (strong, nonatomic) NSNumber *total_fee;/**< 总计价格*/
@property (strong, nonatomic) NSNumber *delivery_fee;/**< 运费*/
@property (strong, nonatomic) NSString *introduction;/**< 订单备注*/
@property (strong, nonatomic) NSString *add_time;/**< 下单时间*/
@property (strong, nonatomic) NSString *shop_name;
@property (strong, nonatomic) NSString *seller_easemob;/**< 卖家easemob*/
@property (strong, nonatomic) NSString *seller_name;/**< 卖家名字*/
@property (strong, nonatomic) NSString *buyer_easemob;/**< 买家easemob*/
@property (strong, nonatomic) NSString *buyer_name;/**< 买家名字*/
@property (strong, nonatomic) NSNumber *delivery_address;/**< 配送地址的ID*/
@property (strong, nonatomic) NSNumber *old_total_fee;/**< 旧的价格*/

@property (nonatomic) NSInteger shop_id;

@property (nonatomic) DeliveryType delivery_type;/**< 配送方式*/
@property (nonatomic) PaymentType payment_type;/**< 付款方式*/
@property (nonatomic) OrderStatus status;

@property (strong, nonatomic) NSString *formattedTime;/**< GET 属性。把服务端传过来的时间戳转化成需要的格式*/
@property (strong, nonatomic) NSString *deliveryTypeString;/**< GET 属性。把服务器传过来的配送方式转化成字符串*/

@property (nonatomic) BOOL is_promotion;/**< 是否特价*/

@end
