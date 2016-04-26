//
//  OrderDetailViewController.m
//  Diamond
//
//  Created by Pan on 15/8/31.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "ShopDetailViewController.h"
#import "OrderCommitViewController.h"
#import "EditPriceViewController.h"
#import "ChatViewController.h"
#import "OrderDetailModel.h"
#import "OrderDetailEntity.h"

#import "OrderDetailFooterView.h"
#import "OrderDetailHeaderView.h"

#import "OrderDetailAddressCell.h"
#import "PaymentTypeCell.h"
#import "OrderListCell.h"
#import "CheckBar.h"
#import "PaymentViewController.h"
#import "SearchFriendModel.h"

#define ADDRESS_SECTION       0
#define PAYMENT_TYPE_SECTION  1
#define ORDER_DETAIL_SECTION  2

#define TOTLE_SECTIONS        3

#define CANCEL_ORDER @"撤销订单"
#define EDIT_PRICE   @"改价"

@interface OrderDetailViewController ()<CheckBarDelegate,
                                        OrderDetailHeaderViewDelegate,
                                        OrderDetailFooterViewDelegate,
                                        ChatModelDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet CheckBar *checkBar;
@property (weak, nonatomic) IBOutlet UIButton *rightBarButton;
@property (nonatomic, strong) SearchFriendModel *searchModel;


@property (strong, nonatomic) OrderDetailModel *model;

@property (nonatomic) OrderOwner owner;
- (IBAction)touchRightBarButton:(UIButton *)sender;

@end

@implementation OrderDetailViewController
#pragma mark - Public Method
- (void)setupWithOwner:(OrderOwner)owner entity:(OrderDetailEntity *)entity;
{
    self.owner = owner;
    self.model.orderDetail = entity;
}

#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addLeftBarButtonItem];
    [self addObserverForNotifications:@[GET_ORDER_DETAIL,
                                        CONFORM_SEND,
                                        CONFORM_ORDER,CLOSE_ORDER,
                                        EDIT_TOTLE_FEE_NOTIFICATION,
                                        EDIT_POSTAGE_NOTIFICATION,
                                        ALIPAY_RESULT,
                                        WECHATPAY_RESULT]];
    [self setupCheckBar];
    [self setupRightBarButton];
    [self showHUDWithTitle:nil];
    [self.model giveMeOrderDetail];
    //取一下店主的信息，以备聊天界面用
    [self.searchModel searchBuddyWithPhone:[self.model easemobToChat:self.owner]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addObserverForNotifications:@[REFRESH_ORDER]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeObserverForNotifications:@[REFRESH_ORDER]];
}

