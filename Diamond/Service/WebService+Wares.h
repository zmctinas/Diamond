//
//  WebService+Wares.h
//  Diamond
//
//  Created by Pan on 15/7/27.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "WebService.h"
#import "WaresEntity.h"
#import "AddGoodsEntity.h"
#import "RequestEntity.h"
#import "WareResponseEntity.h"
#import "UpdateGoodsEntity.h"

@interface WebService (Wares)

/**
 *  获取限时特价
 *
 *  @param requestInfo 请求数据
 *  @param completion  完成回调
 */
- (void)fetchDisCountGoods:(RequestEntity *)requestInfo completion:(DMCompletionBlock)completion;

/**
 *  获取小二推荐
 *
 *  @param requestInfo 请求数据
 *  @param completion  完成回调
 */
- (void)fetchRecommodGoods:(RequestEntity *)requestInfo completion:(DMCompletionBlock)completion;

/**
 *  获取本店的商品
 *
 *  @param requestInfo 请求数据
 *  @param completion  完成回调
 */
- (void)fetchMyShopGoods:(RequestEntity *)requestInfo completion:(DMCompletionBlock)completion;

/**
 *  获取本店所有的商品(包括上下架)
 *
 *  @param requestInfo 请求数据
 *  @param completion  完成回调
 */
- (void)fetchAllMyShopGoods:(RequestEntity *)requestInfo completion:(DMCompletionBlock)completion;

/**
 *  获取一个商品的详细数据
 *
 *  @param requestInfo 请求数据
 *  @param completion  完成回调
 */
- (void)fetchGoodInfo:(RequestEntity *)requestInfo completion:(DMCompletionBlock)completion;

/**
 *  收藏商品
 *
 *  @param wareID       商品
 *  @param userID     用户ID
 *  @param completion 完成回调
 */
- (void)storeUpWare:(NSString *)wareID userID:(NSString *)userID completion:(DMCompletionBlock)completion;

/**
 *  删除商品收藏
 *
 *  @param shop       店铺ID数组
 *  @param userID     用户ID
 *  @param completion 完成回调
 */
- (void)unStoreUpWare:(NSArray *)wareIDs userID:(NSString *)userID completion:(DMCompletionBlock)completion;

/**
 *  新增一个商品
 *
 *  @param name        商品名称
 *  @param price       商品价格
 *  @param isOn        是否推荐
 *  @param description 商品描述
 *  @param array       商品图片数组
 *  @param completion
 */
- (void)addNewGoods:(AddGoodsEntity *)entity completion:(DMCompletionBlock)completion;
/**
 *  编辑商品
 *
 *  @param entity     <#entity description#>
 *  @param completion <#completion description#>
 */
- (void)updateGoods:(UpdateGoodsEntity *)entity completion:(DMCompletionBlock)completion;
/**
 *  添加限时特价商品
 *
 *  @param goodsIds  商品ID数组
 *  @param price     价格
 *  @param startTime 开始时间
 *  @param stopTime  结束时间
 */
- (void)addPromotion:(NSArray *)goodsIds shopId:(NSInteger)shopId  discount:(NSNumber *)discount startTime:(NSString *)startTime stopTime:(NSString *)stopTime completion:(DMCompletionBlock)completion;

/**
 *  删除特价
 *
 *  @param goodsId    <#goodsId description#>
 *  @param completion <#completion description#>
 */
- (void)delPromotion:(NSString *)goodsId completion:(DMCompletionBlock)completion;

/**
 *  删除商品
 *
 *  @param goodsId    <#goodsId description#>
 *  @param completion <#completion description#>
 */
- (void)delGoods:(NSString *)goodsId completion:(DMCompletionBlock)completion;

@end
