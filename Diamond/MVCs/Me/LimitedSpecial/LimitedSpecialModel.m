//
//  LimitedSpecialModel.m
//  Diamond
//
//  Created by Leon Hu on 15/8/17.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "LimitedSpecialModel.h"
#import "WebService+Wares.h"
#import "WebService+Shop.h"

@interface LimitedSpecialModel()

@property (nonatomic, strong) RequestEntity *request;

@end

@implementation LimitedSpecialModel

- (void)giveMeLastestData
{
    //重置请求数据
    self.request = nil;
    
    [self giveMeNextData];
}

- (void)giveMeNextData
{
    [self.dataSource removeAllObjects];
    RequestEntity *request = [[RequestEntity alloc] init];
    request.shop_id = [NSNumber numberWithInteger:[[UserSession sharedInstance] currentUser].shop_id];
    [self.webService fetchAllMyShopGoods:request
                              completion:^(BOOL isSuccess, NSString *message, id result) {
                                  if (isSuccess && message.length<1)
                                  {
                                      for (WaresEntity *entity in result) {
                                          if (entity.is_promotion) {
                                              [self.dataSource addObject:entity];
                                          }
                                      }
                                      [[NSNotificationCenter defaultCenter] postNotificationName:GET_SHOP_GOODS object:self.dataSource];
                                  }
                                  else
                                  {
                                      [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
                                  }
                                  
                              }];
}

- (void)addPromotion:(NSArray *)goodsIds discount:(NSNumber *)discount startTime:(NSDate *)startTime stopTime:(NSDate *)stopTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *startTimeString = [dateFormatter stringFromDate:startTime];
    NSString *stopTimeString =[dateFormatter stringFromDate:stopTime];
    [self.webService addPromotion:goodsIds
                           shopId:[[UserSession sharedInstance] currentUser].shop_id
                         discount:discount
                        startTime:startTimeString
                         stopTime:stopTimeString
                       completion:^(BOOL isSuccess, NSString *message, id result) {
        if (isSuccess && message.length<1)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:ADD_PROMOTION object:result];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
        }

    }];
}

- (void)delPromotionAtIndexPath:(NSIndexPath *)indexPath
{
    WaresEntity *ware = [self.dataSource objectAtIndex:indexPath.item];
    [self.webService delPromotion:ware.goods_id
                       completion:^(BOOL isSuccess, NSString *message, id result) {
                           if (isSuccess && message.length<1)
                           {
                               [self.dataSource removeObjectAtIndex:indexPath.row];
                               [[NSNotificationCenter defaultCenter] postNotificationName:DEL_PROMOTION object:indexPath];
                           }
                           else
                           {
                               [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
                           }
                           
                       }];
}

- (RequestEntity *)request
{
    if (!_request)
    {
        _request = [[RequestEntity alloc]init];
        _request.lat = @([PSLocationManager sharedInstance].currentLocation.coordinate.latitude);
        _request.lng = @([PSLocationManager sharedInstance].currentLocation.coordinate.longitude);
        _request.district = [self priorDistrict];
        _request.pages = 1;
    }
    return _request;
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
