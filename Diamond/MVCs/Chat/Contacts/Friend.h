//
//  Friend.h
//  Diamond
//
//  Created by Pan on 15/7/22.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"
#import <Foundation/Foundation.h>

@interface Friend : BaseEntity
@property (nonatomic, strong) NSNumber *friendID;
@property (nonatomic, strong) NSString *friends_easemob;
@property (nonatomic, strong) NSString *add_time;
@property (nonatomic, strong) NSString *remarkname;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSString *signature;


@property (nonatomic, strong) NSString *searchString;/**< 仅为搜索使用*/


@property (nonatomic) Sex sex;
@end
