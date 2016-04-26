//
//  Page1ViewController.m
//  Diamond
//
//  Created by Leon Hu on 15/7/30.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ShopCollectionPageViewController.h"
#import "CollectionModel.h"
#import "ShopDetailModel.h"
#import "ShopDetailViewController.h"
#import "ShopsCell.h"
#import "Shop.h"
@interface ShopCollectionPageViewController ()

@property (nonatomic, strong) CollectionModel *model;
@property (nonatomic, strong) ShopDetailModel *shopModel;

@end

@implementation ShopCollectionPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addObserverForNotifications:@[GET_SHOP_COLLEC,UN_STORE_UP_SHOP_FAILURE]];
    [self.tableView.header beginRefreshing];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tableView.header endRefreshing];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupTableView
{
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [self.tableView.footer setTitle:@"" forState:MJRefreshFooterStateNoMoreData];
    [self.tableView setTableFooterView:[UIView new]];
    [self.tableView.header beginRefreshing];
}

#pragma mark - UITableViewController
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.model.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopsCell *cell = [tableView dequeueReusableCellWithIdentifier:[ShopsCell description] forIndexPath:indexPath];
    Shop *shop = [self.model.dataSource objectAtIndex:indexPath.row];
    cell.shop = shop;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopDetailViewController *vc = [MStoryboard instantiateViewControllerWithIdentifier:[ShopDetailViewController description]];
    vc.shop = [self.model.dataSource objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.shopModel unStoreUpShop:@[[self.model.dataSource objectAtIndex:indexPath.row]]];
        [self.model.dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Private
- (void)refresh
{
    [self.model giveMeLastestData:CollectionTypeShop];
}

- (void)loadMore
{
    [self.model giveMeNextData:CollectionTypeShop];
}


#pragma mark - Notification

- (void)receivedNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:GET_SHOP_COLLEC])
    {
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
        [self.tableView reloadData];
        BOOL noMoreData = [notification.object boolValue];
        if (noMoreData)
        {
            [self.tableView.footer noticeNoMoreData];
        }
        return;
    }
    
    if ([notification.name isEqualToString:UN_STORE_UP_SHOP_FAILURE])
    {
        [self showtips:notification.object];
        return;
    }
}

- (CollectionModel *)model
{
    if (!_model)
    {
        _model = [CollectionModel new];
    }
    return _model;
}

- (ShopDetailModel *)shopModel
{
    if (!_shopModel)
    {
        _shopModel = [[ShopDetailModel alloc]init];
    }
    return _shopModel;
}

@end
