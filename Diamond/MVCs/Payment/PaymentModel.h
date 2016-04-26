//
//  PaymentModel.h
//  Diamond
//
//  Created by Pan on 15/9/6.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseModel.h"
#import "OrderDetailEntity.h"

@interface PaymentModel : BaseModel

@property (strong, nonatomic) OrderDetailEntity *waitPayOrder;

- (void)payWithAlipay;
- (void)payWithWechat;

@end
