//
//  BaseTableViewController.h
//  DrivingOrder
//
//  Created by Pan on 15/5/27.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+HUD.h"
#import "Macros.h"
#import "MJRefresh.h"
#import "EaseMob.h"
#import "UserSession.h"
#import "IChatManagerDelegate.h"
#import "ValidationManager.h"
#import "URLConstant.h"

@interface BaseTableViewController : UITableViewController
/**
 *  @required
 *  收到请求时的响应方法，所有继承BaseViewController的子类都应该实现这个方法来响应通知。
 *
 *  @param notification NSNotification
 */
- (void)receivedNotification:(NSNotification *)notification;


/**
 *  为Controller添加通知。
 *  可选的，子类不一定非要实现这个行为。
 *
 *  @param notificationNames 通知名称数组
 */
- (void)addObserverForNotifications:(NSArray *)notificationNames;

/**
 *  为NavigationBar的左上角添加一个返回按钮。
 */
- (void)addLeftBarButtonItem;

@end
