//
//  AppDelegate+ShareSDK.h
//  Diamond
//
//  Created by ShawnPan on 15/8/11.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>

@interface AppDelegate (ShareSDK)

- (void)shareSDKApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (BOOL)shareSDKApplication:(UIApplication *)application handleOpenURL:(NSURL *)url;

- (BOOL)shareSDKApplication:(UIApplication *)application
                    openURL:(NSURL *)url
          sourceApplication:(NSString *)sourceApplication
                 annotation:(id)annotation;

@end
