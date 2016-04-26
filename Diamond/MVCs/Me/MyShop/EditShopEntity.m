//
//  EditShopEntity.m
//  Diamond
//
//  Created by Leon Hu on 15/8/11.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "EditShopEntity.h"
#import "ImageEntity.h"

@implementation EditShopEntity

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"images":[ImageEntity class]
             };
}

+ (EditShopEntity *)getEntity:(Shop *)shop
{
    EditShopEntity *entity = [[EditShopEntity alloc] init];
    
    entity.ali_pay= shop.ali_pay;
    entity.wchat_pay= shop.wchat_pay;
//    entity.telNumber=shop.telNumber;
    entity.phoneNumber=shop.phoneNumber;
    entity.shop_id=shop.shop_id;
    entity.shop_name=shop.shop_name;
    entity.province=shop.province;
    entity.city=shop.city;
    entity.district=shop.district;
    entity.address=shop.address;
    entity.Introduction=shop.Introduction;
    entity.cat_id=shop.cat_id;
    entity.length=0;
    entity.site=nil;
    entity.sale_start_time = shop.sale_start_time;
    entity.sale_end_time = shop.sale_end_time;
    entity.is_open= shop.is_open;
    entity.poi_id = shop.poi_id;
    if (shop.shop_ad) {
        entity.shop_ad = [shop.shop_ad mutableCopy];
    }
    entity.images = nil;
//    entity.view = shop.view;
//    entity.collec = shop.collec;
    entity.delivery_distance = shop.delivery_distance;
    entity.delivery_limit = shop.delivery_limit;
  
    return entity;
}

@end
