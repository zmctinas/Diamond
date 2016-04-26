//
//  ChatListViewController.m
//  Diamond
//
//  Created by Pan on 15/7/11.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatListCell.h"
#import "ChatListModel.h"
#import "PSDropView.h"
#import "SearchFriendViewController.h"
#import "ContactsViewController.h"
#import "ChatViewController.h"
#import "Friend.h"
#import "ScanViewController.h"

#define SAO_YI_SAO 0
#define ADD_FRIEND 1
#define ADDRESS_LIST 2

@interface ChatListViewController ()<UITableViewDelegate,
                                    UITableViewDataSource,
                                    IChatManagerDelegate,
                                    PSDropViewDelegate,
                                    ChatModelDelegate>

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (nonatomic, strong) ChatListModel *model;
@property (nonatomic, strong) PSDropView *dropView;

@property (nonatomic, weak) IBOutlet UILabel *redPointLabel;
- (IBAction)touchMoreButton:(UIBarButtonItem *)sender;

@end

@implementation ChatListViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    [self.model removeEmptyConversationsFromDB];
    [self.model getImageURLForConversations:[[EaseMob sharedInstance].chatManager conversations]];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshDataSource)];
    
    [self addObserverForNotifications:@[PUSH_TO_VIEWCONTROLLER_NOTIFICATION,HEAD_PHOTO_GETTED_NOTIFICATION]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshDataSource];
    [self showRedPointIfNeeded];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.dropView hide:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HEAD_PHOTO_GETTED_NOTIFICATION object:nil];
}

- (void)dealloc
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

#pragma mark - UITableViewDelegate & UITableViewDatasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:[ChatListCell description] forIndexPath:indexPath];

    EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
    
    cell.name = [self nickNameWithChatter:conversation.chatter];
    cell.imageURL = [NSURL URLWithString:[self avatarWithChatter:conversation.chatter]];
    cell.placeholderImage = [UIImage imageNamed:@"chatListCellHead"];
    cell.detailMsg = [self.model subTitleMessageByConversation:conversation];
    cell.time = [self.model lastMessageTimeByConversation:conversation];
    cell.unreadCount = [self.model unreadMessageCountByConversation:conversation];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
    
    ChatViewController *chatController;
    NSString *title = [self nickNameWithChatter:conversation.chatter];
    
    
    NSString *chatter = conversation.chatter;
    chatController = [[ChatViewController alloc] initWithChatter:chatter];
    chatController.model.delelgate = self;
    chatController.hidesBottomBarWhenPushed = YES;
    chatController.title = title;
    [self.navigationController pushViewController:chatController animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EMConversation *converation = [self.dataSource objectAtIndex:indexPath.row];
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:converation.chatter deleteMessages:YES append2Chat:YES];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark - PSDropViewDelegate

- (void)dropView:(PSDropView *)dropView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == SAO_YI_SAO)
    {
        [self performSegueWithIdentifier:[ScanViewController description] sender:nil];

        return;
    }
    if (indexPath.row == ADDRESS_LIST)
    {
        [self performSegueWithIdentifier:[ContactsViewController description] sender:nil];
        return;
    }
    if (indexPath.row == ADD_FRIEND)
    {
        [self performSegueWithIdentifier:[SearchFriendViewController description] sender:nil];
        return;
    }
}


#pragma mark - IChatManagerDelegate

-(void)didUnreadMessagesCountChanged
{
    [self refreshDataSource];
}

- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    [self refreshDataSource];
}

- (void)didFinishedReceiveOfflineMessages:(NSArray *)offlineMessages{
    [self refreshDataSource];
}

