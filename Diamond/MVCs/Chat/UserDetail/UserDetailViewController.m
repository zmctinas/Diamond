//
//  UserDetailViewController.m
//  Diamond
//
//  Created by Pan on 15/7/21.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "UserDetailViewController.h"
#import "UserDetailAreaCell.h"
#import "UserDetailImageCell.h"
#import "UserDetialHeadCell.h"
#import "PSButtonFooterView.h"
#import "ChatViewController.h"
#import "UIImageView+WebCache.h"
#import "URLConstant.h"
#import "UserDetailModel.h"
#import "Util.h"
#import "PSAlertView.h"
#import "RemarkViewController.h"
#import "ShopDetailViewController.h"
#import "ShopDetailModel.h"
#import "ApplyEntity.h"
@interface UserDetailViewController()<UITableViewDelegate,
                                      UITableViewDataSource,
                                      PSButtonFooterDelegate,
                                      PSAlertViewDelegate,
                                      IChatManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic ,strong) PSAlertView *alertView;
@property (nonatomic, strong) UserDetailModel *model;


@end

@implementation UserDetailViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addObserverForNotifications:@[ADD_FRIEND_NOTIFICATION]];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [self.tableView registerNib:[UINib nibWithNibName:[PSButtonFooterView description] bundle:nil]  forHeaderFooterViewReuseIdentifier:[PSButtonFooterView description]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)dealloc
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}
#pragma mark - IChatManagerDelegate
- (void)didAcceptedByBuddy:(NSString *)username;
{
    if (self.detailType == UserDetailTypeStranger)
    {
        self.detailType = UserDetailTypeFriend;
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Shop *shop = [Shop new];
    shop.shop_id = [self.buddy.shop_id integerValue];
    shop.easemob = self.buddy.easemob;
    if (shop.shop_id)
    {
        [self performSegueWithIdentifier:[ShopDetailViewController description] sender:shop];
    }
    else
    {
        [self showtips:@"他还没有开店哦"];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 82;
    }
    if (indexPath.row == 1)
    {
        return 40;
    }
    if (indexPath.row == 2)
    {
        return 80;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
       UserDetialHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:[UserDetialHeadCell description]];
        cell.nameLabel.text =  IS_NULL(self.buddy.remarkname) ? self.buddy.user_name : self.buddy.remarkname;
        cell.nicknameLabel.text = self.buddy.user_name;
        cell.accountLabel.text = self.buddy.easemob;
        [cell.headPhotoView sd_setImageWithURL:[NSURL URLWithString:self.buddy.photo] placeholderImage:[UIImage imageNamed:@"chatListCellHead"]];
        if (self.buddy.sex == SexFeMale)
        {
            [cell.sexButton setImage:[UIImage imageNamed:@"detail_icon_nv"] forState:UIControlStateNormal];
        }
        //只要不是好友，都隐藏编辑按钮
        [cell.editButton setHidden:self.detailType != UserDetailTypeFriend];
        return cell;
    }
    
    if (indexPath.row == 1)
    {
        UserDetailAreaCell *cell = [tableView dequeueReusableCellWithIdentifier:[UserDetailAreaCell description]];
        NSString *province = IS_NULL(self.buddy.province) ? @" " : [Util stringWithoutLastCharacter:self.buddy.province];
        NSString *city = IS_NULL(self.buddy.city) ? @" " : [Util stringWithoutLastCharacter:self.buddy.city];
        cell.areaLabel.text = [NSString stringWithFormat:@"%@ %@",province,city];
        
        return cell;
    }
    
    if (indexPath.row == 2)
    {
       UserDetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:[UserDetailImageCell description]];
        for (NSInteger index = 0; index < MIN([self.buddy.shop_ad count], 3); index++)
        {
            NSURL *url = [Util urlWithPath:[self.buddy.shop_ad objectAtIndex:index]];
            UIImageView *imageView = [cell.goodsImageViews objectAtIndex:index];
            [imageView sd_setImageWithURL:url];
        }
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.detailType == UserDetailTypeSelf)
    {
        return nil;
    }
    PSButtonFooterView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[PSButtonFooterView description]];
    [headView.button setTitle:[self titleWithDetailType:self.detailType] forState:UIControlStateNormal];
    headView.delegate = self;
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.detailType == UserDetailTypeSelf ? 0.01 : 80;
}

#pragma mark - PSAlertViewDelegate

- (void)alertViewDidTouchConformButton:(UIButton *)button
{
    EMError *error;
    BOOL success = [[[EaseMob sharedInstance] chatManager] addBuddy:self.buddy.easemob message:self.alertView.messageTextField.text error:&error];
    if (success && !error)
    {
        [self showtips:@"已发送请求，等待对方接受"];
    }
    else
    {
        [self showtips:@"请求失败了，请再试一次"];
    }
    [self.alertView dismiss];
}


#pragma mark - PSButtonFooterDelegate
- (void)buttonFooterDidTouchButton:(UIButton *)button
{
    if (self.detailType == UserDetailTypeFriend)
    {
        UIViewController *backViewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
        if ([backViewController isKindOfClass:[ChatViewController class]])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            ChatViewController *vc = [[ChatViewController alloc]initWithChatter:self.buddy.easemob];
            [self.navigationController popToRootViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:PUSH_TO_VIEWCONTROLLER_NOTIFICATION object:vc];
        }
        return;
    }
    
    if (self.detailType == UserDetailTypeStranger)
    {
        [self.alertView showToView:self.navigationController.view];
        return;
    }
    
    if (self.detailType == UserDetailTypeBeenInvited)
    {
        EMError *error;
        [[EaseMob sharedInstance].chatManager acceptBuddyRequest:self.buddy.easemob error:&error];
        if (!error) {
            [self.model addFriend:self.buddy.easemob withMessage:nil];
        }
        else
        {
            [self showtips:@"接受请求失败"];
        }

        return;
    }
}

#pragma mark - event response
- (IBAction)touchBackButton:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Notification
- (void)receivedNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:ADD_FRIEND_NOTIFICATION])
    {
        [self hideHUD];
        if ([self.delegate respondsToSelector:@selector(didAccpetRequestFromBuddy:)])
        {
            [self.delegate didAccpetRequestFromBuddy:self.buddy];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:[RemarkViewController description]])
    {
        RemarkViewController *vc = segue.destinationViewController;
        vc.buddy = self.buddy;
        return;
    }
    
    if ([segue.identifier isEqualToString:[ShopDetailViewController description]])
    {
        ShopDetailViewController *vc = segue.destinationViewController;
        vc.shop = sender;
        return;
    }
}


- (NSString *)titleWithDetailType:(UserDetailType)type
{
    switch (type)
    {
        case UserDetailTypeFriend:      return @"发消息";
        case UserDetailTypeStranger:    return @"加为好友";
        case UserDetailTypeBeenInvited: return @"接受好友申请";
        case UserDetailTypeSelf:    return nil;
    }
}

#pragma mark - Getter and setter
- (UserDetailModel *)model
{
    if (!_model) {
        _model = [UserDetailModel new];
    }
    return _model;
}

- (PSAlertView *)alertView
{
    if (!_alertView)
    {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:[PSAlertView description] owner:nil options:nil];
        _alertView = [views firstObject];
        _alertView.delegate = self;
    }
    return _alertView;
}

- (void)setBuddy:(Buddy *)buddy
{
    for (Friend *f in [UserInfo info].friends)
    {
        if ([f.friends_easemob isEqualToString:buddy.easemob])
        {
            buddy.remarkname = f.remarkname;
            break;
        }
    }
    _buddy = buddy;
}
@end
