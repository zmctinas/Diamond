//
//  WebService+Wares.m
//  Diamond
//
//  Created by Pan on 15/7/27.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "WebService+Wares.h"

@implementation WebService (Wares)

- (void)fetchDisCountGoods:(RequestEntity *)requestInfo completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = requestInfo.keyValues;
    
    [self postWithMethodName:GET_SPECAIL_OFFER_GOODS data:postData success:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            
            NSDictionary *dataDic = [JSON objectForKey:DATA];
            
            if (status == ResponseStatusSuccess)
            {
                if (![dataDic isEqual:[NSNull null]])
                {
                    
                    [WareResponseEntity setupObjectClassInArray:^NSDictionary *{
                        return @{@"data" : NSStringFromClass([WaresEntity class]),};
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


- (void)fetchRecommodGoods:(RequestEntity *)requestInfo completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = requestInfo.keyValues;
    
    [self postWithMethodName:GET_RECOMMEND data:postData success:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            
            NSDictionary *dataDic = [JSON objectForKey:DATA];
            
            if (status == ResponseStatusSuccess)
            {
                if (![dataDic isEqual:[NSNull null]])
                {
                    
                    [WareResponseEntity setupObjectClassInArray:^NSDictionary *{
                        return @{@"data" : NSStringFromClass([WaresEntity class]),};
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

- (void)fetchMyShopGoods:(RequestEntity *)requestInfo completion:(DMCompletionBlock)completion;
{
    NSDictionary *postData = requestInfo.keyValues;
    
    [self postWithMethodName:GET_SHOP_GOODS data:postData success:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            
            NSDictionary *dataDic = [JSON objectForKey:DATA];
            
            if (status == ResponseStatusSuccess)
            {
                if (![dataDic isEqual:[NSNull null]])
                {
                    NSArray *wares = [WaresEntity objectArrayWithKeyValuesArray:dataDic];
                    completion(YES,nil,wares);
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

- (void)fetchAllMyShopGoods:(RequestEntity *)requestInfo completion:(DMCompletionBlock)completion;
{
    requestInfo.all = YES;
    [self fetchMyShopGoods:requestInfo completion:completion];
}

- (void)fetchGoodInfo:(RequestEntity *)requestInfo completion:(DMCompletionBlock)completion;
{
    NSDictionary *postData = requestInfo.keyValues;
    
    [self postWithMethodName:GET_GOODS_INFO data:postData success:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            
            NSDictionary *dataDic = [JSON objectForKey:DATA];
            
            if (status == ResponseStatusSuccess)
            {
                if (![dataDic isEqual:[NSNull null]])
                {
                    WaresEntity *ware = [WaresEntity objectWithKeyValues:dataDic];
                    completion(YES,nil,ware);
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

- (void)storeUpWare:(NSString *)wareID userID:(NSString *)userID completion:(DMCompletionBlock)completion;
{
    NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:wareID,@"goods_id",userID,@"easemob", nil];
    
    [self postWithMethodName:ADD_GOODS_COLLEC data:postData success:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            
            NSDictionary *dataDic = [JSON objectForKey:DATA];
            
            if (status == ResponseStatusSuccess)
            {
                completion(YES,nil,nil);
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

- (void)unStoreUpWare:(NSArray *)wareIDs userID:(NSString *)userID completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:wareIDs,@"goods_id",userID,@"easemob", nil];
    
    [self postWithMethodName:DEL_GOODS_COLLEC data:postData success:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            
            NSDictionary *dataDic = [JSON objectForKey:DATA];
            
            if (status == ResponseStatusSuccess)
            {
                completion(YES,nil,nil);
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

- (void)addNewGoods:(AddGoodsEntity *)entity completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = entity.keyValues;

    [self postWithMethodName:ADD_GOODS data:postData success:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            
            NSDictionary *dataDic = [JSON objectForKey:DATA];
            
            if (status == ResponseStatusSuccess)
            {
                WaresEntity *entity = [WaresEntity objectWithKeyValues:[dataDic objectForKey:@"goodsinfo"]];
                completion(YES,nil,entity);
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

- (void)updateGoods:(UpdateGoodsEntity *)entity completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = entity.keyValues;
    
    [self postWithMethodName:UPDATE_GOODS data:postData success:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            
            NSDictionary *dataDic = [JSON objectForKey:DATA];
            
            if (status == ResponseStatusSuccess)
            {
                completion(YES,nil,nil);
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


- (void)addPromotion:(NSArray *)goodsIds shopId:(NSInteger)shopId  discount:(NSNumber *)discount startTime:(NSString *)startTime stopTime:(NSString *)stopTime completion:(DMCompletionBlock)completion
{
    NSDictionary *dict = goodsIds.keyValues;
    NSDictionary *postData = @{
                               @"list":dict,
                               @"discount":discount,
                               @"shop_id":@(shopId),
                               @"start_time":startTime,
                               @"end_time":stopTime,
                               };
    
    [self postWithMethodName:ADD_PROMOTION data:postData success:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            
            if (status == ResponseStatusSuccess)
            {
                completion(YES,nil,nil);
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *message = [JSON objectForKey:@"ErrMsg"];
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];
}

- (void)delPromotion:(NSString *)goodsId completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = @{
                               @"goods_id":goodsId
                               };
    
    [self postWithMethodName:DEL_PROMOTION data:postData success:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            
            if (status == ResponseStatusSuccess)
            {
                completion(YES,nil,nil);
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *message = [JSON objectForKey:@"ErrMsg"];
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];
}

- (void)delGoods:(NSString *)goodsId completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = @{
                               @"goods_id":goodsId
                               };
    
    [self postWithMethodName:DEL_GOODS data:postData success:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            
            if (status == ResponseStatusSuccess)
            {
                completion(YES,nil,nil);
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *message = [JSON objectForKey:@"ErrMsg"];
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];
}

@end
