//
//  ShopResponseEntity.h
//  Diamond
//
//  Created by Pan on 15/7/30.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"

@interface ShopResponseEntity : BaseEntity

@property (nonatomic,strong) NSArray *data;
@property (nonatomic) NSInteger pages;

@end
