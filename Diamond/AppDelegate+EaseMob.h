//
//  AppDelegate+EaseMob.h
//  Diamond
//
//  Created by Pan on 15/7/15.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "AppDelegate.h"
@interface AppDelegate (EaseMob)

- (void)easemobApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
// 将得到的deviceToken传给SDK
- (void)easemobApplication:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
// 注册deviceToken失败
- (void)easemobApplication:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

- (void)easemobdidReceiveRemoteNotification:(NSDictionary *)userInfo;

@end
