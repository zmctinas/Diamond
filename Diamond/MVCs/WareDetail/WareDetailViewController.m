//
//  WareDetailViewController.m
//  Diamond
//
//  Created by Pan on 15/8/3.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "WareDetailViewController.h"
#import "ChatViewController.h"
#import "UIImageView+WebCache.h"
#import "SearchFriendModel.h"
#import "PSCarouselView.h"
#import "URLConstant.h"
#import "ShopDetailViewController.h"
#import "Shop.h"
#import "WareDetailModel.h"
#import "PSShareSDKManager.h"
#import "PSAddToShopCartMenu.h"
#import "ShoppingCartViewController.h"
#import "OrderCommitViewController.h"
#define ScreenWidth      CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define ScreenHeight     CGRectGetHeight([UIScreen mainScreen].applicationFrame)

#define ICON_WIDTH 38
#define MARGIN 6

#define BACKGROUND_COLOR [UIColor colorWithRed:126/255 green:126/255 blue:126/255 alpha:0.3]

@interface WareDetailViewController ()<PSCarouselDelegate,ChatModelDelegate,PSAddToShopCartMenuDelegate>

@property (weak, nonatomic) IBOutlet PSCarouselView *carouselView;
@property (weak, nonatomic) IBOutlet UILabel *wareNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *promotionLabel;
@property (weak, nonatomic) IBOutlet UIButton *recommondButton;
@property (weak, nonatomic) IBOutlet UIButton *storeUpButton;
@property (weak, nonatomic) IBOutlet UIImageView *AvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introductionLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *contantButton;
@property (weak, nonatomic) IBOutlet UIButton *addToBuyListButton;
@property (weak, nonatomic) IBOutlet UIButton *buyNowButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIView *iconContainer;


- (IBAction)touchStoreUpButton:(UIButton *)sender;
- (IBAction)touchShareButton:(UIButton *)sender;
- (IBAction)touchBackButton:(UIButton *)sender;
- (IBAction)touchAddToBuyListButton:(UIButton *)sender;
- (IBAction)touchBuyNowButton:(UIButton *)sender;
- (IBAction)touchContantButton:(UIButton *)sender;
- (IBAction)touchCallButton:(UIButton *)sender;

@property (nonatomic, strong) SearchFriendModel *searchModel;
@property (nonatomic, strong) WareDetailModel *model;
@property (nonatomic,strong) PSAddToShopCartMenu *addToShopCartMenu;
@property (strong, nonatomic) UIImage *wareImage;
@property (nonatomic,strong) UIView *backgroundView;//mask层

@end

@implementation WareDetailViewController
#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCarouselView];
    [self setupWareNameView];
    [self addObserverForNotifications:@[SEARCH_FRIEND_NOTIFICATION,UN_STORE_UP_WARE_FAILURE,STORE_UP_WARE_FAILURE,WARE_DETAIL_GETED_NOTIFICATION]];
    
    //预览不获取用户信息
    if (!self.isPreview) {
        [self.searchModel stealthilySearchBuddyWithPhone:self.ware.easemob];
    }
    self.addToShopCartMenu.delegate = self;
    [self.view addSubview:self.addToShopCartMenu];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.model giveMeWareInfo:self.ware.goods_id];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.storeUpButton setEnabled:!self.isPreview];
    [self.shareButton setEnabled:!self.isPreview];
    [self.contantButton setEnabled:!self.isPreview];
    [self.addToBuyListButton setEnabled:!self.isPreview];
    [self.buyNowButton setEnabled:!self.isPreview];
    [self.callButton setEnabled:!self.isPreview];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setIcons];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark  PSAddToShopCartMenuDelegate

