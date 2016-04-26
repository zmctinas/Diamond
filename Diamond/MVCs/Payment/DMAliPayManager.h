//
//  DMAliPayManager.h
//  Diamond
//
//  Created by Pan on 15/8/27.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>

@interface DMAliPayManager : NSObject

/**
 *  付款
 *
 *  @param orderNum        订单编号，由商家自定
 *  @param price           价格
 *  @param name            商品描述
 *  @param completionBlock 完成回调
 */
+ (void)payOrder:(NSString*)orderNum withMoney:(CGFloat)price subject:(NSString*)name  completion:(CompletionBlock)completionBlock;

/*!
 是否支付成功
 
 @param resultDic CompletionBlock中的resultDic
 
 @return BOOL
 */
+ (BOOL)isSuccessPayment:(NSDictionary *)resultDic;
@end
