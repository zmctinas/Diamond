//
//  UIViewController+HUD.h
//  MinusNight
//
//  Created by Pan on 15/9/6.
//  Copyright (c) 2015年 Insigma Hengtian Software Co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HUD)

/**
 *  replace laertView
 *
 *  @param tips tips will show to user
 */
- (void)showtips:(NSString *)tips;
/**
 *  When some operation need user to wait,use this mothed to show a HDU.
 */
- (void)showHUDWithTitle:(NSString *)title;

- (void)hideHUD;

@end
