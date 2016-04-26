//
//  EditGoodsTypeViewController.m
//  Diamond
//
//  Created by Leon Hu on 15/9/16.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "EditGoodsTypeViewController.h"
#import "PSNumberPad.h"

@interface EditGoodsTypeViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *modelTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *stockTextField;

- (IBAction)touchSubmitButton:(UIBarButtonItem *)sender;

@property (nonatomic,strong) GoodsTypeEntity *entity;
@property (nonatomic,strong) PSNumberPad *numberPad;

@end

@implementation EditGoodsTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.priceTextField.delegate = self;
    self.stockTextField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    if (self.entity) {
        [self setTitle:@"编辑型号"];
        [self.modelTextField setText:self.entity.typeName];
        [self.priceTextField setText:[NSString stringWithFormat:@"%.2f",self.entity.price.doubleValue]];
        [self.stockTextField setText:[NSString stringWithFormat:@"%ld",(long)self.entity.stock]];
    }else{
        [self setTitle:@"添加型号"];
        self.entity = [GoodsTypeEntity new];
    }
}

- (void)setGoodsType:(GoodsTypeEntity *)entity
{
    self.entity = entity;
}

- (IBAction)touchSubmitButton:(UIBarButtonItem *)sender {
    if (IS_NULL(self.modelTextField.text)
        || IS_NULL(self.priceTextField.text)
        || IS_NULL(self.stockTextField.text))
    {
        [self showtips:@"有项目未填写"];
        return;
    }
    
    if (self.priceTextField.text.doubleValue > 1000000.0)
    {
        [self showtips:@"价格不能超过100万."];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(didEditedGoodsType:)]) {
        if (!self.entity.typeId) {
            //如果ID为空,说明是新增的,返回给上一页的时候再进行修改时无法判断,所以临时加一个ID,在上传服务端时需去除
            self.entity.typeId = [NSNumber numberWithLong:(-1*[NSDate date].timeIntervalSince1970)];
        }
        self.entity.typeName = self.modelTextField.text;
        self.entity.price = [NSNumber numberWithFloat:[self.priceTextField.text doubleValue]];
        self.entity.stock = [self.stockTextField.text integerValue];
        [self.delegate didEditedGoodsType:self.entity];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.numberPad.textField = textField;
    [self.numberPad setDisableDot:[textField isEqual:self.stockTextField]];
    return YES;
}

#pragma mark getter&setter

- (PSNumberPad *)numberPad
{
    if (!_numberPad) {
        _numberPad = [PSNumberPad pad];
    }
    return _numberPad;
}

@end
