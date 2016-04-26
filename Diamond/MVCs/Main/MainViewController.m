//
//  MainViewController.m
//  Diamond
//
//  Created by Pan on 15/7/11.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ZWIntroductionViewController.h"
#import "MainViewController.h"
#import "WareListViewController.h"
#import "ShopListViewController.h"
#import "WareDetailViewController.h"
#import "ShopDetailViewController.h"
#import "SwitchAddressViewController.h"
#import "ValidationManager.h"
#import "ShopTypeView.h"
#import "CarouselEntity.h"
#import "PSCarouselView.h"
#import "MainModel.h"
#import "CityModel.h"
#import "WareDetailModel.h"
#import "ShopDetailModel.h"
#import "Util.h"
@interface MainViewController ()<ShopTypeViewDelegate,PSCarouselDelegate,SwitchAddressDelegate>

@property (weak, nonatomic) IBOutlet UIPageControl *carouselPageControl;
@property (weak, nonatomic) IBOutlet UIPageControl *typePageControl;
@property (weak, nonatomic) IBOutlet ShopTypeView *typeView;
@property (weak, nonatomic) IBOutlet PSCarouselView *carouselView;
@property (weak, nonatomic) IBOutlet UILabel *currentCityLabel;

@property (nonatomic, strong) MainModel *model;
@property (nonatomic, strong) CityModel *cityModel;

@property (nonatomic, strong) WareDetailModel *wareDetailModel;
@property (nonatomic, strong) ShopDetailModel *shopDetailModel;

@property (strong, nonatomic) ZWIntroductionViewController *introductionView;

@end

@implementation MainViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.typeView.pageDelegate = self;
    self.carouselView.pageDelegate = self;
    self.carouselView.autoMoving = YES;
    self.carouselView.movingTimeInterval = 3.0;
    self.carouselView.placeholder = [UIImage imageNamed:@"home_banner_loding"];
    self.currentCityLabel.text = [self defaultTextForCurrentLabel];
    [self fetchDisctrictInfoIfNeeded];
    [self addObserverForNotifications:@[BANNER_DATA_GETTED_NOTIFICATION]];
    [self showIntroductionIfNeeded];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if ([self.model.imageURLs count])
    {
        [self.carouselView startMoving];
    }
    [self addObserverForNotifications:@[WARE_DETAIL_GETED_NOTIFICATION,
                                        SHOP_DETAIL_GETTED_NOTIFICATION,
                                        CURRENT_LOCATION_UPDATE_NOTIFICATION,
                                        PLACEMARK_UPDATE_NOTIFICATION]];
    [[PSLocationManager sharedInstance] startLocation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self locationAction];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeObserverForNotifications:@[WARE_DETAIL_GETED_NOTIFICATION,
                                           SHOP_DETAIL_GETTED_NOTIFICATION,
                                           CURRENT_LOCATION_UPDATE_NOTIFICATION,
                                           PLACEMARK_UPDATE_NOTIFICATION]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.carouselView stopMoving];
    [[PSLocationManager sharedInstance] stopLocating];
}

#pragma mark - Private

-(void)locationAction
{
    PSLocationManager *locationManager = [PSLocationManager sharedInstance];
    City *city = [[City alloc]init];
    city.cityName = [Util stringWithoutLastCharacter:locationManager.city];
    city.center_lat = @(locationManager.currentLocation.coordinate.latitude);
    city.center_lng = @(locationManager.currentLocation.coordinate.longitude);
    [UserSession sharedInstance].choosedCity = city;
    [UserSession sharedInstance].choosedDistrict = [PSLocationManager sharedInstance].district;
    NSLog(@"%@",[UserSession sharedInstance].choosedDistrict);
}

- (NSString *)defaultTextForCurrentLabel
{
    NSString *cityName = [CityModel priorCity].cityName;
    NSString *districtName = [self.model priorDistrict];
    NSString *text = [NSString stringWithFormat:@"%@%@",cityName,districtName];
    NSLog(@"======%@",text);
    return districtName;
}

- (UIView *)fullScreenView
{
    UIView *selectedView;
    
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        
        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            selectedView = window;
            break;
        }
    }
    return selectedView;
}

