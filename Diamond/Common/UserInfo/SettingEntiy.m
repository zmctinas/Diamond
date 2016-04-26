//
//  SettingEntiy.m
//  Diamond
//
//  Created by Pan on 15/8/18.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "SettingEntiy.h"
#import "UserInfo.h"

@implementation SettingEntiy

static SettingEntiy *sharedInstance = nil;

+ (SettingEntiy *)sharedInstance
{
    static dispatch_once_t onceQueue;
    
    dispatch_once(&onceQueue, ^{
        sharedInstance = [UserInfo info].setting;
        if (!sharedInstance)
        {
            sharedInstance = [[SettingEntiy alloc] init];
            sharedInstance.friendsVerifySwitch     = YES;
            sharedInstance.speakerSwitch           = YES;
            sharedInstance.voiceSwitch             = YES;
            sharedInstance.vibrationSwitch         = YES;
            sharedInstance.receiveNewMessageSwitch = YES;
            [sharedInstance synchronize];
        }
    });
    return sharedInstance;
}

- (void)synchronize
{
    [UserInfo info].setting = self;
}
@end
