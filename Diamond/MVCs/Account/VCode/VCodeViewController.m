//
//  VCodeViewController.m
//  Diamond
//
//  Created by Leon Hu on 15/7/14.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "VCodeViewController.h"
#import "VCodeModel.h"
#import "RePasswordByPhoneViewController.h"

@interface VCodeViewController()

@property (weak, nonatomic) IBOutlet UITextField *vCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;

- (IBAction)touchBackButton:(UIButton *)sender;
- (IBAction)touchSendButton:(UIButton *)sender;

@property (nonatomic,strong) NSString *code;
@property (nonatomic,strong) VCodeModel *model;
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation VCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addObserverForNotifications:@[SEND_CODE_NOTIFICATION,TIMER_NOTIFICATION]];
}

/**
 *  账号密码是否为空
 */
- (BOOL)isEmpty
{
    BOOL ret = NO;
    NSString *mobile = self.mobileTextField.text;
    
    if (mobile.length<1)
    {
        ret = YES;
        DLog(@"手机号不能为空");
    }
    else if (mobile.length < 11)
    {
        ret = YES;
        DLog(@"手机号不正确");
    }
    
    return ret;
}

- (IBAction)touchBackButton:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchSendButton:(UIButton *)sender {
    if (![self isEmpty]) {
        [self.model sendTo:self.mobileTextField.text forget:1];
    }else{
        [self showtips:@"手机号不能为空"];
    }
}

- (void)receivedNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:SEND_CODE_NOTIFICATION]) {
        [self.getCodeButton setEnabled:NO];
        [[UserSession sharedInstance] startTimer:[NSDate date]];

        //记录验证码
        VCodeEntity *entity = notification.object;
        if (entity) {
            self.code = entity.code;
        }
    }else if ([notification.name isEqualToString:TIMER_NOTIFICATION])
    {
        NSString *second = notification.object;
        if ([second isEqualToString:@"0"]) {
            [self.getCodeButton setEnabled:YES];
           [self.getCodeButton setBackgroundColor:UIColorFromRGB(GLOBAL_TINTCOLOR)];
            [self.getCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
        }else{
            [self.getCodeButton setEnabled:NO];
             [self.getCodeButton setBackgroundColor:UIColorFromRGB(LIGHT_GRAY)];
            [self.getCodeButton setTitle:second forState:UIControlStateNormal];
        }
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"toChangePasswordSegue"]) {
        //验证码正确,跳转
        if (self.code.length>0 && self.vCodeTextField.text.length>0 && [self.vCodeTextField.text isEqualToString:self.code]) {
            return YES;
        }else{
            [self showtips:@"验证码不正确"];
            return NO;
        }
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toChangePasswordSegue"]) {
        RePasswordByPhoneViewController *page = segue.destinationViewController;
        page.phone = self.mobileTextField.text;
    }
}

- (VCodeModel *)model
{
    if (!_model) {
        _model = [[VCodeModel alloc] init];
    }
    return _model;
}

@end
