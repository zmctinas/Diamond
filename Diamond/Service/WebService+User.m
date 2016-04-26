//
//  WebService+User.m
//  Diamond
//
//  Created by Leon Hu on 15/8/4.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "WebService+User.h"
#import "Shop.h"
#import "WaresEntity.h"
@implementation WebService (User)

- (void)updateUserInfo:(NSString *)easemob
                  name:(NSString *)name
                   sex:(NSInteger)sex
                images:(NSArray *)array
            completion:(DMCompletionBlock)completion
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                           @"easemob":easemob,
                           @"user_name":name,
                           @"sex":@(sex)
                           }];
    if (array) {
        [dict setObject:@[
                         @{
                             @"image":[array firstObject],
                             @"imageExt":@"png"
                             }
                         ]
                forKey:@"images"];
    }
    [self postWithMethodName:UPDATE_USER_INFO data:dict success:^(id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            if (status == ResponseStatusSuccess)
            {
                NSDictionary *objDict = [JSON objectForKey:DATA];
                if (![objDict isEqual:[NSNull null]])
                {
                    NSString *photo = [objDict objectForKey:@"photo"];
                    completion(YES,nil,photo);
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

- (void)updateUserInfo:(NSString *)easemob province:(NSString *)province city:(NSString *)city completion:(DMCompletionBlock)completion
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"easemob":easemob,
                                                                                @"province":province,
                                                                                @"city":city
                                                                                }];
    [self postWithMethodName:UPDATE_USER_INFO data:dict success:^(id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            if (status == ResponseStatusSuccess)
            {
                NSDictionary *objDict = [JSON objectForKey:DATA];
                if (![objDict isEqual:[NSNull null]])
                {
                    completion(YES,nil,nil);
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

- (void)fetchCollectedShops:(RequestEntity *)requestInfo completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = requestInfo.keyValues;
    
    [self postWithMethodName:GET_SHOP_COLLEC data:postData success:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            
            NSDictionary *dataDic = [JSON objectForKey:DATA];
            
            if (status == ResponseStatusSuccess)
            {
                if (![dataDic isEqual:[NSNull null]])
                {
                    
                    [WareResponseEntity setupObjectClassInArray:^NSDictionary *{
                        return @{@"data" : NSStringFromClass([Shop class]),};
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

- (void)fetchCollectedWares:(RequestEntity *)requestInfo completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = requestInfo.keyValues;
    
    [self postWithMethodName:GET_GOODS_COLLEC data:postData success:^(id JSON) {
        
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


@end
