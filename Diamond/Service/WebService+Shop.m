//
//  WebService+Shop.m
//  Diamond
//
//  Created by Pan on 15/7/14.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "WebService+Shop.h"
#import "ShopLicenseEntity.h"

@implementation WebService (Shop)

- (void)fetchHotShops:(RequestEntity *)requestInfo completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = requestInfo.keyValues;
    
    [self postWithMethodName:HOT_SHOP data:postData success:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            
            NSDictionary *dataDic = [JSON objectForKey:DATA];
            
            if (status == ResponseStatusSuccess)
            {
                if (![dataDic isEqual:[NSNull null]])
                {
                    
                    [ShopResponseEntity setupObjectClassInArray:^NSDictionary *{
                        return @{@"data" : NSStringFromClass([Shop class]),};
                    }];
                    
                    ShopResponseEntity *response = [ShopResponseEntity objectWithKeyValues:JSON];
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

- (void)fetchNewShops:(RequestEntity *)requestInfo completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = requestInfo.keyValues;
    
    [self postWithMethodName:GET_NEW_SHOP_LIST data:postData success:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            
            NSDictionary *dataDic = [JSON objectForKey:DATA];
            
            if (status == ResponseStatusSuccess)
            {
                if (![dataDic isEqual:[NSNull null]])
                {
                    
                    [ShopResponseEntity setupObjectClassInArray:^NSDictionary *{
                        return @{@"data" : NSStringFromClass([Shop class]),};
                    }];
                    
                    ShopResponseEntity *response = [ShopResponseEntity objectWithKeyValues:JSON];
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

- (void)fetchCategorShops:(RequestEntity *)requestInfo completion:(DMCompletionBlock)completion;
{
    NSDictionary *postData = requestInfo.keyValues;
    
    [self postWithMethodName:GET_SHOP_BY_CAT_ID data:postData success:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            
            NSDictionary *dataDic = [JSON objectForKey:DATA];
            
            if (status == ResponseStatusSuccess)
            {
                if (![dataDic isEqual:[NSNull null]])
                {
                    
                    [ShopResponseEntity setupObjectClassInArray:^NSDictionary *{
                        return @{@"data" : NSStringFromClass([Shop class]),};
                    }];
                    
                    ShopResponseEntity *response = [ShopResponseEntity objectWithKeyValues:JSON];
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

- (void)fetchShopDetailInfo:(RequestEntity *)requestInfo completion:(DMCompletionBlock)completion;
{
    NSDictionary *postData = requestInfo.keyValues;
    
    [self postWithMethodName:GET_SHOP_INFO data:postData success:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            
            NSDictionary *dataDic = [JSON objectForKey:DATA];
            
            if (status == ResponseStatusSuccess)
            {
                if (![dataDic isEqual:[NSNull null]])
                {
                    Shop *shop = [Shop objectWithKeyValues:dataDic];
                    completion(YES,nil,shop);
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

- (void)storeUpShop:(NSNumber *)shopID userID:(NSString *)userID completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:shopID,@"shop_id",userID,@"easemob", nil];
    
    [self postWithMethodName:ADD_SHOP_COLLEC data:postData success:^(id JSON) {
        
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

- (void)unStoreUpShop:(NSArray *)shopIDs userID:(NSString *)userID completion:(DMCompletionBlock)completion;
{
    NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:shopIDs,@"shop_id",userID,@"easemob", nil];
    
    [self postWithMethodName:DEL_SHOP_COLLEC data:postData success:^(id JSON) {
        
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

- (void)getActivityMenber:(NSNumber *)activityID completion:(DMCompletionBlock)completion;
{
    NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:activityID,@"activity_id", nil];
    
    [self postWithMethodName:GET_ACTIVITY_MENBER data:postData success:^(id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            if (status == ResponseStatusSuccess)
            {
                NSArray *dataArr = [JSON objectForKey:DATA];
                if (![dataArr isEqual:[NSNull null]])
                {
                    NSArray *shops = [Shop objectArrayWithKeyValuesArray:dataArr];
                    completion(YES,nil,shops);
                }
            }
            else if (status == ResponseStatusFailed)
            {
                NSDictionary *objDict = [JSON objectForKey:DATA];
                NSString *message = SERVER_ERROE_MESSAGE;
                if (![objDict isEqual:[NSNull null]])
                {
                    message = [objDict objectForKey:RESULT_MESSAGE];
                }
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];
}

- (void)setSale:(NSInteger)shopId
        goodsId:(NSString *)goodsId
         isSale:(BOOL)isSale
     completion:(DMCompletionBlock)completion
{
    NSDictionary *dict = @{
                           @"shop_id":@(shopId),
                           @"goods_id":goodsId,
                           @"is_sale":isSale?@1:@0
                           };
    [self postWithMethodName:SET_SALE data:dict success:^(id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            if (status == ResponseStatusSuccess)
            {
                completion(YES,nil,nil);
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *message = [[JSON objectForKey:DATA] objectForKey:RESULT_MESSAGE];
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];
}

- (void)updateShopInfo:(EditShopEntity *)entity
            completion:(DMCompletionBlock)completion
{
    NSDictionary *dict = entity.keyValues;
    [self postWithMethodName:UPDATE_SHOP data:dict success:^(id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            if (status == ResponseStatusSuccess)
            {
                completion(YES,nil,nil);
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *message = [[JSON objectForKey:DATA] objectForKey:RESULT_MESSAGE];
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];

}

- (void)getLicense:(NSString *)easemob
        completion:(DMCompletionBlock)completion
{
    NSDictionary *dict = @{
                           @"easemob":easemob
                           };
    
    [self postWithMethodName:GET_LICENSE data:dict success:^(id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            if (status == ResponseStatusSuccess)
            {
                ShopLicenseEntity *entity = [ShopLicenseEntity objectWithKeyValues:[JSON objectForKey:DATA]];
                completion(YES,nil,entity);
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *message = [[JSON objectForKey:DATA] objectForKey:RESULT_MESSAGE];
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];

}

- (void)upLicense:(UpLicenseEntity *)entity
       completion:(DMCompletionBlock)completion
{
    NSDictionary *dict = entity.keyValues;
    
    [self postWithMethodName:UP_LICENSE data:dict success:^(id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            if (status == ResponseStatusSuccess)
            {
                completion(YES,nil,nil);
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *message = [[JSON objectForKey:DATA] objectForKey:RESULT_MESSAGE];
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];

}

- (void)editLicense:(UpLicenseEntity *)entity
       completion:(DMCompletionBlock)completion
{
    NSDictionary *dict = entity.keyValues;
    
    [self postWithMethodName:UPDATE_LICENSE data:dict success:^(id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            if (status == ResponseStatusSuccess)
            {
                completion(YES,nil,nil);
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *message = [[JSON objectForKey:DATA] objectForKey:RESULT_MESSAGE];
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];

}

- (void)setUp:(SetUpEntity *)entity
   completion:(DMCompletionBlock)completion
{
    NSDictionary *dict = entity.keyValues;
    
    [self postWithMethodName:ADD_SHOP data:dict success:^(id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            if (status == ResponseStatusSuccess)
            {
                id data = [JSON objectForKey:DATA];
                NSNumber *shopId = [data objectForKey:@"shop_id"];
                completion(YES,nil,shopId);
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *message = [[JSON objectForKey:DATA] objectForKey:RESULT_MESSAGE];
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];

}

@end
