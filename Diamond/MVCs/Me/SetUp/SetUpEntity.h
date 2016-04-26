//
//  SetUpEntity.h
//  Diamond
//
//  Created by Leon Hu on 15/8/14.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"

@interface SetUpEntity : BaseEntity

@property (nonatomic,strong) NSString *realName;
@property (nonatomic,strong) NSString *shop_name;
@property (nonatomic,strong) NSString *easemob;
@property (nonatomic,strong) NSString *Introduction;
@property (nonatomic,strong) NSString *district;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *province;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSArray *cat_id;
@property (nonatomic) NSInteger length;
@property (nonatomic,strong) NSMutableArray *images;

@property (nonatomic,strong) NSString *ali_pay;
@property (nonatomic,strong) NSString *wchat_pay;
//@property (nonatomic,strong) NSString *telNumber;
@property (nonatomic,strong) NSString *phoneNumber;


@end
