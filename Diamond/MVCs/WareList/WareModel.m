//
//  WareModel.m
//  Diamond
//
//  Created by Pan on 15/7/29.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "WareModel.h"
#import "PSLocationManager.h"
#import "CityModel.h"

@interface WareModel ()

@property (nonatomic, strong) RequestEntity *requestEntity;

@end

@implementation WareModel

- (void)giveMeLastestData:(WareType)type
{
    //重置请求数据
    _requestEntity = nil;
    
    [self giveMeNextData:type];
}

- (void)giveMeNextData:(WareType)type
{
    if (type == WareTypeDiscount)
    {
        [self.webService fetchDisCountGoods:self.requestEntity completion:^(BOOL isSuccess, NSString *message, id result) {
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
                [[NSNotificationCenter defaultCenter] postNotificationName:DISCOUNT_WARES_GETTED_NOTIFICATIOIN object:@(noMoreData)];
            }
        }];
        return;
    }
    
    if (type == WareTypeRecommond)
    {
        [self.webService fetchRecommodGoods:self.requestEntity completion:^(BOOL isSuccess, NSString *message, id result) {
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
                [[NSNotificationCenter defaultCenter] postNotificationName:RECOMMONED_WARES_GETTED_NOTIFICATIOIN object:@(noMoreData)];
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
