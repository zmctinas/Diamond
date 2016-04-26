//
//  AddGoodsEntity.h
//  Diamond
//
//  Created by Leon Hu on 15/8/9.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"

@interface AddGoodsEntity : BaseEntity

@property (nonatomic,strong) NSString *goods_name;
@property (nonatomic,strong) NSString *introduction;
@property (nonatomic) NSInteger shop_id;
@property (nonatomic,strong) NSNumber *is_recommend;
@property (nonatomic) NSInteger length;
@property (nonatomic,strong) NSMutableArray *images;
@property (nonatomic,strong) NSMutableArray *list;

@end
