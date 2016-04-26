//
//  WebService+Order.m
//  Diamond
//
//  Created by Pan on 15/9/1.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "WebService+Order.h"
#import "WareResponseEntity.h"
#import "OrderListEntity.h"
#import "EditPriceRespone.h"
#import "OrderIndexEntity.h"
@implementation WebService (Order)

- (void)fetchStatisticalData:(NSString *)easemob completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = @{@"easemob" : easemob};
    
    [self postWithMethodName:GET_TOTAL_INFO data:postData success:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            
            NSDictionary *dataDic = [JSON objectForKey:DATA];
            
            if (status == ResponseStatusSuccess)
            {
                if (![dataDic isEqual:[NSNull null]])
                {
                    NSLog(@"%@",dataDic);
                    OrderIndexEntity *entity = [OrderIndexEntity objectWithKeyValues:dataDic];
                    completion(YES,nil,entity);
                }
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *message = SERVER_ERROE_MESSAGE;
                if (![dataDic isEqual:[NSNull null]])
                {
                    message = [dataDic objectForKey:RESULT_MESSAGE];
                }
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];
}


- (void)fetchBuyerOrderList:(OrderRequestEntity *)requestEntity completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = requestEntity.keyValues;
    
    [self postWithMethodName:GET_BUYER_ORDER_LIST data:postData success:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            
            NSDictionary *dataDic = [JSON objectForKey:DATA];
            
            if (status == ResponseStatusSuccess)
            {
                if (![dataDic isEqual:[NSNull null]])
                {
                    [WareResponseEntity setupObjectClassInArray:^NSDictionary *{
                        return @{@"data" : NSStringFromClass([OrderListEntity class]),};
                    }];
                    [OrderListEntity setupObjectClassInArray:^NSDictionary *{
                        return @{@"list" : NSStringFromClass([OrderWare class]),};
                    }];
                    WareResponseEntity *response = [WareResponseEntity objectWithKeyValues:JSON];
                    completion(YES,nil,response);
                }
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *message = SERVER_ERROE_MESSAGE;
                if (![dataDic isEqual:[NSNull null]])
                {
                    message = [dataDic objectForKey:RESULT_MESSAGE];
                }
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];
}

- (void)fetchSellerOrderList:(OrderRequestEntity *)requestEntity completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = requestEntity.keyValues;
    
    [self postWithMethodName:GET_SELLER_ORDER_LIST data:postData success:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            
            NSDictionary *dataDic = [JSON objectForKey:DATA];
            
            if (status == ResponseStatusSuccess)
            {
                if (![dataDic isEqual:[NSNull null]])
                {
                    [WareResponseEntity setupObjectClassInArray:^NSDictionary *{
                        return @{@"data" : NSStringFromClass([OrderListEntity class]),};
                    }];
                    [OrderListEntity setupObjectClassInArray:^NSDictionary *{
                        return @{@"list" : NSStringFromClass([OrderWare class]),};
                    }];
                    WareResponseEntity *response = [WareResponseEntity objectWithKeyValues:JSON];
                    completion(YES,nil,response);
                }
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *message = SERVER_ERROE_MESSAGE;
                if (![dataDic isEqual:[NSNull null]])
                {
                    message = [dataDic objectForKey:RESULT_MESSAGE];
                }
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];
}

- (void)fetchOrderDetail:(NSString *)orderID completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:orderID,@"out_trade_no", nil];
    
    [self postWithMethodName:GET_ORDER_DETAIL data:postData success:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            
            NSDictionary *dataDic = [JSON objectForKey:DATA];
            
            if (status == ResponseStatusSuccess)
            {
                if (![dataDic isEqual:[NSNull null]])
                {
                    [OrderDetailEntity setupObjectClassInArray:^NSDictionary *{
                        return @{@"list" : NSStringFromClass([OrderWare class]),};
                    }];
                    OrderDetailEntity *response = [OrderDetailEntity objectWithKeyValues:dataDic];
                    completion(YES,nil,response);
                }
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *message = SERVER_ERROE_MESSAGE;
                if (![dataDic isEqual:[NSNull null]])
                {
                    message = [dataDic objectForKey:RESULT_MESSAGE];
                }
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];
}

- (void)fetchWechatPayParameter:(NSString *)orderID completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:orderID,@"out_trade_no", nil];
    
    [self postWithMethodName:GET_PREPAY_ID data:postData success:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            
            NSDictionary *dataDic = [JSON objectForKey:DATA];
            
            if (status == ResponseStatusSuccess)
            {
                if (![dataDic isEqual:[NSNull null]])
                {
                    DMWechatPrepayEntity *response = [DMWechatPrepayEntity objectWithKeyValues:dataDic];
                    completion(YES,nil,response);
                }
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *message = SERVER_ERROE_MESSAGE;
                if (![dataDic isEqual:[NSNull null]])
                {
                    message = [dataDic objectForKey:RESULT_MESSAGE];
                }
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];

}

