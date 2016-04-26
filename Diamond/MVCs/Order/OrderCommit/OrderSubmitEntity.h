//
//  OrderSubmitEntity.h
//  Diamond
//
//  Created by Pan on 15/9/10.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"
#import "OrderEnum.h"

@interface OrderSubmitEntity : BaseEntity

@property (strong, nonatomic) NSArray *list;/**< <OrderWare> */

@property (strong, nonatomic) NSNumber *total_fee;/**< 总计价格*/
@property (strong, nonatomic) NSNumber *delivery_fee;/**< 运费*/
@property (strong, nonatomic) NSString *introduction;/**< 订单备注*/
@property (strong, nonatomic) NSString *seller_easemob;/**< 卖家订单号*/
@property (strong, nonatomic) NSString *buyer_easemob;/**< 买家订单号*/
@property (strong, nonatomic) NSNumber *delivery_address;/**< 配送地址的ID*/


@property (nonatomic) DeliveryType delivery_type;/**< 配送方式*/
@property (nonatomic) PaymentType payment_type;/**< 付款方式*/


@end
