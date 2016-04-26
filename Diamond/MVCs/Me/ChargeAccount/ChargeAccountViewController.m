//
//  ChargeAccountViewController.m
//  Diamond
//
//  Created by Pan on 15/9/30.
//  Copyright © 2015年 Pan. All rights reserved.
//

#import "ChargeAccountViewController.h"

@interface ChargeAccountViewController ()
@property (weak, nonatomic) IBOutlet UIButton *wechatAccountButton;
@property (weak, nonatomic) IBOutlet UITextField *wechatTextField;
@property (weak, nonatomic) IBOutlet UITextField *alipayTextField;
@property (weak, nonatomic) IBOutlet UITextField *realNameField;


- (IBAction)touchFinishButton:(UIBarButtonItem *)sender;
- (IBAction)touchGetWechatAccountButton:(id)sender;

@property (strong, nonatomic) NSString *openID;
@property (strong, nonatomic) NSString *AlipayAccount;


@end

@implementation ChargeAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftBarButtonItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (BOOL)isFillTextField
{
    return ( !IS_NULL(self.wechatTextField.text));
}

-(BOOL)isFillAliTextField
{
    return (!IS_NULL(self.alipayTextField.text)
            || !IS_NULL(self.realNameField.text));
}

- (IBAction)touchFinishButton:(UIBarButtonItem *)sender
{
    if ([self isFillTextField])
    {
        //TODO:给openID赋值
        NSAssert([self.delegate respondsToSelector:@selector(conformWechatAccount:alipayAccount:)], @"必须实现ChargeAccountViewControllerDelegate");
        [self.delegate conformWechatAccount:self.openID alipayAccount:self.alipayTextField.text];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self showtips:@"至少填一个收款账号哦"];
    }
}

- (void)updateUI
{
    self.wechatTextField.text = self.openID;
    self.alipayTextField.text = self.AlipayAccount;
}

#pragma mark - Public
- (void)setupWithwechatAccount:(NSString *)wechatAccount alipay:(NSString *)alipay
{
    self.openID = wechatAccount;
    self.AlipayAccount = alipay;
    [self updateUI];
}


#pragma mark - IBAction

- (IBAction)touchGetWechatAccountButton:(id)sender
{
    [self showHUDWithTitle:@"获取微信支付账号中..."];
    [ShareSDK getUserInfoWithType:ShareTypeWeixiSession authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error)
    {
        if (result)
        {
            [self hideHUD];
            self.openID = [userInfo uid];
            self.wechatTextField.text = self.openID;
        }
        else
        {
            [self showtips:@"获取微信账号失败，请重新授权"];
        }
    }];
    
}
@end
