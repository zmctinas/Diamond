//
//  withDralModel.h
//  Diamond
//
//  Created by daimangkeji on 16/4/25.
//  Copyright © 2016年 Pan. All rights reserved.
//

#import "BaseModel.h"
#import "WebService+withDrawl.h"
#import "withDralEntity.h"

@interface withDralModel : BaseModel

@property(strong,nonatomic)NSMutableArray* dataSource;

@property(strong,nonatomic)NSString* cash;
@property(nonatomic)payAcountType AcountType;
@property(strong,nonatomic)NSString* aliAount;
@property(strong,nonatomic)NSString* wechat;
@property(strong,nonatomic)NSString* openID;
@property(strong,nonatomic)NSString* realName;

@property(strong,nonatomic)NSNumber* pages;


-(void)getAliAcount;

-(void)askMoney;

-(void)getRecord;//获取提现列表

@end
