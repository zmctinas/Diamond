//
//  OrderListModel.m
//  Diamond
//
//  Created by Pan on 15/9/1.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "OrderListModel.h"
#import "OrderRequestEntity.h"
#import "WareResponseEntity.h"
#import "WebService+Order.h"

@interface OrderListModel ()

@property (nonatomic, strong) OrderRequestEntity *requestEntity;

@end

@implementation OrderListModel

#pragma mark - Public Method

- (OrderListEntity *)entityInDataSourceWithID:(NSString *)orderID
{
    for (OrderListEntity *listEntity in self.dataSource)
    {
        if ([listEntity.out_trade_no isEqualToString:orderID])
        {
            return listEntity;
        }
    }
    return nil;
}


- (void)giveMeLastestData:(OrderOwner)owner orderStatus:(NSArray *)status
{
    //重置请求数据
    _requestEntity = nil;
    [self giveMeNextData:owner orderStatus:status];
}

- (void)giveMeNextData:(OrderOwner)owner orderStatus:(NSArray *)status
{
    self.requestEntity.status = status;
    
    if (owner == OrderOwnerBuyer)
    {
        [self.webService fetchBuyerOrderList:self.requestEntity completion:^(BOOL isSuccess, NSString *message, id result) {
            if (isSuccess)
            {
                WareResponseEntity *response = result;
                //由于服务端在这个接口 在没有更多数据的时候 传回来的ResultCode是Fail，因此做不同的处理。
                if (self.requestEntity.pages == 1)
                {
                    [self.dataSource removeAllObjects];
                }
                if ([response.data count])
                {
                    [self.dataSource addObjectsFromArray:response.data];
                }
                BOOL noMoreData = YES;
                if (self.requestEntity.pages < response.pages)
                {
                    noMoreData = NO;
                    self.requestEntity.pages++;
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:GET_BUYER_ORDER_LIST object:@(noMoreData)];
            }
        }];
        return;
    }
    
    if (owner == OrderOwnerSeller)
    {
        [self.webService fetchSellerOrderList:self.requestEntity completion:^(BOOL isSuccess, NSString *message, id result) {
            if (isSuccess)
            {
                WareResponseEntity *response = result;
                //由于服务端在这个接口 在没有更多数据的时候 传回来的ResultCode是Failure，因此做不同的处理。
                if (self.requestEntity.pages == 1)
                {
                    [self.dataSource removeAllObjects];
                }
                if ([response.data count])
                {
                    [self.dataSource addObjectsFromArray:response.data];
                }
                BOOL noMoreData = YES;
                if (self.requestEntity.pages < response.pages)
                {
                    noMoreData = NO;
                    self.requestEntity.pages++;
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:GET_SELLER_ORDER_LIST object:@(noMoreData)];
            }
        }];
        return;
    }
}

- (void)conformWareGetted:(NSString *)orderID
{
    [self.webService conformGetted:orderID completion:^(BOOL isSuccess, NSString *message, id result) {
        if (isSuccess && !message)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:CONFORM_ORDER object:orderID];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
        }
        
    }];
}

- (void)conformWareSended:(NSString *)orderID
{
    [self.webService conformSendded:orderID completion:^(BOOL isSuccess, NSString *message, id result) {
        if (isSuccess && !message)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:CONFORM_SEND object:orderID];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
        }
        
    }];
}


#pragma mark - Getter Setter

- (OrderRequestEntity *)requestEntity
{
    if (!_requestEntity)
    {
        _requestEntity = [[OrderRequestEntity alloc]init];
        //FIXME:换回用户自己的easemob
        //        _requestEntity.easemob = @"53301581769";
        _requestEntity.easemob = [UserSession sharedInstance].currentUser.easemob;
        _requestEntity.pages = 1;
    }
    return _requestEntity;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}



@end
