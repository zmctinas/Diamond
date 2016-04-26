//
//  ShopSettingViewController.m
//  Diamond
//
//  Created by Leon Hu on 15/8/10.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ShopSettingViewController.h"
#import "UIViewController+DismissKeyboard.h"
#import "PSCityPickerView.h"
#import "Util.h"
#import "ShopSession.h"
#import "Shop.h"
#import "EditShopEntity.h"
#import "EMError.h"
#import "MyShopModel.h"
#import "UIButton+WebCache.h"
#import "UIImage+Scale.h"
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CoreAnimation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "EditTransportCostsViewController.h"
#import "ImageEntity.h"
#import "ChargeAccountViewController.h"
#import "UIButton+Category.h"
#import "ShopModel.h"
#import "UIColor+Hex.h"

@interface ShopSettingViewController()<UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIActionSheetDelegate,
UITextFieldDelegate,
UITextViewDelegate,
PSCityPickerViewDelegate,
ChooseShopTypeDelegate,
PSSelectTimePickerViewDelegate,
EditTransportCostsDelegate,
ChargeAccountViewControllerDelegate>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *photoButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *deletePhotoButtons;
@property (weak, nonatomic) IBOutlet UITextField *shopNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *areaTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIButton *shopTypeButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *businessHoursTextField;//营业时间
@property (weak, nonatomic) IBOutlet UITextView *shopDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *openShopButton;
@property (weak, nonatomic) IBOutlet UIButton *closeShopButton;
@property (weak, nonatomic) IBOutlet UIButton *transportCostsButton;

@property (weak, nonatomic) IBOutlet UIToolbar *doneToolbar;

- (IBAction)touchDoneButtonInToolbar:(UIButton *)sender;
- (IBAction)touchPhotoButton:(UIButton *)sender;
- (IBAction)touchDeletePhotoButton:(UIButton *)sender;
- (IBAction)touchOpenShopButton:(UIButton *)sender;
- (IBAction)touchCloseShopButton:(UIButton *)sender;
- (IBAction)touchChargeAccountButton:(UIButton *)sender;
- (IBAction)touchOkButton:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet UIButton *chargeAccountButton;/**< 付款方式按钮*/

@property (nonatomic, strong) UIActionSheet *sheet;
@property (strong, nonatomic) PSCityPickerView *picker;
@property (strong, nonatomic) PSSelectTimePickerView *timePicker;
@property (nonatomic, strong) UIButton *buttonWhichIsTouched;
@property (nonatomic, copy)   NSString *lastChosenMediaType;
@property (nonatomic, strong) EditShopEntity *shop;
@property (nonatomic, strong) MyShopModel *model;
@property (nonatomic) BOOL isEditImage;//是否编辑了图片

@end

@implementation ShopSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addObserverForNotifications:@[GET_SHOP_INFO,UPDATE_SHOP]];
    [self addLeftBarButtonItem];
    self.areaTextField.inputView = self.picker;
    self.areaTextField.inputAccessoryView = self.doneToolbar;
    self.picker.cityPickerDelegate = self;
    self.businessHoursTextField.inputView = self.timePicker;
    self.timePicker.selectTimePickerdelegate = self;
    
    self.shopNameTextField.delegate = self;
    self.areaTextField.delegate = self;
    self.addressTextField.delegate = self;
    self.businessHoursTextField.delegate = self;
    self.shopDescriptionTextView.delegate = self;
    
    //TODO 获取数据并赋值
    [self.model getShopInfo:[[UserSession sharedInstance] currentUser].shop_id];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self setupForDismissKeyboard];
}