- (void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message
{
    [self showRedPointIfNeeded];
}

#pragma mark - public Method

-(void)refreshDataSource
{
    self.dataSource = [self.model loadDataSource];
    [self.model getImageURLForConversations:self.dataSource];
    [self.tableView reloadData];
    [self.tableView.header endRefreshing];
}



#pragma mark - ChatModelDelegate

/**
 *  根据环信id得到要显示头像路径，如果返回nil，则显示默认头像
 *
 *  @param chatter 环信账号 easemob
 *
 *  @return 头像URLSting
 */
- (NSString *)avatarWithChatter:(NSString *)chatter
{
    
    NSArray *conversastions = [[[EaseMob sharedInstance] chatManager] conversations];
    for (EMConversation *cv in conversastions)
    {
        if ([cv.chatter isEqualToString:chatter])
        {
            Friend *friend = [cv.ext objectForKey:FRIEND];
            if (friend)
            {
                return friend.photo;
            }
            break;
        }
    }
    
    
    NSArray *friends = [UserInfo info].friends;
    
    for (Friend *frd in friends)
    {
        if ([frd.friends_easemob isEqualToString:chatter])
        {
            return frd.photo;
        }
    }
    
    if ([[UserSession sharedInstance].currentUser.easemob isEqualToString:chatter])
    {
        return [UserSession sharedInstance].currentUser.photo;
    }
    
    return nil;
}

/**
 *  根据环信id得到要显示用户名，如果返回nil，则默认显示环信id
 *
 *  @param chatter 环信账号 easemob
 *
 *  @return 昵称
 */
- (NSString *)nickNameWithChatter:(NSString *)chatter
{
    NSArray *conversastions = [[[EaseMob sharedInstance] chatManager] conversations];
    for (EMConversation *cv in conversastions)
    {
        if ([cv.chatter isEqualToString:chatter])
        {
            Friend *friend = [cv.ext objectForKey:FRIEND];
            if (friend)
            {
                return IS_NULL(friend.remarkname) ? friend.user_name : friend.remarkname;
            }
            break;
        }
    }
    
    
    NSArray *friends = [UserInfo info].friends;
    
    for (Friend *frd in friends)
    {
        if ([frd.friends_easemob isEqualToString:chatter])
        {
            return IS_NULL(frd.remarkname) ? frd.user_name : frd.remarkname;
        }
    }
    
    if ([[UserSession sharedInstance].currentUser.easemob isEqualToString:chatter])
    {
        return [UserSession sharedInstance].currentUser.user_name;
    }
    
    
    return chatter;
}

- (void)receivedNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:PUSH_TO_VIEWCONTROLLER_NOTIFICATION])
    {
        ChatViewController *vc = notification.object;
        vc.model.delelgate = self;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([notification.name isEqualToString:HEAD_PHOTO_GETTED_NOTIFICATION])
    {
        [self refreshDataSource];
    }
}



#pragma mark - Event Response


- (IBAction)touchMoreButton:(UIBarButtonItem *)sender
{
    //TODO:完善一下 点击任何背景都可以隐藏这个View
    if (self.dropView.isShow)
    {
        [self.dropView hide:YES];
        return;
    }
    [self.dropView showInView:self.navigationController.view senderIdentifier:RightBarButtonItem noticeCount:[UserInfo info].unReadApplyCount sender:sender];
}


#pragma mark - Private
- (void)showRedPointIfNeeded
{
    if ([UserInfo info].unReadApplyCount != 0)
    {
        self.redPointLabel.hidden = NO;
    }
    else
    {
        self.redPointLabel.hidden = YES;
    }
}



#pragma mark - Getter and Setter

- (PSDropView *)dropView
{
    if (!_dropView)
    {
        NSMutableArray *dropItems = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < 3; i++)
        {
            NSString *imageName = [NSString stringWithFormat:@"moreImage%ld",(long)i];
            UIImage *image = [UIImage imageNamed:imageName];
            NSArray *titles = @[@"扫一扫",@"添加好友",@"通讯录"];
            
            [dropItems addObject:[PSDropItem dropItemWithIcon:image text:[titles objectAtIndex:i]]];
        }
        _dropView = [[PSDropView alloc]initWithItems:dropItems];
        _dropView.delegate = self;
    }
    return _dropView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (ChatListModel *)model
{
    if (!_model)
    {
        _model = [[ChatListModel alloc]init];
    }
    return _model;
}

@end
