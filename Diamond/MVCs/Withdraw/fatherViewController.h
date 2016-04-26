//
//  fatherViewController.h
//  O2O
//
//  Created by wangxiaowei on 15/7/18.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Hex.h"
#import "FrameSize.h"
#import "UIViewController+HUD.h"
#import <Foundation/Foundation.h>
#import "PSLocationManager.h"
#import "UIViewController+DismissKeyboard.h"
#import "NSString+Valid.h"
#import "Macros.h"
#import "EaseMob.h"
#import "UserSession.h"
#import "IChatManagerDelegate.h"
#import "ValidationManager.h"
#import "UserInfo.h"
#import "URLConstant.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
@interface fatherViewController : UIViewController

@property (nonatomic, strong) IQKeyboardReturnKeyHandler    *returnKeyHandler;

@end
