//
//  ShopListViewController.m
//  Diamond
//
//  Created by Pan on 15/7/28.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ShopListViewController.h"
#import "ShopsCell.h"
#import "MJRefresh.h"
#import "PSDropDownMenu.h"
#import "ShopDetailViewController.h"
@interface ShopListViewController ()<UITableViewDelegate,UITableViewDataSource,PSDropDownMenuDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *districtButton;

@property (nonatomic, strong) ShopModel *model;
@property (nonatomic, strong) PSDropDownMenu *districtMenu;

- (IBAction)touchDistrictButton:(UIButton *)sender;

@end

@implementation ShopListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addLeftBarButtonItem];
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    
    if (self.shopType != ShopTypeDaimang)
    {
        [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    }
    
    [self.tableView.footer setTitle:@"没有更多了" forState:MJRefreshFooterStateNoMoreData];
    [self addObserverForNotifications:@[SHOP_DATA_GETTED_NOTIFICATIOIN]];
    self.title = [Util shopTitleWithType:self.shopType];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self.districtButton setTitle:[self.model priorDistrict] forState:UIControlStateNormal];
    
    [self.tableView.header beginRefreshing];
}

#pragma mark - private


- (void)refresh
{
    //如果这个店铺列表是代忙官方活动列表,下拉刷新的时候需要调取不同的接口
    if (self.shopType == ShopTypeDaimang)
    {
        [self.model giveMeDaimangActivityShops:self.activityID];
    }
    else
    {
        [self.model giveMeLastestData:self.shopType];
    }
}

- (void)loadMore
{
    [self.model giveMeNextData:self.shopType];
}


#pragma mark - IBAction
- (IBAction)touchDistrictButton:(UIButton *)sender
{
    if (![[UserSession sharedInstance].districts count])
    {
        [self showtips:@"未能获取区域信息，请在首页切换城市试试"];
        return;
    }
    if(self.districtMenu.show)
    {
        [self.districtMenu hide];
    }
    else
    {
        [self.districtMenu showInView:self.view];
    }

}

#pragma mark - PSDropDownMenuDelegate
- (void)didTouchItem:(NSString *)itemTitle
{
    [self.districtButton setTitle:itemTitle forState:UIControlStateNormal];
    [UserSession sharedInstance].choosedDistrict = itemTitle;
    [self.tableView.header beginRefreshing];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.model.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopsCell *cell = [tableView dequeueReusableCellWithIdentifier:[ShopsCell description] forIndexPath:indexPath];
    cell.shop = [self.model.dataSource objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:[ShopDetailViewController description] sender:indexPath];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:[ShopDetailViewController description]])
    {
        NSIndexPath *index = sender;
        ShopDetailViewController *vc = segue.destinationViewController;
        if ([self.model.dataSource count])
        {
            Shop *shop = [self.model.dataSource objectAtIndex:index.row];
            vc.shop = shop;
        }
    }
}

#pragma mark - Notification

- (void)receivedNotification:(NSNotification *)notification
{
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
    if ([notification.name isEqualToString:SHOP_DATA_GETTED_NOTIFICATIOIN])
    {
        [self.tableView reloadData];
        //当这个店铺列表是代忙活动的时候,不需要下拉刷新。
        if (self.shopType != ShopTypeDaimang)
        {
            BOOL noMoreData = [notification.object boolValue];
            if (noMoreData)
            {
                [self.tableView.footer noticeNoMoreData];
            }
        }
    }
}


#pragma mark - Getter and setter
- (ShopModel *)model
{
    if (!_model)
    {
        _model = [ShopModel new];
    }
    return _model;
}


#pragma mark - Getter and Setter

- (PSDropDownMenu *)districtMenu
{
    if (!_districtMenu)
    {
        _districtMenu = [[PSDropDownMenu alloc]initWithFrame:self.view.frame dataSource:[UserSession sharedInstance].districts];
        _districtMenu.delegate = self;
    }
    return _districtMenu;
}
@end
