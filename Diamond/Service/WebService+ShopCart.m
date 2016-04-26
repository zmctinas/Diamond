//
//  WebService+ShopCart.m
//  Diamond
//
//  Created by Leon Hu on 15/9/20.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "WebService+ShopCart.h"
#import "ShopCartEntity.h"
#import "BuyWareEntity.h"

@implementation WebService (ShopCart)

- (void)getShopCart:(NSString *)easemob completion:(DMCompletionBlock)completion
{
    NSDictionary *dict = @{@"easemob":easemob};
    [self postWithMethodName:GET_SHOP_CART data:dict success:^(id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            if (status == ResponseStatusSuccess)
            {
                NSMutableArray *array = [ShopCartEntity objectArrayWithKeyValuesArray:[JSON objectForKey:DATA]];

                completion(YES,nil,array);
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

- (void)updateShopCart:(NSInteger)buyWaresId count:(NSInteger)buyCount completion:(DMCompletionBlock)completion
{
    NSDictionary *dict = @{
                           @"id":@(buyWaresId),
                           @"count_no":@(buyCount)
                               };
    [self postWithMethodName:UPDATE_SHOP_CART data:dict success:^(id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            if (status == ResponseStatusSuccess)
            {
                [ShopCartEntity setupObjectClassInArray:^NSDictionary *{
                    return @{@"list" : NSStringFromClass([BuyWareEntity class]),};
                }];
                NSArray *array = [ShopCartEntity objectArrayWithKeyValuesArray:[JSON objectForKey:DATA]];
                completion(YES,nil,array);
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

- (void)delFromShopCart:(NSInteger)buyWaresId completion:(DMCompletionBlock)completion
{
    NSDictionary *dict = @{
                           @"id":@(buyWaresId)
                           };
    [self postWithMethodName:DEL_FORM_SHOP_CART data:dict success:^(id JSON) {
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

- (void)addShopCart:(NSInteger)typeId easemob:(NSString *)easemob count:(NSInteger)buyCount completion:(DMCompletionBlock)completion
{
    NSDictionary *dict = @{
                           @"type_id":@(typeId),
                           @"easemob":easemob,
                           @"count_no":@(buyCount)
                           };
    [self postWithMethodName:ADD_SHOP_CART data:dict success:^(id JSON) {
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

@end
