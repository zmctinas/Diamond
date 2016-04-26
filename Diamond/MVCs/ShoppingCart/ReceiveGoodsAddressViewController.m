//
//  ReceiveGoodsAddressViewController.m
//  Diamond
//
//  Created by Leon Hu on 15/8/29.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ReceiveGoodsAddressViewController.h"
#import "ReceiveGoodsAddressModel.h"
#import "ReceiveGoodsAddressCell.h"
#import "EditReceiveGoodsAddressViewController.h"

@interface ReceiveGoodsAddressViewController ()<ReceiveGoodsAddressCellDelegate>

@property (nonatomic,strong) ReceiveGoodsAddressModel *model;
@property (nonatomic,strong) ReceiveGoodsAddressEntity *currentEntity;

@end

@implementation ReceiveGoodsAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self addLeftBarButtonItem];
    [self addObserverForNotifications:@[GET_ADDRESS]];//,UPDATE_ADDRESS]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = NO;
    [self showHUDWithTitle:@"正在获取收货地址..."];
    [self.model getAddress];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:[EditReceiveGoodsAddressViewController description]]) {
        EditReceiveGoodsAddressViewController *vc = segue.destinationViewController;
        if (![sender isKindOfClass:[UIBarButtonItem class]])
        {
            vc.entity = self.currentEntity;
        }
    }
}

#pragma mark delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.model.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReceiveGoodsAddressCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[ReceiveGoodsAddressCell description] forIndexPath:indexPath];
    cell.entity = [self.model.dataSource objectAtIndex:indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReceiveGoodsAddressEntity *entity = [self.model.dataSource objectAtIndex:indexPath.row];
    [self.delegate didChooseAddress:entity];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //删除地址
        ReceiveGoodsAddressEntity *entity = [self.model.dataSource objectAtIndex:indexPath.row];
        [self.model deleteAddress:entity.addressId];
        [self.model.dataSource removeObjectAtIndex:indexPath.row];
        [self.delegate didDeleteAddress:entity];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

        //如果删除的是默认收货地址，则更改默认收货地址
//        if (entity.status)
//        {
//            ReceiveGoodsAddressEntity *defaultAddress = self.model.dataSource.firstObject;
//            defaultAddress.status = YES;
//            if (defaultAddress)
//            {
//                [self.model updateAddress:defaultAddress];
//            }
//        }
    }
}
#pragma mark - ReceiveGoodsAddressCellDelegate

- (void)didSelectAddress:(ReceiveGoodsAddressEntity *)entity
{
    [self.delegate didChooseAddress:entity];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didEditAddress:(ReceiveGoodsAddressEntity *)entity
{
    self.currentEntity = entity;
    [self performSegueWithIdentifier:[EditReceiveGoodsAddressViewController description] sender:nil];
}

#pragma mark data

- (void)receivedNotification:(NSNotification *)notification
{
    [self hideHUD];
    if ([notification.name isEqualToString:GET_ADDRESS])
    {
        self.model.dataSource = [notification.object mutableCopy];
        for (ReceiveGoodsAddressEntity *entity in self.model.dataSource) {
            if ([self.selectedAddress.addressId isEqualToString:entity.addressId]) {
                entity.isChecked = YES;
            }
        }
        [self.tableView reloadData];
    }
//    else if ([notification.name isEqualToString:UPDATE_ADDRESS])
//    {
//        ReceiveGoodsAddressEntity *entity = notification.object;
//        for (ReceiveGoodsAddressEntity *receiveGoodsAddressEntity in self.model.dataSource)
//        {
//            receiveGoodsAddressEntity.status = NO;
//        }
//        entity.status = YES;
//        [self.tableView reloadData];
//    }
}

#pragma mark getter&setter

- (ReceiveGoodsAddressModel *)model
{
    if (!_model) {
        _model = [[ReceiveGoodsAddressModel alloc] init];
    }
    return  _model;
}

@end