- (void)didAddedShopCart
{
    ShoppingCartViewController *vc = [OrderStoryboard instantiateViewControllerWithIdentifier:[ShoppingCartViewController description]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)ShopCartMenu:(PSAddToShopCartMenu *)menu didTouchContactSellerButton:(UIButton *)button
{
    [self touchContantButton:nil];
}

- (void)buyNow:(GoodsTypeEntity *)goodType count:(NSInteger)count
{
    [self.addToShopCartMenu hide];
    OrderDetailEntity *entity = [self.model packagingWithWare:self.ware type:goodType count:count];
    OrderCommitViewController *vc = [OrderStoryboard instantiateViewControllerWithIdentifier:[OrderCommitViewController description]];
    [vc setupOrder:entity];
    vc.pushedViewController = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private Method

- (void)setupCarouselView
{
    self.carouselView.pageDelegate = self;
    self.carouselView.placeholder = [UIImage imageNamed:@"shop_pic_bg_jiazai"];
    self.carouselView.autoMoving = NO;
    NSMutableArray *temp = [NSMutableArray array];
    for (NSString *imagePath in self.ware.goods_url)
    {
        NSURL *url = [Util urlWithPath:imagePath];
        [temp addObject:url];
    }
    self.carouselView.imageURLs = temp;
    self.pageControl.numberOfPages = [temp count];
}

- (void)setIcons
{
    [self.recommondButton setHidden:!self.ware.is_recommend];
    
    if (self.ware.is_recommend)
    {
        CGRect referenceRect = self.priceLabel.frame;
        CGFloat x = CGRectGetMaxX(referenceRect) + MARGIN;
        CGFloat y = CGRectGetMinY(referenceRect) - 2;
        CGFloat width = 22;
        CGFloat height = 22;
        if (self.ware.is_promotion)
        {
            x += self.oldPriceLabel.frame.size.width + MARGIN + self.promotionLabel.frame.size.width + MARGIN;
        }
        self.recommondButton.frame = CGRectMake(x, y, width, height);
        [self.iconContainer addSubview:self.recommondButton];
    }
    NSString *storeUpButtonImageName = self.ware.isCollected ? @"goods_btn_collect_se" : @"goods_btn_collect";
    [self.storeUpButton setImage:[UIImage imageNamed:storeUpButtonImageName] forState:UIControlStateNormal];
    [self.iconContainer setNeedsLayout];
    [self.iconContainer layoutIfNeeded];
}

- (void)setupWareNameView
{
    self.wareNameLabel.text = self.ware.goods_name;
    NSNumber *visiablePrice = self.ware.is_promotion ? self.ware.promotion_price : self.ware.goods_price;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[visiablePrice doubleValue]];
    self.introductionLabel.text = self.ware.introduction;
    
    //如果没有打折,不需要显示两个价格,隐藏 Leon 20150821
    if (self.ware.is_promotion) {
        [self setupOldPrice];
        [self setupPromotion];
        [self.oldPriceLabel setHidden:NO];
        [self.promotionLabel setHidden:NO];
    }else{
        [self.oldPriceLabel setHidden:YES];
        [self.promotionLabel setHidden:YES];
    }
}

/**
 *  设置带划线的价格
 */
- (void)setupOldPrice
{
    NSString *oldPrice = [NSString stringWithFormat:@"￥%.2f",[self.ware.goods_price doubleValue]];
    NSUInteger length = [oldPrice length];
    NSRange allRange = NSMakeRange(0, length);
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:allRange];
    [attri addAttribute:NSStrikethroughColorAttributeName value:UIColorFromRGB(LIGHT_GRAY) range:allRange];
    [attri addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(LIGHT_GRAY) range:allRange];
    self.oldPriceLabel.attributedText = attri;
}

- (void)setupPromotion
{
    NSString *promotion = [NSString stringWithFormat:@" %.1f折 ",self.ware.discount.doubleValue];
    [self.promotionLabel setText:promotion];
    
    self.promotionLabel.layer.borderColor = UIColorFromRGB(GLOBAL_TINTCOLOR).CGColor;
    self.promotionLabel.layer.borderWidth = 1.0;
}

/**
 *  更新一下店主信息
 */
- (void)updateHostInfo
{
    self.nameLabel.text = (self.searchModel.buddy.remarkname) ? self.searchModel.buddy.remarkname : self.searchModel.buddy.user_name;
    [self.AvatarImageView sd_setImageWithURL:[NSURL URLWithString:self.searchModel.buddy.photo] placeholderImage:[UIImage imageNamed:@"goods_touxiang"]];
}

#pragma mark - PSCarouselDelegate
- (void)carousel:(PSCarouselView *)carousel didMoveToPage:(NSUInteger)page;
{
    self.pageControl.currentPage = page;
}

- (void)carousel:(PSCarouselView *)carousel didDownloadImages:(UIImage *)image
{
    self.wareImage = image;
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
    return IS_NULL(self.searchModel.buddy.user_name) ? self.ware.easemob : self.searchModel.buddy.user_name;
}

#pragma mark - Event Response
- (IBAction)touchCallButton:(UIButton *)sender
{
    if (IS_NULL(self.ware.telNumber))
    {
        [self showtips:@"商家未提供联系方式哦"];
        return;
    }
    [Util callWithPhoneNumber:self.ware.telNumber];
}


- (IBAction)touchStoreUpButton:(UIButton *)sender
{
    if ([ValidationManager validateLogin:self])
    {
        UIImage *unCollectionImage = [UIImage imageNamed:@"goods_btn_collect"];
        UIImage *collectedImage = [UIImage imageNamed:@"goods_btn_collect_se"];
        if ([self.storeUpButton.currentImage isEqual:unCollectionImage])
        {
            [self.storeUpButton setImage:collectedImage forState:UIControlStateNormal];
            [self.model storeUpWare:self.ware];
            self.ware.isCollected = YES;
        }
        else
        {
            [self.storeUpButton setImage:unCollectionImage forState:UIControlStateNormal];
            [self.model unStoreUpWare:@[self.ware]];
            self.ware.isCollected = NO;
        }
    }
}

