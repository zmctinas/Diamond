//
//  MyShopModel.h
//  Diamond
//
//  Created by Leon Hu on 15/8/8.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseModel.h"
#import "WaresEntity.h"
#import "Shop.h"
#import "UpLicenseEntity.h"
#import "EditShopEntity.h"

@interface MyShopModel : BaseModel

@property (nonatomic ,strong) NSMutableArray *dataSource;

- (void)setSale:(WaresEntity *)ware isSale:(BOOL)isSale;

- (void)filterDataSource:(NSArray *)dataSouce isOn:(BOOL)isOn;

- (void)getShopInfo:(NSInteger)shopId;

- (void)updateShopInfo:(EditShopEntity *)shop;

- (void)getLicense:(NSString *)easemob;

- (void)upLicense:(UpLicenseEntity *)entity;

- (void)editLicense:(UpLicenseEntity *)entity;

@end
