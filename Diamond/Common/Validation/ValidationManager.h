//
//  ValidationManager.h
//  DrivingOrder
//
//  Created by Pan on 15/5/20.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<UIKit/UIKit.h>

@interface ValidationManager : NSObject

+ (void)setLoginStatus:(BOOL)login;

+ (BOOL)isLogin;

+ (BOOL)validateLogin:(UIViewController *)vc;

+ (BOOL)validateLogin:(UIViewController *)vc completion:(void (^)(void))completion;
@end
