//
//  SwichCityViewController.m
//  Diamond
//
//  Created by Pan on 15/8/4.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "SwichCityViewController.h"
#import "RealtimeSearchUtil.h"
#import "CityModel.h"
#import "City.h"
@interface SwichCityViewController ()<UISearchDisplayDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) CityModel *model;
@property (nonatomic, strong) City *selectedCity;

@property (nonatomic, strong) NSArray *searchResult;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *hotCityButtons;

- (IBAction)touchHotCityButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SwichCityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addObserverForNotifications:@[CITY_LIST_NOTIFICATION]];
    [self showHUDWithTitle:@"获取城市数据..."];
    [self.model giveMeCityData];
    [self sortButtons];
    [self addLeftBarButtonItem:@"关闭" action:@selector(touchCloseButton:)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (![tableView isEqual:self.tableView])
    {
        return 1;
    }
    return [self.model.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![tableView isEqual:self.tableView])
    {
        return [self.searchResult count];
    }
    
    return [[self.model.dataSource objectAtIndex:section] count];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([[self.model.dataSource objectAtIndex:section] count] == 0 || [tableView isEqual:self.searchDisplayController.searchResultsTableView])
    {
        return nil;
    }
    
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:UIColorFromRGB(0xf1f1f1)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 100, 22)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = UIColorFromRGB(0x999999);
    [label setText:[self.model.sectionTitles objectAtIndex:section]];
    [contentView addSubview:label];
    return contentView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CityCell"];
    
    City *city;
    //如果是SearchDisplay的Cell
    if (![tableView isEqual:self.tableView])
    {
        city = [self.searchResult objectAtIndex:indexPath.row];
    }
    else
    {
        city = [[self.model.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    cell.textLabel.textColor = UIColorFromRGB(0x555555);
    cell.textLabel.text = city.cityName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.searchDisplayController isActive])
    {
        self.selectedCity = [self.searchResult objectAtIndex:indexPath.row];
    }
    else
    {
        self.selectedCity = [[self.model.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    [self finishSelectCity];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[self.model.dataSource objectAtIndex:section] count] == 0)
    {
        return 0;
    }
    else{
        return 22;
    }
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if (IS_NULL(searchString))
    {
        return NO;
    }
    
    
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.model.allCities searchText:(NSString *)searchString collationStringSelector:@selector(cityName) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.searchResult = results;
                [self.searchDisplayController.searchResultsTableView reloadData];
            });
        }
    }];
    
    return YES;
}


#pragma mark - Private
- (void)highlightBackGround:(UIButton *)button
{
    UIImage *selectedBG = [UIImage imageNamed:@"city_btn_bg"];
    for (UIButton *button in self.hotCityButtons)
    {
        if ([button.currentBackgroundImage isEqual:selectedBG])
        {
            [button setBackgroundImage:nil forState:UIControlStateNormal];
            break;
        }
    }
    [button setBackgroundImage:selectedBG forState:UIControlStateNormal];
}

- (void)modifyCityButtontitle
{
    for (UIButton *button in self.hotCityButtons)
    {
        //如果服务器回传的热门城市数量比按钮数量多
        if (button.tag < [self.model.hotCities count])
        {
            City *hotCity = [self.model.hotCities objectAtIndex:button.tag];
            button.titleLabel.text = hotCity.cityName;
            [button setTitle:hotCity.cityName forState:UIControlStateNormal];
        }
        else
        {
            [button setHidden:YES];
        }
    }
}

- (void)sortButtons
{
    self.hotCityButtons = [self.hotCityButtons sortedArrayUsingComparator:^NSComparisonResult(UIButton *obj1, UIButton *obj2) {
        if (obj1.tag > obj2.tag)
        {
            return NSOrderedDescending;
        }
        if (obj1.tag < obj2.tag) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
}

#pragma mark - Event Response
- (void)touchCloseButton:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchHotCityButton:(UIButton *)sender
{
    [self highlightBackGround:sender];
    
    if ([self.delegate respondsToSelector:@selector(didSelectedCity:)])
    {
        for (City *city in self.model.allCities)
        {
            if ([city.cityName isEqualToString:sender.currentTitle])
            {
                self.selectedCity = city;
                [self finishSelectCity];
                return;
            }
        }
    }
    
}


- (void)receivedNotification:(NSNotification *)notification
{
    [self hideHUD];
    if ([notification.name isEqualToString:CITY_LIST_NOTIFICATION])
    {
        [self modifyCityButtontitle];
        [self.tableView reloadData];
        return;
    }
}

- (void)finishSelectCity
{
    if ([self.delegate respondsToSelector:@selector(didSelectedCity:)])
    {
        [self.delegate didSelectedCity:self.selectedCity];
    }
    [self touchCloseButton:nil];
}

- (CityModel *)model
{
    if (!_model)
    {
        _model = [[CityModel alloc]init];
    }
    return _model;
}
@end
