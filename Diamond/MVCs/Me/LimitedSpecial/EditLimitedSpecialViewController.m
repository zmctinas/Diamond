//
//  EditLimitedSpecialViewController.m
//  Diamond
//
//  Created by Leon Hu on 15/8/16.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "EditLimitedSpecialViewController.h"
#import "LimitedSpecialModel.h"

@interface EditLimitedSpecialViewController ()

/**
 *  折扣
 */
@property (weak, nonatomic) IBOutlet UITextField *discountTextField;
@property (weak, nonatomic) IBOutlet UITextField *startTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *stopTimeTextField;

@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,strong) PSDiscountPickerView *discountPicker;

- (IBAction)touchOkButton:(UIBarButtonItem *)sender;

@property (nonatomic,strong) NSNumber *discount;
@property (nonatomic,strong) NSDate *startTime;
@property (nonatomic,strong) NSDate *stopTime;
@property (nonatomic,strong) UITextField *currentTextField;
@property (nonatomic,strong) LimitedSpecialModel *model;

@end

@implementation EditLimitedSpecialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftBarButtonItem];
    
    self.startTimeTextField.delegate = self;
    self.stopTimeTextField.delegate = self;
    self.discountPicker.discountPickerDelegate = self;
    self.startTimeTextField.inputView = self.datePicker;
    self.stopTimeTextField.inputView = self.datePicker;
    self.discountTextField.inputView = self.discountPicker;
    
    self.startTimeTextField.returnKeyType = UIReturnKeyDone;
    self.stopTimeTextField.returnKeyType = UIReturnKeyDone;
    
    [self addObserverForNotifications:@[
                                       ADD_PROMOTION
                                       ]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = NO;
    
    [self setStartTimeString];
    [self setStopTimeString];
}

- (void)datePickerValueChanged
{
    self.currentTextField.text = [self.datePicker.date description];
}

- (IBAction)touchOkButton:(UIBarButtonItem *)sender {
    if (self.discountTextField.text.length<1) {
        [self showtips:@"未选商品,返回选择商品."];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self.model addPromotion:self.goodsIds discount:self.discount startTime:self.startTime stopTime:self.stopTime];
}

- (void)receivedNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:ADD_PROMOTION]) {
        [self showtips:@"编辑成功."];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.currentTextField = nil;
}

- (void)dateChanged:(UIDatePicker *)picker
{
    if (self.currentTextField == self.startTimeTextField) {
        self.startTime = picker.date;
        [self setStartTimeString];
    }else  if (self.currentTextField == self.stopTimeTextField) {
        self.stopTime = picker.date;
        [self setStopTimeString];
    }
}

- (void)discountValueChanged:(NSNumber *)value text:(NSString *)text
{
    self.discount = value;
    [self.discountTextField setText:text];
}

#pragma privates

- (void)setStartTimeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self.startTimeTextField setText:[dateFormatter stringFromDate:self.startTime]];
}
- (void)setStopTimeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self.stopTimeTextField setText:[dateFormatter stringFromDate:self.stopTime]];
}

#pragma getter,setter
- (NSDate *)startTime
{
    if (!_startTime) {
        _startTime = [NSDate date];
    }
    return _startTime;
}

- (NSDate *)stopTime
{
    if (!_stopTime) {
        NSTimeInterval interval = 3600;
        _stopTime = [self.startTime initWithTimeIntervalSinceNow:+interval];
    }
    return _stopTime;
}

- (LimitedSpecialModel *)model
{
    if (!_model) {
        _model = [[LimitedSpecialModel alloc] init];
    }
    return _model;
}

- (UIDatePicker *)datePicker
{
    if (!_datePicker)
    {
        _datePicker = [[UIDatePicker alloc]init];
        [_datePicker addTarget:self
                        action:@selector(dateChanged:)
              forControlEvents:UIControlEventValueChanged];
        
        [self.datePicker setDate:[NSDate date] animated:YES];
    }
    return _datePicker;
}

- (PSDiscountPickerView *)discountPicker
{
    if (!_discountPicker) {
        _discountPicker = [[PSDiscountPickerView alloc] init];
    }
    return _discountPicker;
}

- (NSNumber *)discount
{
    if (!_discount) {
        _discount = [NSNumber numberWithDouble:9.9];
    }
    return _discount;
}

@end
