//
//  ApplyEntity.h
//  Diamond
//
//  Created by Pan on 15/7/25.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"

@interface ApplyEntity : BaseEntity


@property (nonatomic, strong) NSString * applicantUsername;/**< 申请者的环信账号*/
@property (nonatomic, strong) NSString * applicantNick;
@property (nonatomic, strong) NSString * applicantAvatar;
@property (nonatomic, strong) NSString * receiverUsername;/**< 接收者的环信账号*/
@property (nonatomic, strong) NSString * receiverNick;
@property (nonatomic, strong) NSString * receiverAvatar;

@property (nonatomic, strong) NSString * reason;

@property (nonatomic) BOOL accepted;

@end
