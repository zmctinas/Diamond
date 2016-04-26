//
//  DMWechatPayManager.m
//  Diamond
//
//  Created by Pan on 15/9/6.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "DMWechatPayManager.h"
#import "ApiXml.h"
#import "WXUtil.h"
#import "WebService+Order.h"
#import "payRequsestHandler.h"

@implementation DMWechatPayManager

static DMWechatPayManager *sharedManager = nil;

+ (DMWechatPayManager *)sharedManager
{
    static dispatch_once_t onceQueue;
    dispatch_once(&onceQueue, ^{
        sharedManager = [[DMWechatPayManager alloc] init];
    });
    return sharedManager;
}

- (void)payWithPrepayEntity:(DMWechatPrepayEntity *)entity
{
    
    //由于服务端签名失败，所以只取服务端的prepayID 其他工作都在客户端完成
//===========================================================================================
//    NSMutableDictionary *signParams = [self localSign:entity];
//    NSMutableString *stamp  = [signParams objectForKey:@"timestamp"];
//    PayReq *req             = [[PayReq alloc] init];
//    req.openID              = [signParams objectForKey:@"appid"];
//    req.partnerId           = [signParams objectForKey:@"partnerid"];
//    req.prepayId            = [signParams objectForKey:@"prepayid"];
//    req.nonceStr            = [signParams objectForKey:@"noncestr"];
//    req.timeStamp           = stamp.intValue;
//    req.package             = [signParams objectForKey:@"package"];
//    req.sign                = [signParams objectForKey:@"sign"];
//    
//    [WXApi sendReq:req];
//===========================================================================================
    
    

//==============================如果服务端sign可用，那么用下面这一段代码来付款======================
    
    PayReq *req   = [[PayReq alloc] init];
    req.openID    = entity.appid;
    req.partnerId = entity.partnerid;
    req.prepayId  = entity.prepayid;
    req.nonceStr  = entity.noncestr;
    req.timeStamp = entity.timestamp.intValue;
    req.package   = @"Sign=WXPay";
    req.sign      = entity.sign;
    
    [WXApi sendReq:req];
//===========================================================================================

    //日志输出
    DLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
    
}

- (NSMutableDictionary *)localSign:(DMWechatPrepayEntity *)entity
{
    //获取到prepayid后进行第二次签名
    NSString    *package, *time_stamp, *nonce_str;
    //设置支付参数
    time_t now;
    time(&now);
    time_stamp  = [NSString stringWithFormat:@"%ld", now];
    nonce_str	= [WXUtil md5:time_stamp];
    
    package         = @"Sign=WXPay";
    //第二次签名参数列表
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject:entity.appid        forKey:@"appid"];
    [signParams setObject:entity.noncestr    forKey:@"noncestr"];
    [signParams setObject:package             forKey:@"package"];
    [signParams setObject:entity.partnerid       forKey:@"partnerid"];
    [signParams setObject:time_stamp          forKey:@"timestamp"];
    [signParams setObject:entity.prepayid    forKey:@"prepayid"];
    
    //生成签名
    NSString *sign  = [self createMd5Sign:signParams];
    
    //添加签名
    [signParams setObject:sign         forKey:@"sign"];
    return signParams;
}

- (NSString*)createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", PARTNER_ID];
    //得到MD5 sign签名
    NSString *md5Sign =[WXUtil md5:contentString];
    
    //输出Debug Info
    
    return md5Sign;
}

#pragma mark - WXApiDelegate

-(void)onResp:(BaseResp*)resp
{
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    BOOL isSuccess;
    if([resp isKindOfClass:[PayResp class]])
    {
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付成功！";
                isSuccess = YES;
                DLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
            default:
                strMsg = @"支付失败！";
                isSuccess = NO;
                DLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:WECHATPAY_RESULT object:@(isSuccess)];
}


@end
