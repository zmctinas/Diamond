//
//  WareDetailModel.h
//  Diamond
//
//  Created by Pan on 15/8/4.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseModel.h"
#import "WaresEntity.h"
#import "OrderDetailEntity.h"

@class GoodsTypeEntity;
@interface WareDetailModel : BaseModel

@property (nonatomic, strong) WaresEntity *ware;


- (void)giveMeWareInfo:(NSString *)wareID;

/**
 *  收藏商品
 *
 *  @param ware
 */
- (void)storeUpWare:(WaresEntity *)ware;

/**
 *  删除商品收藏
 *
 *  @param ware
 */
- (void)unStoreUpWare:(NSArray *)wares;


- (OrderDetailEntity *)packagingWithWare:(WaresEntity *)ware type:(GoodsTypeEntity *)type count:(NSInteger)count;
@end
