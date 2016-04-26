//
//  LimitedSpecialViewController.m
//  Diamond
//
//  Created by Leon Hu on 15/8/9.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "LimitedSpecialViewController.h"
#import "WareDetailViewController.h"
#import "WareModel.h"
#import "SelectedWareCell.h"
#import "MJRefresh.h"
#import "LimitedSpecialModel.h"

@interface LimitedSpecialViewController()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) LimitedSpecialModel *model;

@end

@implementation LimitedSpecialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftBarButtonItem];
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    [self addObserverForNotifications:@[GET_SHOP_GOODS,DEL_PROMOTION,TICK_TOCK_NOTIFICATION]];
    self.title = @"限时特价";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView.header beginRefreshing];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    count = [self.model.dataSource count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectedWareCell *cell = [tableView dequeueReusableCellWithIdentifier:[SelectedWareCell description] forIndexPath:indexPath];
    if ([self.model.dataSource count])
    {
        WaresEntity *ware = [self.model.dataSource objectAtIndex:indexPath.row];
        cell.ware = ware;
        cell.type = LimitedSpecialDelete;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self showHUDWithTitle:@"删除特价..."];
        [self.model delPromotionAtIndexPath:indexPath];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

#pragma mark - Private
- (void)refresh
{
    [self.model giveMeLastestData];
}

#pragma mark - Notification
//重写基类的网络错误处理
- (void)webServiceError:(NSNotification *)notification
{
    [self.tableView.header endRefreshing];
    if ([notification.object isKindOfClass:[NSString class]])
    {
        [self showtips:notification.object];
    }
    else
    {
        [self showtips:@"网络出错，请重试"];
    }
}
 
- (void)receivedNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:GET_SHOP_GOODS])
    {
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
    }
    else if ([notification.name isEqualToString:DEL_PROMOTION])
    {
        [self.tableView deleteRowsAtIndexPaths:@[notification.object] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [self hideHUD];
}

- (LimitedSpecialModel *)model
{
    if (!_model) {
        _model = [[LimitedSpecialModel alloc] init];
    }
    return _model;
}

@end
