//
//  ShoppingCartViewController.m
//  Diamond
//
//  Created by Leon Hu on 15/8/29.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "OrderCommitViewController.h"
#import "ShopDetailViewController.h"
#import "ChatViewController.h"
#import "PSSelectItemHeader.h"
#import "PSSelectItemFooter.h"
#import "ShopCartModel.h"
#import "BuyWareCell.h"
#import "BuyWareEntity.h"
#import "SearchFriendModel.h"

@interface ShoppingCartViewController ()<PSSelectItemFooterDelegate,PSSelectItemHeaderDelegate,BuyWareCellDelegate,ChatModelDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) ShopCartModel *model;

@property (nonatomic,strong) NSMutableArray *selectEntity;
@property (nonatomic, strong) SearchFriendModel *searchModel;
@property (nonatomic) NSIndexPath *currentIndexPath;//选中的...

@end

@implementation ShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftBarButtonItem];
    [self addObserverForNotifications:@[
                                        GET_SHOP_CART,
                                        UPDATE_SHOP_CART,
                                        ]];
    [self.tableView addLegendHeaderWithRefreshingTarget:self.model refreshingAction:@selector(getShopCart)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];    
    [self addObserverForNotifications:@[SEARCH_FRIEND_NOTIFICATION,SEARCH_FRIEND_FAIL_IN_SHOPPING_CART]];
    [self.tableView.header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SEARCH_FRIEND_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SEARCH_FRIEND_FAIL_IN_SHOPPING_CART object:nil];
}

#pragma UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.model.dataSource count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ShopCartEntity *shopCartItem = [self.model.dataSource objectAtIndex:section];
    return [shopCartItem.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuyWareCell *cell = [tableView dequeueReusableCellWithIdentifier:[BuyWareCell description] forIndexPath:indexPath];
    ShopCartEntity *shopCartEntity = [self.model.dataSource objectAtIndex:indexPath.section];
    BuyWareEntity *entity = [shopCartEntity.list objectAtIndex:indexPath.row];
    
    cell.entity = entity;
    cell.delegate = self;
    cell.indexPath = indexPath;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PSSelectItemHeader *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[PSSelectItemHeader description]];
    if(self.model.dataSource && [self.model.dataSource count]>section){
        if (!headView) {
            [self.tableView registerNib:[UINib nibWithNibName:[PSSelectItemHeader description] bundle:nil] forHeaderFooterViewReuseIdentifier:[PSSelectItemHeader description]];
            headView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:[PSSelectItemHeader description]];
        }
        headView.delegate = self;
        ShopCartEntity *entity = [self.model.dataSource objectAtIndex:section];
        headView.entity = entity;
        headView.section = section;
    }
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 48;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    PSSelectItemFooter *footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[PSSelectItemFooter description]];
    if(self.model.dataSource && [self.model.dataSource count]>section){
        if (!footView) {
            [self.tableView registerNib:[UINib nibWithNibName:[PSSelectItemFooter description] bundle:nil] forHeaderFooterViewReuseIdentifier:[PSSelectItemFooter description]];
            footView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:[PSSelectItemFooter description]];
        }
        footView.delegate = self;
        ShopCartEntity *entity = [self.model.dataSource objectAtIndex:section];
        footView.section = section;
        [footView setShopCart:entity];
    }
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return PS_SELECT_ITEM_FOOTER_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self didSelectRowAtIndexPath:indexPath];
}

#pragma mark - alertview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:{
            ShopCartEntity *shopCart = [self.model.dataSource objectAtIndex:self.currentIndexPath.section];
            BuyWareEntity *entity = [shopCart.list objectAtIndex:self.currentIndexPath.row];
            
            [self.model delBuyWare:entity];
            //移除物品，计算总价
            [shopCart.list removeObjectAtIndex:self.currentIndexPath.row];
            [self.model calculate:shopCart];
            
            //刷新界面
            if (![shopCart.list count])
            {
                [self.model.dataSource removeObjectAtIndex:self.currentIndexPath.section];
                [self.tableView reloadData];
            }
            else
            {
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.currentIndexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        
            break;
        }
        default:
            break;
    }
}

#pragma mark - ChatModelDelegate
/**
 *  根据环信id得到要显示头像路径，如果返回nil，则显示默认头像
 *
 *  @param chatter 环信账号 easemob
 *
 *  @return 昵称
 */
- (NSString *)avatarWithChatter:(NSString *)chatter
{
    
    if ([[UserSession sharedInstance].currentUser.easemob isEqualToString:chatter])
    {
        return [UserSession sharedInstance].currentUser.photo;
    }
    
    NSArray *friends = [UserInfo info].friends;
    for (Friend *frd in friends)
    {
        if ([frd.friends_easemob isEqualToString:chatter])
        {
            return frd.photo;
        }
    }
    return self.searchModel.buddy.photo;
}

/**
 *  根据环信id得到要显示用户名，如果返回nil，则默认显示环信id
 *
 *  @param chatter 环信账号 easemob
 *
 *  @return 显示的用户名
 */