- (void)showIntroductionIfNeeded
{
    if ([UserInfo info].hideIntroduction == NO) {
        // Added Introduction View Controller
        NSArray *coverImageNames = @[@"yindaoye1",@"yindaoye2",@"yindaoye3"];
        UIButton *enterButton = [UIButton new];
        [enterButton setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateNormal];
        
        self.introductionView = [[ZWIntroductionViewController alloc] initWithCoverImageNames:coverImageNames backgroundImageNames:nil button:enterButton];
        
        [[self fullScreenView] addSubview:self.introductionView.view];
        
        __weak MainViewController *weakSelf = self;
        self.introductionView.didSelectedEnter = ^() {
            [UIView animateWithDuration:0.3
                             animations:^{
                                 weakSelf.introductionView.view.alpha = 0;
                             }
                             completion:^(BOOL finished) {
                                 if (finished)
                                 {
                                     weakSelf.introductionView = nil;
                                 }
                             }];
            [UserInfo info].hideIntroduction = YES;
        };
    }
}

- (void)fetchDisctrictInfoIfNeeded
{
    if (![[UserSession sharedInstance].districts count])
    {
        [self.cityModel giveMeDistrictInfo:[CityModel priorCity]];
    }
}

- (void)refetchCarouselData
{
    //定位更新，重新获取轮播图数据
    [self.model giveMeCarouselData:[CityModel priorCity] district:[self.model priorDistrict]];
}

