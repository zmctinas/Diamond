//
//  SettingViewController.m
//  Diamond
//
//  Created by Leon Hu on 15/7/26.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "SettingViewController.h"
#import "UserInfo.h"
#import "SettingEntiy.h"
#import "UserSession.h"
#import "ShopSession.h"
@interface SettingViewController ()

@property (weak ,nonatomic) IBOutlet UISwitch *receiveNewMessageSwitch;/**< 接收新消息开关*/
@property (weak ,nonatomic) IBOutlet UISwitch *voiceSwitch;/**< 声音开关*/
@property (weak ,nonatomic) IBOutlet UISwitch *vibrationSwitch;/**< 震动开关*/
@property (weak ,nonatomic) IBOutlet UISwitch *speakerSwitch;/**< 扬声器开关开关*/
@property (weak ,nonatomic) IBOutlet UISwitch *friendsVerifySwitch;/**< 好友验证开关*/


- (IBAction)touchReceiveNewMessageSwitch:(UISwitch *)sender;/**< 接收新消息开关*/
- (IBAction)touchVoiceSwitch:(UISwitch *)sender;/**< 声音开关*/
- (IBAction)touchVibrationSwitch:(UISwitch *)sender;/**< 震动开关*/
- (IBAction)touchSpeakerSwitch:(id)sender;/**< 扬声器*/
- (IBAction)touchFriendsVerifySwitch:(UISwitch *)sender;/**< 好友验证*/
- (IBAction)touchClearCacheButton:(UIButton *)sender;/**< 清除缓存*/
- (IBAction)touchLogoutButton:(UIButton *)sender;/**< 退出登录*/


@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self addLeftBarButtonItem];
    [self setup];
    self.title = @"设置";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


#pragma mark - Private
- (void)setup
{
    self.receiveNewMessageSwitch.on = [SettingEntiy sharedInstance].receiveNewMessageSwitch;
    self.vibrationSwitch.on = [SettingEntiy sharedInstance].vibrationSwitch;
    self.voiceSwitch.on = [SettingEntiy sharedInstance].voiceSwitch;
    self.speakerSwitch.on = [SettingEntiy sharedInstance].speakerSwitch;
    self.friendsVerifySwitch.on = [SettingEntiy sharedInstance].friendsVerifySwitch;
}



#pragma mark - Event Response

- (IBAction)touchReceiveNewMessageSwitch:(UISwitch *)sender
{
    [SettingEntiy sharedInstance].receiveNewMessageSwitch = sender.isOn;
    [[SettingEntiy sharedInstance] synchronize];
}

- (IBAction)touchVoiceSwitch:(UISwitch *)sender
{
    [SettingEntiy sharedInstance].voiceSwitch = sender.isOn;
    [[SettingEntiy sharedInstance] synchronize];

}

- (IBAction)touchVibrationSwitch:(UISwitch *)sender
{
    [SettingEntiy sharedInstance].vibrationSwitch = sender.isOn;
    [[SettingEntiy sharedInstance] synchronize];
}

- (IBAction)touchSpeakerSwitch:(UISwitch *)sender
{
    [SettingEntiy sharedInstance].speakerSwitch = sender.isOn;
    [[SettingEntiy sharedInstance] synchronize];

}

- (IBAction)touchFriendsVerifySwitch:(UISwitch *)sender
{
    [SettingEntiy sharedInstance].friendsVerifySwitch = sender.isOn;
    [[SettingEntiy sharedInstance] synchronize];

}

- (IBAction)touchClearCacheButton:(UIButton *)sender
{
//    [[UserInfo info] clear];
    [self showtips:@"清除缓存成功！"];
}

- (IBAction)touchLogoutButton:(UIButton *)sender
{
    ShareType loginType = [UserSession sharedInstance].loginType;
    if (loginType == ShareTypeQQSpace)
    {
        [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
    }else if (loginType == ShareTypeWeixiSession){
        [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
    }
    
    [[UserSession sharedInstance] resetUser];
    [[ShopSession sharedInstance] resetShop];
    [[UserInfo info] clear];
    [ValidationManager setLoginStatus:NO];
    EMError *error;
    //退出环信
    [[EaseMob sharedInstance].chatManager logoffWithUnbindDeviceToken:NO error:&error];

    //跳回到主页
    [self.tabBarController setSelectedIndex:0];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
