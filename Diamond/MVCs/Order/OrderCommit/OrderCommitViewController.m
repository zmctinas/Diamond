//
//  OrderCommitViewController.m
//  Diamond
//
//  Created by Pan on 15/9/7.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "OrderCommitViewController.h"
#import "OrderDetailViewController.h"
#import "ReceiveGoodsAddressViewController.h"
#import "UIViewController+DismissKeyboard.h"
#import "OrderDetailModel.h"
#import "ReceiveGoodsAddressModel.h"
#import "DeliveryTypeView.h"
#import "OrderDetailFooterView.h"
#import "OrderDetailHeaderView.h"

#import "OrderDetailAddressCell.h"
#import "PaymentTypeCell.h"
#import "OrderListCell.h"
#import "CheckBar.h"
#import "PaymentViewController.h"

#define ADDRESS_SECTION       0
#define PAYMENT_TYPE_SECTION  1
#define ORDER_DETAIL_SECTION  2

#define TOTLE_SECTIONS        3


@interface OrderCommitViewController ()<CheckBarDelegate,
                                        OrderDetailFooterViewDelegate,
                                        OrderDetailHeaderViewDelegate,
                                        DeliveryTypeViewDelegate,
                                        ConsigneeAddressViewControllerDelegate>

@property (weak, nonatomic) IBOutlet CheckBar *checkBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet DeliveryTypeView *deliveryTypeView;

@property (strong, nonatomic) OrderDetailModel *model;
@property (strong, nonatomic) ReceiveGoodsAddressModel *receiveGoodsAdddressModel;

@property (nonatomic) OrderOwner owner;

@end

@implementation OrderCommitViewController
#pragma mark - Public Method
- (void)setupOrder:(OrderDetailEntity *)order;
{
    self.model.orderDetail = order;
    //默认付款方式 当面交易
    self.model.orderDetail.payment_type = PaymentTypeOnLine;
    //默认配送方式 卖家配送
    self.model.orderDetail.delivery_type = DeliveryTypeSeller;

}

#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addLeftBarButtonItem];
    [self setupForDismissKeyboard];
    [self.receiveGoodsAdddressModel getAddress];
    [self addObserverForNotifications:@[ORDER_SUBMITE]];
    [self setupCheckBar];
    self.deliveryTypeView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addObserverForNotifications:@[GET_ADDRESS]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeObserverForNotifications:@[GET_ADDRESS]];
}


#pragma mark - Private Method
- (void)setupCheckBar
{
    self.checkBar.owner = self.owner;
    self.checkBar.orderStatus = self.model.orderDetail.status;
    self.checkBar.delegate = self;
    self.checkBar.price = self.model.orderDetail.total_fee;
}


- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    if (section == ADDRESS_SECTION)
    {
        return 1;
    }
    
    if (section == PAYMENT_TYPE_SECTION)
    {
        return 2;
    }
    
    if (section == ORDER_DETAIL_SECTION)
    {
        return [self.model.orderDetail.list count];
    }
    return 0;
}

- (UITableViewCell *)diffirentCellForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    OrderDetailEntity *orderDetailEntity = self.model.orderDetail;
    
    if (section == ADDRESS_SECTION)
    {
        OrderDetailAddressCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[OrderDetailAddressCell description] forIndexPath:indexPath];
        cell.entity = orderDetailEntity;
        return cell;
    }
    
    if (section == PAYMENT_TYPE_SECTION)
    {
        PaymentTypeCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[PaymentTypeCell description] forIndexPath:indexPath];
        cell.indexPath = indexPath;
        cell.entity = self.model.orderDetail;
        return cell;
    }
    
    if (section == ORDER_DETAIL_SECTION)
    {
        OrderListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[OrderListCell description] forIndexPath:indexPath];
        if ([orderDetailEntity.list count])
        {
            OrderWare *ware = [orderDetailEntity.list objectAtIndex:indexPath.row];
            cell.ware = ware;
        }
        return cell;
    }
    return nil;
}

- (CGFloat)diffirentHeightForcellAtIndexPath:(NSIndexPath *)indexPath;
{
    NSInteger section = indexPath.section;
    if (section == ADDRESS_SECTION)
    {
        return (self.model.orderDetail) ? ADDRESS_CELL_HEIGHT_WITH_ENTITY : ADDRESS_CELL_HEIGHT_WITHOUT_ENTITY;
    }
    
    if (section == PAYMENT_TYPE_SECTION)
    {
        return PAYMENT_CELL_HEIGHT;
    }
    
    if (section == ORDER_DETAIL_SECTION)
    {
        return ORDER_LIST_CELL_HEIGHT;
    }
    return 44;
}


#pragma mark - Notification

