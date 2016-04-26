//
//  ReceiveGoodsAddressModel.h
//  Diamond
//
//  Created by Leon Hu on 15/8/31.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseModel.h"
#import "ReceiveGoodsAddressEntity.h"

@interface ReceiveGoodsAddressModel : BaseModel

@property (nonatomic,strong) NSMutableArray *dataSource;

- (void)addAddress:(ReceiveGoodsAddressEntity *)entity;

- (void)updateAddress:(ReceiveGoodsAddressEntity *)entity;

- (void)deleteAddress:(NSString *)addressId;

- (void)getAddress;

@end
