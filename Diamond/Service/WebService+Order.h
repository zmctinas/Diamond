//
//  WebService+Order.h
//  Diamond
//
//  Created by Pan on 15/9/1.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "WebService.h"
#import "OrderRequestEntity.h"
#import "DMWechatPrepayEntity.h"
#import "ReceiveGoodsAddressEntity.h"
#import "OrderDetailEntity.h"
#import "OrderSubmitEntity.h"

@interface WebService (Order)

/**
 *  获取订单首页统计数据
 *
 *  @param easemob    用户ID
 *  @param completion 完成回调
 */
- (void)fetchStatisticalData:(NSString *)easemob completion:(DMCompletionBlock)completion;

/**
 *  获取我买到的订单列表
 *
 *  @param requestEntity 请求数据
 *  @param completion  完成回调
 */
- (void)fetchBuyerOrderList:(OrderRequestEntity *)requestEntity completion:(DMCompletionBlock)completion;

/**
 *  获取我卖出的订单列表
 *
 *  @param requestEntity 请求数据
 *  @param completion  完成回调
 */
- (void)fetchSellerOrderList:(OrderRequestEntity *)requestEntity completion:(DMCompletionBlock)completion;

/**
 *  获取订单详情
 *
 *  @param orderID    订单ID
 *  @param completion 完成回调
 */
- (void)fetchOrderDetail:(NSString *)orderID completion:(DMCompletionBlock)completion;

/**
 *  获取微信预支付ID
 *
 *  @param entity
 *  @param completion
 */
- (void)fetchWechatPayParameter:(NSString *)orderID completion:(DMCompletionBlock)completion;

/**
 *  提交订单
 *
 *  @param entity
 *  @param completion
 */
- (void)commitOrder:(OrderSubmitEntity *)entity cartList:(NSArray *)cartList completion:(DMCompletionBlock)completion;
/**
 *  确认收货
 *
 *  @param orderID
 *  @param completion
 */
- (void)conformGetted:(NSString *)orderID completion:(DMCompletionBlock)completion;

/**
 *  确认发货
 *
 *  @param orderID
 *  @param completion 
 */
- (void)conformSendded:(NSString *)orderID completion:(DMCompletionBlock)completion;

/**
 *  关闭订单
 *
 *  @param orderID
 *  @param completion
 */
- (void)cancleOrder:(NSString *)orderID completion:(DMCompletionBlock)completion;

/**
 *  修改运费
 *
 *  @param price      运费价格
 *  @param orderID
 *  @param completion
 */
- (void)editPostage:(NSNumber *)price order:(NSString *)orderID completion:(DMCompletionBlock)completion;

/**
 *  修改订单总价
 *
 *  @param totleFee 订单总价
 *  @param orderID
 *  @param completion
 */
- (void)editTotleFee:(NSNumber *)totleFee order:(NSString *)orderID completion:(DMCompletionBlock)completion;

/**
 *  获取配送地址列表
 *
 *  @param easemob
 *  @param completion
 */
- (void)getAddress:(NSString *)easemob completion:(DMCompletionBlock)completion;
/**
 *  删除地址
 *
 *  @param addressId
 *  @param completion
 */
- (void)deleteAddress:(NSString *)addressId completion:(DMCompletionBlock)completion;
/**
 *  修改地址
 *
 *  @param entity
 *  @param completion
 */
- (void)updateAddress:(ReceiveGoodsAddressEntity *)entity completion:(DMCompletionBlock)completion;
/**
 *  添加地址
 *
 *  @param entity
 *  @param completion
 */
- (void)addAddress:(ReceiveGoodsAddressEntity *)entity completion:(DMCompletionBlock)completion;

@end
