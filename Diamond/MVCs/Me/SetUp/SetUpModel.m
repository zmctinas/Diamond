//
//  SetUpModel.m
//  Diamond
//
//  Created by Leon Hu on 15/8/14.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "SetUpModel.h"
#import "WebService+Shop.h"

@implementation SetUpModel

- (void)setUp:(SetUpEntity *)entity
{
    [self.webService setUp:entity completion:^(BOOL isSuccess, NSString *message, id result) {
        if (isSuccess && message.length<1)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:ADD_SHOP object:result];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
        }

    }];
}

@end
