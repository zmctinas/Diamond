//
//  UserEntity.h
//  Diamond
//
//  Created by Leon Hu on 15/7/19.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"

@interface UserEntity : BaseEntity<NSCoding>

@property (nonatomic, strong) NSString *easemob;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *photo;
@property (nonatomic) NSInteger shop_id;
@property (nonatomic, strong) NSString *shop_name;
@property (nonatomic, strong) NSString *signature;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *province;/**< 个人信息界面显示的省份*/
@property (nonatomic, strong) NSString *city;/**< 个人信息界面显示的地区*/

@property (nonatomic) Sex sex;


@end
