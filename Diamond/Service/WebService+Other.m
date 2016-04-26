//
//  WebService+Other.m
//  Diamond
//
//  Created by Pan on 15/7/20.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "WebService+Other.h"
#import "CarouselEntity.h"
#import "CityResponse.h"
#import "RequestEntity.h"
#import "Shop.h"
#import "WaresEntity.h"
#import "WareResponseEntity.h"
#import "CityModel.h"
@implementation WebService (Other)

- (void)getCarouselWithLatitude:(double)latitude
                     longtitude:(double)longtituede
                       district:(NSString *)district
                     completion:(DMCompletionBlock)completion;
{
    NSString *city = [NSString stringWithFormat:@"%@市",[CityModel priorCity].cityName];
    NSDictionary *postData = @{@"lat":@(latitude),
                              @"lng":@(longtituede),
                               @"district":district,
                               @"city":city};
    
    [self postWithMethodName:GET_ACTIVITY data:postData success:^(id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            if (status == ResponseStatusSuccess)
            {
                NSArray *dataArray = [JSON objectForKey:DATA];
                if (![dataArray isEqual:[NSNull null]])
                {
                    NSArray *entities = [CarouselEntity objectArrayWithKeyValuesArray:dataArray];
                    completion(YES,nil,entities);
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

- (void)getCityList:(DMCompletionBlock)completion
{
    [self postWithMethodName:GET_CITY_LIST data:nil success:^(id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            if (status == ResponseStatusSuccess)
            {
                NSDictionary *dataDic = [JSON objectForKey:DATA];
                if (![dataDic isEqual:[NSNull null]])
                {
                    [CityResponse setupObjectClassInArray:^NSDictionary *{
                        return @{@"city" : NSStringFromClass([City class]),
                                 @"hot" : NSStringFromClass([City class])};
                    }];
                    
                    CityResponse *response = [CityResponse objectWithKeyValues:dataDic];
                    completion(YES,nil,response);
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

- (void)search:(RequestEntity *)requestInfo completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = requestInfo.keyValues;
    
    [self postWithMethodName:SEARCH data:postData success:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            
            NSDictionary *dataDic = [JSON objectForKey:DATA];
            
            if (status == ResponseStatusSuccess)
            {
                if (![dataDic isEqual:[NSNull null]])
                {
                    if (requestInfo.type == SearchTypeShop)
                    {
                        [WareResponseEntity setupObjectClassInArray:^NSDictionary *{
                            return @{@"data" : NSStringFromClass([Shop class]),};
                        }];
                    }else if (requestInfo.type == SearchTypeWare)
                    {
                        [WareResponseEntity setupObjectClassInArray:^NSDictionary *{
                            return @{@"data" : NSStringFromClass([WaresEntity class]),};
                        }];
                    }
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


- (void)getDistrict:(NSString *)cityName completion:(DMCompletionBlock)completion;
{
    NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:cityName,@"cityName", nil];
    
    [self postWithMethodName:GET_DISTRICTS_LIST data:postData success:^(id JSON) {
        
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            
            NSArray *dataArr = [JSON objectForKey:DATA];
            
            if (status == ResponseStatusSuccess)
            {
                if (![dataArr isEqual:[NSNull null]])
                {
                    NSMutableArray *result = [NSMutableArray array];
                    for (NSDictionary *dic in dataArr)
                    {
                        [result addObject:[dic objectForKey:@"district"]];
                    }
                    completion(YES,nil,result);
                }
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *message = @"无法获取区域信息";
                completion(YES,message,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];
}
@end
