//
//  SelectLimitedSpecialViewController.m
//  Diamond
//
//  Created by Leon Hu on 15/8/16.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "SelectLimitedSpecialViewController.h"
#import "ShopDetailModel.h"
#import "WaresEntity.h"
#import "EditLimitedSpecialViewController.h"

@interface SelectLimitedSpecialViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UIButton *rightBarButton;
- (IBAction)touchRightBarButton:(UIButton *)sender;

@property (nonatomic,strong) ShopDetailModel *model;
@property (nonatomic,strong) NSMutableArray *selectedId;

@end

@implementation SelectLimitedSpecialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self adjustRightBarButtonTitle];
    [self addLeftBarButtonItem];
    [self addObserverForNotifications:@[SHOP_GOODS_LIST_GETTED_NOTIFICATION ]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.editButton.adjustsImageWhenHighlighted = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = NO;
    
    [self.selectedId removeAllObjects];
    [self.model giveMeShopGoodsByShopId:[[UserSession sharedInstance] currentUser].shop_id];
}

- (void)adjustRightBarButtonTitle
{
    NSString *title = self.selectedId.count ? @"取消全选" : @"全选";
    [self.rightBarButton setTitle:title forState:UIControlStateNormal];
}

- (IBAction)touchRightBarButton:(UIButton *)sender {
    
    [self.selectedId removeAllObjects];

    if ([sender.currentTitle isEqualToString:@"取消全选"])
    {
        for (WaresEntity *entity in self.model.dataSource) {
            entity.is_promotion = NO;
        }
    }
    else
    {
        for (WaresEntity *entity in self.model.dataSource) {
            entity.is_promotion = YES;
            [self.selectedId addObject:entity.goods_id];
        }
    }
    [self adjustRightBarButtonTitle];
    [self.tableView reloadData];

}

- (void)receivedNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:SHOP_GOODS_LIST_GETTED_NOTIFICATION]) {
        NSArray *array = notification.object;
        NSMutableArray *data = [[NSMutableArray alloc] init];
        for (WaresEntity *entity in array) {
            if (!entity.is_promotion) {
                [data addObject:entity];
            }
        }
        self.model.dataSource = data;
        [self.tableView reloadData];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:[EditLimitedSpecialViewController description]]) {
        if (![self.selectedId count]) {
            [self showtips:@"先选好商品呗."];
            return NO;
        }
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:[EditLimitedSpecialViewController description]]) {
        EditLimitedSpecialViewController *vc = segue.destinationViewController;
        vc.goodsIds = self.selectedId;
    }
}

#pragma cell delegate

- (void)selectedWareCell:(SelectedWareCell *)cell didWareWasSelected:(BOOL)isSelected
{
    if (isSelected) {
        cell.ware.is_promotion = YES;
        [self.selectedId addObject:cell.ware.goods_id];
    }else{
        cell.ware.is_promotion = NO;
        [self.selectedId removeObject:cell.ware.goods_id];
    }
    [self adjustRightBarButtonTitle];
}

#pragma mark - UITableViewController
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.model.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectedWareCell *cell = [tableView dequeueReusableCellWithIdentifier:[SelectedWareCell description] forIndexPath:indexPath];
    WaresEntity *ware = [self.model.dataSource objectAtIndex:indexPath.row];
    cell.ware = ware;
    cell.delegate = self;
    cell.type = LimitedSpecialSelect;
    return cell;
}

#pragma mark - Private


#pragma getter setter

- (ShopDetailModel *)model
{
    if (!_model) {
        _model = [[ShopDetailModel alloc] init];
    }
    return _model;
}

- (NSMutableArray *)selectedId
{
    if (!_selectedId) {
        _selectedId = [[NSMutableArray alloc] init];
    }
    return _selectedId;
}

@end
