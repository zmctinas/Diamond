//
//  OrderIndexModel.h
//  Diamond
//
//  Created by Pan on 15/9/15.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseModel.h"
#import "OrderIndexEntity.h"
@interface OrderIndexModel : BaseModel

@property (strong, nonatomic) OrderIndexEntity *statistics;

/**
 *  获取订单首页的统计数据
 */
- (void)giveMeStatisticalData;

@end
