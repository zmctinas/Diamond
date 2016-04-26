//
//  AuthenticationViewController.m
//  Diamond
//
//  Created by Leon Hu on 15/8/10.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "AuthenticationViewController.h"
#import "EMError.h"
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CoreAnimation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "MyShopModel.h"
#import "LicenseImageEntity.h"
#import "ImageEntity.h"
#import "UIImage+Scale.h"
#import "Util.h"
#import "ShopLicenseEntity.h"
#import "UIButton+WebCache.h"
#import "UIViewController+DismissKeyboard.h"
#import "UIButton+Category.h"

typedef NS_ENUM(NSInteger, LicenseInputModel)
{
    LicenseInputNEW = 0,/**< 新增*/
    LicenseInputEDIT = 1,/**< 编辑*/
};

@interface AuthenticationViewController()

@property (nonatomic,strong) UIActionSheet *sheet;
@property (weak, nonatomic) IBOutlet UITextField *sellerNameTextField;
//@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *homeTextField;
@property (weak, nonatomic) IBOutlet UITextField *idCardTextField;
@property (weak, nonatomic) IBOutlet UIButton *idCardButton;
@property (weak, nonatomic) IBOutlet UIButton *idCardBackButton;
@property (weak, nonatomic) IBOutlet UIButton *businessLicenseButton;
@property (weak, nonatomic) IBOutlet UIButton *healthLicenseButton;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *photoButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *deletePhotoButtons;

- (IBAction)touchPhotoButton:(UIButton *)sender;
- (IBAction)touchDeletePhotoButton:(UIButton *)sender;
- (IBAction)touchOkButton:(UIBarButtonItem *)sender;

@property (nonatomic,strong) UIButton *buttonWhichIsTouched;
@property (nonatomic,copy) NSString *lastChosenMediaType;
@property (nonatomic,strong) MyShopModel *model;
/**
 *  本页数据是否为新增
 */
@property (nonatomic) LicenseInputModel inputType;

@end

@implementation AuthenticationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupForDismissKeyboard];
    [self addLeftBarButtonItem];
    [self addObserverForNotifications:@[
                                        GET_LICENSE,
                                        UP_LICENSE,
                                        UPDATE_LICENSE
                                        ]];
    self.inputType = LicenseInputNEW;
    
    self.sellerNameTextField.delegate = self;
//    self.phoneTextField.delegate = self;
    self.homeTextField.delegate = self;
    self.idCardTextField.delegate = self;
    
    NSString *easemob = [[UserSession sharedInstance] currentUser].easemob;
    if(easemob.length>0){
        [self showHUDWithTitle:@"获取认证相关数据..."];
        [self.model getLicense:easemob];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)touchPhotoButton:(UIButton *)sender {
    self.buttonWhichIsTouched = sender;
    self.sheet = [[UIActionSheet alloc] initWithTitle:nil
                                             delegate:self
                                    cancelButtonTitle:@"取消"
                               destructiveButtonTitle:nil
                                    otherButtonTitles:@"拍照", @"相册中选取照片", nil];
    [self.sheet showInView:self.view];
}

- (IBAction)touchDeletePhotoButton:(UIButton *)sender {
    for (UIButton *button in self.photoButtons) {
        if (button.tag == sender.tag) {
            [button setImage:nil forState:UIControlStateNormal];
            [sender setHidden:YES];
            break;
        }
    }
}

