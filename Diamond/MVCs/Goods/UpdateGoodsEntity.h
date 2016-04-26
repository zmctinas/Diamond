//
//  UpdateGoodsEntity.h
//  Diamond
//
//  Created by Leon Hu on 15/8/18.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"

@interface UpdateGoodsEntity : BaseEntity

@property (nonatomic) NSInteger shop_id;
@property (nonatomic,strong) NSString *goods_name;
@property (nonatomic) BOOL is_recommend;
@property (nonatomic,strong) NSString *introduction;
@property (nonatomic,strong) NSArray *site;
@property (nonatomic) NSInteger length;
@property (nonatomic,strong) NSString *goods_id;
@property (nonatomic,strong) NSMutableArray *images;
@property (nonatomic,strong) NSMutableArray *list;

@end
