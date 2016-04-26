//
//  LicenseImageEntity.h
//  Diamond
//
//  Created by Leon Hu on 15/8/11.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"
@class ImageEntity;

@interface LicenseImageEntity : BaseEntity

@property (nonatomic,strong) ImageEntity *idCard_A;
@property (nonatomic,strong) ImageEntity *idCard_B;
@property (nonatomic,strong) ImageEntity *businessLicense;
@property (nonatomic,strong) ImageEntity *healthLicense;

@end
