//
//  ReceiveGoodsAddressEntity.h
//  Diamond
//
//  Created by Leon Hu on 15/8/31.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"

@interface ReceiveGoodsAddressEntity : BaseEntity

@property (nonatomic,strong) NSString *addressId;
/**
 *  是否为默认地址
 */
@property (nonatomic) BOOL status;
/**
 *  收货人姓名
 */
@property (strong, nonatomic) NSString *linkman;
/**
 *  收货人手机号码
 */
@property (strong, nonatomic) NSString *phoneNumber;
/**
 *  省
 */
@property (nonatomic,strong) NSString *province;
/**
 *  市
 */
@property (nonatomic,strong) NSString *city;
/**
 *  区
 */
@property (nonatomic,strong) NSString *district;
/**
 *  详细地址
 */
@property (strong, nonatomic) NSString *address;

@property (nonatomic,strong) NSString *easemob;

@property (nonatomic,strong) NSString *fullAddress;/**< Get属性，完整的地址*/
/**
 *  是否被选择
 */
@property (nonatomic) BOOL isChecked;

@end
