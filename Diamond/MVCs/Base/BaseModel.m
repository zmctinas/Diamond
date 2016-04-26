//
//  BaseModel.m
//  Diamond
//
//  Created by Pan on 15/7/13.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

-(WebService *)webService
{
    if (!_webService) {
        _webService = [WebService service];
    }
    return _webService;
}

- (NSString *)priorDistrict
{
    NSString *firstChoice = [UserSession sharedInstance].choosedDistrict;
    
    //如果用户手动选择了区域，则用他选择的区域。
    //否则，用定位的当前区域。
    //如果定位也没有，则使用首页获取城市中地区列表中的第一个。
    
    NSString *returnDistrict = @"全城";
    return IS_NULL(firstChoice) ? returnDistrict : firstChoice;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
