//
//  RequestEntity.h
//  Diamond
//
//  Created by Pan on 15/7/27.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"

typedef NS_ENUM(NSInteger, SearchType)
{
    SearchTypeShop = 1,/**< 搜索类型为店铺*/
    SearchTypeWare = 2/**< 搜索类型为商品*/
};


/**
 *  所有商品店铺相关的请求，都使用这个Entity来传数据
 */
@interface RequestEntity : BaseEntity

@property (nonatomic,strong) NSNumber *lat;/**< 纬度*/
@property (nonatomic,strong) NSNumber *lng;/**< 经度*/
@property (nonatomic,strong) NSNumber *cat_id;/**< 16个分类的id*/
@property (nonatomic,strong) NSNumber *shop_id;/**< 店铺的id*/
@property (nonatomic,strong) NSString *goods_id;/**< 商品的id*/
@property (nonatomic,strong) NSString *district;/**< XX区*/
@property (nonatomic,strong) NSString *easemob;/**< 环信账号*/
@property (nonatomic,strong) NSString *city;/**< 城市名*/

@property (nonatomic) BOOL all;/**<  是否获取店铺中所有的商品(包括上下架)*/

@property (nonatomic) SearchType type;/**< 用于搜索界面搜索类型*/
@property (nonatomic) NSString *key_words;/**< 用于搜索界面搜索关键字*/

@property (nonatomic) NSInteger pages;/**< 页码*/

@end
