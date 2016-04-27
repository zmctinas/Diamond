//
//  ShopModel.m
//  Diamond
//
//  Created by Pan on 15/7/30.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ShopModel.h"
#import "PSLocationManager.h"
#import "CityModel.h"
@interface ShopModel ()

@property (nonatomic, strong) RequestEntity *requestEntity;

@end

@implementation ShopModel

- (void)giveMeLastestData:(ShopType)type
{
    //重置请求数据
    _requestEntity = nil;
    
    [self giveMeNextData:type];
}

- (void)giveMeNextData:(ShopType)type
{
    if (type == ShopTypeHot)
    {
        [self fetchHotShopData];
        return;
    }
    
    if (type == ShopTypeNew)
    {
        [self fetchNewShopData];
        return;
    }
    
    [self fetchShopCategoryData:type];
}

#pragma mark - Private

- (void)fetchHotShopData
{
    [self.webService fetchHotShops:self.requestEntity completion:^(BOOL isSuccess, NSString *message, id result) {
        if (isSuccess)
        {
            [self handleResult:result];
        }
    }];
}

- (void)fetchNewShopData
{
    [self.webService fetchNewShops:self.requestEntity completion:^(BOOL isSuccess, NSString *message, id result) {
        if (isSuccess)
        {
            [self handleResult:result];

        }
    }];
}

/**
 *  获取16个分类的店铺数据
 *
 *  @param type
 */
- (void)fetchShopCategoryData:(ShopType)type
{
    self.requestEntity.cat_id = @(type);
    [self.webService fetchCategorShops:self.requestEntity completion:^(BOOL isSuccess, NSString *message, id result)
    {
        if (isSuccess)
        {
            NSLog(@"%@",result);
            [self handleResult:result];
        }
    }];
}

- (void)giveMeDaimangActivityShops:(NSNumber *)activityID
{
    [self.webService getActivityMenber:activityID completion:^(BOOL isSuccess, NSString *message, id result)
     {
         if (isSuccess)
         {
             if ([result count])
             {
                 [self.dataSource addObjectsFromArray:result];
             }
             [[NSNotificationCenter defaultCenter] postNotificationName:SHOP_DATA_GETTED_NOTIFICATIOIN object:nil];
         }
     }];
}

- (void)handleResult:(id)result
{
    ShopResponseEntity *response = result;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOP_DATA_GETTED_NOTIFICATIOIN object:@(noMoreData)];
}



#pragma mark - Getter and Setter


- (RequestEntity *)requestEntity
{
    if (!_requestEntity)
    {
        _requestEntity = [[RequestEntity alloc]init];
        _requestEntity.lat = @([PSLocationManager sharedInstance].currentLocation.coordinate.latitude);
        _requestEntity.lng = @([PSLocationManager sharedInstance].currentLocation.coordinate.longitude);
        _requestEntity.district = [self priorDistrict];
        _requestEntity.pages = 1;
        NSString *city = [NSString stringWithFormat:@"%@市",[CityModel priorCity].cityName];
        _requestEntity.city = city;
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
