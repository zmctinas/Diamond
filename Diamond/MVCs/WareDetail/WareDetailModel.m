//
//  WareDetailModel.m
//  Diamond
//
//  Created by Pan on 15/8/4.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "WareDetailModel.h"
#import "WebService+Wares.h"
#import "RequestEntity.h"
#import "GoodsTypeEntity.h"
@interface WareDetailModel ()

@property (nonatomic, strong) RequestEntity *requestEntity;


@end

@implementation WareDetailModel

- (void)giveMeWareInfo:(NSString *)wareID
{
    self.requestEntity.goods_id = wareID;
    [self.webService fetchGoodInfo:self.requestEntity completion:^(BOOL isSuccess, NSString *message, id result)
    {
        if (isSuccess && !message)
        {
            self.ware = result;
            [[NSNotificationCenter defaultCenter] postNotificationName:WARE_DETAIL_GETED_NOTIFICATION object:nil];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
        }
    }];
}


- (void)storeUpWare:(WaresEntity *)ware;
{
    [self.webService storeUpWare:ware.goods_id userID:[UserSession sharedInstance].currentUser.easemob completion:^(BOOL isSuccess, NSString *message, id result)
    {
        if (message)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:STORE_UP_WARE_FAILURE object:@"啊哦，由于网络不稳定，导致收藏失败，请稍后再试试吧。"];
        }
    }];
}


- (void)unStoreUpWare:(NSArray *)wares;
{
    NSMutableArray *arr = [NSMutableArray array];
    for (WaresEntity *ware in wares)
    {
        [arr addObject:ware.goods_id];
    }
    
    [self.webService unStoreUpWare:arr userID:[UserSession sharedInstance].currentUser.easemob completion:^(BOOL isSuccess, NSString *message, id result)
     {
         if (message)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:UN_STORE_UP_WARE_FAILURE object:@"啊哦，由于网络不稳定，导致收藏失败，请稍后再试试吧。"];
         }
     }];
}

- (OrderDetailEntity *)packagingWithWare:(WaresEntity *)ware type:(GoodsTypeEntity *)type count:(NSInteger)count
{
    if (!ware || !type || !count)
    {
        return nil;
    }
    
    OrderDetailEntity *orderDetail = [[OrderDetailEntity alloc] init];
    orderDetail.buyer_easemob = [UserSession sharedInstance].currentUser.easemob;
    orderDetail.seller_easemob = ware.easemob;
    orderDetail.status = OrderStatusWaitCommit;
    orderDetail.count_no = @(count);
    orderDetail.shop_name = ware.shop_name;
    orderDetail.is_promotion = ware.is_promotion;
    
    NSMutableArray *orderWares = [NSMutableArray array];
    OrderWare *orderWare = [[OrderWare alloc] init];
    if (ware.is_promotion)
    {
        orderWare.discount = ware.discount;
    }
    else
    {
        orderWare.discount = @(10);
    }
    
    orderWare.goods_id = ware.goods_id;
    orderWare.goods_name = ware.goods_name;
    orderWare.goods_url = [ware.goods_url firstObject];
    orderWare.nowprice = @(type.price.doubleValue * orderWare.discount.doubleValue / 10);
    orderWare.type_name = type.typeName;
    orderWare.price = type.price;
    orderWare.number = @(count);
    orderWare.discount = ware.discount;
    orderWare.type_id = type.typeId;
    [orderWares addObject:orderWare];
    orderDetail.total_fee = @(orderWare.nowprice.doubleValue * count);
    orderDetail.list = orderWares;
    return orderDetail;
}




- (RequestEntity *)requestEntity
{
    if (!_requestEntity)
    {
        _requestEntity = [[RequestEntity alloc]init];
        _requestEntity.easemob = [UserSession sharedInstance].currentUser.easemob;
        _requestEntity.lat = @([PSLocationManager sharedInstance].currentLocation.coordinate.latitude);
        _requestEntity.lng = @([PSLocationManager sharedInstance].currentLocation.coordinate.longitude);
        _requestEntity.district = [self priorDistrict];
    }
    return _requestEntity;
}
@end
