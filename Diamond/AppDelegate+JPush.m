//
//  AppDelegate+JPush.m
//  Diamond
//
//  Created by Pan on 15/10/25.
//  Copyright © 2015年 Pan. All rights reserved.
//

#import "AppDelegate+JPush.h"
#import "APService.h"
#import "UserInfo.h"
#import "UserSession.h"
#import "PushNotificationEntity.h"
@implementation AppDelegate (JPush)

- (BOOL)jpushApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    [APService setupWithOption:launchOptions];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    //添加Jpush透传消息观察者
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    return YES;
}

- (void)jpushApplication:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)jpushApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    [APService handleRemoteNotification:userInfo];
    [self handleRemoteNotification:userInfo];
}

- (void)jpushApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    [self handleRemoteNotification:userInfo];
}


- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    DLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
    if(iResCode == 6002)
    {
        [self performSelector:@selector(registerAliasForJpush) withObject:nil afterDelay:60];
    }
}

- (void)registerAliasForJpush
{
    [APService setTags:nil alias:[UserInfo info].currentUser.easemob callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
}

/**
 *  处理后台通过Jush传过来的推送。不管是透传还是推送 都会到这里处理。
 *
 *  @param userInfo
 */
- (void)handleRemoteNotification:(NSDictionary *)userInfo
{
    PushNotificationEntity *pushNotification = [PushNotificationEntity objectWithKeyValues:userInfo];
    if ([pushNotification.msg isEqualToString:OrderSubmit]) {
        [UserSession sharedInstance].showSellNotice = YES;
    } else if ([pushNotification.msg isEqualToString:UpdateFee]) {
        [UserSession sharedInstance].showBuyNotice = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_ORDER object:nil];
    }else if ([pushNotification.msg isEqualToString:ConfirmSend]) {
        [UserSession sharedInstance].showBuyNotice = YES;
    }else if ([pushNotification.msg isEqualToString:ConfirmOrder]) {
        [UserSession sharedInstance].showBuyNotice = YES;
    }else if ([pushNotification.msg isEqualToString:PaymentFee]) {
        [UserSession sharedInstance].showSellNotice = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_ORDER_LIST object:nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_TABBAR_BADGE object:nil];
}

//处理透传
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    DLog(@"RECEIVE MESSAGE FROM JPUSH %@\n",userInfo);
    NSDictionary *extras = [userInfo valueForKey:@"extras"];
    [self handleRemoteNotification:extras];
}

@end
