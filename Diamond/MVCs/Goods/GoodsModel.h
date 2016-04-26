//
//  GoodsModel.h
//  Diamond
//
//  Created by Leon Hu on 15/8/3.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseModel.h"
#import "UpdateGoodsEntity.h"

@interface GoodsModel : BaseModel

@property (nonatomic, strong) NSMutableArray *dataSource;

- (void)updateGoods:(NSString *)name
        isRecommend:(BOOL)isRecommend
        description:(NSString *)description
               site:(NSArray *)site
             length:(NSInteger)length
            goodsId:(NSString *)goodsId
             images:(NSArray *)images
           typeList:(NSMutableArray *)typeList;

- (void)updateGoods:(UpdateGoodsEntity *)entity;

- (void)addNewGoods:(NSString *)name
        isRecommend:(BOOL)isOn
        description:(NSString *)description
             images:(NSMutableArray *)array
           typeList:(NSMutableArray *)typeList;

- (void)delGoods:(NSString *)goodsId;

@end
