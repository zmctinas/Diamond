//
//  ShopLicenseEntity.h
//  Diamond
//
//  Created by Leon Hu on 15/8/11.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"

@interface ShopLicenseEntity : BaseEntity

@property (nonatomic,strong) NSString *idCard_A;
@property (nonatomic,strong) NSString *idCard_B;
@property (nonatomic,strong) NSString *businessLicense;
@property (nonatomic,strong) NSString *healthLicense;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *phoneNumber;
@property (nonatomic,strong) NSString *idNumber;

@end