#pragma mark - IBAction
- (IBAction)touchChargeAccountButton:(UIButton *)sender
{
    ChargeAccountViewController *vc = [OrderStoryboard instantiateViewControllerWithIdentifier:[ChargeAccountViewController description]];
    vc.delegate = self;
    [vc setupWithwechatAccount:self.shop.wchat_pay alipay:self.shop.ali_pay];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)touchPhotoButton:(UIButton *)sender {
    self.isEditImage = YES;
    self.buttonWhichIsTouched = sender;
    self.sheet = [[UIActionSheet alloc] initWithTitle:nil
                                             delegate:self
                                    cancelButtonTitle:@"取消"
                               destructiveButtonTitle:nil
                                    otherButtonTitles:@"拍照", @"相册中选取照片", nil];
    [self.sheet showInView:self.view];
}

- (IBAction)touchDeletePhotoButton:(UIButton *)sender {
    self.isEditImage = YES;
    for (UIButton *button in self.photoButtons) {
        if (button.tag == sender.tag) {
            [button setImage:nil forState:UIControlStateNormal];
            [sender setHidden:YES];
            break;
        }
    }
}

- (IBAction)touchDoneButtonInToolbar:(UIButton *)sender
{
    [self.areaTextField resignFirstResponder];
}


- (IBAction)touchOpenShopButton:(UIButton *)sender {
    self.shop.is_open = YES;
    [self setShopStateButton:YES];
}

- (IBAction)touchCloseShopButton:(UIButton *)sender {
    self.shop.is_open = NO;
    [self setShopStateButton:NO];
}

- (IBAction)touchOkButton:(UIBarButtonItem *)sender {
    @try {
        EditShopEntity *shop = self.shop;
        shop.shop_name = self.shopNameTextField.text;
        shop.address = self.addressTextField.text;
        shop.Introduction = self.shopDescriptionTextView.text;
        shop.phoneNumber = self.phoneNumberTextField.text;
        
        if (self.isEditImage){
            NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
            self.shop.site =[[NSMutableArray alloc] init];
            self.shop.length = 0;
            for (UIButton *button in self.photoButtons) {
                if (button.currentImage) {
                    [self.shop.site addObject:@(button.tag)];
                    self.shop.length++;
                    ImageEntity *imageEntity = [ImageEntity createWithImage:button.currentImage];
                    [mutableArray addObject:imageEntity];
                }
            }
            if (![mutableArray count]) {
                [self showtips:@"请添加至少一张图片"];
                return;
            }
            
//            self.shop.shop_ad = mutableArray;
            self.shop.images = mutableArray;
            
            //添加删除的site
            for (int i=0; i<[self.shop.shop_ad count]; i++) {
                for (UIButton *button in self.photoButtons) {
                    if (button.tag == i) {
                        if (!button.currentImage) {
                            [self.shop.site addObject:@(button.tag)];
                        }
                    }
                }
            }
        }
        
        if (shop.shop_name.length<1) {
            [self showtips:@"店名不能为空."];
            return;
        }else if (shop.address.length<1) {
            [self showtips:@"地址不能为空."];
            return;
        }else if (shop.Introduction.length<1) {
            [self showtips:@"店铺介绍不能为空."];
            return;
        }else if (shop.province.length<1) {
            [self showtips:@"所在省份不能为空."];
            return;
        }else if (shop.city.length<1) {
            [self showtips:@"所在城市不能为空."];
            return;
        }else if (shop.district.length<1) {
            [self showtips:@"所在区域不能为空."];
            return;
        }else if (![shop.cat_id count]) {
            [self showtips:@"至少选择一种类型."];
            return;
        }else if (![Util evaluatePhoneNumber:shop.phoneNumber]) {
            [self showtips:@"未按要求填写手机号码"];
            return;
        }else{
            [self showHUDWithTitle:@"正在保存"];
            [self.model updateShopInfo:shop];
        }
    }
    @catch (NSException *exception) {
        [self showtips:exception.description];
    }
    @finally {
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:[ChooseShopTypeViewController description]]) {
        ChooseShopTypeViewController *vc = segue.destinationViewController;
        vc.selectedItems = self.shop.cat_id;
        vc.delegate = self;
    }else if ([segue.identifier isEqualToString:[EditTransportCostsViewController description]]){
        EditTransportCostsViewController *vc = segue.destinationViewController;
        vc.delegate = self;
        vc.distance = self.shop.delivery_distance;
        vc.price = self.shop.delivery_limit;
    }
}

