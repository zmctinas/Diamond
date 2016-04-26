//
//  WebService+withDrawl.h
//  Diamond
//
//  Created by daimangkeji on 16/4/25.
//  Copyright © 2016年 Pan. All rights reserved.
//

#import "WebService.h"

typedef enum payAcountType {
    payAcountAli              = 0,
    payAcountWechat             = 1
}payAcountType;

@interface WebService (withDrawl)

/**
 *  请求可提现金额
 *
 *  @param easemob uid
 *  @param type 获取账号类型
 *  @param completion  .
 */
-(void)getAliAcountWitheasemob:(NSString*)easemob andType:(NSString*)type completion:(DMCompletionBlock)completion;

/**
 *  请求可提现金额
 *
 *  @param easemob uid
 *  @param type 提取方式
 *  @param realName 支付宝真实姓名
 *  @param payment 账号
 *  @param cash 提现金额
 *  @param completion  .
 */
-(void)requestExtractMoneyWitheasemob:(NSString*)easemob andType:(payAcountType)type andRealName:(NSString*)realName andPayment:(NSString*)payment andCash:(NSString*)cash completion:(DMCompletionBlock)completion;


/**
 *  请求可提现金额
 *
 *  @param easemob uid
 *  @param pages 提取方式
 *  @param completion  .
 */
-(void)getExtractMoneyListWitheasemob:(NSString*)easemob andPages:(NSNumber*)pages completion:(DMCompletionBlock)completion;


@end
