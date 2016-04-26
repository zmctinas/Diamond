//
//  AppDelegate.h
//  Diamond
//
//  Created by Pan on 15/7/11.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseMob.h"
#import "WXApi.h"
@class UserDetailModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate,IChatManagerDelegate,WXApiDelegate>
{
    EMConnectionState _connectionState;
}
@property (strong, nonatomic) UserDetailModel *userdetailModel;
@property (strong, nonatomic) UIWindow *window;

//为Jpush注册别名
- (void)registerJpushAlias;

@end

