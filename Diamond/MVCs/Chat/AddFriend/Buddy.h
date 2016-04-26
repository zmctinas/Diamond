//
//  Buddy.h
//  Diamond
//
//  Created by Pan on 15/7/21.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"



@interface Buddy : BaseEntity

@property (nonatomic, strong) NSNumber *shop_id;
@property (nonatomic, strong) NSString *easemob;
@property (nonatomic, strong) NSString *signature;/**< 签名*/
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *photo;/**< 头像URL*/
@property (nonatomic, strong) NSString *city;/**< 城市*/
@property (nonatomic, strong) NSString *province;/**< 省会*/
@property (nonatomic, strong) NSString *add_time;
@property (nonatomic, strong) NSString *remarkname;/**< 备注名*/
@property (nonatomic, strong) NSNumber *lat;
@property (nonatomic, strong) NSNumber *lng;
@property (nonatomic, strong) NSArray *shop_ad;/**< 图片的URL数组*/




@property (nonatomic) Sex sex;
@end
