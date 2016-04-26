//
//  OrderIndexModel.m
//  Diamond
//
//  Created by Pan on 15/9/15.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "OrderIndexModel.h"
#import "WebService+Order.h"
#import "UserInfo.h"
@implementation OrderIndexModel

- (void)giveMeStatisticalData
{
    [self.webService fetchStatisticalData:[UserSession sharedInstance].currentUser.easemob completion:^(BOOL isSuccess, NSString *message, id result) {
        if (isSuccess && !message)
        {
            [UserInfo info].statistics = result;
            [[NSNotificationCenter defaultCenter] postNotificationName:GET_TOTAL_INFO object:nil];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:nil];
        }
    }];
}


- (OrderIndexEntity *)statistics
{
    _statistics = [UserInfo info].statistics;
    return _statistics;
}
@end
