//
//  BuyWareEntity.h
//  Diamond
//
//  Created by Leon Hu on 15/9/1.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"
#import "WaresEntity.h"

@interface BuyWareEntity : BaseEntity



@property (nonatomic) NSInteger shop_id;
@property (nonatomic,strong) NSString *goods_id;
@property (nonatomic,strong) NSString *goods_name;
@property (nonatomic,strong) NSString *goods_url;
@property (nonatomic) BOOL is_promotion;
//"start_time": "0",
//"end_time": "0",
/**
 *  折扣率
 */
@property (nonatomic,strong) NSNumber *discount;
/**
 *  该型号原价
 */
@property (nonatomic,strong) NSNumber *price;
/**
 *  库存
 */
@property (nonatomic) NSInteger number;
/**
 *  型号
 */
@property (nonatomic,strong) NSString *type;
@property (nonatomic, strong) NSNumber *type_id;/**< 型号ID*/
/**
 *  购买量
 */
@property (nonatomic) NSInteger count_no;
/**
 *  该商品购物款中id
 */
@property (nonatomic) NSInteger buyWaresId;

/**
 *  是否选中
 */
@property (nonatomic) BOOL isChecked;



/**
 *  现价，根据是否折扣来计算。is_promotion为True则此值为 price * discount; 否则 为 price;
 *  GET 属性
 */
@property (nonatomic, readonly) CGFloat accountPrice;/**< 结算价*/

@end
