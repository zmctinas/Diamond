//
//  ValidationManager.m
//  DrivingOrder
//
//  Created by Pan on 15/5/20.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ValidationManager.h"
#import "LoginViewController.h"
#import "Macros.h"

@implementation ValidationManager

+ (void)setLoginStatus:(BOOL)login
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:IS_LOGIN];
    [[NSUserDefaults standardUserDefaults] setBool:login forKey:IS_LOGIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isLogin
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:IS_LOGIN];
}

+ (BOOL)validateLogin:(UIViewController *)vc
{
    return [self validateLogin:vc completion:nil];
}

+ (BOOL)validateLogin:(UIViewController *)vc completion:(void (^)(void))completion
{
    if (![ValidationManager isLogin] && ![vc isKindOfClass:[LoginViewController class]])
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UINavigationController *loginNaviVC = [sb instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
        [vc presentViewController:loginNaviVC animated:YES completion:completion];
    }
    return [ValidationManager isLogin];
}

@end
