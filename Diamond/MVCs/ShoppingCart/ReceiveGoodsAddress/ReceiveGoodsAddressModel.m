//
//  ReceiveGoodsAddressModel.m
//  Diamond
//
//  Created by Leon Hu on 15/8/31.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ReceiveGoodsAddressModel.h"
#import "WebService+Order.h"

@implementation ReceiveGoodsAddressModel

- (void)addAddress:(ReceiveGoodsAddressEntity *)entity
{
    [self.webService addAddress:entity
                     completion:^(BOOL isSuccess, NSString *message, id result)
     {
         if (isSuccess && message.length<1)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:ADD_ADDRESS object:result];
         }
         else
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
         }
     }];
}

- (void)updateAddress:(ReceiveGoodsAddressEntity *)entity
{
    [self.webService updateAddress:entity
                        completion:^(BOOL isSuccess, NSString *message, id result)
     {
         if (isSuccess && message.length<1)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:UPDATE_ADDRESS object:result];
         }
         else
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
         }
     }];
}

- (void)deleteAddress:(NSString *)addressId
{
    [self.webService deleteAddress:addressId
                        completion:^(BOOL isSuccess, NSString *message, id result)
     {
         if (isSuccess && message.length<1)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:DELETE_ADDRESS object:result];
         }
         else
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
         }
     }];
}

- (void)getAddress
{
    NSString *easemob =  [[UserSession sharedInstance] currentUser].easemob;
    [self.webService getAddress:easemob
                     completion:^(BOOL isSuccess, NSString *message, id result)
     {
         if (isSuccess && message.length<1)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:GET_ADDRESS object:result];
         }
         else
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
         }
     }];
}

@end
