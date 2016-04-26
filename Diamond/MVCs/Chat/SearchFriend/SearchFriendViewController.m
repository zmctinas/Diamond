//
//  SearchFriendViewController.m
//  Diamond
//
//  Created by Pan on 15/7/21.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "SearchFriendViewController.h"
#import "UserDetailViewController.h"
#import "SearchFriendModel.h"
#import "UIImageView+WebCache.h"
#import "QRCodeGenerator.h"
#import "UIViewController+DismissKeyboard.h"

@interface SearchFriendViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headPhotoView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *identifierTextView;
@property (weak, nonatomic) IBOutlet UIImageView *QRcodeView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *conformButton;

@property (nonatomic, strong) SearchFriendModel *model;


- (IBAction)touchConformButton:(UIButton *)sender;

@end

@implementation SearchFriendViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addLeftBarButtonItem];
    [self setup];
    [self setupForDismissKeyboard];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addObserverForNotifications:@[SEARCH_FRIEND_NOTIFICATION]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - private method
- (void)setup
{
    UserEntity *currentUser = [UserSession sharedInstance].currentUser;
    [self.headPhotoView sd_setImageWithURL:[NSURL URLWithString:currentUser.photo] placeholderImage:[UIImage imageNamed:@"chatListCellHead"]];
    [self.nameLabel setText:currentUser.user_name];
    self.identifierTextView.text = currentUser.easemob;
    [self.QRcodeView setImage:[QRCodeGenerator qrImageForString:currentUser.easemob imageSize:CGRectGetWidth(self.QRcodeView.frame) + 10]];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

#pragma mark - Notification

- (void)receivedNotification:(NSNotification *)notification
{
    DLog(@"received notification");
    [self hideHUD];
    if ([notification.name isEqualToString:SEARCH_FRIEND_NOTIFICATION])
    {
        if (self.model.buddy)
        {
            [self performSegueWithIdentifier:[UserDetailViewController description] sender:nil];
        }
    }
}


#pragma mark - Event Respones

- (IBAction)touchConformButton:(UIButton *)sender
{
    if (IS_NULL(self.searchTextField.text))
    {
        [self showtips:@"请先输入手机号码或代忙号"];
        return;
    }
    [self showHUDWithTitle:@"搜索中..."];
    self.model.buddy = nil;
    [self.model searchBuddyWithPhone:self.searchTextField.text];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:[UserDetailViewController description]])
    {
        UserDetailViewController *vc = segue.destinationViewController;
        vc.buddy = self.model.buddy;
        if ([self.model.buddy.easemob isEqualToString:[UserSession sharedInstance].currentUser.easemob])
        {
            vc.detailType = UserDetailTypeSelf;
        }
        else
        {
            vc.detailType = [self isFriend:self.model.buddy] ? UserDetailTypeFriend : UserDetailTypeStranger;
        }
        
    }
}

- (BOOL)isFriend:(Buddy *)buddy;
{
    for (Friend *f in [UserInfo info].friends) {
        if ([buddy.easemob isEqualToString:f.friends_easemob])
        {
            return YES;
        }
    }
    return NO;
}


- (SearchFriendModel *)model
{
    if (!_model)
    {
        _model = [SearchFriendModel new];
    }
    return _model;
}
@end
