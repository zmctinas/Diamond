//
//  BaseTableViewController.m
//  DrivingOrder
//
//  Created by Pan on 15/5/27.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ValidationManager.h"
#import "UserInfo.h"
@interface BaseTableViewController()


@end

@implementation BaseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WebServiceErrorNotification object:nil];
    [self hideHUD];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addLeftBarButtonItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 20, 44)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = item;
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
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


- (void)receivedNotification:(NSNotification *)notification
{
    //Override Point,收到通知的响应方法。
}


#pragma mark - private method
- (void)webServiceError:(NSNotification *)notification
{
    if (self.tableView.header)
    {
        [self.tableView.header endRefreshing];
    }
    
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
