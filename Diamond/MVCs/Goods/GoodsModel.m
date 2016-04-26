//
//  GoodsModel.m
//  Diamond
//
//  Created by Leon Hu on 15/8/3.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "GoodsModel.h"
#import "WebService+Wares.h"
#import "ImageEntity.h"
#import "UIImage+Scale.h"
#import "UpdateGoodsEntity.h"

@interface GoodsModel()



@end

@implementation GoodsModel

- (void)updateGoods:(NSString *)name
        isRecommend:(BOOL)isRecommend
        description:(NSString *)description
               site:(NSArray *)site
             length:(NSInteger)length
            goodsId:(NSString *)goodsId
             images:(NSArray *)images
           typeList:(NSMutableArray *)typeList
 {
     UpdateGoodsEntity *entity = [[UpdateGoodsEntity alloc] init];
     entity.goods_id = goodsId;
     entity.introduction = description;
     entity.list = typeList;
     entity.is_recommend = isRecommend;
     entity.goods_name = name;
     entity.site = site;
     entity.length = length;
     entity.shop_id = [[UserSession sharedInstance] currentUser].shop_id;
     entity.images = [images copy];

     [self updateGoods:entity];
 }

- (void)updateGoods:(UpdateGoodsEntity *)entity
{
    [self.webService updateGoods:entity
                      completion:^(BOOL isSuccess, NSString *message, id result)
     {
         if (isSuccess && message.length<1)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_GOODS object:result];
         }
         else
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
         }
     }];
}

- (void)addNewGoods:(NSString *)name isRecommend:(BOOL)isOn description:(NSString *)description images:(NSMutableArray *)array typeList:(NSMutableArray *)typeList
{
    AddGoodsEntity *entity = [[AddGoodsEntity alloc] init];
    entity.shop_id = [[UserSession sharedInstance] currentUser].shop_id;
    entity.goods_name = name;
    entity.list = typeList;
    entity.is_recommend = (isOn?@1:@0);
    entity.introduction = description;
    entity.length = 0;
    if ([array count]) {
        entity.length = [array count];
        entity.images = array;
    }
    
    [self.webService addNewGoods:entity completion:^(BOOL isSuccess, NSString *message, id result)
    {
         if (isSuccess && message.length<1)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:ADD_GOODS_NOTIFICATION object:result];
         }
         else
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
         }
     }];

}

- (void)delGoods:(NSString *)goodsId
{
    [self.webService delGoods:goodsId
                   completion:^(BOOL isSuccess, NSString *message, id result)
     {
         if (isSuccess && message.length<1)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:DEL_GOODS object:result];
         }
         else
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
         }
     }];
}

@end
