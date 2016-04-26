//
//  WareModel.h
//  Diamond
//
//  Created by Pan on 15/7/29.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseModel.h"
#import "WebService+Wares.h"

typedef NS_ENUM(NSInteger, WareType)
{
    WareTypeDiscount = 100,/**< 限时特价*/
    WareTypeRecommond,/**< 小二推荐*/
    WareTypeSelf,/**< 本店的商品*/
};

@interface WareModel : BaseModel

@property (nonatomic, strong) NSMutableArray *dataSource;


/**
 *  下拉刷新调用这个数据
 */
- (void)giveMeLastestData:(WareType)type;

/**
 *  上拉加载调用这个数据
 */
- (void)giveMeNextData:(WareType)type;
@end
