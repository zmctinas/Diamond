//
//  WareListViewController.m
//  Diamond
//
//  Created by Pan on 15/7/28.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "WareListViewController.h"
#import "WareDetailViewController.h"
#import "WaresCell.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "PSDropDownMenu.h"
@interface WareListViewController ()<PSDropDownMenuDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) WareModel *model;
@property (weak, nonatomic) IBOutlet UIButton *districtButton;
@property (nonatomic, strong) PSDropDownMenu *districtMenu;

- (IBAction)touchDistrictButton:(UIButton *)sender;

@end

@implementation WareListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftBarButtonItem];
    [self.collectionView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    [self.collectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [self.collectionView.footer setTitle:@"没有更多了" forState:MJRefreshFooterStateNoMoreData];
    [self addObserverForNotifications:@[DISCOUNT_WARES_GETTED_NOTIFICATIOIN,
                                        RECOMMONED_WARES_GETTED_NOTIFICATIOIN]];
    self.title = [self titleString];
    [self.districtButton setTitle:[self.model priorDistrict] forState:UIControlStateNormal];
    
    [self.collectionView.header beginRefreshing];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = 0;
    count = [self.model.dataSource count];
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WaresCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[WaresCell description] forIndexPath:indexPath];
    if ([self.model.dataSource count])
    {
        WaresEntity *ware = [self.model.dataSource objectAtIndex:indexPath.item];
        cell.indexPath = indexPath;
        cell.ware = ware;
        cell.type = self.wareType;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:[WareDetailViewController description] sender:indexPath];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(self.collectionView.frame.size.width / 2 - 0.5, self.collectionView.frame.size.width / 2 - 0.5 + 60);
    return size;
}

#pragma mark - PSDropDownMenuDelegate
- (void)didTouchItem:(NSString *)itemTitle
{
    [self.districtButton setTitle:itemTitle forState:UIControlStateNormal];
    [UserSession sharedInstance].choosedDistrict = itemTitle;
//    [[NSNotificationCenter defaultCenter] postNotificationName:DISTRICT_CHANGED_NOTIFICATION object:nil];
    [self.collectionView.header beginRefreshing];
}


#pragma mark - Private
- (void)refresh
{
    [self.model giveMeLastestData:self.wareType];
}

- (void)loadMore
{
    [self.model giveMeNextData:self.wareType];
}

- (NSString *)titleString
{
    switch (self.wareType)
    {
        case WareTypeDiscount:
            return @"限时特价";
        case WareTypeRecommond:
            return @"小二推荐";
        case WareTypeSelf:
            return @"";
    }
}

#pragma mark - Event Response

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

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:[WareDetailViewController description]])
    {
        NSIndexPath *index = sender;
        WareDetailViewController *vc = segue.destinationViewController;
        vc.ware = [self.model.dataSource objectAtIndex:index.item];
    }
}


#pragma mark - Notification

- (void)receivedNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:DISCOUNT_WARES_GETTED_NOTIFICATIOIN]
        ||[notification.name isEqualToString:RECOMMONED_WARES_GETTED_NOTIFICATIOIN])
    {
        [self.collectionView.header endRefreshing];
        [self.collectionView.footer endRefreshing];
        [self.collectionView reloadData];
        BOOL noMoreData = [notification.object boolValue];
        if (noMoreData)
        {
            [self.collectionView.footer noticeNoMoreData];
        }
        return;
    }
    [self hideHUD];
}


- (WareModel *)model
{
    if (!_model)
    {
        _model = [[WareModel alloc]init];
    }
    return _model;
}

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
