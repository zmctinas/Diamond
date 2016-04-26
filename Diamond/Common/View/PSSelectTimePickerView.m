//
//  PSSelectTimePickerView.m
//  Diamond
//
//  Created by Leon Hu on 15/8/13.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "PSSelectTimePickerView.h"

@interface PSSelectTimePickerView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic) NSInteger openHour;
@property (nonatomic) NSInteger openMin;
@property (nonatomic) NSInteger closeHour;
@property (nonatomic) NSInteger closeMin;

@end

@implementation PSSelectTimePickerView

- (instancetype)init
{
    self = [super init];
    if (self)
    {        
        self = [self initWithValue:9 close:21];
    }
    return self;
}

- (instancetype)initWithValue:(NSInteger)hour close:(NSInteger)closeHour
{
    self = [super init];
    if (self)
    {
        self.openHour = 9;
        self.openMin = 0;
        self.closeHour = 21;
        self.closeMin = 0;
        
        self.delegate = self;
        self.dataSource = self;
        
        [self selectRow:(hour * 2) inComponent:0 animated:YES];
        [self selectRow:(closeHour * 2) inComponent:1 animated:YES];
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    //包含2列
    return 2;
}

//该方法返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 49;
}

//该方法返回的NSString将作为UIPickerView中指定列、指定列表项上显示的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSInteger hourInteger = (row / 2);
    NSInteger minInteger = ((row % 2 == 1) ? 30 : 0);
    
    NSString *hour = [NSString stringWithFormat:@"%ld",(long)hourInteger];
    NSString *min = (minInteger<9?
                     [NSString stringWithFormat:@"0%ld",(long)minInteger]:
                     [NSString stringWithFormat:@"%ld",(long)minInteger]);
    
    return [NSString stringWithFormat:@"%@:%@",hour,min];
}

//选择指定列、指定列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        self.openHour = row / 2;
        self.openMin = (row % 2 == 1 ? 30 : 0);

        if (self.openHour > self.closeHour || (self.openHour==self.closeHour && self.openMin>self.closeMin)){
            [pickerView selectRow:(row+1) inComponent:1 animated:YES];
            
            if (self.openHour == 24) {
                self.closeHour = self.openHour ;
                self.closeMin = 0;
            }else{
                if (self.openMin == 0) {
                    self.closeHour = self.openHour;
                    self.closeMin = 30;
                }else{
                    self.closeHour = self.openHour + 1;
                    self.closeMin = 0;
                }
            }
        }
        
        [pickerView reloadComponent:1];
    }
    else if (component == 1)
    {
        self.closeHour = row / 2;
        self.closeMin = (row % 2 == 1 ? 30 : 0);
        
        if (self.openHour > self.closeHour || (self.openHour==self.closeHour && self.openMin>self.closeMin)){
            [pickerView selectRow:(row-1) inComponent:0 animated:YES];
            
            if (self.closeHour == 0 && self.closeMin == 0){
                self.openHour = 0;
                self.openMin = 0;
            }else{
                if (self.closeMin == 0) {
                    self.openHour = self.closeHour - 1;
                    self.openMin = 30;
                }else{
                    self.openHour = self.closeHour;
                    self.openMin = 0;
                }
            }
        }
        
        [pickerView reloadComponent:0];
    }
    NSString *openHourString = [NSString stringWithFormat:@"%ld",(long)self.openHour];
    NSString *openMinString = (self.openMin<9?
                               [NSString stringWithFormat:@"0%ld",(long)self.openMin]:
                               [NSString stringWithFormat:@"%ld",(long)self.openMin]);
    self.openTime = [NSString stringWithFormat:@"%@:%@",openHourString,openMinString];
    
    NSString *closeHourString = [NSString stringWithFormat:@"%ld",(long)self.closeHour];
    NSString *closeMinString = (self.closeMin<9?
                     [NSString stringWithFormat:@"0%ld",(long)self.closeMin]:
                     [NSString stringWithFormat:@"%ld",(long)self.closeMin]);
    self.closeTime = [NSString stringWithFormat:@"%@:%@",closeHourString,closeMinString];
    
    if ([self.selectTimePickerdelegate respondsToSelector:@selector(selectChanged)])
    {
        [self.selectTimePickerdelegate selectChanged];
    }
}

//指定列的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    // 宽度
    return 150;
}

- (NSString *)openTime
{
    if (!_openTime) {
        _openTime = [NSString stringWithFormat:@"%2ld:%2ld",(long)self.openHour,(long)self.openMin];
    }
    return _openTime;
}

- (NSString *)closeTime
{
    if (!_closeTime) {
        _closeTime = [NSString stringWithFormat:@"%2ld:%2ld",(long)self.closeHour,(long)self.closeMin];
    }
    return _closeTime;
}

@end