- (void)receivedNotification:(NSNotification *)notification
{
    [self hideHUD];
    if ([notification.name isEqualToString:ORDER_SUBMITE])
    {
        OrderDetailViewController *vc = [OrderStoryboard instantiateViewControllerWithIdentifier:[OrderDetailViewController description]];
        [vc setupWithOwner:OrderOwnerBuyer entity:self.model.orderDetail];
        vc.backToViewController = self.pushedViewController;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([notification.name isEqualToString:GET_ADDRESS])
    {
        NSArray *addressList = notification.object;
        //自动选择默认地址
        for (ReceiveGoodsAddressEntity *entity in addressList)
        {
            if (entity.status)
            {
                [self didChooseAddress:entity];
            }
        }
        return;
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return TOTLE_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return [self diffirentHeightForcellAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self diffirentCellForIndexPath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == ORDER_DETAIL_SECTION)
    {
        NSString *reuseIdentifer = [OrderDetailHeaderView description];
        
        OrderDetailHeaderView *headView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifer];
        if (!headView)
        {
            [self.tableView registerNib:[UINib nibWithNibName:reuseIdentifer bundle:nil]  forHeaderFooterViewReuseIdentifier:reuseIdentifer];
            headView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifer];
        }
        
        if ([self.model.orderDetail.list count])
        {
            OrderDetailEntity *orderDetail = self.model.orderDetail;
            headView.entity = orderDetail;
        }
        
        headView.delegate = self;
        headView.owner = self.owner;
        return headView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == ORDER_DETAIL_SECTION)
    {
        return ORDER_DETAIL_HEADER_HEIGHT_NO_ORDER;
    }
    return 5.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == ORDER_DETAIL_SECTION)
    {
        NSString *reuseIdentifer = [OrderDetailFooterView description];
        
        OrderDetailFooterView *footerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifer];
        if (!footerView)
        {
            [self.tableView registerNib:[UINib nibWithNibName:reuseIdentifer bundle:nil]  forHeaderFooterViewReuseIdentifier:reuseIdentifer];
            footerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifer];
        }
        
        if ([self.model.orderDetail.list count])
        {
            OrderDetailEntity *orderDetail = self.model.orderDetail;
            footerView.entity = orderDetail;
            footerView.owner = self.owner;
            footerView.orderType = OrderDetailTypeCommit;
            footerView.delegate = self;
        }
        return footerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == ORDER_DETAIL_SECTION)
    {
        return ORDER_DETAIL_FOOTER_VIEW_HEIGHT;
    }
    return 5.0;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == ADDRESS_SECTION)
    {
        //选择收货地址
        [self performSegueWithIdentifier:[ReceiveGoodsAddressViewController description] sender:nil];
    }
    else if (indexPath.section == PAYMENT_TYPE_SECTION)
    {
        self.model.orderDetail.payment_type = indexPath.row;
        [self.tableView reloadData];
    }
}

#pragma mark - OrderDetailFooterViewDelegate
- (void)didTouchPostTypeButton
{
    [self.deliveryTypeView showInView:self.navigationController.view];
}

- (void)didTouchRetrunKeyWithInputWords:(NSString *)words
{
    self.model.orderDetail.introduction = words;
    [self.tableView reloadData];
}

#pragma mark - CheckBarDelegate
- (void)didTouchConformButton
{
    if (!self.model.orderDetail.delivery_address && self.model.orderDetail.delivery_type == DeliveryTypeSeller)
    {
        [self showtips:@"请选择收货地址"];
        return;
    }
    [self showHUDWithTitle:@"订单提交中..."];
    [self.model submitOrderWithCartList:self.cartList];
}

#pragma mark - DeliveryTypeViewDelegate
- (void)didChooseDeliveryType:(DeliveryType)type
{
    self.model.orderDetail.delivery_type = type;
    [self.tableView reloadData];
}

#pragma mark - ConsigneeAddressViewControllerDelegate
- (void)didChooseAddress:(ReceiveGoodsAddressEntity *)address
{
    self.model.orderDetail.consigneeAddress = address;
    self.model.orderDetail.delivery_address = @([address.addressId integerValue]);
    [self.tableView reloadData];
}

- (void)didDeleteAddress:(ReceiveGoodsAddressEntity *)address
{
    if ([self.model.orderDetail.consigneeAddress.addressId isEqualToString:address.addressId])
    {
        [self didChooseAddress:nil];
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:[ReceiveGoodsAddressViewController description]])
    {
        ReceiveGoodsAddressViewController *vc = segue.destinationViewController;
        if (self.model.orderDetail.consigneeAddress)
        {
            vc.selectedAddress = self.model.orderDetail.consigneeAddress;
        }
        vc.delegate = self;
    }
}


#pragma mark - Getter Setter

- (OrderOwner)owner
{
    //提交订单的永远只有买家
    return OrderOwnerBuyer;
}

- (OrderDetailModel *)model
{
    if (!_model)
    {
        _model = [[OrderDetailModel alloc] init];
    }
    return _model;
}

- (ReceiveGoodsAddressModel *)receiveGoodsAdddressModel
{
    if (!_receiveGoodsAdddressModel)
    {
        _receiveGoodsAdddressModel = [ReceiveGoodsAddressModel new];
    }
    return _receiveGoodsAdddressModel;
}
@end