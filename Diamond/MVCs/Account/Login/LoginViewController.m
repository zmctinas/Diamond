//
//  LoginViewController.m
//  Diamond
//
//  Created by Pan on 15/7/11.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginModel.h"
#import "EMError.h"
#import "CurrentUser.h"
#import "MyShopModel.h"
#import <ShareSDK/ShareSDK.h>
#import "AppDelegate.h"
#import "WXApi.h"
#import "PSShareSDKManager.h"


#define QQ_URL  @"mqq://"
#define WEIXIN_URL @"weixin://"


@interface LoginViewController ()<IChatManagerDelegate,UITextFieldDelegate,WXApiDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet UIButton *weixinButton;
@property (weak, nonatomic) IBOutlet UIButton *qqButton;
@property (weak, nonatomic) IBOutlet UILabel *weixinLabel;
@property (weak, nonatomic) IBOutlet UILabel *qqLabel;

@property (weak, nonatomic) IBOutlet UIView *qqAndWeixinView;

- (IBAction)touchLoginButton:(UIButton *)sender;
- (IBAction)touchWeixinLoginButton:(UIButton *)sender;
- (IBAction)touchQQLoginButton:(UIButton *)sender;
- (IBAction)touchBackButton:(UIButton *)sender;

@property (nonatomic, strong) LoginModel *model;
@property (nonatomic, strong) MyShopModel *myShopModel;

@end

@implementation LoginViewController

#pragma mark - Lify Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupForDismissKeyboard];
    
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    [self addObserverForNotifications:@[LOGIN_NOTIFICATION,WCHAT_LOGIN,QQ_LOGIN]];
    [self hideQQAndWeixinButtonIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self addObserverForNotifications:@[WeiXinCodeGetted]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WeiXinCodeGetted object:nil];
}


- (void)hideQQAndWeixinButtonIfNeeded
{
    BOOL hiddenQQ = ![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:QQ_URL]];
    BOOL hiddenWeixin = ![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:WEIXIN_URL]];
    self.weixinLabel.hidden = hiddenWeixin;
    self.weixinButton.hidden = hiddenWeixin;
    self.qqLabel.hidden = hiddenQQ;
    self.qqButton.hidden = hiddenQQ;
    self.qqAndWeixinView.hidden = hiddenQQ && hiddenWeixin;
}
#pragma mark - private method

/**
 *  账号密码是否为空
 */
- (BOOL)isEmpty
{
    BOOL ret = NO;
    NSString *username = _usernameTextField.text;
    NSString *password = _passwordTextField.text;
    if (username.length == 0 || password.length == 0)
    {
        ret = YES;
        DLog(@"密码不能为空");
    }
    
    return ret;
}



#pragma  mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _usernameTextField)
    {
        _passwordTextField.text = @"";
    }
    return YES;
}

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma  mark - UIAlertViewDelegate

//弹出提示的代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView cancelButtonIndex] != buttonIndex)
    {
        //获取文本输入框
        UITextField *nameTextField = [alertView textFieldAtIndex:0];
        if(nameTextField.text.length > 0)
        {
            //设置推送设置
            [[EaseMob sharedInstance].chatManager setApnsNickname:nameTextField.text];
        }
    }
    //登陆
    [self showtips:@"Is to register..."];
    [self.model registerEaseMobAccountWithUsername:self.usernameTextField.text password:self.passwordTextField.text];
}


#pragma mark - Event Response

/**
 *  登陆
 *
 *  @param sender 登陆按钮
 */
- (IBAction)touchLoginButton:(UIButton *)sender
{
    if (![self isEmpty])
    {
        NSString *userName = self.usernameTextField.text;
        NSString *password = self.passwordTextField.text;
//        NSString *userName = @"13282008052";
//        NSString *password = @"369079363";
        [self.view endEditing:YES];
        //支持是否为中文
        if ([userName isChinese])
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"请输入英文"
                                  message:nil
                                  delegate:nil
                                  cancelButtonTitle:@"好"
                                  otherButtonTitles:nil];
            
            [alert show];
            
            return;
        }
        
        [self showHUDWithTitle:@"正在登录..."];
        [self.model login:userName password:password];
    }
}

-(void)sendWeixinAuthRequest
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc]init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}


- (IBAction)touchWeixinLoginButton:(UIButton *)sender
{
    //服务器需要原始的Code  所以这里另作处理。
    [self sendWeixinAuthRequest];
//    [ShareSDK getUserInfoWithType:ShareTypeWeixiSession authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
//        NSLog(@"%d",result);
//        if (result) {
//            //成功登录后，判断该用户的ID是否在自己的数据库中。
//            //如果有直接登录，没有就将该用户的ID和相关资料在数据库中创建新用户。
//            [self reloadStateWithType:ShareTypeWeixiSession userInfo:userInfo];
//        }
//    }];
}

- (IBAction)touchQQLoginButton:(UIButton *)sender
{
    [ShareSDK getUserInfoWithType:ShareTypeQQSpace authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        NSLog(@"%d",result);
        if (result) {
            //成功登录后，判断该用户的ID是否在自己的数据库中。
            //如果有直接登录，没有就将该用户的ID和相关资料在数据库中创建新用户。
            [self reloadStateWithType:ShareTypeQQSpace userInfo:userInfo];
        } 
    }];
}

- (IBAction)touchBackButton:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)reloadStateWithType:(ShareType)type userInfo:(id<ISSPlatformUser>)userInfo
{
    [UserSession sharedInstance].loginType = type;
    //现实授权信息，包括授权ID、授权有效期等。
    //此处可以在用户进入应用的时候直接调用，如授权信息不为空且不过期可帮用户自动实现登录。
    id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:type];
                                                  NSString *message = [NSString stringWithFormat:
                                                                     @"uid = %@\ntoken = %@\nsecret = %@\n expired = %@\nextInfo = %@",
                                                                     [credential uid],
                                                                     [credential token],
                                                                     [credential secret],
                                                                     [credential expired],
                                                                       [credential extInfo]];
    DLog(@"%@",message);
    
    switch (type) {
        case ShareTypeQQSpace:
        {
            Sex sex = [userInfo gender] ? SexFeMale : SexMale;
            [self.model loginByQQ:[credential uid] photo:[userInfo profileImage] username:[userInfo nickname] sex:sex];
        }
            break;
        case ShareTypeWeixiSession:
        {
            NSString *code = [PSShareSDKManager sharedInstance].weixinCode;
            if (!IS_NULL(code))
            {
                [self.model loginByWeixin:code];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - Notification

- (void)receivedNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:LOGIN_NOTIFICATION]
        || [notification.name isEqualToString:WCHAT_LOGIN]
        || [notification.name isEqualToString:QQ_LOGIN])
    {
        [self hideHUD];
        //登陆服务器成功后 登陆一下环信
        [self.model loginEaseMobWithUsername:[UserInfo info].currentUser.easemob password:[UserInfo info].currentUser.password];

        [self dismissViewControllerAnimated:true completion:nil];
        
        [ValidationManager setLoginStatus:YES];
    }else if ([notification.name isEqualToString:FIRST_WCHAT_LOGIN_NOTIFIATION]){
        
    }else if ([notification.name isEqualToString:FIRST_QQ_LOGIN_NOTIFIATION]){
        
    } else if ([notification.name isEqualToString:WeiXinCodeGetted]) {
        [self reloadStateWithType:ShareTypeWeixiSession userInfo:nil];

    }
}

#pragma mark - Getter and setter
- (LoginModel *)model
{
    if (!_model)
    {
        _model = [[LoginModel alloc]init];
    }
    return _model;
}

@end
