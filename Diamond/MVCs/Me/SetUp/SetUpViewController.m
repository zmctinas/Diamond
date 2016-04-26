//
//  SetUpViewController.m
//  Diamond
//
//  Created by Leon Hu on 15/7/26.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "SetUpViewController.h"
#import "EMError.h"
#import "UIImage+Scale.h"
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CoreAnimation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "SetUpEntity.h"
#import "SetUpModel.h"
#import "ImageEntity.h"
#import "Util.h"
#import "SetUpSuccessViewController.h"
#import "PSLocationManager.h"
#import "ChargeAccountViewController.h"
#import "UIViewController+DismissKeyboard.h"
#import "UIColor+Hex.h"

@interface SetUpViewController ()<ChargeAccountViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *photoButton1;
@property (weak, nonatomic) IBOutlet UIButton *photoButton2;
@property (weak, nonatomic) IBOutlet UIButton *photoDeleteButton1;
@property (weak, nonatomic) IBOutlet UIButton *photoDeleteButton2;
@property (weak, nonatomic) IBOutlet UIButton *chargeAccountButton;

@property (weak, nonatomic) IBOutlet UITextField *shopNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *areaTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIButton *shopTypeTextField;
@property (weak, nonatomic) IBOutlet UITextView *shopDescriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UIToolbar *doneToolbar;

- (IBAction)touchDoneButtonInToolbar:(UIButton *)sender;
- (IBAction)touchChargeAccountButton:(UIButton *)sender;
- (IBAction)touchPhoto1Button:(UIButton *)sender;
- (IBAction)touchPhoto2Button:(UIButton *)sender;
- (IBAction)touchPhoto1DeleteButton:(UIButton *)sender;
- (IBAction)touchPhoto2DeleteButton:(UIButton *)sender;
- (IBAction)touchNextButton:(UIBarButtonItem *)sender;

@property (nonatomic,copy) NSString *lastChosenMediaType;
@property (nonatomic) NSInteger currentButtonIndex;
@property (nonatomic,strong) SetUpEntity *entity;
@property (nonatomic,strong) PSCityPickerView *cityPicker;
@property (nonatomic,strong) SetUpModel *model;
@property (nonatomic,strong) NSString *province;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *district;

@end

@implementation SetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self addLeftBarButtonItem];
    [self setupForDismissKeyboard];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    self.shopNameTextField.delegate = self;
    self.areaTextField.delegate = self;
    self.areaTextField.inputAccessoryView = self.doneToolbar;
    self.addressTextField.delegate = self;
    self.shopDescriptionTextField.delegate = self;
    self.cityPicker.cityPickerDelegate = self;
    
    self.areaTextField.inputView = self.cityPicker;
    
    [self addObserverForNotifications:@[ADD_SHOP]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearTextView) name:UITextViewTextDidBeginEditingNotification object:nil];
    self.navigationController.navigationBarHidden = NO;
    
    PSLocationManager *locationManager = [PSLocationManager sharedInstance];
    self.province = locationManager.province;
    self.city = locationManager.city;
    self.district = locationManager.district;
    
    self.cityPicker.province = locationManager.province;
    self.cityPicker.city = locationManager.city;
    self.cityPicker.district = locationManager.district;
    
    if (self.district.length>0) {
        [self.areaTextField setText:[NSString stringWithFormat:@"%@ %@ %@",self.province,self.city,self.district]];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
}


#pragma mark - ChargeAccountViewControllerDelegate
- (void)conformWechatAccount:(NSString *)openID alipayAccount:(NSString *)alipayAccount real_name:(NSString *)realName
{
    self.entity.wchat_pay = openID;
    self.entity.ali_pay = alipayAccount;
    self.entity.realName = realName;
    NSString *weixinTips = IS_NULL(openID) ? @"" : @"微信账号";
    NSString *alipayTips = IS_NULL(alipayAccount) ? @"" : @"支付宝账号";
    NSString *tips = [NSString stringWithFormat:@"已获取%@ %@",weixinTips,alipayTips];
    [self.chargeAccountButton setTitle:tips forState:UIControlStateNormal];
    [self.chargeAccountButton setTitleColor:[UIColor colorWithHexString:@"#555555"] forState:UIControlStateNormal];
}


#pragma mark - IBAction

- (IBAction)touchChargeAccountButton:(UIButton *)sender
{
    ChargeAccountViewController *vc = [OrderStoryboard instantiateViewControllerWithIdentifier:[ChargeAccountViewController description]];
    vc.delegate = self;
    [vc setupWithwechatAccount:self.entity.wchat_pay alipay:self.entity.ali_pay];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)touchPhoto1Button:(UIButton *)sender {
    self.currentButtonIndex = 0;
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [sheet showInView:self.view];
}

- (IBAction)touchPhoto2Button:(UIButton *)sender {
    self.currentButtonIndex = 1;
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [sheet showInView:self.view];
}

- (IBAction)touchPhoto1DeleteButton:(UIButton *)sender {
    [self.photoButton1 setImage:nil forState:UIControlStateNormal];
    [self.photoDeleteButton1 setHidden:YES];
}

- (IBAction)touchPhoto2DeleteButton:(UIButton *)sender {
    [self.photoButton2 setImage:nil forState:UIControlStateNormal];
    [self.photoDeleteButton2 setHidden:YES];
}

