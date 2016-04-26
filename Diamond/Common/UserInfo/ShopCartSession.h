//
//  ShopCart.h
//  Diamond
//
//  Created by Leon Hu on 15/9/14.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopCartEntity.h"
#import "BuyWareEntity.h"

@interface ShopCartSession : NSMutableArray

+ (ShopCartSession *)shareInstance;
/**
 *  添加商品到购物车
 *
 *  @param entity 购物车
 */
- (void)addToShopCart:(ShopCartEntity *)entity;
/**
 *  从购物车中移除商品
 *
 *  @param entity 购物车
 */
- (void)removeFromShopCart:(ShopCartEntity *)entity;

@end