- (NSString *)nickNameWithChatter:(NSString *)chatter
{
    return IS_NULL(self.searchModel.buddy.user_name) ? chatter : self.searchModel.buddy.user_name;
}

#pragma mark - PSSelectItemHeaderDelegate
- (void)pushToCatterViewController
{
    EMConversation *conversation = [[[EaseMob sharedInstance] chatManager] conversationForChatter:self.searchModel.buddy.easemob conversationType:eConversationTypeChat];
    
    ChatViewController *chatController;
    NSString *title = self.searchModel.buddy.user_name;
    
    NSString *chatter = conversation.chatter;
    chatController = [[ChatViewController alloc] initWithChatter:chatter];
    chatController.model.delelgate = self;
    chatController.title = title;
    [self.navigationController pushViewController:chatController animated:YES];
}

- (void)didTouchShopButtonAtSection:(NSInteger)section
{
    ShopCartEntity *entity = [self.model.dataSource objectAtIndex:section];
    ShopDetailViewController *vc = [MStoryboard instantiateViewControllerWithIdentifier:[ShopDetailViewController description]];
    Shop *shop = [[Shop alloc] init];
    shop.shop_id = entity.shop_id;
    shop.easemob = entity.easemob;
    vc.shop = shop;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didTouchContactSellerAtSection:(NSInteger)section
{
    ShopCartEntity *shopCart = [self.model.dataSource objectAtIndex:section];
    [self showHUDWithTitle:@"获取卖家信息中..."];
    [self.searchModel searchBuddyWithPhone:shopCart.easemob];

}
//选中购物车中某个商家的全部商品
- (void)selectItemHeader:(PSSelectItemHeader *)headView didTouchSelectButton:(UIButton *)button
{
    [self.model shopCartEntityBeingSelectedAtIndex:headView.section];
    [self.tableView reloadData];
}

#pragma mark - BuyWareCellDelegate

- (void)BuyWareCellBeingTouchDeleteButtonAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentIndexPath = indexPath;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"确定删除该项吗?"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)BuyWareCellBeingTouchAddButtonAtIndexPath:(NSIndexPath *)indexPath
{
    ShopCartEntity *shopCartEntity = [self.model.dataSource objectAtIndex:indexPath.section];
    BuyWareEntity *entity = [shopCartEntity.list objectAtIndex:indexPath.row];
    entity.count_no++;
    [self.model updateShopCart:entity count:entity.count_no];
}

- (void)BuyWareCellBeingTouchMinusButtonAtIndexPath:(NSIndexPath *)indexPath
{
    ShopCartEntity *shopCartEntity = [self.model.dataSource objectAtIndex:indexPath.section];
    BuyWareEntity *entity = [shopCartEntity.list objectAtIndex:indexPath.row];
    
    if (entity.count_no <= 1) {
        [self showtips:@"最少买一个哦."];
        return;
    }
    entity.count_no--;
    [self.model updateShopCart:entity count:entity.count_no];
}

- (void)BuyWareCellBeingSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    [self didSelectRowAtIndexPath:indexPath];
}

#pragma mark - PSSelectItemFooterDelegate

- (void)didSettleAccounts:(NSInteger)section
{
    ShopCartEntity *shopCart = [self.model.dataSource objectAtIndex:section];
    OrderDetailEntity *entity = [self.model convertWithShopCart:shopCart];

    OrderCommitViewController *vc = [OrderStoryboard instantiateViewControllerWithIdentifier:[OrderCommitViewController description]];
    [vc setupOrder:entity];
    vc.pushedViewController = self;
    NSMutableArray *temp = [NSMutableArray array];
    for (BuyWareEntity *buyWare in shopCart.list)
    {
        if (buyWare.isChecked)
        {
            [temp addObject:@(buyWare.buyWaresId)];
        }
    }
    vc.cartList = temp;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private
//选中购物车中某个商品
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.model buyWareBeingSelectedAtIndexPath:indexPath];
    [self.tableView reloadData];
}

#pragma mark - Notification

- (void)receivedNotification:(NSNotification *)notification
{
    [self hideHUD];
    if ([notification.name isEqualToString:GET_SHOP_CART])
    {
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
    }
    else if ([notification.name isEqualToString:UPDATE_SHOP_CART])
    {
        [self.tableView reloadData];
    }
    
    if ([notification.name isEqualToString:SEARCH_FRIEND_NOTIFICATION])
    {
        [self pushToCatterViewController];
        return;
    }
    if ([notification.name isEqualToString:SEARCH_FRIEND_FAIL_IN_SHOPPING_CART])
    {
        Buddy *buddy = [[Buddy alloc] init];
        buddy.easemob = notification.object;
        self.searchModel.buddy = buddy;
        [self pushToCatterViewController];
    }
}

#pragma getter&setter

- (ShopCartModel *)model
{
    if (!_model) {
        _model = [[ShopCartModel alloc] init];
    }
    return _model;
}

- (SearchFriendModel *)searchModel
{
    if (!_searchModel)
    {
        _searchModel = [[SearchFriendModel alloc] init];
    }
    return _searchModel;
}
@end
