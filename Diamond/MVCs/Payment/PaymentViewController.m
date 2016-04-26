//
//  PaymentViewController.m
//  Diamond
//
//  Created by Pan on 15/8/27.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "PaymentViewController.h"
#import "DMAliPayManager.h"
#import "PaymentCell.h"
#import "CheckBar.h"
#import "PaymentModel.h"
#import "OrderListContainerViewController.h"

#define ROW_ALIPAY    0
#define ROW_WECHATPAY 1

static NSString * const PaySuccessTips = @"支付成功!";
static NSString * const PayFailureTips = @"支付失败,请重新支付!";

@interface PaymentViewController ()<UITabBarDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) PaymentModel *model;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

- (IBAction)touchPayButton:(UIButton *)sender;

@end

@implementation PaymentViewController
#pragma mark - Public
- (void)setupWaitPayOrder:(OrderDetailEntity *)entity
{
    self.model.waitPayOrder = entity;
}

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addObserverForNotifications:@[WECHATPAY_RESULT,ALIPAY_RESULT,PaySuccessNotification]];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.model.waitPayOrder.total_fee doubleValue]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - Private Method


#pragma mark - Notification
- (void)receivedNotification:(NSNotification *)notification
{
    [self hideHUD];
    if ([notification.name isEqualToString:WECHATPAY_RESULT]
        || [notification.name isEqualToString:ALIPAY_RESULT])
    {
        BOOL isSuccess = [notification.object boolValue];
        NSString *message = isSuccess ? PaySuccessTips : PayFailureTips;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:message
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
    //防止菊花无线转的BUG
    if ([notification.name isEqualToString:PaySuccessNotification])
    {
        [self hideHUD];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex)
    {
        if ([alertView.message isEqualToString:PaySuccessTips])
        {
            OrderListContainerViewController *vc = [OrderStoryboard instantiateViewControllerWithIdentifier:[OrderListContainerViewController description]];
            vc.owner = OrderOwnerBuyer;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([alertView.message isEqualToString:PayFailureTips])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


#pragma mark - Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:[PaymentCell description] forIndexPath:indexPath];
    cell.indexPath = indexPath;
    return cell;
}

#pragma mark - Event Response


#pragma mark - Getter and Setter
- (PaymentModel *)model
{
    if (!_model)
    {
        _model = [[PaymentModel alloc]init];
    }
    return _model;
}

- (IBAction)touchPayButton:(UIButton *)sender
{
    if (self.tableView.indexPathForSelectedRow.row == ROW_ALIPAY)
    {
        [self showHUDWithTitle:nil];
        [self.model payWithAlipay];
    }
    else if (self.tableView.indexPathForSelectedRow.row == ROW_WECHATPAY)
    {
        [self showHUDWithTitle:nil];
        [self.model payWithWechat];
    }
}

@end
