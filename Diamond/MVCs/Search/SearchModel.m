//
//  SearchModel.m
//  Diamond
//
//  Created by Pan on 15/8/5.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "SearchModel.h"
#import "WebService+Other.h"
#import "WareResponseEntity.h"
#import "CityModel.h"

@interface SearchModel ()

@property (nonatomic, strong) RequestEntity *requestEntity;
@property (nonatomic, strong) NSString *keyWords;

@end

@implementation SearchModel

- (void)searchWithKeyWords:(NSString *)keyWords
{
    //重置请求数据
    [self.dataSource removeAllObjects];
    _requestEntity = nil;
    self.keyWords = keyWords;
    [self giveMeNextData];
}

- (void)giveMeNextData
{
    
    self.requestEntity.type = self.searchType;
    self.requestEntity.key_words = self.keyWords;
    [self.webService search:self.requestEntity completion:^(BOOL isSuccess, NSString *message, id result)
    {
        if (isSuccess)
        {
            WareResponseEntity *response = result;
            //由于服务端在这个接口 在没有更多数据的时候 传回来的ResultCode是Failure，因此做不同的处理。
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
            [[NSNotificationCenter defaultCenter] postNotificationName:SEARCH_NOTIFICATION object:@(noMoreData)];
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
