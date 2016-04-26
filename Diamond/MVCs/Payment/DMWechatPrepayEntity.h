//
//  DMWechatPrepayEntity.h
//  Diamond
//
//  Created by Pan on 15/9/6.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"

@interface DMWechatPrepayEntity : BaseEntity

@property (strong, nonatomic) NSString *appid;
@property (strong, nonatomic) NSString *partnerid;
@property (strong, nonatomic) NSString *noncestr;
@property (strong, nonatomic) NSString *prepayid;
@property (strong, nonatomic) NSString *timestamp;
@property (strong, nonatomic) NSString *string;

@property (strong, nonatomic) NSString *sign;

@end
