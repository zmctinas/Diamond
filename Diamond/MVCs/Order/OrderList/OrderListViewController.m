//
//  OrderListViewController.m
//  Diamond
//
//  Created by Pan on 15/8/31.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderListCell.h"
#import "OrderListModel.h"
#import "OrderListHeadView.h"
#import "OrderListFootView.h"
#import "SellerOrderListHeadView.h"
#import "PaymentViewController.h"
#import "OrderDetailViewController.h"
#import "OrderDetailEntity.h"


@interface OrderListViewController ()<OrderListFootViewDelegate>

@property (strong, nonatomic) OrderListModel *model;
@property (nonatomic) NSArray *status;

@end

@implementation OrderListViewController

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addLeftBarButtonItem];
    [self addObserverForNotifications:@[GET_SELLER_ORDER_LIST,
                                        GET_BUYER_ORDER_LIST,
                                        CONFORM_SEND,
                                        CONFORM_ORDER,
                                        CLOSE_ORDER,
                                        EDIT_POSTAGE_NOTIFICATION,
                                        EDIT_TOTLE_FEE_NOTIFICATION,
                                        REFRESH_ORDER_LIST]];
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [self.tableView.footer setTitle:@"没有更多了" forState:MJRefreshFooterStateNoMoreData];
    [self.tableView.header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addObserverForNotifications:@[REFRESH_ORDER]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REFRESH_ORDER object:nil];
}


#pragma mark - Private Method
- (void)refresh
{
    [self.model giveMeLastestData:self.owner orderStatus:self.status];
}

- (void)loadMore
{
    [self.model giveMeNextData:self.owner orderStatus:self.status];
}


- (void)actionWithOwner:(OrderOwner)owner entity:(OrderListEntity *)entity
{
    if (owner == OrderOwnerBuyer)
    {
        if (entity.status == OrderStatusUnpay)
        {
            [self pay:entity];
            return;
        }
        
        if (entity.status == OrderStatusSellerConformed)
        {
            [self showHUDWithTitle:nil];
            [self.model conformWareGetted:entity.out_trade_no];
            return;
        }
    }
    else if (owner == OrderOwnerSeller)
    {
        if (entity.status == OrderStatusPaied)
        {
            [self showHUDWithTitle:nil];
            [self.model conformWareSended:entity.out_trade_no];
            return;
        }
    }
}

- (void)pay:(OrderListEntity *)entity
{
    [self performSegueWithIdentifier:[PaymentViewController description] sender:entity];
}