#pragma mark - ChargeAccountViewControllerDelegate
- (void)conformWechatAccount:(NSString *)openID alipayAccount:(NSString *)alipayAccount real_name:(NSString *)realName
{
    self.shop.wchat_pay = openID;
    self.shop.ali_pay = alipayAccount;
    self.shop.realName = realName;
}

- (void)updateChargeAccountButton
{
    NSString *weixinTips = IS_NULL(self.shop.wchat_pay) ? @"" : @"微信账号";
    NSString *alipayTips = IS_NULL(self.shop.ali_pay) ? @"" : @"支付宝账号";
    NSString *tips = [NSString stringWithFormat:@"已获取%@ %@",weixinTips,alipayTips];
    [self.chargeAccountButton setTitle:tips forState:UIControlStateNormal];
    [self.chargeAccountButton setTitleColor:[UIColor colorWithHexString:@"#555555"] forState:UIControlStateNormal];
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

- (void)textViewDidBeginEditing:(UITextView *)textView
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
-(BOOL)textViewShouldReturn:(UITextField *)textView
{
    [textView resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textViewDidEndEditing:(UITextField *)textView
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark - ChooseShopType

- (void)didShopTypeSelected:(NSArray *)catIds text:(NSString *)text
{
    self.shop.cat_id = catIds;
    [self.shopTypeButton setTitle:text forState:UIControlStateNormal];
    [self.shopTypeButton setTitleColor:[UIColor colorWithHexString:@"#555555"] forState:UIControlStateNormal];
}

#pragma mark - EditTransportCostsDelegate

- (void)didEditTransportCosts:(NSInteger)distance price:(NSNumber *)price
{
    NSString *str = [NSString stringWithFormat:@"%ld公里内,%.2f以上,免费配送",(long)distance,price.doubleValue];
    [self.transportCostsButton setTitle:str forState:UIControlStateNormal];
    [self.transportCostsButton setTitleColor:UIColorFromRGB(0x555555) forState:UIControlStateNormal];
    self.shop.delivery_distance = distance;
    self.shop.delivery_limit = price;
}

#pragma mark - picker

- (void)cityPickerViewValueChanged
{
    [self.areaTextField setText:[NSString stringWithFormat:@"%@ %@ %@",self.picker.province,self.picker.city,self.picker.district]];
    self.shop.province = self.picker.province;
    self.shop.city = self.picker.city;
    self.shop.district = self.picker.district;
}

- (void)selectChanged
{
    [self.businessHoursTextField setText:[NSString stringWithFormat:@"%@ - %@",self.timePicker.openTime,self.timePicker.closeTime]];
    self.shop.sale_start_time = self.timePicker.openTime;
    self.shop.sale_end_time = self.timePicker.closeTime;
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
        [self.buttonWhichIsTouched setImage:chosenImage forState:UIControlStateNormal];
        for (UIButton *button in self.deletePhotoButtons) {
            if (button.tag == self.buttonWhichIsTouched.tag) {
                [button setHidden:NO];
                break;
            }
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


- (void)receivedNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:GET_SHOP_INFO]) {
        self.shop = [EditShopEntity getEntity:[ShopSession sharedInstance].currentShop];
        EditShopEntity *shop = self.shop;
        //重置修改图片标记
        self.isEditImage = NO;
        //设置图片
        NSInteger count = [shop.shop_ad count];
        if (count){
            //只有两个图位
            count = (count > 2 ? 2 : count);
            for (int i=0; i<count; i++) {
                NSURL *url = [Util urlWithPath:[shop.shop_ad objectAtIndex:i]];
                [[self.photoButtons objectAtIndex:i] setDefaultLoadingImage];
                [[self.photoButtons objectAtIndex:i] sd_setImageWithURL:url forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image)
                    {
                        [[self.deletePhotoButtons objectAtIndex:i] setHidden:NO];
                    }
                }];
            }
        }
        //名字
        [self.shopNameTextField setText:shop.shop_name];
        //省市区
        [self.areaTextField setText:[NSString stringWithFormat:@"%@ %@ %@",shop.province,shop.city,shop.district]];
        //详细地址
        [self.addressTextField setText:shop.address];
        //店铺类型
        NSMutableString *shopTypeString = [NSMutableString new];
        for (NSNumber *shopType in shop.cat_id) {
            [shopTypeString appendFormat:@" %@",[Util shopTitleWithType:shopType.integerValue]];
        }
        //联系方式
        [self.phoneNumberTextField setText:shop.phoneNumber];
        //店铺类型
        [self.shopTypeButton setTitle:shopTypeString forState:UIControlStateNormal];
        [self.shopTypeButton setTitleColor:[UIColor colorWithHexString:@"#555555"] forState:UIControlStateNormal];
        //营业时间
        [self.businessHoursTextField setText:[NSString stringWithFormat:@"%@ - %@",shop.sale_start_time,shop.sale_end_time]];
        //店铺状态
        [self setShopStateButton:shop.is_open];
        //介绍
        [self.shopDescriptionTextView setText:shop.Introduction];
        //收款方式
        [self updateChargeAccountButton];
        //运费设置
        [self didEditTransportCosts:shop.delivery_distance price:shop.delivery_limit];
        
        
    }else if ([notification.name isEqualToString:UPDATE_SHOP]){
        [self showtips:@"店铺设置更改成功."];
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self hideHUD];
}

