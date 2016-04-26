//
//  UpLicenseEntity.h
//  Diamond
//
//  Created by Leon Hu on 15/8/11.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"

@interface UpLicenseEntity : BaseEntity

@property (nonatomic,strong) NSString *name;
@property (nonatomic) NSString *easemob;
@property (nonatomic,strong) NSString *phoneNumber;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *idNumber;
@property (nonatomic,strong) NSArray *images;

@end
