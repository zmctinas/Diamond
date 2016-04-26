//
//  OrderDetailModel.h
//  Diamond
//
//  Created by Pan on 15/9/3.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseModel.h"
#import "OrderDetailEntity.h"
@interface OrderDetailModel : BaseModel

@property (strong, nonatomic) OrderDetailEntity *orderDetail;

- (void)giveMeOrderDetail;

/**
 *  提交订单,cartList不为空 说明是从购物车来的
 */
- (void)submitOrderWithCartList:(NSArray *)cartList;
/**
 *  确认发货操作
 */
- (void)conformWareSended;
/**
 *  确认收货操作
 */
- (void)conformWareGetted;
/**
 *  撤销订单
 */
- (void)cancleOrder;
/**
 *  编辑运费
 */
- (void)editPostage:(NSNumber *)price;
/**
 *  编辑价格
 */
- (void)editTotleFee:(NSNumber *)price;


- (NSString *)easemobToChat:(OrderOwner)owner;
@end
