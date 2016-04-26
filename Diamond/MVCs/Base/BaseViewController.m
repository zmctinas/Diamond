//
//  BaseViewController.m
//  DrivingOrder
//
//  Created by Pan on 15/5/20.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseViewController.h"
#import "ValidationManager.h"
#import "PSLocationManager.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webServiceError:) name:WebServiceErrorNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:LOGIN_STATUS_CHANGED_NOTIFICATION
                                               object:nil];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hideHUD];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addLeftBarButtonItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 20, 44)];
//    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)addLeftBarButtonItem:(NSString *)title action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
    //! 这里需要根据内容大小来调整宽度
    button.frame = CGRectMake(0, 0, size.width <= 10 ? 70 : size.width + 10, 44);
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    [button setTitleColor:UIColorFromRGB(GLOBAL_TINTCOLOR) forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-15时，间距正好调整
     *  为10；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -6;
    
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, backItem];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - BaseNotificationBehavior

- (void)addObserverForNotifications:(NSArray *)notificationNames
{
    for (NSString *name in notificationNames)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification:) name:name object:nil];
    }
}

- (void)removeObserverForNotifications:(NSArray *)notificationNames
{
    for (NSString *name in notificationNames)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
    }
}

- (void)receivedNotification:(NSNotification *)notification
{
   //Override Point,收到通知的响应方法。
}

#pragma mark - private method
- (void)webServiceError:(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[NSString class]])
    {
        [self showtips:notification.object];
    }
    else
    {
        [self showtips:@"网络出错，请重试"];
    }
}

- (void)loginStateChange:(NSNotification *)notification
{
    BOOL isLogin = [notification.object boolValue];
    if (!isLogin)
    {
        [[UserSession sharedInstance] resetUser];
        [[UserInfo info] clear];
        
        //退出环信
        EMError *error;
        [[EaseMob sharedInstance].chatManager logoffWithUnbindDeviceToken:NO error:&error];
        
        [ValidationManager setLoginStatus:NO];
        [ValidationManager validateLogin:self completion:^{
            [self showtips:@"您的账号在其他设备上登陆了"];
        }];
    }
}


@end
