//
//  ShopModel.h
//  Diamond
//
//  Created by Pan on 15/7/30.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseModel.h"
#import "WebService+Shop.h"
#import "ShopEnum.h"

@interface ShopModel : BaseModel


@property (nonatomic, strong) NSMutableArray *dataSource;

/**
 *  下拉刷新调用这个数据
 */
- (void)giveMeLastestData:(ShopType)type;

/**
 *  上拉加载调用这个数据
 */
- (void)giveMeNextData:(ShopType)type;

/**
 *  当店铺列表类型是代忙官方活动的时候 调用这个接口
 *
 *  @param activityID
 */
- (void)giveMeDaimangActivityShops:(NSNumber *)activityID;

@end
