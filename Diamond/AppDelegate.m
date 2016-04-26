//
//  AppDelegate.m
//  Diamond
//
//  Created by Pan on 15/7/11.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "AppDelegate+EaseMob.h"
#import "AppDelegate+ShareSDK.h"
#import "AppDelegate+JPush.h"
#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "Macros.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ValidationManager.h"
#import "DMWechatPayManager.h"
#import "UserDetailModel.h"
#import "WXApi.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //初始化Jpush相关事宜
    [self jpushApplication:application didFinishLaunchingWithOptions:launchOptions];
    //初始化环信相关事宜
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];
    //初始化ShareSDK相关事宜
    [self shareSDKApplication:application didFinishLaunchingWithOptions:launchOptions];
    [IQKeyboardManager load];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //清除角标
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //Easemob receiveRemoteNofitication      JUST LOG
    [self easemobdidReceiveRemoteNotification:userInfo];
    
    //Jpush
    [self jpushApplication:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    //Jpush
    [self jpushApplication:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
    //Easemob
    [self easemobdidReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //Jpush
    [self jpushApplication:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    //Easemob
    [self easemobApplication:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //Easemob
    [self easemobApplication:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self shareSDKApplication:application handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    //跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
    if ([url.host isEqualToString:@"safepay"])
    {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            DLog(@"%@",resultDic);
            NSNumber *resulCode = [resultDic objectForKey:@"resultStatus"];
            BOOL isSuccess = ([resulCode integerValue] == 9000);//9000代表订单支付成功
            [[NSNotificationCenter defaultCenter] postNotificationName:ALIPAY_RESULT object:@(isSuccess)];
        }];
        return YES;
    } else if ([sourceApplication isEqualToString:@"com.tencent.xin"]
                || [sourceApplication isEqualToString:@"com.tencent.mqq"])
    {
        if ([url.host isEqualToString:@"pay"])
        {
            return [WXApi handleOpenURL:url delegate:[DMWechatPayManager sharedManager]];
        }
        return [self shareSDKApplication:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    else
    {
        return YES;
    }
}

- (void)registerJpushAlias
{
    [self registerAliasForJpush];
}

- (UserDetailModel *)userdetailModel
{
    if (!_userdetailModel)
    {
        _userdetailModel = [[UserDetailModel alloc] init];
    }
    return _userdetailModel;
}

@end
