//
//  withDralModel.m
//  Diamond
//
//  Created by daimangkeji on 16/4/25.
//  Copyright © 2016年 Pan. All rights reserved.
//

#import "withDralModel.h"


@implementation withDralModel

#pragma mark - getter and setter

-(NSMutableArray*)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - public

-(void)getAliAcount
{
    NSString* easemob = [[UserSession sharedInstance] currentUser].easemob;
    [self.webService getAliAcountWitheasemob:easemob andType:@"ali_pay" completion:^(BOOL isSuccess, NSString *message, id result) {
        NSLog(@"%@",message);
        if (isSuccess && message.length<1)
        {
            
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
        }
    }];
}

-(void)askMoney
{
    NSString* easemob = [[UserSession sharedInstance] currentUser].easemob;
    NSString* payment = self.AcountType == 0 ? self.aliAount : self.wechat;
    [self.webService requestExtractMoneyWitheasemob:easemob andType:self.AcountType andRealName:self.realName andPayment:payment andCash:self.cash completion:^(BOOL isSuccess, NSString *message, id result) {
        if (isSuccess && message.length<1)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:EXTRACT_MONEY object:nil userInfo:@{}];
        }else {
            NSLog(@"%@",message);
            [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
        }
    }];
}

-(void)getRecord
{
    NSString* easemob = [[UserSession sharedInstance] currentUser].easemob;
    [self.webService getExtractMoneyListWitheasemob:easemob andPages:self.pages completion:^(BOOL isSuccess, NSString *message, id result) {
        if (isSuccess && message.length<1)
        {
            NSArray* arr = result;
            if ([arr count]) {
                if (self.pages.integerValue == 1) {
                    [self.dataSource removeAllObjects];
                }
                for (NSDictionary* dic in arr) {
                    if ([dic isKindOfClass:[NSDictionary class]]) {
                        withDralEntity* entity = [[withDralEntity alloc]init];
                        [entity setValuesForKeysWithDictionary:dic];
                        [self.dataSource addObject:entity];
                    }
                }
                [[NSNotificationCenter defaultCenter]postNotificationName:EXTRACT_MONEY_LIST object:nil userInfo:@{}];
            }
        }
        else {
            [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
        }
    }];
}

@end
