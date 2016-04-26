//
//  UIViewController+HUD.m
//  MinusNight
//
//  Created by Pan on 15/9/6.
//  Copyright (c) 2015年 Insigma Hengtian Software Co., LTD. All rights reserved.
//

#import "UIViewController+HUD.h"
#import "SVProgressHUD.h"

@implementation UIViewController (HUD)

- (void)showtips:(NSString *)tips
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showInfoWithStatus:tips];
    });
}

- (void)showHUDWithTitle:(NSString *)title;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:title];
    });
}

- (void)hideHUD
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}


@end
