//
//  ApplyViewController.m
//  Diamond
//
//  Created by Pan on 15/7/25.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ApplyViewController.h"
#import "Macros.h"
#import "UserInfo.h"
#import "ApplyCell.h"
#import "ApplyEntity.h"
#import "UIImageView+WebCache.h"
#import "UserDetailViewController.h"
#import "UserDetailModel.h"
#import "WebService+Chat.h"
#import "SearchFriendModel.h"
#import "ContactsModel.h"
#import "Friend.h"
static ApplyViewController *controller = nil;


@interface ApplyViewController ()<ApplyCellDelegate,UserDetailViewControllerDelegate>

@property (strong, nonatomic, readwrite) NSMutableArray *dataSource;
@property (strong, nonatomic) UserDetailModel *model;
@property (strong, nonatomic) SearchFriendModel *searchModel;
@property (nonatomic, strong) ContactsModel *contactModel;

@end

@implementation ApplyViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _dataSource = [NSMutableArray array];
    }
    return self;
}

//单例是为了收到环信的好友申请去处理而是用的。可以提取出来
+ (instancetype)shareController
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        controller = [MStoryboard instantiateViewControllerWithIdentifier:[ApplyViewController description]];
        [controller addObserverForNotifications:@[GET_APPLY_ENTITY_NOTIFICATION]];
    });
    return controller;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.title = @"新的好友";
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.contentInset = UIEdgeInsetsMake(-35.5, 0, 0, 0);
    [self addObserverForNotifications:@[ADD_FRIEND_NOTIFICATION]];
    [self addLeftBarButtonItem];
    [self loadDataSourceFromLocalDB];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addObserverForNotifications:@[SEARCH_FRIEND_NOTIFICATION]];
    //这个页面显示了，说明好友数量全都读过了。
    [UserInfo info].unReadApplyCount = 0;
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:SEARCH_FRIEND_NOTIFICATION object:nil];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:[ApplyCell description] forIndexPath:indexPath];
    ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.titleLabel.text = entity.applicantNick;
    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:entity.applicantAvatar] placeholderImage:[UIImage imageNamed:@"chatListCellHead"]];
    cell.contentLabel.text = entity.reason;
    
    if (entity.accepted)
    {
        [cell.addButton setBackgroundImage:nil forState:UIControlStateNormal];
        [cell.addButton setTitle:@"已添加" forState:UIControlStateNormal];
        [cell.addButton setTitleColor:UIColorFromRGB(0xbdbdbd) forState:UIControlStateNormal];
        [cell.addButton setEnabled:NO];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
    if (!entity.accepted)
    {
        [self showHUDWithTitle:@""];
        [self.searchModel searchBuddyWithPhone:entity.applicantUsername];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self synchronize];
        [self.tableView reloadData];

    }
}


#pragma mark - ApplyCellDelegate

- (void)applyCellAddFriendAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < [self.dataSource count])
    {
        [self showHUDWithTitle:nil];
        
        ApplyEntity *entity = [self.dataSource objectAtIndex:indexPath.row];
        EMError *error;
        [[EaseMob sharedInstance].chatManager acceptBuddyRequest:entity.applicantUsername error:&error];
        if (!error) {
            
            [self.model addFriend:entity.applicantUsername withMessage:entity.reason];
            entity.accepted = YES;
            [self synchronize];
        }
        else
        {
            [self showtips:@"接受请求失败"];
        }
    }
}

#pragma mark - UserDetailViewControllerDelegate
- (void)didAccpetRequestFromBuddy:(Buddy *)buddy
{
    for (ApplyEntity *entity in self.dataSource)
    {
        if ([entity.applicantUsername isEqualToString:buddy.easemob])
        {
            entity.accepted = YES;
            [self synchronize];
        }
    }
}


#pragma mark - Notification
- (void)receivedNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:ADD_FRIEND_NOTIFICATION])
    {
        [self hideHUD];
        [self.tableView reloadData];
        return;
    }
    
    if ([notification.name isEqualToString:GET_APPLY_ENTITY_NOTIFICATION])
    {
        NSMutableArray *applyRequests = [NSMutableArray array];
        NSArray *cacheApplys = [UserInfo info].applyRequests;
        if ([cacheApplys count])
        {
            applyRequests = [NSMutableArray arrayWithArray:cacheApplys];
        }
        [applyRequests insertObject:notification.object atIndex:0];
        [UserInfo info].applyRequests = applyRequests;
        [self loadDataSourceFromLocalDB];
        return;
    }
    
    if ([notification.name isEqualToString:SEARCH_FRIEND_NOTIFICATION])
    {
        [self hideHUD];
        [self performSegueWithIdentifier:[UserDetailViewController description] sender:self.searchModel.buddy];
        return;
    }
}


#pragma mark - public

- (void)addNewApply:(NSString *)easemob message:(NSString *)message
{
    //如果好友请求里已经有了，就不再往里面添加
    for (ApplyEntity *entity in [UserInfo info].applyRequests)
    {
        if ([entity.applicantUsername isEqualToString:easemob])
        {
            return;
        }
    }
    
    [self.searchModel searchBuddyWithPhone:easemob message:message];
    //直接往数据库添加一个未读数量。ContactViewController自动会去取的。
    [UserInfo info].unReadApplyCount = [UserInfo info].unReadApplyCount + 1;//不能用++。
}

- (void)loadDataSourceFromLocalDB
{
    [_dataSource removeAllObjects];
    
    NSArray *arr = [UserInfo info].applyRequests;
    NSMutableArray *temp = [NSMutableArray arrayWithArray:arr];
//    if (![temp count])
//    {
//        UserEntity *user = [UserSession sharedInstance].currentUser;
//        for (Friend *buddy in [UserInfo info].friends)
//        {
//            ApplyEntity *entity = [ApplyEntity new];
//            
//            entity.applicantUsername = buddy.friends_easemob;
//            entity.applicantNick = buddy.user_name;
//            entity.applicantAvatar = buddy.photo;
//            entity.receiverUsername = user.easemob;
//            entity.receiverNick = user.user_name;
//            entity.receiverAvatar = user.photo;
//            entity.reason = [NSString stringWithFormat:@"%@请求添加你为好友",buddy.user_name];
//            entity.accepted = YES;
//            [temp addObject:entity];
//        }
//        [UserInfo info].applyRequests = temp;
//    }
    
    [self.dataSource addObjectsFromArray:temp];
    [self.tableView reloadData];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:[UserDetailViewController description]])
    {
        UserDetailViewController *vc = segue.destinationViewController;
        vc.buddy = sender;
        vc.detailType = UserDetailTypeBeenInvited;
        vc.delegate = self;
        return;
    }
}


- (void)back
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SETUP_UNREAD_APPLY_COUNT object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clear
{
    [_dataSource removeAllObjects];
    [self.tableView reloadData];
}

- (void)synchronize
{
    //接受了请求 持久化一下
    [UserInfo info].applyRequests = self.dataSource;
    //更新一下本地好友列表
    [self.contactModel giveMeFriendList];
}

#pragma mark - getter

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (UserDetailModel *)model
{
    if (!_model)
    {
        _model = [[UserDetailModel alloc]init];
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

- (ContactsModel *)contactModel
{
    if (!_contactModel)
    {
        _contactModel = [[ContactsModel alloc] init];
    }
    return _contactModel;
}

@end
