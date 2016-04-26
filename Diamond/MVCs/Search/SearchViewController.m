//
//  SearchViewController.m
//  Diamond
//
//  Created by Pan on 15/7/20.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "SearchViewController.h"
#import "ShopDetailViewController.h"
#import "WareDetailViewController.h"
#import "SearchGoodsCell.h"
#import "ShopsCell.h"
#import "SearchGoodsCell.h"
#import "SearchModel.h"
#import "MJRefresh.h"
@interface SearchViewController()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SearchModel *model;
@property (weak, nonatomic) IBOutlet UISegmentedControl *searchTypeSegment;


- (IBAction)searchTypeChanged:(UISegmentedControl *)sender;

@end

@implementation SearchViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchBar.delegate = self;
    [self addObserverForNotifications:@[SEARCH_NOTIFICATION]];
    self.tableView.tableFooterView = [[UIView alloc]init];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.searchBar becomeFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.model.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self currentSearchType] == SearchTypeWare)
    {
        SearchGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:[SearchGoodsCell description] forIndexPath:indexPath];
        WaresEntity *ware = [self.model.dataSource objectAtIndex:indexPath.row];
        cell.ware = ware;
        return cell;
    }
    
    if ([self currentSearchType] == SearchTypeShop)
    {
        ShopsCell *cell = [tableView dequeueReusableCellWithIdentifier:[ShopsCell description] forIndexPath:indexPath];
        Shop *shop = [self.model.dataSource objectAtIndex:indexPath.row];
        cell.shop = shop;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self currentSearchType] == SearchTypeShop)
    {
        [self performSegueWithIdentifier:[ShopDetailViewController description] sender:indexPath];
    }
    else if ([self currentSearchType] == SearchTypeWare)
    {
        [self performSegueWithIdentifier:[WareDetailViewController description] sender:indexPath];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - Private Method
- (void)search
{
    if (IS_NULL(self.searchBar.text))
    {
        return;
    }
    
    [self showHUDWithTitle:@"搜索中..."];
    self.model.searchType = [self currentSearchType];
    [self.model searchWithKeyWords:self.searchBar.text];
}

- (SearchType)currentSearchType
{
    SearchType searchType;
    switch (self.searchTypeSegment.selectedSegmentIndex)
    {
        case 0:
            searchType = SearchTypeShop;
            break;
        case 1:
            searchType = SearchTypeWare;
            break;
        default:
            break;
    }
    return searchType;
}


- (void)addFooter
{
    [self.tableView addLegendFooterWithRefreshingTarget:self.model refreshingAction:@selector(giveMeNextData)];
    [self.tableView.footer setTitle:@"没有你想要的了" forState:MJRefreshFooterStateNoMoreData];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self search];
}


#pragma mark - Event Response
- (IBAction)searchTypeChanged:(UISegmentedControl *)sender
{
    [self search];
}

- (void)receivedNotification:(NSNotification *)notification
{
    [self hideHUD];
    [self.tableView.footer endRefreshing];
    if ([notification.name isEqualToString:SEARCH_NOTIFICATION])
    {
        if (!self.tableView.footer)
        {
            [self addFooter];
        }
        [self.tableView reloadData];
        BOOL noMoreData = [notification.object boolValue];
        if (noMoreData)
        {
            [self.tableView.footer noticeNoMoreData];
        }
    }
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:[WareDetailViewController description]])
    {
        NSIndexPath *index = sender;
        WareDetailViewController *vc = segue.destinationViewController;
        vc.ware = [self.model.dataSource objectAtIndex:index.item];
    }else if ([segue.identifier isEqualToString:[ShopDetailViewController description]])
    {
        NSIndexPath *index = sender;
        ShopDetailViewController *vc = segue.destinationViewController;
        Shop *shop = [self.model.dataSource objectAtIndex:index.row];
        vc.shop = shop;
    }
}


#pragma mark - getter and setter
- (SearchModel *)model
{
    if (!_model)
    {
        _model = [[SearchModel alloc]init];
    }
    return _model;
}

@end
