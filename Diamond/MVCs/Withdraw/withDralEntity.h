//
//  withDralEntity.h
//  Diamond
//
//  Created by daimangkeji on 16/4/26.
//  Copyright © 2016年 Pan. All rights reserved.
//

#import "BaseEntity.h"

@interface withDralEntity : BaseEntity


@property(copy,nonatomic)NSString* cash;
@property(copy,nonatomic)NSString* date;
@property(copy,nonatomic)NSString* take_cash_no;
@property(copy,nonatomic)NSString* type;
@property(copy,nonatomic)NSString* status;


#pragma mark - getter
@property(copy,nonatomic)NSString* money;
@property(copy,nonatomic)NSString* headLine;
@property(copy,nonatomic)NSString* messages;
@property(copy,nonatomic)NSString* condition;


@end
