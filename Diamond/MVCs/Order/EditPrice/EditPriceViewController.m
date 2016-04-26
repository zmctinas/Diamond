//
//  EditPriceViewController.m
//  Diamond
//
//  Created by Pan on 15/8/31.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "EditPriceViewController.h"
#import "PSNumberPad.h"

@interface EditPriceViewController ()

@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) PSNumberPad *numberPad;

- (IBAction)touchConformButton:(UIBarButtonItem *)sender;
@end

//TODO:缺少一个输入数字的键盘

@implementation EditPriceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addLeftBarButtonItem];
    [self addObserverForNotifications:@[EDIT_POSTAGE_NOTIFICATION,EDIT_TOTLE_FEE_NOTIFICATION]];
    [self setupUI];
}

- (void)setupUI
{
    NSMutableString *placeholderString = [NSMutableString stringWithString:@"请输入修改后的"];
    if (self.type == EditPriceTypePostage)
    {
        //邮费
        self.title = @"修改运费";
        self.titleLabel.text = @"运费";
        [placeholderString appendString:@"运费"];
    }
    else if (self.type == EditPriceTypeWarePrice)
    {
        //商品价格
        self.title = @"修改价格";
        self.titleLabel.text = @"商品价格";
        [placeholderString appendString:@"价格（不含运费）"];

    }
    
    self.priceTextField.placeholder = placeholderString;
    self.numberPad.textField = self.priceTextField;
}

#pragma mark - Notification
- (void)receivedNotification:(NSNotification *)notification
{
    [self hideHUD];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchConformButton:(UIBarButtonItem *)sender
{
    NSString *priceString = self.priceTextField.text;
    
    if (!IS_NULL(priceString))
    {
        [self showHUDWithTitle:@"正在修改..."];
        if (self.type == EditPriceTypePostage)
        {
            //邮费
            [self.model editPostage:@([priceString doubleValue])];
        }
        else if (self.type == EditPriceTypeWarePrice)
        {
            //商品价格
            [self.model editTotleFee:@([priceString doubleValue])];
        }
    }
}

- (PSNumberPad *)numberPad
{
    if (!_numberPad)
    {
        _numberPad = [PSNumberPad pad];
    }
    return _numberPad;
}


@end
