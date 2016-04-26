//
//  OrderIndexViewController.m
//  Diamond
//
//  Created by Pan on 15/8/28.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "OrderIndexViewController.h"
#import "OrderListContainerViewController.h"
#import "OrderIndexCell.h"
#import "ShoppingCartViewController.h"
#import "OrderIndexModel.h"
#import "withDrawlViewController.h"
@interface OrderIndexViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *earningLabel;
@property (weak, nonatomic) IBOutlet UILabel *paiedLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyedCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *selledCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *availableMoneyLabel;


- (IBAction)shopCarBtn:(UIButton *)sender;
- (IBAction)collectBtn:(UIButton *)sender;
- (IBAction)myBuyBtn:(id)sender;
- (IBAction)mySaleBtn:(UIButton *)sender;


@property(strong,nonatomic)UIBarButtonItem* rightItem;
@property (strong ,nonatomic) OrderIndexModel *model;
@end

@implementation OrderIndexViewController

#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addObserverForNotifications:@[GET_TOTAL_INFO,SHOW_TABBAR_BADGE]];
    [self setupStatisticsLabels];
    self.navigationItem.rightBarButtonItem = self.rightItem;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSLog(@"======%@",[UserSession sharedInstance].currentUser.easemob);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    [self setupStatisticsLabels];
    //FIXME:经常去获取不经常变化的网络数据，容易造成流量浪费。为了赶上线暂时这么做，将来做成：每次登出，则需要获取一次网络数据。
    [self.model giveMeStatisticalData];
    [self.tableView reloadData];
}

#pragma mark - Private Method

-(void)clickRightBtn:(UIButton*)sender
{
    withDrawlViewController* drawl = [[withDrawlViewController alloc]initWithNibName:@"withDrawlViewController" bundle:nil];
    OrderIndexEntity *entity = self.model.statistics;
    drawl.remainderMoney = entity.balance.stringValue;
    NSLog(@"%@",entity.balance);
    [self.navigationController pushViewController:drawl animated:YES];
    
}


- (void)pushToViewControllerAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            UIViewController *vc=[OrderStoryboard instantiateViewControllerWithIdentifier:[ShoppingCartViewController description]];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 1)
        {
            [self.navigationController pushViewController:[OrderStoryboard instantiateViewControllerWithIdentifier:@"CollectionViewController"] animated:YES];
        }
    }
    else if (indexPath.section == 1)
    {
        OrderOwner owner = (indexPath.row) ? OrderOwnerSeller : OrderOwnerBuyer;
        OrderListContainerViewController *vc = [OrderStoryboard instantiateViewControllerWithIdentifier:@"OrderListContainerViewController"];
        vc.owner = owner;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)setupStatisticsLabels
{
    OrderIndexEntity *entity = self.model.statistics;
    self.paiedLabel.text          = entity.paiedString;
    self.earningLabel.text        = entity.earningString;
    self.buyedCountLabel.text     = entity.buyedCountString;
    self.selledCountLabel.text    = entity.selledCountString;
    self.availableMoneyLabel.text = entity.availableMoneyString;
}

#pragma mark - Notification
- (void)receivedNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:GET_TOTAL_INFO])
    {
        [self setupStatisticsLabels];
        return;
    }
    if ([notification.name isEqualToString:SHOW_TABBAR_BADGE])
    {
        //收到推送停留在此界面也自动刷新一下
        [self.tableView reloadData];
        return;
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderIndexCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderIndexCell description] forIndexPath:indexPath];
    cell.indexPath = indexPath;
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            cell.showNoticePoint = [UserSession sharedInstance].showBuyNotice;
        } else if (indexPath.row == 1) {
            cell.showNoticePoint = [UserSession sharedInstance].showSellNotice;
        }
    }
    [cell setNeedsLayout];
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 1)
//    {
//        return @"我的订单";
//    }
//    return nil;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            [UserSession sharedInstance].showBuyNotice = NO;
        } else if (indexPath.row == 1) {
            [UserSession sharedInstance].showSellNotice = NO;
        }
    }
    [self pushToViewControllerAtIndexPath:indexPath];
}

#pragma mark - Navigation



- (IBAction)shopCarBtn:(UIButton *)sender {
    
    UIViewController *vc=[OrderStoryboard instantiateViewControllerWithIdentifier:[ShoppingCartViewController description]];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)collectBtn:(UIButton *)sender {
    
    [self.navigationController pushViewController:[OrderStoryboard instantiateViewControllerWithIdentifier:@"CollectionViewController"] animated:YES];
    
}

- (IBAction)myBuyBtn:(id)sender {
    
    [UserSession sharedInstance].showBuyNotice = NO;
    OrderOwner owner =  OrderOwnerBuyer;
    OrderListContainerViewController *vc = [OrderStoryboard instantiateViewControllerWithIdentifier:@"OrderListContainerViewController"];
    vc.owner = owner;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)mySaleBtn:(UIButton *)sender {
    
    [UserSession sharedInstance].showSellNotice = NO;
    OrderOwner owner = OrderOwnerSeller ;
    OrderListContainerViewController *vc = [OrderStoryboard instantiateViewControllerWithIdentifier:@"OrderListContainerViewController"];
    vc.owner = owner;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - Getter and Setter

-(UIBarButtonItem*)rightItem
{
    if (_rightItem == nil) {
        UIButton* btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(0, 0, 40, 30);
        [btn setTitle:@"提现" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
        _rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    }
    return _rightItem;
}

- (OrderIndexModel *)model
{
    if (!_model)
    {
        _model = [[OrderIndexModel alloc] init];
    }
    return _model;
}


@end