- (IBAction)touchOkButton:(UIBarButtonItem *)sender
{
    [self showHUDWithTitle:@"正在保存..."];
    
    UpLicenseEntity *entity = [[UpLicenseEntity alloc] init];
    entity.easemob = [[UserSession sharedInstance] currentUser].easemob;
    entity.name = self.sellerNameTextField.text;
//    entity.phoneNumber = self.phoneTextField.text;
    entity.address = self.homeTextField.text;
    entity.idNumber = self.idCardTextField.text;
    
    if (entity.name.length<1) {
        [self showtips:@"商家名称不能为空."];
        return;
    }
//    if (entity.phoneNumber.length<1) {
//        [self showtips:@"手机号不能为空."];
//        return;
//    }
    if (entity.address.length<1) {
        [self showtips:@"商家地址不能为空."];
        return;
    }
    if (entity.idNumber.length<1) {
        [self showtips:@"身份证号码不能为空."];
        return;
    }
    
    LicenseImageEntity *licenseImageEntity = [[LicenseImageEntity alloc] init];
    if ([self.idCardButton currentImage])
    {
        licenseImageEntity.idCard_A = [ImageEntity createWithImage:[self.idCardButton currentImage]];
    }else{
        [self showtips:@"需要身份证正面照片哦."];
        return;
    }
    if ([self.idCardBackButton currentImage]) {
        licenseImageEntity.idCard_B = [ImageEntity createWithImage:[self.idCardBackButton currentImage]];
    }else{
        [self showtips:@"需要身份证反面照片哦."];
        return;
    }
    if ([self.businessLicenseButton currentImage]) {
        licenseImageEntity.businessLicense = [ImageEntity createWithImage:[self.businessLicenseButton currentImage]];
    }else{
        [self showtips:@"需要营业证照片哦."];
        return;
    }
    if ([self.healthLicenseButton currentImage]) {
        licenseImageEntity.healthLicense = [ImageEntity createWithImage:[self.healthLicenseButton currentImage]];
    }
    entity.images = @[
                       licenseImageEntity
                       ];
    
    if (self.inputType == LicenseInputNEW) {
        [self.model upLicense:entity];
    }else{
        [self.model editLicense:entity];
    }
}

- (void)receivedNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:GET_LICENSE]) {
        ShopLicenseEntity *entity = notification.object;
        [self.sellerNameTextField setText:entity.name];
//        [self.phoneTextField setText:entity.phoneNumber];
        [self.homeTextField setText:entity.address];
        [self.idCardTextField setText:entity.idNumber];
        NSURL *imageIdCardA = [Util urlWithPath:entity.idCard_A];
        NSURL *imageIdCardB = [Util urlWithPath:entity.idCard_B];
        NSURL *imageBusinessLicense = [Util urlWithPath:entity.businessLicense];
        NSURL *imageHealthLicense = [Util urlWithPath:entity.healthLicense];
        //先加载默认图片
        [self.idCardButton setDefaultLoadingImage];
        [self.idCardBackButton setDefaultLoadingImage];
        [self.businessLicenseButton setDefaultLoadingImage];
        [self.healthLicenseButton setDefaultLoadingImage];
        
        [self.idCardButton sd_setImageWithURL:imageIdCardA forState:UIControlStateNormal];
        [self.idCardBackButton sd_setImageWithURL:imageIdCardB forState:UIControlStateNormal];
        [self.businessLicenseButton sd_setImageWithURL:imageBusinessLicense forState:UIControlStateNormal];
        [self.healthLicenseButton sd_setImageWithURL:imageHealthLicense forState:UIControlStateNormal];
        
        self.inputType = LicenseInputEDIT;
    }else if ([notification.name isEqualToString:UP_LICENSE]) {
        [self showtips:@"保存成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([notification.name isEqualToString:UPDATE_LICENSE])
    {
        [self showtips:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self hideHUD];
}

#pragma mark - TextDelegate

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

#pragma 拍照选择模块
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button %ld", (long)buttonIndex);
    if(buttonIndex==0)
        [self shootPiicturePrVideo];
    else if(buttonIndex==1)
        [self selectExistingPictureOrVideo];
}

#pragma  mark- 拍照模块
//从相机上选择
-(void)shootPiicturePrVideo{
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}

//从相册中选择
- (void)selectExistingPictureOrVideo{
    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma 拍照模块
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.lastChosenMediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if([self.lastChosenMediaType isEqual:(NSString *) kUTTypeImage])
    {
        UIImage *chosenImage=[info objectForKey:UIImagePickerControllerEditedImage];
        //设置图片
        [self.buttonWhichIsTouched setImage:chosenImage forState:UIControlStateNormal];
    }
    if([self.lastChosenMediaType isEqual:(NSString *) kUTTypeMovie])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示信息!" message:@"系统只支持图片格式" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if([UIImagePickerController isSourceTypeAvailable:sourceType] && [mediatypes count] > 0)
    {
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
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误信息!" message:@"当前设备不支持拍摄功能" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
}

- (MyShopModel *)model
{
    if (!_model) {
        _model = [[MyShopModel alloc] init];
    }
    return _model;
}

@end
