//
//  ShopDetailModel.m
//  Diamond
//
//  Created by Pan on 15/7/30.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ShopDetailModel.h"
#import "WebService+Shop.h"
#import "WebService+Wares.h"
#import "RequestEntity.h"
#import "PSLocationManager.h"
@interface ShopDetailModel ()

@property (nonatomic, strong) RequestEntity *requestEntity;


@end

@implementation ShopDetailModel


- (void)giveMeShopInfo:(Shop *)shop
{
    self.requestEntity.shop_id = @(shop.shop_id);
    [self.webService fetchShopDetailInfo:self.requestEntity completion:^(BOOL isSuccess, NSString *message, id result)
    {
        if (isSuccess && !message)
        {
            self.shop = result;
            [[NSNotificationCenter defaultCenter] postNotificationName:SHOP_DETAIL_GETTED_NOTIFICATION object:result];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
        }
    }];
}

- (void)giveMeAllOfShopGoodsByShopId:(NSInteger)shopId
{
    [self.dataSource removeAllObjects];
    self.requestEntity.shop_id = [NSNumber numberWithInteger:shopId];
    self.requestEntity.all = YES;
    [self.webService fetchMyShopGoods:self.requestEntity completion:^(BOOL isSuccess, NSString *message, id result) {
        if (isSuccess)
        {
            if ([result count])
            {
                [self.dataSource addObjectsFromArray:result];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:SHOP_GOODS_LIST_GETTED_NOTIFICATION object:result];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
        }
    }];
}

- (void)giveMeShopGoodsByShopId:(NSInteger)shopId
{
    [self.dataSource removeAllObjects];
    self.requestEntity.shop_id = [NSNumber numberWithInteger:shopId];
    [self.webService fetchMyShopGoods:self.requestEntity completion:^(BOOL isSuccess, NSString *message, id result) {
        if (isSuccess)
        {
            if ([result count])
            {
                [self.dataSource addObjectsFromArray:result];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:SHOP_GOODS_LIST_GETTED_NOTIFICATION object:result];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
        }
    }];
}

- (void)giveMeShopGoods:(Shop *)shop
{
    [self giveMeShopGoodsByShopId:shop.shop_id];
}

- (void)storeUpShop:(Shop *)shop
{
    [self.webService storeUpShop:@(shop.shop_id) userID:[UserSession sharedInstance].currentUser.easemob completion:^(BOOL isSuccess, NSString *message, id result)
    {
        if (message)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:STORE_UP_SHOP_RESULT object:@"啊哦，由于网络不稳定，导致收藏失败，请稍后再试试吧。"];
        }
    }];
}

- (void)unStoreUpShop:(NSArray *)shops;
{
    NSMutableArray *shopIDs = [NSMutableArray array];
    for (Shop *shop in shops)
    {
        [shopIDs addObject:@(shop.shop_id)];
    }
    
    [self.webService unStoreUpShop:shopIDs userID:[UserSession sharedInstance].currentUser.easemob completion:^(BOOL isSuccess, NSString *message, id result)
     {
         if (message)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:UN_STORE_UP_SHOP_FAILURE object:@"啊哦，由于网络不稳定，导致删除收藏失败，请稍后再试试吧。"];
         }
     }];
}

- (RequestEntity *)requestEntity
{
    if (!_requestEntity)
    {
        _requestEntity = [[RequestEntity alloc]init];
        _requestEntity.lat = @([PSLocationManager sharedInstance].currentLocation.coordinate.latitude);
        _requestEntity.lng = @([PSLocationManager sharedInstance].currentLocation.coordinate.longitude);
        _requestEntity.district = [PSLocationManager sharedInstance].district;
        _requestEntity.district = [self priorDistrict];
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
