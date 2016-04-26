//
//  CollectionModel.h
//  Diamond
//
//  Created by Pan on 15/8/8.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseModel.h"
typedef NS_ENUM(NSInteger, CollectionType)
{
    CollectionTypeWare = 1,
    CollectionTypeShop
};

@interface CollectionModel : BaseModel

@property (nonatomic, strong) NSMutableArray *dataSource;

/**
 *  下拉刷新调用这个数据
 */
- (void)giveMeLastestData:(CollectionType)type;

/**
 *  上拉加载调用这个数据
 */
- (void)giveMeNextData:(CollectionType)type;

@end
