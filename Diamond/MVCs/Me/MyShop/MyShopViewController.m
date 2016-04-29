    //
//  MyShopViewController.m
//  Diamond
//
//  Created by Leon Hu on 15/7/28.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "MyShopViewController.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "UIImageView+Category.h"
#import "NewGoodsViewController.h"
#import "MyWareCell.h"
#import "WaresEntity.h"
#import "MyShopModel.h"
#import "ShopDetailModel.h"
#import "Shop.h"
#import "Macros.h"
#import "ShopSession.h"
#import "WareDetailViewController.h"
#import "ShopDetailViewController.h"
#import "UIButton+Category.h"
#import "qrCodeViewController.h"

CGFloat const TableHeaderViewHeight = 178;
CGFloat const StatusBarHeight = 20.0;

@interface MyShopViewController ()<MyWareCellDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UIView *inSaleButtonLineView;
@property (weak, nonatomic) IBOutlet UIView *outSaleButtonLineView;
@property (weak, nonatomic) IBOutlet UIButton *inSaleButton;
@property (weak, nonatomic) IBOutlet UIButton *outSaleButton;

- (IBAction)touchBackButton:(UIButton *)sender;
- (IBAction)touchShowInSaleGoodsButton:(UIButton *)sender;
- (IBAction)touchShowOutSaleGoodsButton:(UIButton *)sender;
- (IBAction)touchPreviewButton:(UIButton *)sender;
@property (nonatomic,strong) MyShopModel *myShopModel;
@property (nonatomic,strong) ShopDetailModel *shopModel;
@property (nonatomic) BOOL isShowSaleGoods;
@property (nonatomic) BOOL isEdit;
@property (nonatomic,strong) MyWareCell *selectedCell;//选中的Cell,编辑或上下架


- (IBAction)qrCodeBtn:(UIButton *)sender;

@end

@implementation MyShopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addObserverForNotifications:@[SHOP_GOODS_LIST_GETTED_NOTIFICATION,SET_SALE,TICK_TOCK_NOTIFICATION,GET_SHOP_INFO]];
    
    self.isShowSaleGoods = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
    self.navigationController.navigationBarHidden = YES;
    self.photoButton.layer.cornerRadius = self.photoButton.frame.size.width/2;
    self.photoButton.layer.masksToBounds = YES;
    [self fetchShopInfoIfNeeded];
    [self saleGoodsButtonChanged:NO];
    NSInteger shop_id = [[UserSession sharedInstance] currentUser].shop_id;
    [self.shopModel giveMeAllOfShopGoodsByShopId:shop_id];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - Private 
- (void)fetchShopInfoIfNeeded
{
    Shop *shop = [[ShopSession sharedInstance] currentShop];
    if (!shop)
    {
        [self showHUDWithTitle:@"获取店铺信息中..."];
    }
    [self.myShopModel getShopInfo:[UserSession sharedInstance].currentUser.shop_id];
}

- (void)updateUI
{
    Shop *shop = [[ShopSession sharedInstance] currentShop];
    if ([shop.shop_ad count]>0) {
        NSString *shopAd = [shop.shop_ad objectAtIndex:0];
        NSString *photoUrl = [Util urlStringWithPath:shopAd];
        if (photoUrl.length>0) {
            [self.photoButton setDefaultLoadingImage];
            [self.photoButton sd_setImageWithURL:[NSURL URLWithString:photoUrl] forState:UIControlStateNormal ];
        }else{
            [self.photoButton setImage:[UIImage imageNamed:@"my_button_touxiang"] forState:UIControlStateNormal];
        }
    }
    
    [self.shopNameLabel setText:[[ShopSession sharedInstance] currentShop].shop_name];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    BOOL isInDarkArea = self.tableView.contentOffset.y < (TableHeaderViewHeight - (StatusBarHeight / 2));
    return isInDarkArea ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat deltaY = scrollView.contentOffset.y;
    if (deltaY < (TableHeaderViewHeight + StatusBarHeight) && deltaY > (TableHeaderViewHeight - StatusBarHeight))
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}


#pragma mark - UITableViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.myShopModel.dataSource count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WaresEntity *ware = [self.myShopModel.dataSource objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:[WareDetailViewController description] sender:ware];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyWareCell *cell = [tableView dequeueReusableCellWithIdentifier:[MyWareCell description] forIndexPath:indexPath];
    WaresEntity *ware = [self.myShopModel.dataSource objectAtIndex:indexPath.row];
    cell.ware = ware;
    cell.delegate = self;
    return cell;
}


#pragma mark - MyWareCellDelegate

- (void)myWareCell:(MyWareCell *)cell didTouchEditButton:(UIButton *)sender
{
    [self showHUDWithTitle:@"正在加载..."];
    self.isEdit = YES;
    [self performSegueWithIdentifier:[NewGoodsViewController description] sender:cell.ware];
}

