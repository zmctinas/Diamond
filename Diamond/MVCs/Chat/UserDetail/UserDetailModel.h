//
//  UserDetailModel.h
//  Diamond
//
//  Created by Pan on 15/7/23.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseModel.h"
@class Buddy;

@interface UserDetailModel : BaseModel

- (void)addFriend:(NSString *)easemob withMessage:(NSString *)msg;

- (void)updateUserInfo:(NSString *)name
                   sex:(NSInteger)sex
                images:(NSArray *)array;

@end
