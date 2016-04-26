//
//  SwitchAddressViewController.m
//  Diamond
//
//  Created by Pan on 15/12/23.
//  Copyright © 2015年 Pan. All rights reserved.
//

#import "SwitchAddressViewController.h"
#import "SwichCityViewController.h"
#import "PSDropCollectionCell.h"
#import "CityModel.h"
#import "PSLocationManager.h"

#define ScreenWidth      CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define ScreenHeight     CGRectGetHeight([UIScreen mainScreen].applicationFrame)
@interface SwitchAddressViewController ()<PSDropDownMenuCellDelegate,SwichCityDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *currentCityLabel;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) CityModel *cityModel;

@property (strong, nonatomic) City *selectedCity;
@property (copy, nonatomic) NSString *selectedDistrict;


- (IBAction)touchLocationButton:(id)sender;


@end

@implementation SwitchAddressViewController
#pragma mark - Public
- (void)setupWithSelectedCity:(City *)city SelectedDistrict:(NSString *)district;
{
    self.selectedCity = city;
    self.selectedDistrict = district;
}

#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addLeftBarButtonItem];
    [self addObserverForNotifications:@[DISTRICT_LIST_NOTIFIATION]];
    [self setupCollectionView];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showHUDWithTitle:nil];
    [self.cityModel giveMeDistrictInfo:self.selectedCity];
    [self updateUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PSDropCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PSDropCollectionCell description] forIndexPath:indexPath];
    NSString *name = [self.dataSource objectAtIndex:indexPath.item];
    cell.areaButton.titleLabel.text = name;
    [cell.areaButton setTitle:name forState:UIControlStateNormal];
    cell.indexPath = indexPath;
    cell.delegate = self;
    if ([name isEqualToString:self.selectedDistrict])
    {
        cell.selected = YES;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self didtouchCellAtIndexPath:indexPath];
}

#pragma mark - PSDropDownMenuCellDelegate
- (void)didTouchCell:(PSDropCollectionCell *)cell
{
    [self.collectionView selectItemAtIndexPath:cell.indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    [self didtouchCellAtIndexPath:cell.indexPath];
}

- (void)didtouchCellAtIndexPath:(NSIndexPath *)indexPath;
{
    [UserSession sharedInstance].choosedCity = self.selectedCity;
    [UserSession sharedInstance].choosedDistrict = [self.dataSource objectAtIndex:indexPath.item];
    [self tellDelegateAddress:[self addressForSelection]];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SwichCityDelegate
- (void)didSelectedCity:(City *)city
{
    [self updateUI];
    if (![self.selectedCity.cityCode isEqual:city.cityCode])
    {
        self.selectedCity = city;
        self.selectedDistrict = self.dataSource.firstObject;
        [UserSession sharedInstance].choosedCity = self.selectedCity;
        [UserSession sharedInstance].choosedDistrict = self.dataSource.firstObject;
        [self tellDelegateAddress:[self addressForSelection]];
        [self showHUDWithTitle:nil];
        [self.cityModel giveMeDistrictInfo:city];
    }
    //用户切换过城市之后，刷新一下城市信息
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:[SwichCityViewController description]])
    {
        SwichCityViewController *vc = segue.destinationViewController;
        vc.delegate = self;
        return;
    }
}

#pragma mark - IBAction
- (IBAction)touchLocationButton:(id)sender
{
    PSLocationManager *locationManager = [PSLocationManager sharedInstance];
    if (!locationManager.placemark) {
        [self showHUDWithTitle:@"定位中..."];
        [self addObserverForNotifications:@[PLACEMARK_UPDATE_NOTIFICATION]];
        [locationManager startLocation];
        return;
    }
    
    City *city = [[City alloc]init];
    city.cityName = [Util stringWithoutLastCharacter:locationManager.city];
    city.center_lat = @(locationManager.currentLocation.coordinate.latitude);
    city.center_lng = @(locationManager.currentLocation.coordinate.longitude);
    [UserSession sharedInstance].choosedCity = city;
    [UserSession sharedInstance].choosedDistrict = [PSLocationManager sharedInstance].district;
    [self tellDelegateAddress:[self addressForLocation]];
    [self hideHUD];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Notification
- (void)receivedNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:DISTRICT_LIST_NOTIFIATION])
    {
        [self hideHUD];
        [self.collectionView reloadData];
        return;
    }
    if ([notification.name isEqualToString:PLACEMARK_UPDATE_NOTIFICATION])
    {
        [self removeObserverForNotifications:@[PLACEMARK_UPDATE_NOTIFICATION]];
        [self touchLocationButton:nil];
        return;
    }
}

#pragma mark - Private Method
- (void)updateUI
{
    self.currentCityLabel.text = [NSString stringWithFormat:@"当前城市:%@",self.selectedCity.cityName];
    [self.collectionView reloadData];
}

- (void)setupCollectionView
{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(ScreenWidth / 3, 40);
}

- (void)tellDelegateAddress:(NSString *)address
{
    if ([self.delegate respondsToSelector:@selector(didSwitchAddress:)])
    {
        [self.delegate didSwitchAddress:address];
    }
}

- (NSString *)addressForLocation
{
    NSString *district = [UserSession sharedInstance].choosedDistrict;
    NSString *street = [PSLocationManager sharedInstance].placemark.thoroughfare;
    NSString *number = [PSLocationManager sharedInstance].placemark.subThoroughfare;
    NSString *address = [NSString stringWithFormat:@"%@%@%@",district,street,number];
    return address;
}

- (NSString *)addressForSelection
{
    NSString *city = [UserSession sharedInstance].choosedCity.cityName;
    NSString *district = [UserSession sharedInstance].choosedDistrict;
    NSString *address = [NSString stringWithFormat:@"%@%@",city,district];
    return address;
}

#pragma mark - Getter and Setter
- (NSArray *)dataSource
{
    _dataSource = [UserSession sharedInstance].districts;
    return _dataSource;
}

- (CityModel *)cityModel
{
    if (!_cityModel)
    {
        _cityModel = [[CityModel alloc] init];
    }
    return _cityModel;
}
@end
