//
//  EditShopEntity.h
//  Diamond
//
//  Created by Leon Hu on 15/8/11.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"
#import "Shop.h"

@interface EditShopEntity : BaseEntity


@property (nonatomic,strong) NSString *ali_pay;
@property (nonatomic,strong) NSString *wchat_pay;
//@property (nonatomic,strong) NSString *telNumber; NS_DEPRECATED_IOS(@"已废弃此字段", 1.1.2)

@property (nonatomic,strong) NSString *phoneNumber;
@property (nonatomic,strong) NSString *realName;

@property (nonatomic) NSInteger shop_id;
@property (nonatomic,strong) NSString *shop_name;
@property (nonatomic,strong) NSString *province;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *district;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *Introduction;
@property (nonatomic,strong) NSArray *cat_id;
@property (nonatomic) NSInteger length;
@property (nonatomic,strong) NSMutableArray *site;
@property (nonatomic,strong) NSString *sale_start_time;
@property (nonatomic,strong) NSString *sale_end_time;
@property (nonatomic) BOOL is_open;
@property (nonatomic,strong) NSString *poi_id;
/**
 *  店铺招牌图片
 */
@property (nonatomic,strong) NSMutableArray *shop_ad;
@property (nonatomic,strong) NSMutableArray *images;
/**
 *  浏览量
 */
//@property (nonatomic,strong) NSString *view;  NS_DEPRECATED_IOS(@"已废弃此字段", 1.1.2)
/**
 *  收藏量
 */
//@property (nonatomic,strong) NSString *collec;  NS_DEPRECATED_IOS(@"已废弃此字段", 1.1.2)
/**
 *  免费配送距离
 */
@property (nonatomic) NSInteger delivery_distance;
/**
 *  多少金额以上免费
 */
@property (nonatomic,strong) NSNumber *delivery_limit;

+ (EditShopEntity *)getEntity:(Shop *)shop;

@end
