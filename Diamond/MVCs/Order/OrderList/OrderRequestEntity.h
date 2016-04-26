//
//  OrderRequestEntity.h
//  Diamond
//
//  Created by Pan on 15/9/1.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"
#import "OrderEnum.h"

@interface OrderRequestEntity : BaseEntity

@property (nonatomic,strong) NSString *easemob;/**< 环信账号*/
@property (nonatomic) NSInteger pages;/**< 页码*/
@property (nonatomic) NSArray *status;/**< 获取哪种数据 全部 未付款 已付款 交易成功*/


@end
