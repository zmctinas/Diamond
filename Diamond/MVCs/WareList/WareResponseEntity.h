//
//  WareResponseEntity.h
//  Diamond
//
//  Created by Pan on 15/7/28.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"

/**
 *  和接口相关，用来接收分页的商品列表的Entity
 */
@interface WareResponseEntity : BaseEntity

@property (nonatomic,strong) NSArray *data;
@property (nonatomic) NSInteger pages;

@end
