//
//  WebService+ShopCart.h
//  Diamond
//
//  Created by Leon Hu on 15/9/20.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "WebService.h"

@interface WebService (ShopCart)

/**
 *  获取购物车数据
 */
- (void)getShopCart:(NSString *)easemob completion:(DMCompletionBlock)completion;

/**
 *  更新购物车中商品数据
 */
- (void)updateShopCart:(NSInteger)buyWaresId count:(NSInteger)buyCount completion:(DMCompletionBlock)completion;

/**
 *  删除购物车中商品
 */
- (void)delFromShopCart:(NSInteger)buyWaresId completion:(DMCompletionBlock)completion;

/**
 *  添加商品到购物车
 */
- (void)addShopCart:(NSInteger)typeId easemob:(NSString *)easemob count:(NSInteger)buyCount completion:(DMCompletionBlock)completion;

@end
