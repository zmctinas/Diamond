//
//  EditReceiveGoodsAddressViewController.m
//  Diamond
//
//  Created by Leon Hu on 15/8/28.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "EditReceiveGoodsAddressViewController.h"
#import "ReceiveGoodsAddressModel.h"
#import "PSCityPickerView.h"
#import "MJExtension.h"

@interface EditReceiveGoodsAddressViewController ()<PSCityPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *areaTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIButton *defaultAddressButton;

- (IBAction)touchSaveButton:(UIBarButtonItem *)sender;
- (IBAction)touchSetDefaultButton:(UIButton *)sender;
- (IBAction)touchDoneToolBar:(id)sender;

@property (nonatomic,strong) ReceiveGoodsAddressModel *model;
@property (strong, nonatomic) PSCityPickerView *picker;
@property (weak, nonatomic) IBOutlet UIToolbar *doneToolbar;

@end

@implementation EditReceiveGoodsAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftBarButtonItem];
    self.areaTextField.inputView = self.picker;
    self.areaTextField.inputAccessoryView = self.doneToolbar;
    self.picker.cityPickerDelegate = self;
    [self addObserverForNotifications:@[ADD_ADDRESS,UPDATE_ADDRESS]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    @try {
        self.navigationController.navigationBarHidden = NO;
        
        if (self.entity && self.entity.addressId.length>0)
        {
            [self.nameTextField setText:self.entity.linkman];
            [self.mobileTextField setText:self.entity.phoneNumber];
            [self.areaTextField setText:[NSString stringWithFormat:@"%@ %@ %@",self.entity.province,self.entity.city,self.entity.district]];
            [self.addressTextField setText:self.entity.address];
            if (self.entity.status) {
                [self.defaultAddressButton setImage:[UIImage imageNamed:@"shoppingcart_btn_xuanze_se"] forState:UIControlStateNormal];
            }else{
                [self.defaultAddressButton setImage:nil forState:UIControlStateNormal];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.debugDescription);
    }
    @finally {
    }
}
- (IBAction)touchDoneToolBar:(id)sender;
{
    [self.areaTextField resignFirstResponder];
}
- (IBAction)touchSaveButton:(UIBarButtonItem *)sender {
    self.entity.status = ![self.defaultAddressButton.currentImage isEqual:nil];
    self.entity.linkman = self.nameTextField.text;
    self.entity.phoneNumber = self.mobileTextField.text;
    self.entity.address = self.addressTextField.text;
    self.entity.easemob = [[UserSession sharedInstance] currentUser].easemob;
    
    if (self.entity.linkman.length<1) {
        [self showtips:@"请输入收货人"];
        return;
    }
    if (self.entity.phoneNumber.length<1 || ![self checkTelNumber:self.entity.phoneNumber]) {
        [self showtips:@"请输入收货人手机"];
        return;
    }
    if (self.entity.address.length<1) {
        [self showtips:@"请输入收货地址"];
        return;
    }
    if (self.entity.province.length<1
        || self.entity.city.length<1
        || self.entity.district.length<1) {
        [self showtips:@"请选择所在区域"];
        return;
    }
    
    [self showHUDWithTitle:@"保存收获地址中..."];
    if (self.entity.addressId.length>0) {
        [self.model updateAddress:self.entity];
    }else{
        [self.model addAddress:self.entity];
    }
}

- (BOOL)checkTelNumber:(NSString *) telNumber
{
    NSString *pattern = @"^\\d{11}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}

- (IBAction)touchSetDefaultButton:(UIButton *)sender {
    if (self.entity.status) {
        self.entity.status = NO;
        [self.defaultAddressButton setImage:nil forState:UIControlStateNormal];
    }else{
        self.entity.status = YES;
        [self.defaultAddressButton setImage:[UIImage imageNamed:@"shoppingcart_btn_xuanze_se"] forState:UIControlStateNormal];
    }
}

- (void)receivedNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:UPDATE_ADDRESS]
        || [notification.name isEqualToString:ADD_ADDRESS]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark delegate

- (void)cityPickerViewValueChanged
{
    [self.areaTextField setText:[NSString stringWithFormat:@"%@ %@ %@",self.picker.province,self.picker.city,self.picker.district]];
    self.entity.province = self.picker.province;
    self.entity.city = self.picker.city;
    self.entity.district = self.picker.district;
}

#pragma mark gettersetter

- (PSCityPickerView *)picker
{
    if (!_picker) {
        _picker = [[PSCityPickerView alloc] init];
    }
    return _picker;
}

- (ReceiveGoodsAddressEntity *)entity
{
    if (!_entity) {
        _entity = [[ReceiveGoodsAddressEntity alloc] init];
    }
    return _entity;
}

- (ReceiveGoodsAddressModel *)model
{
    if (!_model) {
        _model = [[ReceiveGoodsAddressModel alloc] init];
    }
    return _model;
}

@end
