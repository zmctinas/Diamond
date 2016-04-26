//
//  Goods.h
//  Diamond
//
//  Created by Leon Hu on 15/8/3.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"

@interface Goods : BaseEntity

/**
 *  商品编号
 */
@property (nonatomic,strong) NSString *goods_id;

/**
 *  商品名
 */
@property (nonatomic,strong) NSString *goods_name;

/**
 *  商品价格
 */
@property (nonatomic,strong) NSNumber *goods_price;

/**
 *  商品图片
 */
@property (nonatomic,strong) NSString *goods_url;

/**
 *  是否在售,1为是0为否
 */
@property (nonatomic) BOOL is_sale;

/**
 *  是否推荐
 */
@property (nonatomic) BOOL is_recommend;

/**
 *  是否特价
 */
@property (nonatomic) BOOL is_promotion;

/**
 *  是否热销
 */
@property (nonatomic) BOOL Is_hot;

/**
 *  最后编辑
 */
@property (nonatomic,strong) NSString *lastedit;

/**
 *  特价价格
 */
@property (nonatomic,strong) NSNumber *promotion_price;

/**
 *  商品介绍
 */
@property (nonatomic,strong) NSString *introduction;

/**
 *  商铺编号
 */
@property (nonatomic) NSInteger shop_id;

/**
 *  限制开始
 */
@property (nonatomic,strong) NSString *start_time;

/**
 *  限制结束
 */
@property (nonatomic,strong) NSString *end_time;

/**
 *  商品收藏量.
 */
@property (nonatomic) NSInteger collec;

@end
