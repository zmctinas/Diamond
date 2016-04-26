//
//  CarouselEntity.h
//  Diamond
//
//  Created by Pan on 15/7/20.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"
typedef NS_ENUM(NSInteger, ActivityType)
{
    ActivityTypeDiamond = 1,/**< 后续显示的是店铺列表*/
    ActivityTypeShop = 2,/**< 后续显示店铺详情*/
    ActivityTypeGoods = 3,/**< 后续显示商品详情*/
    ActivityTypeTimeLimit = 4,/**< 限时特价*/
    ActivityTypeRecommond = 5,/**< 小儿推荐*/
    ActivityTypeNewShop = 6,/**< 新铺开张*/
    ActivityTypeHotShop = 7 /**< 热销铺子*/
};


@interface CarouselEntity : BaseEntity

@property (nonatomic, strong) NSNumber *activity_id;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, strong) NSString *add_time;
@property (nonatomic, strong) NSString *jump_id;

@property (nonatomic) ActivityType type;



@end