#pragma mark - Notification
- (void)receivedNotification:(NSNotification *)notification
{
    [self hideHUD];
    if ([notification.name isEqualToString:GET_BUYER_ORDER_LIST]
        || [notification.name isEqualToString:GET_SELLER_ORDER_LIST])
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
    
    if ([notification.name isEqualToString:CONFORM_ORDER])
    {
        OrderListEntity *entity = [self.model entityInDataSourceWithID:notification.object];
        entity.status = OrderStatusBuyerConformed;
        [self.tableView reloadData];
        return;
    }
    
    if ([notification.name isEqualToString:CONFORM_SEND])
    {
        OrderListEntity *entity = [self.model entityInDataSourceWithID:notification.object];
        entity.status = OrderStatusSellerConformed;
        [self.tableView reloadData];
        return;
    }
    
    if ([notification.name isEqualToString:CLOSE_ORDER])
    {
        OrderListEntity *entity = [self.model entityInDataSourceWithID:notification.object];
        entity.status = OrderStatusCancel;
        [self.tableView reloadData];
        return;
    }
    
    if (   [notification.name isEqualToString:EDIT_POSTAGE_NOTIFICATION]
        || [notification.name isEqualToString:EDIT_TOTLE_FEE_NOTIFICATION])
    {
        OrderDetailEntity *orderDetail = notification.object;
        OrderListEntity *orderList = [self.model entityInDataSourceWithID:orderDetail.out_trade_no];
        orderList.delivery_fee = orderDetail.delivery_fee;
        orderList.old_total_fee = orderDetail.old_total_fee;
        orderList.total_fee = orderDetail.total_fee;
        [self.tableView reloadData];
        return;
    }
    //卖家修改了价格，收到推送
    if ([notification.name isEqualToString:REFRESH_ORDER])
    {
        if (self.owner == OrderOwnerBuyer)
        {
            [self.tableView.header beginRefreshing];
        }
        return;
    }
    //买家付款
    if ([notification.name isEqualToString:REFRESH_ORDER_LIST])
    {
        if (self.owner == OrderOwnerSeller)
        {
            [self.tableView.header beginRefreshing];
        }
        return;
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.model.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    OrderListEntity *orderList = [self.model.dataSource objectAtIndex:section];
    return [orderList.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderListCell description] forIndexPath:indexPath];
    OrderListEntity *orderList = [self.model.dataSource objectAtIndex:indexPath.section];
    if ([orderList.list count])
    {
        OrderWare *ware = [orderList.list objectAtIndex:indexPath.row];
        cell.ware = ware;
    }
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *reuseIdentifer = (self.owner == OrderOwnerBuyer) ? [OrderListHeadView description] : [SellerOrderListHeadView description];
    
    OrderListHeadView *headView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifer];
    if (!headView)
    {
        [self.tableView registerNib:[UINib nibWithNibName:reuseIdentifer bundle:nil]  forHeaderFooterViewReuseIdentifier:reuseIdentifer];
        headView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifer];
    }
    OrderListEntity *orderList = [self.model.dataSource objectAtIndex:section];
    headView.entity = orderList;
    headView.owner = self.owner;
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (self.owner == OrderOwnerBuyer) ? OrderListHeadViewHeight : SELLER_ORDER_LIST_HEAD_VIEW_HEIGHT;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    OrderListFootView *footView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:[OrderListFootView description]];
    if (!footView)
    {
        [self.tableView registerNib:[UINib nibWithNibName:[OrderListFootView description] bundle:nil]  forHeaderFooterViewReuseIdentifier:[OrderListFootView description]];
        footView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:[OrderListFootView description]];
    }
    OrderListEntity *orderList = [self.model.dataSource objectAtIndex:section];
    footView.entity = orderList;
    footView.orderOwner = self.owner;
    footView.delegate = self;
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return OrderListFootViewHeight;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderListEntity *orderList = [self.model.dataSource objectAtIndex:indexPath.section];
    [self performSegueWithIdentifier:[OrderDetailViewController description] sender:orderList];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:[OrderDetailViewController description]])
    {
        OrderListEntity *orderList = sender;
        OrderDetailViewController *vc = segue.destinationViewController;
        [OrderDetailEntity setupObjectClassInArray:^NSDictionary *{
            return @{@"list" : NSStringFromClass([OrderWare class]),};
        }];
        OrderDetailEntity *entity = [OrderDetailEntity objectWithKeyValues:orderList.keyValues];
        [vc setupWithOwner:self.owner entity:entity];
    }
    
    if ([segue.identifier isEqualToString:[PaymentViewController description]])
    {
        PaymentViewController *vc = segue.destinationViewController;
        OrderDetailEntity *entity = [OrderDetailEntity objectWithKeyValues:sender];
        [vc setupWaitPayOrder:entity];
    }
}

#pragma mark - OrderListFootViewDelegate

- (void)footView:(OrderListFootView *)footView didTouchConformButton:(UIButton *)button
{
    [self actionWithOwner:self.owner entity:footView.entity];
}

#pragma mark - Getter and Setter
- (OrderListModel *)model
{
    if (!_model)
    {
        _model = [[OrderListModel alloc]init];
    }
    return _model;
}

- (NSArray *)status
{
    if ([self.title isEqualToString:TITLE_ALL])
    {
        return ORDER_STATUS_ALL;
    }
    if ([self.title isEqualToString:TITLE_UNPAY] || [self.title isEqualToString:TITLE_UNCHARGE])
    {
        return @[@(OrderStatusUnpay)];
    }
    if ([self.title isEqualToString:TITLE_TRADING])
    {
        return @[@(OrderStatusPaied),@(OrderStatusSellerConformed)];
    }
    if ([self.title isEqualToString:TITLE_DONE])
    {
        return @[@(OrderStatusBuyerConformed),@(OrderStatusCancel)];
    }
    return ORDER_STATUS_ALL;
}
@end
