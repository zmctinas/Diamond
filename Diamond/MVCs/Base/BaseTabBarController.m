//
//  BaseTabBarController.m
//  Diamond
//
//  Created by Pan on 15/7/15.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseTabBarController.h"
#import "Macros.h"
#import "ValidationManager.h"
#import "EaseMob.h"
#import "DMTabbar.h"
#import "UserSession.h"
#import "MyShopModel.h"

static NSString *const KAI_DIAN = @"home_kaidian";
static NSString *const DIAN_PU = @"home_dianpu";

static NSString *const SETUP_SHOP = @"SetUpShopNavi";
static NSString *const MY_SHOP = @"MyShopNavi";

@interface BaseTabBarController ()<UITabBarControllerDelegate,DMTabbarDelegate>

@property (strong, nonatomic) DMTabbar *customTabbar;
@property (strong, nonatomic) MyShopModel *myShopModel;

@end

@implementation BaseTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOrderBadge) name:SHOW_TABBAR_BADGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showChatBadgeIfNeeded) name:SHOW_CHAT_TABBAR_BADGE object:nil];
    [self setValue:self.customTabbar forKey:@"tabBar"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self adjustCenterButtonIcon];
}
#pragma mark - DMTabbarDelegate
//未登录的用户先登陆
- (BOOL)shouldSelectItemAtIndex:(NSInteger)index
{
    if (index == MAIN_INDEX)
    {
        return YES;
    }
    return [ValidationManager validateLogin:self] ;
}

- (void)didSelectItemAtIndex:(NSInteger)index
{
    self.selectedIndex = index;
    [self hideBadeAtIndex:index];
}

//未登录的用户先登陆
- (BOOL)shouldSelectCenterItem
{
    return [ValidationManager validateLogin:self];
}

- (void)didSelectCenterItem
{
    NSInteger shopId = [UserSession sharedInstance].currentUser.shop_id;
    NSString *identifer = shopId ? MY_SHOP : SETUP_SHOP;
    [self performSegueWithIdentifier:identifer sender:nil];
}

- (void)showOrderBadge
{
    //在当前界面不显示红点
    if (self.selectedIndex == ORDER_INDEX)
    {
        return;
    }
    
   PSTabbarItem *item = [self.customTabbar.barItems objectAtIndex:ORDER_INDEX];
    NSInteger value = 0;
    if (!IS_NULL(item.badgeValue))
    {
         value = [item.badgeValue integerValue];
    }
    value++;
    item.badgeValue = [NSString stringWithFormat:@"%ld",value];
}

- (void)showChatBadgeIfNeeded
{
    if (self.selectedIndex != CHAT_INDEX)
    {
        NSArray *myConversions = [[EaseMob sharedInstance].chatManager conversations];
        NSUInteger count = 0;
        for (EMConversation *converstion in myConversions)
        {
            count += converstion.unreadMessagesCount;
        }
        
        if (count)
        {
            PSTabbarItem *item = [self.customTabbar.barItems objectAtIndex:CHAT_INDEX];
            item.badgeValue = [NSString stringWithFormat:@"%ld",count];
        }
        else
        {
            [self hideBadeAtIndex:CHAT_INDEX];
        }
    }
}

- (void)hideBadeAtIndex:(NSInteger)index
{
    PSTabbarItem *item = [self.customTabbar.barItems objectAtIndex:index];
    item.badgeValue = nil;
}

- (void)adjustCenterButtonIcon
{
    NSInteger shopId = [[UserSession sharedInstance] currentUser].shop_id ;
    NSString *imageName = shopId ? DIAN_PU : KAI_DIAN;
    self.customTabbar.centerIcon = [UIImage imageNamed:imageName];
}

#pragma mark - Getter & Setter

- (MyShopModel *)myShopModel
{
    if (!_myShopModel)
    {
        _myShopModel = [[MyShopModel alloc] init];
    }
    return _myShopModel;
}

- (DMTabbar *)customTabbar
{
    if (!_customTabbar)
    {
        _customTabbar = [DMTabbar tabbar];
        _customTabbar.DMTDelegate = self;
    }
    return _customTabbar;
}
@end
