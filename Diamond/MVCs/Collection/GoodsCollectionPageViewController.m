//
//  Page2ViewController.m
//  Diamond
//
//  Created by Leon Hu on 15/7/30.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "GoodsCollectionPageViewController.h"
#import "SearchGoodsCell.h"
#import "CollectionModel.h"
#import "WareDetailModel.h"
#import "WareDetailViewController.h"
@interface GoodsCollectionPageViewController ()

@property (nonatomic, strong) CollectionModel *model;
@property (nonatomic, strong) WareDetailModel *wareModel;


@end

@implementation GoodsCollectionPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addObserverForNotifications:@[GET_GOODS_COLLEC,UN_STORE_UP_WARE_FAILURE]];
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
    SearchGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:[SearchGoodsCell description] forIndexPath:indexPath];
    WaresEntity *ware = [self.model.dataSource objectAtIndex:indexPath.row];
    cell.ware = ware;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WareDetailViewController *vc = [MStoryboard instantiateViewControllerWithIdentifier:[WareDetailViewController description]];
    vc.ware = [self.model.dataSource objectAtIndex:indexPath.row];
    vc.ware.isCollected = YES;
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
        [self.wareModel unStoreUpWare:@[[self.model.dataSource objectAtIndex:indexPath.row]]];
        [self.model.dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Private
- (void)refresh
{
    [self.model giveMeLastestData:CollectionTypeWare];
}

- (void)loadMore
{
    [self.model giveMeNextData:CollectionTypeWare];
}

#pragma mark - Notification

- (void)receivedNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:GET_GOODS_COLLEC])
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
    if ([notification.name isEqualToString:UN_STORE_UP_WARE_FAILURE])
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

- (WareDetailModel *)wareModel
{
    if (!_wareModel)
    {
        _wareModel = [[WareDetailModel alloc] init];
    }
    return _wareModel;
}

@end
