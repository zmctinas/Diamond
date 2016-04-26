//
//  NewPasswordByPhoneViewController.m
//  Diamond
//
//  Created by Leon Hu on 15/7/20.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "RePasswordByPhoneViewController.h"
#import "RePasswordByPhoneModel.h"

@interface RePasswordByPhoneViewController ()

@property (weak, nonatomic) IBOutlet UITextField *changedPasswordTextField;

- (IBAction)touchBackButton:(UIButton *)sender;
- (IBAction)touchEditButton:(UIButton *)sender;

@property (nonatomic,strong) RePasswordByPhoneModel *model;

@end

@implementation RePasswordByPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    [self addObserverForNotifications:@[CHANGE_PASSWORD_NOTIFICATION]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (BOOL)isEmpty
{
    BOOL ret = NO;
    NSString *password = self.changedPasswordTextField.text;
    
    if (password.length<1)
    {
        ret = YES;
        DLog(@"密码不能为空");
    }
    
    return ret;
}

- (IBAction)touchBackButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchEditButton:(UIButton *)sender
{
    [self.model changePassword:self.changedPasswordTextField.text phone:self.phone];
}

- (void)receivedNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:CHANGE_PASSWORD_NOTIFICATION])
    {
        [self showtips:notification.object];
        
        UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3];
        [self.navigationController popToViewController:vc animated:YES];
    }
}

- (RePasswordByPhoneModel *)model
{
    if (!_model)
    {
        _model = [[RePasswordByPhoneModel alloc] init];
    }
    return _model;
}

@end
