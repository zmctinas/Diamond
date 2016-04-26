//
//  OrderListViewController.h
//  Diamond
//
//  Created by Pan on 15/8/31.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseTableViewController.h"
#import "OrderListEntity.h"

static NSString *const TITLE_ALL = @"全部";
static NSString *const TITLE_UNPAY = @"未付款";
static NSString *const TITLE_UNCHARGE = @"未收款";
static NSString *const TITLE_TRADING = @"交易中";
static NSString *const TITLE_DONE = @"已交易";


@interface OrderListViewController : BaseTableViewController

@property (nonatomic) OrderOwner owner;

@end
