//
//  OrderIndexEntity.h
//  Diamond
//
//  Created by Pan on 15/9/15.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"

@interface OrderIndexEntity : BaseEntity

@property (strong, nonatomic) NSNumber *buyer_count_no;
@property (strong, nonatomic) NSNumber *buyer_count_fee;
@property (strong, nonatomic) NSNumber *seller_count_no;
@property (strong, nonatomic) NSNumber *seller_count_fee;
@property (strong, nonatomic) NSNumber *balance;


//get 属性
@property (strong, nonatomic) NSString *paiedString;
@property (strong, nonatomic) NSString *earningString;
@property (strong, nonatomic) NSString *buyedCountString;
@property (strong, nonatomic) NSString *selledCountString;
@property (strong, nonatomic) NSString *availableMoneyString;

@end