- (void)receivedNotification:(NSNotification *)notification
{
    [self hideHUD];
    if ([notification.name isEqualToString:BANNER_DATA_GETTED_NOTIFICATION])
    {
        [self.carouselView stopMoving];
        self.carouselView.imageURLs = self.model.imageURLs;
        self.carouselPageControl.numberOfPages = [self.model.imageURLs count];
        [self.carouselView startMoving];
        return;
    }
    else if ([notification.name isEqualToString:WARE_DETAIL_GETED_NOTIFICATION])
    {
        [self performSegueWithIdentifier:[WareDetailViewController description] sender:nil];
        return;
    }
    else if ([notification.name isEqualToString:SHOP_DETAIL_GETTED_NOTIFICATION])
    {
        [self performSegueWithIdentifier:[ShopDetailViewController description] sender:nil];
        return;
    }
    else if ([notification.name isEqualToString:CURRENT_LOCATION_UPDATE_NOTIFICATION])
    {
        [self refetchCarouselData];
        return;
    }
    
    if ([notification.name isEqualToString:PLACEMARK_UPDATE_NOTIFICATION])
    {
        UserSession *session = [UserSession sharedInstance];
        if (!session.hasRewriteChoosedCity && !session.hasChooseCityThisTime)
        {
            City *locatedCity = [[City alloc]init];
            locatedCity.cityName = [Util stringWithoutLastCharacter:[PSLocationManager sharedInstance].city];
            
            locatedCity.center_lat = @([PSLocationManager sharedInstance].currentLocation.coordinate.latitude);
            locatedCity.center_lng = @([PSLocationManager sharedInstance].currentLocation.coordinate.longitude);
            session.choosedCity = locatedCity;
            session.hasRewriteChoosedCity = YES;
            session.choosedDistrict = [PSLocationManager sharedInstance].district;
            self.currentCityLabel.text = [self defaultTextForCurrentLabel];
            return;
        }
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //跳转到商品列表
    if ([segue.identifier isEqualToString:@"限时特价"])
    {
        WareListViewController *vc = segue.destinationViewController;
        vc.wareType = WareTypeDiscount;
        return;
    }
    if ([segue.identifier isEqualToString:@"小二推荐"])
    {
        WareListViewController *vc = segue.destinationViewController;
        vc.wareType = WareTypeRecommond;
        
        return;
    }
    
    //跳转到店铺列表
    if ([segue.identifier isEqualToString:@"新铺开张"])
    {
        ShopListViewController *vc = segue.destinationViewController;
        vc.shopType = ShopTypeNew;
        
        return;
    }
    if ([segue.identifier isEqualToString:@"热销铺子"])
    {
        ShopListViewController *vc = segue.destinationViewController;
        vc.shopType = ShopTypeHot;
        return;
    }
    
    if ([segue.identifier isEqualToString:@"代忙活动"])
    {
        ShopListViewController *vc = segue.destinationViewController;
        vc.shopType = ShopTypeDaimang;
        vc.activityID = sender;
        return;
    }
    if ([segue.identifier isEqualToString:[ShopListViewController description]])
    {
        ShopListViewController *vc = segue.destinationViewController;
        vc.shopType = [sender integerValue];
        return;
    }
    
    //跳转到详情界面
    if ([segue.identifier isEqualToString:[WareDetailViewController description]])
    {
        WareDetailViewController *vc = segue.destinationViewController;
        vc.ware = self.wareDetailModel.ware;
        return;
    }
    if ([segue.identifier isEqualToString:[ShopDetailViewController description]])
    {
        ShopDetailViewController *vc = segue.destinationViewController;
        vc.shop = self.shopDetailModel.shop;
        return;
    }
    
    //跳转到切换城市
    if ([segue.identifier isEqualToString:[SwitchAddressViewController description]])
    {
        SwitchAddressViewController *vc = segue.destinationViewController;
        vc.delegate = self;
        [vc setupWithSelectedCity:[CityModel priorCity] SelectedDistrict:[self.model priorDistrict]];
        return;
    }
}
#pragma mark - SwitchAddressDelegate
- (void)didSwitchAddress:(NSString *)address
{
    [self.currentCityLabel setText:address];
    [UserSession sharedInstance].hasChooseCityThisTime = YES;
    //用户切换过地址之后，手动获取一下轮播图
    [self refetchCarouselData];
}


#pragma mark - ShopTypeViewDelegate
- (void)didMoveToPage:(NSUInteger)page
{
    self.typePageControl.currentPage = page;
}

- (void)didTouchType:(NSInteger)type
{
    [self performSegueWithIdentifier:[ShopListViewController description] sender:@(type)];
}

#pragma mark - PSCarouselDelegate
- (void)carousel:(PSCarouselView *)carousel didMoveToPage:(NSUInteger)page;
{
    self.carouselPageControl.currentPage = page;
}

- (void)carousel:(PSCarouselView *)carousel didTouchPage:(NSUInteger)page;
{
    if (![self.model.carouselDatas count] || page >= [self.model.carouselDatas count])
    {
        return;
    }
    CarouselEntity *entity = [self.model.carouselDatas objectAtIndex:page];
    switch (entity.type)
    {
        case ActivityTypeShop:
        {
            //获取店铺详情数据，跳转至店铺界面
            [self showHUDWithTitle:@"请稍等..."];
            Shop *shop = [[Shop alloc]init];
            shop.shop_id = [entity.jump_id integerValue];
            [self.shopDetailModel giveMeShopInfo:shop];
        }
            break;
        case ActivityTypeGoods:
        {
            //获取商品详情数据，跳转至店铺界面
            [self showHUDWithTitle:@"请稍等..."];
            [self.wareDetailModel giveMeWareInfo:entity.jump_id];
        }
            break;
        case ActivityTypeDiamond:
            [self performSegueWithIdentifier:@"代忙活动" sender:entity.activity_id];
            break;
        case ActivityTypeNewShop:
            [self performSegueWithIdentifier:[ShopListViewController description] sender:@(ShopTypeNew)];
            break;
        case ActivityTypeHotShop:
            [self performSegueWithIdentifier:[ShopListViewController description] sender:@(ShopTypeHot)];
            break;
        case ActivityTypeTimeLimit:
            [self performSegueWithIdentifier:@"限时特价" sender:nil];
            break;
        case ActivityTypeRecommond:
            [self performSegueWithIdentifier:@"小二推荐" sender:nil];
            break;
            
    }
}



#pragma mark - Getter and Setter

- (MainModel *)model
{
    if (!_model)
    {
        _model = [[MainModel alloc]init];
    }
    return _model;
}

- (WareDetailModel *)wareDetailModel
{
    if (!_wareDetailModel) {
        _wareDetailModel = [[WareDetailModel alloc]init];
    }
    return _wareDetailModel;
}

- (ShopDetailModel *)shopDetailModel
{
    if (!_shopDetailModel)
    {
        _shopDetailModel = [[ShopDetailModel alloc]init];
    }
    return _shopDetailModel;
}

- (CityModel *)cityModel
{
    if (!_cityModel)
    {
        _cityModel = [[CityModel alloc]init];
    }
    return _cityModel;
}

@end
