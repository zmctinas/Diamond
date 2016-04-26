//
//  PSCityPickerView.m
//  Diamond
//
//  Created by Pan on 15/8/12.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "PSCityPickerView.h"

@interface PSCityPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) NSDictionary *allCityInfo;

@property (nonatomic, copy) NSArray *provinceArr;/**< 省名称数组*/
@property (nonatomic, copy) NSArray *cityArr;/**< 市名称数组*/
@property (nonatomic, copy) NSArray *districtArr;/**< 区名称数组*/

@property (nonatomic, strong) NSDictionary *currentProvinceDic;
@property (nonatomic, strong) NSDictionary *currentCityDic;

@end

@implementation PSCityPickerView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}


#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    //包含3列
    return 3;
}

//该方法返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger result = 0;
    switch (component) {
        case 0:
        {
            result = [self.provinceArr count];
            break;
        }
        case 1:
        {
            result = [self.cityArr count];
            break;
        }
        case 2:
        {
            result = [self.districtArr count];
            break;
        }
        default:
            break;
    }
    return result;
}

//该方法返回的NSString将作为UIPickerView中指定列、指定列表项上显示的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *result = @"";
    switch (component) {
        case 0:
        {
            result = [self.provinceArr objectAtIndex:row];
            break;
        }
        case 1:
        {
            result = [self.cityArr objectAtIndex:row];
            break;
        }
        case 2:
        {
            result = [self.districtArr objectAtIndex:row];
            break;
        }
        default:
            break;
    }
    return result;
}

//选择指定列、指定列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        NSDictionary *provinceDic = [self provinceDicAtIndex:row];
        NSArray *cityNames = [self cityNamesInProvinceDic:provinceDic];
        self.currentProvinceDic = provinceDic;
        self.cityArr = cityNames;
    
        NSDictionary *cityDic = [self provinceDic:provinceDic cityDicAtIndex:0];
        NSArray *districtNames = [self districtArrayInCityDic:cityDic];
        self.districtArr = districtNames;
        
        
        self.province = [self provinceNameWithPrivinceDic:provinceDic];
        self.city = [[self cityNamesInProvinceDic:provinceDic] firstObject];
        self.district = [self.districtArr firstObject];
        
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
        [pickerView reloadAllComponents];
    }
    else if (component == 1)
    {
        NSDictionary *cityDic = [self provinceDic:self.currentProvinceDic cityDicAtIndex:row];
        self.currentCityDic = cityDic;
        self.districtArr = [self districtArrayInCityDic:cityDic];
        
        self.province = [self provinceNameWithPrivinceDic:self.currentProvinceDic];
        self.city = [self cityNameWithCityDic:cityDic];
        self.district = [self.districtArr firstObject];
        
        [pickerView selectRow:0 inComponent:2 animated:YES];
        [pickerView reloadComponent:2];
    }
    else if (component == 2)
    {
        self.province = [self provinceNameWithPrivinceDic:self.currentProvinceDic];
        self.city = [self cityNameWithCityDic:self.currentCityDic];
        self.district = [self.districtArr objectAtIndex:row];
    }
    
    if ([self.cityPickerDelegate respondsToSelector:@selector(cityPickerViewValueChanged)])
    {
        [self.cityPickerDelegate cityPickerViewValueChanged];
    }
}

//指定列的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    // 宽度
    return 100;
}



#pragma mark - Private
/**
 *  获取省级字典
 *
 *  @param index
 *
 *  @return 省级字典
 */
- (NSDictionary *)provinceDicAtIndex:(NSUInteger)index;
{
    return [self.allCityInfo objectForKey:[@(index) stringValue]];
}

/**
 *  返回省级字典的名字
 *
 *  @param privinceDic 省级字典
 *
 *  @return NSString
 */
- (NSString *)provinceNameWithPrivinceDic:(NSDictionary *)provinceDic
{
    return [[provinceDic allKeys] firstObject];
}

/**
 *  返回省级字典下面的市名称列表
 *
 *  @param privinceDic 省级字典
 *
 *  @return NSArray<NSString>
 */
- (NSMutableArray *)cityNamesInProvinceDic:(NSDictionary *)provinceDic
{
    NSMutableArray *temp = [NSMutableArray array];
    for (NSInteger i = 0; i < [[[provinceDic allValues] firstObject] count]; i++)
    {
        NSDictionary *cityDic = [self provinceDic:provinceDic cityDicAtIndex:i];
        [temp addObject:[self cityNameWithCityDic:cityDic]];
    }
    return temp;
}


/**
 *  获取省级字典下的市级字典
 *
 *  @param privinceDic 省级字典
 *  @param index
 *
 *  @return 市级字典
 */
- (NSDictionary *)provinceDic:(NSDictionary *)provinceDic cityDicAtIndex:(NSUInteger)index;
{
    NSDictionary *cityDicInProvince = [provinceDic objectForKey:[self provinceNameWithPrivinceDic:provinceDic]];
    return [cityDicInProvince objectForKey:[@(index) stringValue]];
}

/**
 *  返回市级字典的市名称
 *
 *  @param cityDic 市级字典
 *
 *  @return NSSting
 */
- (NSString *)cityNameWithCityDic:(NSDictionary *)cityDic
{
    return [[cityDic allKeys] firstObject];
}

/**
 *  返回市级字典下的区/县信息
 *
 *  @param cityDic 市级字典
 *
 *  @return NSArray<NSString>
 */
- (NSArray *)districtArrayInCityDic:(NSDictionary *)cityDic
{
    return [[cityDic allValues] firstObject];
}

#pragma mark - Getter and Setter

- (NSDictionary *)allCityInfo
{
    if (!_allCityInfo)
    {
        NSBundle *bundle=[NSBundle mainBundle];
        NSString *path=[bundle pathForResource:@"city" ofType:@"plist"];
        _allCityInfo = [[NSDictionary alloc]initWithContentsOfFile:path];
    }
    return _allCityInfo;
}

- (NSArray *)provinceArr
{
    if (!_provinceArr)
    {
        NSMutableArray *temp = [NSMutableArray array];
        for (NSInteger i = 0 ; i < [[self.allCityInfo allKeys] count]; i++)
        {
            NSDictionary *provinceDic = [self provinceDicAtIndex:i];
            [temp addObject:[self provinceNameWithPrivinceDic:provinceDic]];
        }
        _provinceArr = temp;
    }
    return _provinceArr;
}

- (NSArray *)cityArr
{
    if (!_cityArr)
    {
        NSDictionary *provinceDic = [self provinceDicAtIndex:0];
        _cityArr = [self cityNamesInProvinceDic:provinceDic];
    }
    return _cityArr;
}

- (NSArray *)districtArr
{
    if (!_districtArr)
    {
        NSDictionary *cityDic = [self provinceDic:[self provinceDicAtIndex:0] cityDicAtIndex:0];
        _districtArr = [self districtArrayInCityDic:cityDic];
    }
    return _districtArr;
}

- (NSDictionary *)currentProvinceDic
{
    if (!_currentProvinceDic) {
        _currentProvinceDic = [self provinceDicAtIndex:0];
    }
    return _currentProvinceDic;
}

- (NSDictionary *)currentCityDic
{
    if (!_currentCityDic) {
        _currentCityDic = [self provinceDic:self.currentProvinceDic cityDicAtIndex:0];
    }
    return _currentCityDic;
}

@end
