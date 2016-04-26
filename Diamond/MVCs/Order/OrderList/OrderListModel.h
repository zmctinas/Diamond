//
//  OrderListModel.h
//  Diamond
//
//  Created by Pan on 15/9/1.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseModel.h"
#import "OrderListEntity.h"

@interface OrderListModel : BaseModel

@property (strong, nonatomic)  NSMutableArray *dataSource;

/**
 *  下拉刷新调用这个数据
 */
- (void)giveMeLastestData:(OrderOwner)owner orderStatus:(NSArray *)status;

/**
 *  上拉加载调用这个数据
 */
- (void)giveMeNextData:(OrderOwner)owner orderStatus:(NSArray *)status;

/**
 *  确认发货操作
 */
- (void)conformWareSended:(NSString *)orderID;

/**
 *  确认收货操作
 */
- (void)conformWareGetted:(NSString *)orderID;



- (OrderListEntity *)entityInDataSourceWithID:(NSString *)orderID;

@end

