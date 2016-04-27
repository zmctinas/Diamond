//
//  ShopDetailViewController.m
//  Diamond
//
//  Created by Pan on 15/7/30.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "WareDetailViewController.h"
#import "WaresCell.h"
#import "ShopDetailModel.h"
#import "ShopDetailView.h"
#import "UIImageView+WebCache.h"
#import "ChatViewController.h"
#import "SearchFriendModel.h"
#import "ShopIntroViewController.h"
#import "MapViewController.h"
#import "PSShareSDKManager.h"
#import "CLLocation+WGS_84ToGCJ_02.h"
#import <ShareSDK/ShareSDK.h>
#import "taokeViewController.h"

@interface ShopDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,ChatModelDelegate,ShopDetalViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) ShopDetailModel *model;
@property (nonatomic, strong) SearchFriendModel *searchModel;

@property (weak, nonatomic) IBOutlet UIButton *storeUpButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;

- (IBAction)touchBackButton:(UIButton *)sender;
- (IBAction)touchCollectionButton:(UIButton *)sender;
- (IBAction)touchShareButton:(UIButton *)sender;
- (IBAction)touchContactButton:(UIButton *)sender;

@end

@implementation ShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftBarButtonItem];
    [self addObserverForNotifications:@[SHOP_DETAIL_GETTED_NOTIFICATION,SHOP_GOODS_LIST_GETTED_NOTIFICATION]];
    
    if (self.isPreview) {
        if(!self.shop){
            self.shop = [[Shop alloc] init];
            self.shop.shop_id = [[UserSession sharedInstance] currentUser].shop_id;
            self.shop.easemob = [[UserSession sharedInstance] currentUser].easemob;
        }
    }
    
    [self.model giveMeShopInfo:self.shop];
    [self.model giveMeShopGoods:self.shop];
    //取一下店主的信息，以备聊天界面用
    [self.searchModel stealthilySearchBuddyWithPhone:self.shop.easemob];
    
    //预览禁用
    [self.storeUpButton setHidden:self.isPreview];
    [self.shareButton setHidden:self.isPreview];
    [self.contactButton setHidden:self.isPreview];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];

}
#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"%lud",(unsigned long)self.model.dataSource.count);
    return [self.model.dataSource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    WaresCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[WaresCell description] forIndexPath:indexPath];
    WaresEntity *ware = [self.model.dataSource objectAtIndex:indexPath.item];
    cell.ware = ware;
    cell.type = WareTypeSelf;

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    ShopDetailView *reuseableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[ShopDetailView description] forIndexPath:indexPath];
    reuseableView.shop = self.shop;
    reuseableView.isPreview = self.isPreview;
    reuseableView.delegate = self;
    [reuseableView setNeedsLayout];
    return reuseableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(self.collectionView.frame.size.width / 2 - 0.5, self.collectionView.frame.size.width / 2 - 0.5 + 60);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    WaresEntity *ware = [self.model.dataSource objectAtIndex:indexPath.item];
    if (ware.is_taoke) {
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:ware.externalUrl]];
        
        taokeViewController * taoke = [[taokeViewController alloc]init];
        taoke.hidesBottomBarWhenPushed = YES;
        taoke.urlString = ware.externalUrl;
        [self.navigationController pushViewController:taoke animated:YES];
        return;
    }
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (!self.isPreview)
    {
        [self performSegueWithIdentifier:[WareDetailViewController description] sender:indexPath];
    }
}

#pragma mark - ShopDetalViewDelegate
- (void)didTouchCallButton
{
    if (IS_NULL(self.shop.phoneNumber))
    {
        [self showtips:@"该商户没有提供联系方式哦"];
        return;
    }
    
    [Util callWithPhoneNumber:self.shop.phoneNumber];
    
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
    return IS_NULL(self.searchModel.buddy.user_name) ? self.shop.easemob : self.searchModel.buddy.user_name;
}

