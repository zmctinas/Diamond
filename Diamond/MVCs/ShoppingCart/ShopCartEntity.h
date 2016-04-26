//
//  ShopCartEntity.h
//  Diamond
//
//  Created by Leon Hu on 15/9/1.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"

@interface ShopCartEntity : BaseEntity

@property (nonatomic,strong) NSString *shop_name;
@property (nonatomic,strong) NSString *easemob;
@property (nonatomic) NSInteger shop_id;
/**
 *  总费用
 */
@property (nonatomic,strong) NSNumber *total_fee;
/**
 *  总数量
 */
@property (nonatomic) NSInteger total_count;
/**
 *  商品列表 BuyWareEntity
 */
@property (nonatomic,strong) NSMutableArray *list;
/**
 *  是否选中 纯GET SET属性
 */
@property (nonatomic) BOOL isChecked;

@end