- (IBAction)touchDoneButtonInToolbar:(UIButton *)sender
{
    [self.areaTextField resignFirstResponder];
}


- (IBAction)touchNextButton:(UIBarButtonItem *)sender
{
    self.entity.shop_name = self.shopNameTextField.text;
    self.entity.address = self.addressTextField.text;
    self.entity.Introduction = self.shopDescriptionTextField.text;
    self.entity.images = [[NSMutableArray alloc] init];
    if ([self.photoButton1 currentImage]) {
        ImageEntity *imageEntity = [ImageEntity createWithImage:[self.photoButton1 currentImage]];
        [self.entity.images addObject:imageEntity];
    }
    if ([self.photoButton2 currentImage]) {
        ImageEntity *imageEntity = [ImageEntity createWithImage:[self.photoButton2 currentImage]];
        [self.entity.images addObject:imageEntity];
    }
    self.entity.province = self.province;
    self.entity.city=self.city;
    self.entity.district=self.district;
    self.entity.length = [self.entity.images count];
    self.entity.easemob = [[UserSession sharedInstance] currentUser].easemob;
    self.entity.phoneNumber = self.phoneNumberTextField.text;
    
    //验证
    if (!self.entity.length ) {
        [self showtips:@"拍个店铺图片吧."];
        return;
    }
    if (self.entity.shop_name.length<=0) {
        [self showtips:@"店铺名称不能为空."];
        return;
    }
    if (self.entity.province.length<=0
        || self.entity.city.length<=0
        || self.entity.district.length<=0) {
        [self showtips:@"区域不能为空."];
        return;
    }
    if (self.entity.address.length<=0) {
        [self showtips:@"详细地址不能为空."];
        return;
    }
    if (![self.entity.cat_id count]) {
        [self showtips:@"选个店铺类型吧."];
        return;
    }
    if (self.entity.Introduction.length<=0) {
        [self showtips:@"介绍下店铺呗."];
        return;
    }
    if (![Util evaluatePhoneNumber:self.entity.phoneNumber]) {
        [self showtips:@"请填写正确的手机号码."];
        return;
    }
    if (IS_NULL(self.entity.wchat_pay) && IS_NULL(self.entity.ali_pay))
    {
        [self showtips:@"没有填收款账号，会收不到钱哦."];
        return;
    }


    
    [self showHUDWithTitle:@"正在加载..."];
    [self.model setUp:self.entity];
}

#pragma ChooseShopTypeDelegate

- (void)didShopTypeSelected:(NSArray *)catIds text:(NSString *)text
{
    if ([catIds count]) {
        self.entity.cat_id = catIds;
        [self.shopTypeTextField setTitleColor:UIColorFromRGB(DARK_GRAY) forState:UIControlStateNormal];
        [self.shopTypeTextField setTitle:text forState:UIControlStateNormal];
    }
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

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect frame = textView.frame;
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
-(BOOL)textViewShouldReturn:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textViewDidEndEditing:(UITextView *)textView
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)receivedNotification:(NSNotification *)notification
{
    [self hideHUD];
    if ([notification.name isEqualToString:ADD_SHOP]) {
        UserEntity *entity = [[UserInfo info] currentUser];
        //开店成功,记录SHOP_ID
        entity.shop_id = ((NSNumber *)notification.object).integerValue;
        [[UserInfo info] setCurrentUser:entity];
        [[UserSession sharedInstance] setCurrentUser:entity];
        [self performSegueWithIdentifier:[SetUpSuccessViewController description] sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:[ChooseShopTypeViewController description]]) {
        ChooseShopTypeViewController *vc = segue.destinationViewController;
        vc.selectedItems = self.entity.cat_id;
        vc.delegate = self;
    }
}

#pragma CityPickerDelegate

- (void)cityPickerViewValueChanged
{
    [self.areaTextField setText:[NSString stringWithFormat:@"%@ %@ %@",self.cityPicker.province,self.cityPicker.city,self.cityPicker.district]];
    self.province = self.cityPicker.province;
    self.city = self.cityPicker.city;
    self.district = self.cityPicker.district;
}

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
        switch (self.currentButtonIndex) {
            case 0:{
                [self.photoButton1 setImage:chosenImage forState:UIControlStateNormal];
                [self.photoDeleteButton1 setHidden:NO];
                break;
            }
            case 1:{
                [self.photoButton2 setImage:chosenImage forState:UIControlStateNormal];
                [self.photoDeleteButton2 setHidden:NO];
                break;
            }
            default:
                break;
        }
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

//Override
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)clearTextView
{
    if ([self.shopDescriptionTextField.text isEqualToString:@"请输入店铺介绍"])
    {
        self.shopDescriptionTextField.text = @"";
    }
}

- (SetUpEntity *)entity
{
    if (!_entity) {
        _entity = [[SetUpEntity alloc] init];
    }
    return _entity;
}

- (SetUpModel *)model
{
    if (!_model) {
        _model = [[SetUpModel alloc] init];
    }
    return _model;
}

- (PSCityPickerView *)cityPicker
{
    if (!_cityPicker) {
        _cityPicker = [[PSCityPickerView alloc]init];
    }
    return _cityPicker;
}

@end
