//
//  ShopCartModel.h
//  Diamond
//
//  Created by Leon Hu on 15/9/1.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseModel.h"
#import "BuyWareEntity.h"
#import "ShopCartEntity.h"

@class OrderDetailEntity;
@interface ShopCartModel : BaseModel

@property (nonatomic,strong) NSMutableArray *dataSource;

/**
 *  获取购物车数据
 */
- (void)getShopCart;

/**
 *  更新购物车中商品数据
 *
 *  @param entity 该商品
 *  @param count      购买量
 */
- (void)updateShopCart:(BuyWareEntity *)entity count:(NSInteger)count;

/**
 *  删除购物车中商品
 *
 *  @param entity 该商品
 */
- (void)delBuyWare:(BuyWareEntity *)entity;

/**
 *  添加到购物车
 *
 *  @param typeId 商品类型ID
 *  @param buyCount 购买数量
 */
- (void)addToShopCart:(NSInteger)typeId count:(NSInteger)buyCount;

/**
 *  处理用户勾选购物车中 整个店铺的情况。
 *
 *  @param index 够了dataSource中哪个index下的shopCartEntity
 */
- (void)shopCartEntityBeingSelectedAtIndex:(NSInteger)index;

/**
 *  处理用户勾选/取消勾选 了购物车中 某一个商品的情况。
 *
 *  @param indexPath 勾选了那一个ShopCartEntity中的哪一个BuyWareEntity
 */
- (void)buyWareBeingSelectedAtIndexPath:(NSIndexPath *)indexPath;

//计算一下某一家店的总价和总数量
- (void)calculate:(ShopCartEntity *)shopCartEntity;

/**
 *  将ShopCartEntity对象转换为OrderCommitViewController可用的OrderDetailEntity对象
 *
 *  @param shopCart
 *
 *  @return 
 */
- (OrderDetailEntity *)convertWithShopCart:(ShopCartEntity *)shopCart;

@end
