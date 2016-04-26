//
//  PaymentModel.m
//  Diamond
//
//  Created by Pan on 15/9/6.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "PaymentModel.h"
#import "DMAliPayManager.h"
#import "DMWechatPayManager.h"
#import "WebService+Order.h"

@implementation PaymentModel


- (void)payWithAlipay
{
    NSString *introduction = [NSString stringWithFormat:@"代忙商品:%@",self.waitPayOrder.out_trade_no];
    [DMAliPayManager payOrder:self.waitPayOrder.out_trade_no
                    withMoney:[self.waitPayOrder.total_fee doubleValue]
                      subject:introduction
                   completion:^(NSDictionary *resultDic)
     {
         [[NSNotificationCenter defaultCenter] postNotificationName:ALIPAY_RESULT object:@([DMAliPayManager isSuccessPayment:resultDic])];
         [[NSNotificationCenter defaultCenter] postNotificationName:PaySuccessNotification object:nil];
     }];
}

- (void)payWithWechat
{
    [self giveMeprepareID:self.waitPayOrder.out_trade_no];
}

- (void)giveMeprepareID:(NSString *)orderID;
{
    [self.webService fetchWechatPayParameter:orderID completion:^(BOOL isSuccess, NSString *message, id result) {
        if (isSuccess && !message)
        {
            [[DMWechatPayManager sharedManager] payWithPrepayEntity:result];
            [[NSNotificationCenter defaultCenter] postNotificationName:PaySuccessNotification object:nil];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
        }
    }];
}



@end
