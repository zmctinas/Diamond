//
//  PSDiscountPickerView.m
//  Diamond
//
//  Created by Leon Hu on 15/8/19.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "PSDiscountPickerView.h"

@interface PSDiscountPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>

@end

@implementation PSDiscountPickerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}

//该方法返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 99;
}

//该方法返回的NSString将作为UIPickerView中指定列、指定列表项上显示的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSInteger all = [pickerView numberOfRowsInComponent:component];
    NSString *result = [NSString stringWithFormat:@"%.1f折",((double)(all - row ) / 10)];
    return result;
}

//选择指定列、指定列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger all = [pickerView numberOfRowsInComponent:component];
    NSNumber *discount= [NSNumber numberWithDouble: ((double)(all - row)/10)];
    NSString *text = [NSString stringWithFormat:@"%.1f折",((double)(all - row) / 10)];
    
    if ([self.discountPickerDelegate respondsToSelector:@selector(discountValueChanged:text:)])
    {
        [self.discountPickerDelegate discountValueChanged:discount text:text];
    }
}

//指定列的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    // 宽度
    return 100;
}

@end
