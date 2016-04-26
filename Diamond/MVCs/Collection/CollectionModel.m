//
//  CollectionModel.m
//  Diamond
//
//  Created by Pan on 15/8/8.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "CollectionModel.h"
#import "RequestEntity.h"
#import "WareResponseEntity.h"
#import "WebService+User.h"

@interface CollectionModel ()

@property (nonatomic, strong) RequestEntity *requestEntity;


@end

@implementation CollectionModel


- (void)giveMeLastestData:(CollectionType)type
{
    //重置请求数据
    _requestEntity = nil;
    [self giveMeNextData:type];
}

- (void)giveMeNextData:(CollectionType)type
{
    if (type == CollectionTypeShop)
    {
        [self.webService fetchCollectedShops:self.requestEntity completion:^(BOOL isSuccess, NSString *message, id result) {
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
                [[NSNotificationCenter defaultCenter] postNotificationName:GET_SHOP_COLLEC object:@(noMoreData)];
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:GET_SHOP_COLLEC object:@YES];
            }
        }];
        return;
    }
    
    if (type == CollectionTypeWare)
    {
        [self.webService fetchCollectedWares:self.requestEntity completion:^(BOOL isSuccess, NSString *message, id result) {
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
                [[NSNotificationCenter defaultCenter] postNotificationName:GET_GOODS_COLLEC object:@(noMoreData)];
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:GET_GOODS_COLLEC object:@YES];
            }
        }];
        return;
    }
    
}


- (RequestEntity *)requestEntity
{
    if (!_requestEntity)
    {
        _requestEntity = [[RequestEntity alloc]init];
        _requestEntity.lat = @([PSLocationManager sharedInstance].currentLocation.coordinate.latitude);
        _requestEntity.lng = @([PSLocationManager sharedInstance].currentLocation.coordinate.longitude);
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