- (IBAction)touchShareButton:(UIButton *)sender
{
    //分享
    //构造分享内容
    NSString *urlString = nil;
    if ([self.ware.goods_url count])
    {
        NSURL *url = [Util urlWithPath:[self.ware.goods_url firstObject]];
        urlString = url.absoluteString;
    }
    [[PSShareSDKManager sharedInstance] shareWithImageURL:urlString
                                              description:self.ware.introduction
                                                   shopId:self.ware.shop_id
                                                    title:self.ware.goods_name];
}

- (IBAction)touchBackButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchAddToBuyListButton:(UIButton *)sender
{
    //禁止购买自己的东西
    if ([self.ware.easemob isEqualToString:[UserSession sharedInstance].currentUser.easemob])
    {
        [self showtips:@"不能买自己的商品哦"];
        return;
    }
    if ([ValidationManager validateLogin:self])
    {
        self.addToShopCartMenu.buyNow = NO;
        [self showAddToShopCartMenu];
    }
}

- (IBAction)touchBuyNowButton:(UIButton *)sender
{
    //禁止购买自己的东西
    if ([self.ware.easemob isEqualToString:[UserSession sharedInstance].currentUser.easemob])
    {
        [self showtips:@"不能买自己的商品哦"];
        return;
    }
    
    if ([ValidationManager validateLogin:self])
    {
        self.addToShopCartMenu.buyNow = YES;
        [self showAddToShopCartMenu];
    }
}

- (void)showAddToShopCartMenu
{
    [self.addToShopCartMenu setCurrentEntity:self.ware];
    [self.backgroundView setHidden:NO];
    self.backgroundView.backgroundColor = BACKGROUND_COLOR;
    [self.addToShopCartMenu show];
}

- (IBAction)touchContantButton:(UIButton *)sender
{
    //未登录的人先登陆才可以联系小二
    if (![ValidationManager validateLogin:self])
    {
        return;
    }
    if ([self.ware.easemob isEqualToString:[UserSession sharedInstance].currentUser.easemob])
    {
        [self showtips:@"不能自己联系自己哦"];
        return;
    }
    EMConversation *conversation = [[[EaseMob sharedInstance] chatManager] conversationForChatter:self.ware.easemob conversationType:eConversationTypeChat];
    
    ChatViewController *chatController;
    NSString *chatter = conversation.chatter;
    chatController = [[ChatViewController alloc] initWithChatter:chatter];
    chatController.model.delelgate = self;
    [self.navigationController pushViewController:chatController animated:YES];
    [chatController.model performSelector:@selector(sendImageMessage:) withObject:self.wareImage afterDelay:0.5];
}

#pragma mark - Notification
- (void)receivedNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:SEARCH_FRIEND_NOTIFICATION])
    {
        [self updateHostInfo];
        return;
    }
    
    if ([notification.name isEqualToString:STORE_UP_WARE_FAILURE])
    {
        [self.storeUpButton setImage:[UIImage imageNamed:@"goods_btn_collect"] forState:UIControlStateNormal];
        [self showtips:notification.object];
        return;
    }
    
    if ([notification.name isEqualToString:UN_STORE_UP_WARE_FAILURE])
    {
        [self.storeUpButton setImage:[UIImage imageNamed:@"goods_btn_collect_se"] forState:UIControlStateNormal];
        [self showtips:notification.object];
        return;
    }
    
    if ([notification.name isEqualToString:WARE_DETAIL_GETED_NOTIFICATION])
    {
        self.ware = self.model.ware;
        [self setupWareNameView];
        return;
    }
}


#pragma mark - Navigation
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:[ShopDetailViewController description]])
    {
        if (self.isPreview) {
            return NO;
        }
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:[ShopDetailViewController description]])
    {
        ShopDetailViewController *vc = segue.destinationViewController;
        Shop *shop = [Shop new];
        shop.shop_id = [self.ware.shop_id integerValue];
        shop.easemob = self.ware.easemob;
        vc.shop = shop;
    }
}


#pragma mark - Getter and setter
- (SearchFriendModel *)searchModel
{
    if (!_searchModel)
    {
        _searchModel = [SearchFriendModel new];
    }
    return _searchModel;
}

- (WareDetailModel *)model
{
    if (!_model)
    {
        _model = [WareDetailModel new];
    }
    return _model;
}

- (PSAddToShopCartMenu *)addToShopCartMenu
{
    if (!_addToShopCartMenu) {
        _addToShopCartMenu = [PSAddToShopCartMenu initView];
    }
    return _addToShopCartMenu;
}

- (UIView *)backgroundView
{
    if (!_backgroundView)
    {
        //background init and tapped
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _backgroundView.opaque = NO;
    }
    return _backgroundView;
}

@end
