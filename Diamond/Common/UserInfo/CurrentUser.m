//
//  CurrentUser.m
//  Diamond
//
//  Created by Leon Hu on 15/7/21.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "CurrentUser.h"
#import "UserEntity.h"
@interface CurrentUser()

@end

@implementation CurrentUser

static UserEntity *sharedUser = nil;

+ (UserEntity *)sharedUser
{
    static dispatch_once_t onceQueue;
    
    dispatch_once(&onceQueue, ^{
        sharedUser = [[UserEntity alloc] init];
    });
    
    return sharedUser;
}


+ (void)save:(UserEntity *)entity
{
    sharedUser = entity;
}

+ (void)clear
{
    sharedUser = nil;
}

@end