#pragma mark - Event Response
- (IBAction)touchBackButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchCollectionButton:(UIButton *)sender
{
    if ([ValidationManager validateLogin:self])
    {
        UIImage *unCollectionImage = [UIImage imageNamed:@"shop_button_shouchang"];
        UIImage *collectedImage = [UIImage imageNamed:@"shop_button_shouchang_se"];
        if ([sender.currentImage isEqual:unCollectionImage])
        {
            [sender setImage:collectedImage forState:UIControlStateNormal];
            [self.model storeUpShop:self.shop];
        }
        else
        {
            [sender setImage:unCollectionImage forState:UIControlStateNormal];
            [self.model unStoreUpShop:@[self.shop]];
        }
    }
}

- (IBAction)touchShareButton:(UIButton *)sender
{
    //构造分享内容
    NSString *urlString = nil;
    if ([self.shop.shop_ad count])
    {
        NSURL *url = [Util urlWithPath:[self.shop.shop_ad firstObject]];
        urlString = url.absoluteString;
    }
    [[PSShareSDKManager sharedInstance] shareWithImageURL:urlString
                                              description:self.shop.Introduction
                                                   shopId:@(self.shop.shop_id)
                                                    title:self.shop.shop_name];
}

- (IBAction)touchContactButton:(UIButton *)sender
{
    //未登录的人先登陆才可以联系小二
    if (![ValidationManager validateLogin:self])
    {
        return;
    }
    
    if ([self.shop.easemob isEqualToString:[UserSession sharedInstance].currentUser.easemob])
    {
        [self showtips:@"不能自己联系自己哦"];
        return;
    }

    EMConversation *conversation = [[[EaseMob sharedInstance] chatManager] conversationForChatter:self.shop.easemob conversationType:eConversationTypeChat];
    
    ChatViewController *chatController;
    NSString *chatter = conversation.chatter;
    chatController = [[ChatViewController alloc] initWithChatter:chatter];
    chatController.model.delelgate = self;
    chatController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatController animated:YES];
}

#pragma mark - private
- (void)adjustStoreUpButtonState:(Shop *)shop
{
    NSString *imageName = ([shop.isCollected boolValue]) ? @"shop_button_shouchang_se" : @"shop_button_shouchang";
    [self.storeUpButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

#pragma mark - Navigation
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return !self.isPreview;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:[WareDetailViewController description]])
    {
        NSIndexPath *index = sender;
        WareDetailViewController *vc = segue.destinationViewController;
        vc.ware = [self.model.dataSource objectAtIndex:index.item];
        vc.ware.easemob = self.shop.easemob;
//        vc.ware.telNumber = self.shop.phoneNumber;
        return;
    }
    
    if ([segue.identifier isEqualToString:[ShopIntroViewController description]])
    {
        ShopIntroViewController *vc = segue.destinationViewController;
        vc.shop = self.shop;
    }
    
    if ([segue.identifier isEqualToString:[MapViewController description]])
    {
        MapViewController *vc = segue.destinationViewController;
        CLLocation *location = [[CLLocation alloc]initWithLatitude:self.shop.latitude longitude:self.shop.longtitude];
        CLLocationCoordinate2D chinaLG = [CLLocation transformFromWGSToGCJ:location.coordinate];
        vc.location = [[CLLocation alloc]initWithLatitude:chinaLG.latitude longitude:chinaLG.longitude];
    }
}



#pragma mark - Notification

- (void)receivedNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:SHOP_DETAIL_GETTED_NOTIFICATION])
    {
        [self hideHUD];
        [self adjustStoreUpButtonState:self.model.shop];
        self.shop = self.model.shop;
        [self.collectionView reloadData];
        return;
    }
    
    if ([notification.name isEqualToString:SHOP_GOODS_LIST_GETTED_NOTIFICATION])
    {
        [self.collectionView reloadData];
        return;
    }
    
    if ([notification.name isEqualToString:STORE_UP_SHOP_RESULT])
    {
        [self.storeUpButton setImage:[UIImage imageNamed:@"shop_button_shouchang"] forState:UIControlStateNormal];
        [self showtips:notification.object];
        return;
    }
    
    if ([notification.name isEqualToString:UN_STORE_UP_SHOP_FAILURE])
    {
        [self.storeUpButton setImage:[UIImage imageNamed:@"shop_button_shouchang_se"] forState:UIControlStateNormal];
        [self showtips:notification.object];
        return;
    }
}


#pragma mark - Getter
- (ShopDetailModel *)model
{
    if (!_model)
    {
        _model = [ShopDetailModel new];
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
