//
//  RemarkViewController.m
//  Diamond
//
//  Created by Pan on 15/7/27.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "RemarkViewController.h"
#import "WebService+Chat.h"
#import "Friend.h"
#import "EaseMob.h"

@interface RemarkViewController ()
@property (nonatomic, strong) WebService *webService;

@property (nonatomic, weak) IBOutlet UITextField *remarkNameLabel;
@property (nonatomic, weak) IBOutlet UIButton *conformButton;

- (IBAction)touchConformButton:(UIButton *)sender;
@end

@implementation RemarkViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addLeftBarButtonItem];
}

- (IBAction)touchConformButton:(UIButton *)sender
{
    if (IS_NULL(self.remarkNameLabel))
    {
        return;
    }
    
    [self.webService updateRemarkName:self.remarkNameLabel.text friend:self.buddy.easemob myEaseMobID:[UserSession sharedInstance].currentUser.easemob completion:^(BOOL isSuccess, NSString *message, id result) {
        if (isSuccess && !message)
        {
            //修改本地数据库中的好友信息
            self.buddy.remarkname = self.remarkNameLabel.text;
            Friend *fr = [[UserInfo info] FriendWitheasemob:self.buddy.easemob];
            fr.remarkname = self.buddy.remarkname;
            [[UserInfo info] updateFriend:fr];
            
            //修改环信体系数据库中的好友信息
            NSArray *conversastions = [[[EaseMob sharedInstance] chatManager] conversations];
            for (EMConversation *cv in conversastions)
            {
                if ([cv.chatter isEqualToString:self.buddy.easemob])
                {
                    Friend *friend = [cv.ext objectForKey:FRIEND];
                    if (friend)
                    {
                        friend.remarkname = self.buddy.remarkname;
                        cv.ext = [NSDictionary dictionaryWithObjectsAndKeys:friend,FRIEND, nil];
                        [[[EaseMob sharedInstance] chatManager] insertConversationToDB:cv append2Chat:YES];
                    }
                    break;
                }
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self showtips:@"备注失败"];
        }

    }];
}

- (WebService *)webService
{
    if (!_webService)
    {
        _webService = [WebService service];
    }
    return _webService;
}
@end
