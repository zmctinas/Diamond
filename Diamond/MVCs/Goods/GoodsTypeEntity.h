//
//  GoodsTypeEntity.h
//  Diamond
//
//  Created by Leon Hu on 15/8/27.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"

@interface GoodsTypeEntity : BaseEntity

@property (nonatomic,strong) NSNumber *typeId;
/**
 *  型号
 */
@property (nonatomic,strong) NSString *typeName;
/**
 *  价格
 */
@property (nonatomic,strong) NSNumber *price;
/**
 *  库存
 */
@property (nonatomic) NSInteger stock;

@end
