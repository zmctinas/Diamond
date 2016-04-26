//
//  ShopCart.m
//  Diamond
//
//  Created by Leon Hu on 15/9/14.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ShopCartSession.h"
#import "BuyWareEntity.h"

@implementation ShopCartSession

+ (ShopCartSession *)shareInstance
{
    static ShopCartSession *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[ShopCartSession alloc] init];
    });
    return share;
}

- (void)addToShopCart:(ShopCartEntity *)entity
{
    for (ShopCartEntity *shopCartEntity in self) {
        if (entity.shop_id == shopCartEntity.shop_id) {
            for (BuyWareEntity *buyWareEntity in entity.list) {
                //是否已存在商品的标记
                BOOL hasWares = NO;
                for (BuyWareEntity *buyWareEntityNeedAdd in shopCartEntity.list ) {
                    if ([buyWareEntity.goods_id isEqualToString:buyWareEntityNeedAdd.goods_id]) {
                        buyWareEntity.count_no += buyWareEntityNeedAdd.count_no;
                        hasWares = YES;
                    }
                    //如果原先不存在该商品,则新添加
                    if (!hasWares) {
                        [shopCartEntity.list addObject:buyWareEntityNeedAdd];
                    }
                }
            }
            break;
        }
    }
}

- (void)removeFromShopCart:(ShopCartEntity *)entity
{
    for (ShopCartEntity *shopCartEntity in self) {
        if (entity.shop_id == shopCartEntity.shop_id) {
            for (BuyWareEntity *buyWareEntity in entity.list) {
                for (BuyWareEntity *buyWareEntityNeedAdd in shopCartEntity.list ) {
                    if ([buyWareEntity.goods_id isEqualToString:buyWareEntityNeedAdd.goods_id]) {
                        buyWareEntity.count_no -= buyWareEntityNeedAdd.count_no;
                        
                        //如果已经移除到0,则去除该商品
                        if (buyWareEntity.count_no <= 0) {
                            [shopCartEntity.list removeObject:buyWareEntity];
                        }
                    }
                }
            }
            break;
        }
    }
}

@end