- (void)commitOrder:(OrderSubmitEntity *)entity cartList:(NSArray *)cartList completion:(DMCompletionBlock)completion;
{
    NSMutableDictionary *postData = entity.keyValues;
    if ([cartList count])
    {
        [postData setObject:cartList forKey:@"cartList"];
    }
    [self postWithMethodName:ORDER_SUBMITE data:postData success:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            
            NSDictionary *dataDic = [JSON objectForKey:DATA];
            
            if (status == ResponseStatusSuccess)
            {
                if (![dataDic isEqual:[NSNull null]])
                {
                    OrderDetailEntity *response = [OrderDetailEntity objectWithKeyValues:dataDic];
                    NSArray *orderWares = [OrderWare objectArrayWithKeyValuesArray:[dataDic objectForKey:@"body"]];
                    response.list = orderWares;
                    completion(YES,nil,response);
                }
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *message = SERVER_ERROE_MESSAGE;
                if (![dataDic isEqual:[NSNull null]])
                {
                    message = [dataDic objectForKey:RESULT_MESSAGE];
                }
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];

}

- (void)getAddress:(NSString *)easemob completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = @{
                                @"easemob":easemob
                            };
    
    [self postWithMethodName:GET_ADDRESS data:postData success:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            
            NSDictionary *dataDic = [JSON objectForKey:DATA];
            
            if (status == ResponseStatusSuccess)
            {
                if (![dataDic isEqual:[NSNull null]])
                {
                    NSArray *response = [ReceiveGoodsAddressEntity objectArrayWithKeyValuesArray:dataDic];
                    completion(YES,nil,response);
                }
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *message = SERVER_ERROE_MESSAGE;
                if (![dataDic isEqual:[NSNull null]])
                {
                    message = [dataDic objectForKey:RESULT_MESSAGE];
                }
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];
}

- (void)addAddress:(ReceiveGoodsAddressEntity *)entity completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = entity.keyValues;
    
    [self postWithMethodName:ADD_ADDRESS data:postData success:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            
            
            if (status == ResponseStatusSuccess)
            {
                NSNumber *addressId = [JSON objectForKey:DATA];
                if (![addressId isEqual:[NSNull null]])
                {
                    completion(YES,nil,addressId);
                }
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *message = SERVER_ERROE_MESSAGE;
//                if (![dataDic isEqual:[NSNull null]])
//                {
//                    message = [dataDic objectForKey:RESULT_MESSAGE];
//                }
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];
}

- (void)updateAddress:(ReceiveGoodsAddressEntity *)entity completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = entity.keyValues;
    
    [self postWithMethodName:UPDATE_ADDRESS data:postData success:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            
            if (status == ResponseStatusSuccess)
            {
                completion(YES,nil,entity);
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *message = SERVER_ERROE_MESSAGE;
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];
}

- (void)deleteAddress:(NSString *)addressId completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = @{@"id":addressId};
    
    [self postWithMethodName:DELETE_ADDRESS data:postData success:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            
            if (status == ResponseStatusSuccess)
            {
                    completion(YES,nil,addressId);
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *message = SERVER_ERROE_MESSAGE;
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];
}

- (void)conformGetted:(NSString *)orderID completion:(DMCompletionBlock)completion
{
    [self changeOrderWithAPI:CONFORM_ORDER orderID:orderID completion:completion];
}

- (void)conformSendded:(NSString *)orderID completion:(DMCompletionBlock)completion
{
    [self changeOrderWithAPI:CONFORM_SEND orderID:orderID completion:completion];
}

- (void)cancleOrder:(NSString *)orderID completion:(DMCompletionBlock)completion
{
    [self changeOrderWithAPI:CLOSE_ORDER orderID:orderID completion:completion];
}

- (void)editPostage:(NSNumber *)price order:(NSString *)orderID completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:orderID,@"out_trade_no",
                              price,@"delivery_fee",
                              nil];
    [self updateOrder:postData completion:completion];
}

- (void)editTotleFee:(NSNumber *)totleFee order:(NSString *)orderID completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:orderID,@"out_trade_no",
                              totleFee,@"goods_fee",
                              nil];
    [self updateOrder:postData completion:completion];
}

#pragma mark - Private
- (void)updateOrder:(NSDictionary *)postData completion:(DMCompletionBlock)completion
{
    [self postWithMethodName:UPDATE_ORDER data:postData success:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            NSDictionary *dataDic = [JSON objectForKey:DATA];

            if (status == ResponseStatusSuccess)
            {
                EditPriceRespone *entity = [EditPriceRespone objectWithKeyValues:dataDic];
                completion(YES,nil,entity);
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *message = SERVER_ERROE_MESSAGE;
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];

}

- (void)changeOrderWithAPI:(NSString *)APIPath orderID:(NSString *)orderID completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = @{@"out_trade_no":orderID};
    
    [self postWithMethodName:APIPath data:postData success:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            
            if (status == ResponseStatusSuccess)
            {
                completion(YES,nil,nil);
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *message = SERVER_ERROE_MESSAGE;
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];
}

@end