#pragma mark - Private Method
// Overwrite
- (void)back
{
    if (self.backToViewController)
    {
        [self.navigationController popToViewController:self.backToViewController animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)setupCheckBar
{
    self.checkBar.owner = self.owner;
    self.checkBar.orderStatus = self.model.orderDetail.status;
    self.checkBar.delegate = self;
    self.checkBar.price = self.model.orderDetail.total_fee;
}

- (void)setupRightBarButton
{
    BOOL hiddenButton = !(self.model.orderDetail.status == OrderStatusUnpay);
    [self.rightBarButton setHidden:hiddenButton];
    if (self.owner == OrderOwnerSeller)
    {
        [self.rightBarButton setTitle:EDIT_PRICE forState:UIControlStateNormal];
    }
}

- (void)actionWithOwner:(OrderOwner)owner orderStatus:(OrderStatus)status
{
    if (owner == OrderOwnerBuyer)
    {
        switch (status)
        {
            case OrderStatusUnpay:
                [self pay];
                break;
            case OrderStatusSellerConformed:
                [self showHUDWithTitle:nil];
                [self.model conformWareGetted];
                break;
            default:
                break;
        }
    }
    else if (owner == OrderOwnerSeller)
    {
        switch (status)
        {
            case OrderStatusPaied:
                [self showHUDWithTitle:nil];
                [self.model conformWareSended];
                break;
            default:
                break;
        }
    }
}

- (void)pay
{
    [self performSegueWithIdentifier:[PaymentViewController description] sender:nil];
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
        cell.entity = orderDetailEntity;
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
    if ([notification.name isEqualToString:GET_ORDER_DETAIL])
    {
        self.checkBar.price = self.model.orderDetail.total_fee;
        [self.tableView reloadData];
        return;
    }
    
    if ([notification.name isEqualToString:CONFORM_ORDER])
    {
        self.model.orderDetail.status = OrderStatusBuyerConformed;
        self.checkBar.orderStatus = OrderStatusBuyerConformed;
        return;
    }

    if ([notification.name isEqualToString:CONFORM_SEND])
    {
        self.model.orderDetail.status = OrderStatusBuyerConformed;
        self.checkBar.orderStatus = OrderStatusSellerConformed;
        return;
    }
    
    if ([notification.name isEqualToString:CLOSE_ORDER])
    {
        self.model.orderDetail.status = OrderStatusCancel;
        self.checkBar.orderStatus = OrderStatusCancel;
        self.rightBarButton.hidden = YES;
        return;
    }
    
    //改价
    if (   [notification.name isEqualToString:EDIT_POSTAGE_NOTIFICATION]
        || [notification.name isEqualToString:EDIT_TOTLE_FEE_NOTIFICATION])
    {
        //TODO:看看需不需要修改这个model
        [self setupCheckBar];
        [self.tableView reloadData];
        return;
    }
    //支付成功后 跳转回来相对应的状态改变
    if ([notification.name isEqualToString:WECHATPAY_RESULT]
        || [notification.name isEqualToString:ALIPAY_RESULT])
    {
        BOOL isSuccess = [notification.object boolValue];
        OrderStatus status = isSuccess ? OrderStatusPaied : OrderStatusUnpay;
        self.model.orderDetail.status = status;
        self.checkBar.orderStatus = status;
        
        [self setupRightBarButton];
        return;
    }
    //卖家修改了价格，收到推送
    if ([notification.name isEqualToString:REFRESH_ORDER])
    {
        [self.model giveMeOrderDetail];
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
        return ORDER_DETAIL_HEADER_HEIGHT_WITH_ORDER;
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
            footerView.orderType = OrderDetailTypeNormal;
            footerView.owner = self.owner;
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
    //TODO:如果需要，做一个跳转到商品详情界面的Segue。
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

#pragma mark - CheckBarDelegate
- (void)didTouchConformButton
{
    [self actionWithOwner:self.owner orderStatus:self.model.orderDetail.status];
}

#pragma mark - OrderDetailHeaderViewDelegate
- (void)didTouchContactButton
{
    EMConversation *conversation = [[[EaseMob sharedInstance] chatManager] conversationForChatter:[self.model easemobToChat:self.owner] conversationType:eConversationTypeChat];
    
    ChatViewController *chatController;
    NSString *title = self.searchModel.buddy.user_name;
    
    NSString *chatter = conversation.chatter;
    chatController = [[ChatViewController alloc] initWithChatter:chatter];
    chatController.model.delelgate = self;
    chatController.title = title;
    [self.navigationController pushViewController:chatController animated:YES];
}

- (void)didTouchShopButton
{
    ShopDetailViewController *vc = [MStoryboard instantiateViewControllerWithIdentifier:[ShopDetailViewController description]];
    Shop *shop = [[Shop alloc] init];
    shop.shop_id = self.model.orderDetail.shop_id;
    shop.easemob = [self.model easemobToChat:self.owner];
    vc.shop = shop;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - OrderDetailFooterViewDelegate

- (void)didTouchEditPostageButton
{
    [self performSegueWithIdentifier:[EditPriceViewController description] sender:@(EditPriceTypePostage)];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:[EditPriceViewController description]])
    {
        EditPriceViewController *vc = segue.destinationViewController;
        vc.type = [sender integerValue];
        vc.model = self.model;
    }
    
    if ([segue.identifier isEqualToString:[PaymentViewController description]])
    {
        PaymentViewController *vc = segue.destinationViewController;
        [vc setupWaitPayOrder:self.model.orderDetail];
    }
}

#pragma mark - IBAction

- (IBAction)touchRightBarButton:(UIButton *)sender
{
    if (self.owner == OrderOwnerBuyer)
    {
        //撤销订单
        [self showHUDWithTitle:@"撤销中..."];
        [self.model cancleOrder];
    }
    else
    {
        //跳转到改价
        [self performSegueWithIdentifier:[EditPriceViewController description] sender:@(EditPriceTypeWarePrice)];
    }
}

#pragma mark - Getter and Setter
- (OrderDetailModel *)model
{
    if (!_model)
    {
        _model = [[OrderDetailModel alloc]init];
    }
    return _model;
}

- (SearchFriendModel *)searchModel
{
    if (!_searchModel)
    {
        _searchModel = [SearchFriendModel new];
    }
    return _searchModel;
}

@end