- (void)myWareCell:(MyWareCell *)cell didTouchSetupButton:(UIButton *)sender
{
    self.selectedCell = cell;
    if (cell.ware.is_sale)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                            message:@"宝贝下架后，其他人将看不见这个宝贝哦，确认下架吗？"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        [alertView show];
    }else{
        [self.myShopModel setSale:cell.ware isSale:YES];
    }
}
#pragma  mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            [self.myShopModel setSale:self.selectedCell.ware isSale:NO];
            break;
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:[NewGoodsViewController description]])
    {
        NewGoodsViewController *vc = segue.destinationViewController;
        if (self.isEdit){
            vc.entity = sender;
            self.isEdit = NO;
        }
    }
    else if ([segue.identifier isEqualToString:[WareDetailViewController description]])
    {
        WareDetailViewController *vc = segue.destinationViewController;
        vc.ware = sender;
        vc.isPreview = YES;
    }
    else if ([segue.identifier isEqualToString:[ShopDetailViewController description]])
    {
        ShopDetailViewController *vc = segue.destinationViewController;
        vc.isPreview = YES;
    }
}

- (IBAction)touchBackButton:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)touchShowInSaleGoodsButton:(UIButton *)sender {
    [self saleGoodsButtonChanged:NO];
}

- (IBAction)touchShowOutSaleGoodsButton:(UIButton *)sender {
    [self saleGoodsButtonChanged:YES];
}

- (IBAction)touchPreviewButton:(UIButton *)sender   //:(id)sender
{
    [self performSegueWithIdentifier:[ShopDetailViewController description] sender:nil];
}

- (void)receivedNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:SET_SALE]) {
        NSString *goodsId = notification.object;
        for (WaresEntity *item in self.shopModel.dataSource) {
            if ([goodsId isEqualToString:item.goods_id]) {
                item.is_sale = !item.is_sale;
                break;
            }
        }
        [self filterTableDataSource:self.isShowSaleGoods];
        [self showtips:(self.isShowSaleGoods ? @"下架成功." : @"上架成功.")];
    }else if ([notification.name isEqualToString:SHOP_GOODS_LIST_GETTED_NOTIFICATION])
    {
        [self filterTableDataSource:self.isShowSaleGoods];
    }else if ([notification.name isEqualToString:TICK_TOCK_NOTIFICATION])
    {
        [self.tableView reloadData];
    } else if ([notification.name isEqualToString:GET_SHOP_INFO]) {
        [self hideHUD];
        [self updateUI];
    }
}

- (void)filterTableDataSource:(BOOL)isOn
{
    self.isShowSaleGoods = isOn;
    [self.myShopModel filterDataSource:self.shopModel.dataSource isOn:isOn];
    NSLog(@"数据条目数:%ld,刷新表格",(long)[self.shopModel.dataSource count]);
    [self.tableView reloadData];
}

//上架/下架按钮选择变化后处理事件
- (void)saleGoodsButtonChanged:(BOOL)isTouchOutSale
{
    if (isTouchOutSale) {
        [self.inSaleButtonLineView setHidden:YES];
        [self.outSaleButtonLineView setHidden:NO];
        [self.inSaleButton setTitleColor:UIColorFromRGB(DARK_GRAY) forState:UIControlStateNormal];
        [self.outSaleButton setTitleColor:UIColorFromRGB(GLOBAL_TINTCOLOR) forState:UIControlStateNormal];
        
        [self filterTableDataSource:NO];
        
    }else{
        [self.inSaleButtonLineView setHidden:NO];
        [self.outSaleButtonLineView setHidden:YES];
        [self.inSaleButton setTitleColor:UIColorFromRGB(GLOBAL_TINTCOLOR) forState:UIControlStateNormal];
        [self.outSaleButton setTitleColor:UIColorFromRGB(DARK_GRAY) forState:UIControlStateNormal];
        
        [self filterTableDataSource:YES];
    }
}

- (MyShopModel *)myShopModel
{
    if (!_myShopModel) {
        _myShopModel = [[MyShopModel alloc] init];
    }
    return _myShopModel;
}

- (ShopDetailModel *)shopModel
{
    if (!_shopModel) {
        _shopModel = [[ShopDetailModel alloc] init];
    }
    return _shopModel;
}

- (IBAction)qrCodeBtn:(UIButton *)sender {
    
    qrCodeViewController* qrCode = [[qrCodeViewController alloc]init];
    qrCode.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    qrCode.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    qrCode.shop = [[ShopSession sharedInstance] currentShop];
    [self presentViewController:qrCode animated:YES completion:^{
        
    }];
    
}
@end
