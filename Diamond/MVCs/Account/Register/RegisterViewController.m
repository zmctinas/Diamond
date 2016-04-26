//
//  RegisterViewController.m
//  Diamond
//
//  Created by Leon Hu on 15/7/14.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterModel.h"
#import "VCodeModel.h"
#import "EMError.h"
#import "UIImage+Scale.h"
#import "LoginModel.h"
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CoreAnimation.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface RegisterViewController() <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *vCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;

- (IBAction)touchRegisterButton:(UIButton *)sender;
- (IBAction)touchGetCodeButton:(UIButton *)sender;
- (IBAction)touchBackButton:(UIButton *)sender;
- (IBAction)touchPhotoButton:(UIButton *)sender;

@property (nonatomic,copy) NSString *lastChosenMediaType;
@property (nonatomic,strong) RegisterModel *model;
@property (nonatomic,strong) VCodeModel *vCodeModel;
@property (nonatomic,strong) LoginModel *loginModel;
@property (nonatomic,strong) NSString *code;

@property (nonatomic) BOOL isChangePhoto;

@end

@implementation RegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupForDismissKeyboard];
    self.navigationController.navigationBarHidden = YES;
    //变更头像标记,初始化为未变更
    self.isChangePhoto = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addObserverForNotifications:@[SEND_CODE_NOTIFICATION,TIMER_NOTIFICATION,REGISTER_NOTIFICATION,LOGIN_NOTIFICATION]];
}

#pragma mark - Event Response

- (IBAction)touchRegisterButton:(UIButton *)sender
{
    NSString *msg = [self isEmpty];
    if (!msg)
    {
        if ([self.code isEqualToString:self.vCodeTextField.text]) {
            [self.view endEditing:YES];
            NSString *nick = self.usernameTextField.text;
            NSString *phone = self.mobileTextField.text;
            NSString *password = self.passwordTextField.text;
            UIImage *image = nil;
            if (self.isChangePhoto) {
                image = [self.photoButton.imageView.image transformWidth:255 height:255];
            }
            [self showHUDWithTitle:@"正在注册，请稍后..."];
            [self.model registerByMobile:phone nickName:nick password:password image:image];
        }else{
            [self showtips:@"验证码错误"];
        }
    }else{
        [self showtips:msg];
    }
}

- (IBAction)touchGetCodeButton:(UIButton *)sender {
    NSString *errorTips = [self isEmpty];
    if (IS_NULL(errorTips)) {
        [self.vCodeModel sendTo:self.mobileTextField.text forget:0];
    }else{
        [self showtips:errorTips];
    }
    
}

- (IBAction)touchBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchPhotoButton:(UIButton *)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                             delegate:self
                                    cancelButtonTitle:@"取消"
                               destructiveButtonTitle:nil
                                    otherButtonTitles:@"拍照", @"相册中选取照片", nil];
    [sheet showInView:self.view];
}

#pragma mark - private method

/**
 *  账号密码是否为空
 */
- (NSString *)isEmpty
{
//    NSString *username = self.usernameTextField.text;
    NSString *mobile = self.mobileTextField.text;
    NSString *password = self.passwordTextField.text;
//    if (username.length < 1 )
//    {
//        return @"昵称不能为空";
//    }
    if (mobile.length < 1 )
    {
        return @"手机号不能为空";
    }
    if (password.length < 1)
    {
        return @"密码不能为空";
    }
    
    return nil;
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
        NSString *str = notification.object;
        NSInteger second = str.integerValue;
        
        if (second <= 0) {
            [self.getCodeButton setEnabled:YES];
            [self.getCodeButton setBackgroundColor:UIColorFromRGB(GLOBAL_TINTCOLOR)];
            [self.getCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
        }else{
            [self.getCodeButton setEnabled:NO];
            [self.getCodeButton setBackgroundColor:UIColorFromRGB(LIGHT_GRAY)];
            [self.getCodeButton setTitle:[NSString stringWithFormat:@"%ld",(long)second] forState:UIControlStateNormal];
        }
    }else if ([notification.name isEqualToString:REGISTER_NOTIFICATION])
    {
        RegisterEntity *entity = notification.object;
        UserEntity *userEntity = [[UserEntity alloc] init];
        userEntity.easemob = entity.easemob;
        userEntity.phoneNumber = entity.phoneNumber;
        userEntity.user_name = entity.userName;
        userEntity.photo = entity.photo;
        userEntity.shop_id = entity.shopId;
        userEntity.signature = entity.signature;
        userEntity.password = entity.password;
        [[UserSession sharedInstance] setCurrentUser:userEntity];
        [self.loginModel login:self.mobileTextField.text password:self.passwordTextField.text];
        return;
    }
    if ([notification.name isEqualToString:LOGIN_NOTIFICATION])
    {
        [self hideHUD];
        //登陆服务器成功后 登陆一下环信
        [self.loginModel loginEaseMobWithUsername:[UserInfo info].currentUser.easemob password:[UserInfo info].currentUser.password];
        
        [self dismissViewControllerAnimated:true completion:nil];
        
        [ValidationManager setLoginStatus:YES];
    }
}

#pragma mark -

#pragma 拍照选择模块
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self shootPiicturePrVideo];
            break;
        case 1:
            [self selectExistingPictureOrVideo];
            break;
        default:
            break;
    }
}
#pragma  mark- 拍照模块
//从相机上选择
-(void)shootPiicturePrVideo{
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}
//从相册中选择
-(void)selectExistingPictureOrVideo{
    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}
#pragma 拍照模块
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.lastChosenMediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if([self.lastChosenMediaType isEqual:(NSString *) kUTTypeImage])
    {
        UIImage *chosenImage=[info objectForKey:UIImagePickerControllerEditedImage];
        //设置图片
        [self.photoButton setImage:chosenImage forState:UIControlStateNormal];
        self.photoButton.layer.cornerRadius = self.photoButton.frame.size.width/2;
        self.photoButton.clipsToBounds = YES;
        //图片已发生变更的标记
        self.isChangePhoto = YES;
    }
    if([self.lastChosenMediaType isEqual:(NSString *) kUTTypeMovie])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示信息!" message:@"系统只支持图片格式" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if([UIImagePickerController isSourceTypeAvailable:sourceType] &&[mediatypes count]>0){
        NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.mediaTypes=mediatypes;
        picker.delegate=self;
        picker.allowsEditing=YES;
        picker.sourceType=sourceType;
        NSString *requiredmediatype=(NSString *)kUTTypeImage;
        NSArray *arrmediatypes=[NSArray arrayWithObject:requiredmediatype];
        [picker setMediaTypes:arrmediatypes];
        [self presentViewController:picker animated:YES completion:nil];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误信息!" message:@"当前设备不支持拍摄功能" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark - Getter and setter

- (RegisterModel *)model
{
    if (!_model) {
        _model = [[RegisterModel alloc] init];
    }
    return _model;
}

- (VCodeModel *)vCodeModel
{
    if (!_vCodeModel) {
        _vCodeModel = [[VCodeModel alloc] init];
    }
    return _vCodeModel;
}

- (LoginModel *)loginModel
{
    if (!_loginModel)
    {
        _loginModel = [[LoginModel alloc] init];
    }
    return _loginModel;
}

@end
