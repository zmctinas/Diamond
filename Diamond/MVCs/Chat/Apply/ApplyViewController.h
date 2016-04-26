//
//  ApplyViewController.h
//  Diamond
//
//  Created by Pan on 15/7/25.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseTableViewController.h"

@interface ApplyViewController : BaseTableViewController

@property (strong, nonatomic, readonly) NSMutableArray *dataSource;

+ (instancetype)shareController;
/**
 *  添加一个新的ApplyEntity,用户接受到环信好友申请的回调
 *
 *  @param easemob 环信账号
 *  @param message 请求消息
 */
- (void)addNewApply:(NSString *)easemob message:(NSString *)message;

- (void)loadDataSourceFromLocalDB;

- (void)clear;
@end
