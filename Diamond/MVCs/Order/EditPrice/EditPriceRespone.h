//
//  EditPriceRespone.h
//  Diamond
//
//  Created by Pan on 15/9/15.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"

@interface EditPriceRespone : BaseEntity

@property (strong, nonatomic) NSNumber *delivery_fee;/**< 运费*/
@property (strong, nonatomic) NSNumber *old_total_fee;/**< 旧的总价*/
@property (strong, nonatomic) NSNumber *total_fee;/**< 新的总价*/
@property (strong, nonatomic) NSNumber *out_trade_no;/**< 订单号*/

@end
