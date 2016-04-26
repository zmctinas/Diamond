//
//  ShopDetailModel.h
//  Diamond
//
//  Created by Pan on 15/7/30.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseModel.h"
#import "Shop.h"
@interface ShopDetailModel : BaseModel

@property (nonatomic, strong) Shop *shop;

@property (nonatomic, strong) NSMutableArray *dataSource;

/**
 *  获取店铺详情数据
 *
 *  @param shopID 店铺ID
 */
- (void)giveMeShopInfo:(Shop *)shop;
/**
 *  获取店内的商品
 *
 *  @param shopId shopId
 */
- (void)giveMeShopGoodsByShopId:(NSInteger)shopId;

- (void)giveMeAllOfShopGoodsByShopId:(NSInteger)shopId;
/**
 *  获取店内的商品
 *
 *  @param shop shop
 */
- (void)giveMeShopGoods:(Shop *)shop;

/**
 *  收藏店铺
 *
 *  @param shop 
 */
- (void)storeUpShop:(Shop *)shop;

/**
 *  删除店铺收藏
 *
 *  @param shop
 */
- (void)unStoreUpShop:(NSArray *)shops;

@end
