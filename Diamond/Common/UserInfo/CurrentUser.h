//
//  CurrentUser.h
//  Diamond
//
//  Created by Leon Hu on 15/7/21.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserEntity.h"

@interface CurrentUser : NSObject

+ (UserEntity *)sharedUser;

+ (void)save:(UserEntity *)entity;

+ (void)clear;

@end
