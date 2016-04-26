//
//  MyShopModel.m
//  Diamond
//
//  Created by Leon Hu on 15/8/8.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "MyShopModel.h"
#import "WaresEntity.h"
#import "WebService+Shop.h"
#import "RequestEntity.h"
#import "PSLocationManager.h"
#import "ShopSession.h"
@interface MyShopModel()



@end

@implementation MyShopModel

- (void)setSale:(WaresEntity *)ware isSale:(BOOL)isSale
{
    [self.webService setSale:[[UserSession sharedInstance] currentUser].shop_id
                     goodsId:ware.goods_id
                      isSale:isSale
                  completion:^(BOOL isSuccess, NSString *message, id result)
     {
         if (isSuccess && message.length<1)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:SET_SALE object:ware.goods_id];
         }
         else
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
         }
     }];
}

- (void)getShopInfo:(NSInteger)shopId
{
    RequestEntity *entity = [[RequestEntity alloc] init];
    entity.shop_id = @(shopId);
    entity.easemob = [[UserSession sharedInstance] currentUser].easemob;
    CLLocation *location = [[PSLocationManager sharedInstance] currentLocation];
    entity.lat = @(location.coordinate.latitude);
    entity.lng = @(location.coordinate.longitude);
    
    [self.webService fetchShopDetailInfo:entity
                         completion:^(BOOL isSuccess, NSString *message, id result)
     {
         if (isSuccess && message.length<1)
         {
             [[ShopSession sharedInstance] setCurrentShop:result];
             [[NSNotificationCenter defaultCenter] postNotificationName:GET_SHOP_INFO object:result];
         }
         else
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
         }
     }];
}

- (void)updateShopInfo:(EditShopEntity *)entity
{
    [self.webService updateShopInfo:entity
                     completion:^(BOOL isSuccess, NSString *message, id result)
     {
         if (isSuccess && message.length<1)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_SHOP object:result];
         }
         else
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
         }
     }];
}

- (void)getLicense:(NSString *)easemob
{
    [self.webService getLicense:easemob
     completion:^(BOOL isSuccess, NSString *message, id result)
     {
         if (isSuccess && message.length<1)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:GET_LICENSE object:result];
         }
         else
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
         }
     }];
}

- (void)upLicense:(UpLicenseEntity *)entity
{
    [self.webService upLicense:entity
                     completion:^(BOOL isSuccess, NSString *message, id result)
     {
         if (isSuccess && message.length<1)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:UP_LICENSE object:result];
         }
         else
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
         }
     }];
}

- (void)editLicense:(UpLicenseEntity *)entity
{
    [self.webService editLicense:entity
                    completion:^(BOOL isSuccess, NSString *message, id result)
     {
         if (isSuccess && message.length<1)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_LICENSE object:result];
         }
         else
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
         }
     }];
}

- (void)filterDataSource:(NSArray *)dataSouce isOn:(BOOL)isOn
{
    [self.dataSource removeAllObjects];
    for (WaresEntity *entity in dataSouce) {
        if (entity.is_sale == isOn) {
            [self.dataSource addObject:entity];
        }
    }
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end
