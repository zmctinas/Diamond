//
//  AppDelegate+JPush.h
//  Diamond
//
//  Created by Pan on 15/10/25.
//  Copyright © 2015年 Pan. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (JPush)



- (BOOL)jpushApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)jpushApplication:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)jpushApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;
- (void)jpushApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

//为Jpush注册别名
- (void)registerAliasForJpush;

@end