- (void)setShopStateButton:(BOOL)isOpen
{
    if (isOpen) {
        [self.openShopButton setBackgroundImage:[UIImage imageNamed:@"install_btn_se"] forState:UIControlStateNormal];
        [self.closeShopButton setBackgroundImage:[UIImage imageNamed:@"install_btn"] forState:UIControlStateNormal];
    }else{
        [self.openShopButton setBackgroundImage:[UIImage imageNamed:@"install_btn"] forState:UIControlStateNormal];
        [self.closeShopButton setBackgroundImage:[UIImage imageNamed:@"install_btn_se"] forState:UIControlStateNormal];
    }
}

#pragma mark - getter and Setter

- (EditShopEntity *)shop
{
    if (!_shop) {
        _shop = [[EditShopEntity alloc] init];
    }
    return _shop;
}

/**
 *  排序
 *
 *  @return 排序后的按钮组
 */
- (NSArray *)photoButtons
{
    _photoButtons = [_photoButtons sortedArrayUsingComparator:^NSComparisonResult(UIButton *obj1, UIButton *obj2) {
        if (obj1.tag < obj2.tag)
        {
            return(NSComparisonResult)NSOrderedAscending;
        }else {
            return(NSComparisonResult)NSOrderedDescending;
        }
    }];
    return _photoButtons;
}
- (NSArray *)deletePhotoButtons
{
    _deletePhotoButtons = [_deletePhotoButtons sortedArrayUsingComparator:^NSComparisonResult(UIButton *obj1, UIButton *obj2) {
        if (obj1.tag < obj2.tag)
        {
            return(NSComparisonResult)NSOrderedAscending;
        }else {
            return(NSComparisonResult)NSOrderedDescending;
        }
    }];
    return _deletePhotoButtons;
}

- (UIPickerView *)picker
{
    if (!_picker)
    {
        _picker = [[PSCityPickerView alloc] init];
    }
    return _picker;
}

- (UIPickerView *)timePicker
{
    if (!_timePicker) {
        _timePicker = [[PSSelectTimePickerView alloc] init];
    }
    return _timePicker;
}

- (MyShopModel *)model
{
    if (!_model) {
        _model = [[MyShopModel alloc] init];
    }
    return _model;
}

@end
