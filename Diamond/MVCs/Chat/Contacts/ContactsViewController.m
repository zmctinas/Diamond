//
//  ContactsViewController.m
//  Diamond
//
//  Created by Pan on 15/7/11.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ContactsViewController.h"
#import "UIImageView+WebCache.h"
#import "RealtimeSearchUtil.h"
#import "AddFriendViewController.h"
#import "ApplyViewController.h"
#import "ChatViewController.h"
#import "ContactsModel.h"
#import "SearchFriendModel.h"
#import "ContactCell.h"
#import "UserDetailViewController.h"
@interface ContactsViewController ()<IChatManagerDelegate,UISearchDisplayDelegate>

@property (nonatomic, strong) ContactsModel *model;
@property (nonatomic, strong) SearchFriendModel *searchModel;
@property (nonatomic, strong) NSArray *searchResult;

@end

@implementation ContactsViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addLeftBarButtonItem];
    self.title = @"通讯录";
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    __weak ContactsViewController *weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf.model giveMeFriendList];
    }];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [self.model.contactsSource addObjectsFromArray:[UserInfo info].friends];
    self.model.dataSource = [self.model sortDataArray:self.model.contactsSource];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addObserverForNotifications:@[FRIEND_LIST_NOTIFICATION,SEARCH_FRIEND_NOTIFICATION,ADD_FRIEND_NOTIFICATION]];
    if (![self.model.contactsSource count])
    {
        [self.tableView.header beginRefreshing];
    }
    [self.model reloadDataSource];
    [self.tableView reloadData];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}



#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (![tableView isEqual:self.tableView])
    {
        return 1;
    }
    return [self.model.dataSource count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![tableView isEqual:self.tableView])
    {
        return [self.searchResult count];
    }
    
    if (section == 0) {return 1;}
    return [[self.model.dataSource objectAtIndex:(section - 1)] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[ContactCell description] forIndexPath:indexPath];
    
    //如果是SearchDisplay的Cell，设置个头像就直接返回
    if (![tableView isEqual:self.tableView])
    {
        Friend *aFriend = [self.searchResult objectAtIndex:indexPath.row];
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:aFriend.photo] placeholderImage:[UIImage imageNamed:@"chatListCellHead"]];
        cell.nameLabel.text = IS_NULL(aFriend.remarkname)? aFriend.user_name : aFriend.remarkname;
        return cell;
    }
    //如果是新的好友那一行
    if (indexPath.section == 0)
    {
        NSUInteger unreadApplyCount = [UserInfo info].unReadApplyCount;
        if (unreadApplyCount > 0)
        {
            [cell.unReadCountLabel setHidden:NO];
            cell.unReadCountLabel.text = [@(unreadApplyCount) stringValue];
        }
        else
        {
            [cell.unReadCountLabel setHidden:YES];
        }
        
        //防止重用混乱
        [cell.headImageView setImage:[UIImage imageNamed:@"address_headPlaceholder"]];
        cell.nameLabel.text = @"新的好友";
        return cell;
    }
    
    Friend *aFriend = [[self.model.dataSource objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:aFriend.photo] placeholderImage:[UIImage imageNamed:@"chatListCellHead"]];
    cell.nameLabel.text = IS_NULL(aFriend.remarkname)? aFriend.user_name : aFriend.remarkname;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.tableView] && indexPath.section == 0)
    {
        [self performSegueWithIdentifier:[ApplyViewController description] sender:nil];
        return;
    }
    
    
    //当用户点击一行好友。 区分一下是通讯录里的好友 还是SearchDisplay里的好友
    Friend *aFriend;
    if ([self.searchDisplayController isActive]) {
        aFriend = [self.searchResult objectAtIndex:indexPath.row];
    }else{
        aFriend = [[self.model.dataSource objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
    }
    //去服务器请求一下好友资料
    [self showHUDWithTitle:nil];
    [self.searchModel searchBuddyWithPhone:aFriend.friends_easemob];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.searchDisplayController isActive]) {
        return NO;
    }else{
        if (indexPath.section != 0)
        {
            return YES;
        }
    }
    return NO;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==UITableViewCellEditingStyleDelete)
    {
        Friend *aFriend = [[self.model.dataSource objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
        EMError *error = nil;
        [[[EaseMob sharedInstance] chatManager] removeBuddy:aFriend.friends_easemob removeFromRemote:YES error:&error];
        if (!error)
        {
            [[EaseMob sharedInstance].chatManager removeConversationByChatter:aFriend.friends_easemob deleteMessages:YES append2Chat:YES];
            [self.model deleteFriend:aFriend];//删除服务器上的好友
            [[UserInfo info] deleteFriend:aFriend];//删除本地的好友
            [self.model reloadDataSource];//刷新一下界面
            [self.tableView reloadData];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0 || [[self.model.dataSource objectAtIndex:(section - 1)] count] == 0)
    {
        return nil;
    }
    
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:UIColorFromRGB(0xfafafa)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 100, 22)];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = UIColorFromRGB(DARK_GRAY);
    label.backgroundColor = [UIColor clearColor];
    [label setText:[self.model.sectionTitles objectAtIndex:(section - 1)]];
    [contentView addSubview:label];
    return contentView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || [[self.model.dataSource objectAtIndex:(section - 1)] count] == 0)
    {
        return 0;
    }
    else{
        return 22;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray * existTitles = [NSMutableArray array];
    //section数组为空的title过滤掉，不显示
    for (int i = 0; i < [self.model.sectionTitles count]; i++)
    {
        if ([[self.model.dataSource objectAtIndex:i] count] > 0)
        {
            [existTitles addObject:[self.model.sectionTitles objectAtIndex:i]];
        }
    }
    return existTitles;
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller  shouldReloadTableForSearchString:(NSString *)searchString
{
    if (IS_NULL(searchString))
    {
        return NO;
    }
    
    //根据好友名称搜索
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.model.contactsSource searchText:(NSString *)searchString collationStringSelector:@selector(searchString) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.searchResult = results;
                [self.searchDisplayController.searchResultsTableView reloadData];
            });
        }
    }];
    
    return YES;
}

#pragma mark - IChatManagerDelegate
- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message
{
    [self.tableView reloadData];
}




#pragma mark - Notification
- (void)receivedNotification:(NSNotification *)notification
{
    [self hideHUD];

    if ([notification.name isEqualToString:FRIEND_LIST_NOTIFICATION])
    {
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];
        return;
    }
    
    if ([notification.name isEqualToString:SEARCH_FRIEND_NOTIFICATION])
    {
        [self performSegueWithIdentifier:[UserDetailViewController description] sender:nil];
        return;
    }
    
    if ([notification.name isEqualToString:ADD_FRIEND_NOTIFICATION])
    {
        [self.tableView reloadData];
    }
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:[UserDetailViewController description]])
    {
        UserDetailViewController *vc = segue.destinationViewController;
        vc.buddy = self.searchModel.buddy;
        vc.detailType = UserDetailTypeFriend;
    }
}



#pragma mark - action

- (ContactsModel *)model
{
    if (!_model)
    {
        _model = [ContactsModel new];
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
