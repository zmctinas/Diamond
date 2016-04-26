//
//  WebService+withDrawl.m
//  Diamond
//
//  Created by daimangkeji on 16/4/25.
//  Copyright © 2016年 Pan. All rights reserved.
//

#import "WebService+withDrawl.h"

@implementation WebService (withDrawl)

/**
 *  请求可提现金额
 *
 *  @param easemob uid
 *  @param type 获取账号类型
 *  @param completion  .
 */
-(void)getAliAcountWitheasemob:(NSString*)easemob andType:(NSString*)type completion:(DMCompletionBlock)completion
{
    NSDictionary *postData = @{@"easemob":easemob,@"type":type};
    
    [self postWithMethodName:GET_Ali_Acount data:postData success:^(id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            if (status == ResponseStatusSuccess)
            {
                id jsonData = [JSON objectForKey:DATA];
                //                VCodeEntity *entity = [VCodeEntity objectWithKeyValues:jsonData];
                [[NSNotificationCenter defaultCenter]postNotificationName:GET_Ali_Acount object:nil userInfo:jsonData];
                NSLog(@"%@",jsonData);
                completion(YES,nil,nil);
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *msg = [[JSON objectForKey:DATA] objectForKey:RESULT_MESSAGE];
                NSLog(@"%@",msg);
                completion(YES,msg,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];
}

/**
 *  请求可提现金额
 *
 *  @param easemob uid
 *  @param type 提取方式
 *  @param realName 支付宝真实姓名
 *  @param payment 支付宝账号
 *  @param cash 提现金额
 *  @param completion  .
 */
-(void)requestExtractMoneyWitheasemob:(NSString*)easemob andType:(payAcountType)type andRealName:(NSString*)realName andPayment:(NSString*)payment andCash:(NSString*)cash completion:(DMCompletionBlock)completion
{
    NSDictionary *postData ;
    if (type == 0) {
        postData = @{@"easemob":easemob,
          @"type":@"ali_pay",
          @"real_name":realName,
          @"cash":cash,
          @"payment":payment
          };
    }else
    {
        postData = @{@"easemob":easemob,
                     @"type":@"wchat_pay",
                     
                     @"cash":cash,
                     @"payment":payment
                     };
    }
    NSLog(@"%@",postData);
    [self postWithMethodName:EXTRACT_MONEY data:postData success:^(id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            if (status == ResponseStatusSuccess)
            {
                id jsonData = [JSON objectForKey:DATA];
//                VCodeEntity *entity = [VCodeEntity objectWithKeyValues:jsonData];
                NSLog(@"%@",jsonData);
                
                completion(YES,nil,nil);
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *msg = [[JSON objectForKey:DATA] objectForKey:RESULT_MESSAGE];
                NSLog(@"%@",msg);
                completion(YES,msg,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];
}


/**
 *  请求可提现金额
 *
 *  @param easemob uid
 *  @param pages 提取方式
 *  @param completion  .
 */
-(void)getExtractMoneyListWitheasemob:(NSString*)easemob andPages:(NSNumber*)pages completion:(DMCompletionBlock)completion
{
    NSDictionary* dic = @{
                          @"easemob":easemob,
                          @"pages":pages,
                          };
    
    [self postWithMethodName:EXTRACT_MONEY_LIST data:dic success:^(id JSON) {
        if ([JSON isKindOfClass:[NSDictionary class]])
        {
            int status = [[JSON objectForKey:STATUS] intValue];
            if (status == ResponseStatusSuccess)
            {
                id jsonData = [JSON objectForKey:DATA];
                //                VCodeEntity *entity = [VCodeEntity objectWithKeyValues:jsonData];
                NSLog(@"%@",jsonData);
                
                completion(YES,nil,jsonData);
            }
            else if (status == ResponseStatusFailed)
            {
                NSString *msg = [[JSON objectForKey:DATA] objectForKey:RESULT_MESSAGE];
                NSLog(@"%@",msg);
                completion(YES,msg,nil);
            }
        }
    } failure:^(NSError *error, id JSON) {
        completion(NO,[error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey],nil);
    }];

}

@end
