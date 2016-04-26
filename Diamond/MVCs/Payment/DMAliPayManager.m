//
//  DMAliPayManager.m
//  Diamond
//
//  Created by Pan on 15/8/27.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "DMAliPayManager.h"
#import "DataSigner.h"
#import "URLConstant.h"
@interface Order : NSObject

@property(nonatomic, copy) NSString * partner;
@property(nonatomic, copy) NSString * seller;
@property(nonatomic, copy) NSString * tradeNO;

@property(nonatomic, copy) NSString * amount;
@property(nonatomic, copy) NSString * notifyURL;

@property(nonatomic, copy) NSString * service;
@property(nonatomic, copy) NSString * paymentType;
@property(nonatomic, copy) NSString * inputCharset;
@property(nonatomic, copy) NSString * itBPay;
@property(nonatomic, copy) NSString * showUrl;

@property(nonatomic, copy) NSString * productName;
@property(nonatomic, copy) NSString * productDescription;

/*
 @property(nonatomic, copy) NSString * rsaDate;//可选
 @property(nonatomic, copy) NSString * appID;//可选
 
 @property(nonatomic, readonly) NSMutableDictionary * extraParams;
 */

@end

@implementation Order

- (NSString *)description {
    NSMutableString * discription = [NSMutableString string];
    if (self.partner) {
        [discription appendFormat:@"partner=\"%@\"", self.partner];
    }
    
    if (self.seller) {
        [discription appendFormat:@"&seller_id=\"%@\"", self.seller];
    }
    if (self.tradeNO) {
        [discription appendFormat:@"&out_trade_no=\"%@\"", self.tradeNO];
    }
    
    if (self.amount) {
        [discription appendFormat:@"&total_fee=\"%@\"", self.amount];
    }
    if (self.notifyURL) {
        [discription appendFormat:@"&notify_url=\"%@\"", self.notifyURL];
    }
    
    if (self.service) {
        [discription appendFormat:@"&service=\"%@\"",self.service];//mobile.securitypay.pay
    }
    if (self.paymentType) {
        [discription appendFormat:@"&payment_type=\"%@\"",self.paymentType];//1
    }
    
    if (self.inputCharset) {
        [discription appendFormat:@"&_input_charset=\"%@\"",self.inputCharset];//utf-8
    }
    if (self.itBPay) {
        [discription appendFormat:@"&it_b_pay=\"%@\"",self.itBPay];//30m
    }
    if (self.showUrl) {
        [discription appendFormat:@"&show_url=\"%@\"",self.showUrl];//m.alipay.com
    }
    
    if (self.productName) {
        [discription appendFormat:@"&subject=\"%@\"", self.productName];
    }
    
    if (self.productDescription) {
        [discription appendFormat:@"&body=\"%@\"", self.productDescription];
    }
    
    /*
     [discription appendFormat:@"&sign_date=\"%@\"",@"2015-01-05 15:46:30"];
     
     if (self.rsaDate) {
     [discription appendFormat:@"&sign_date=\"%@\"",self.rsaDate];
     }
     if (self.appID) {
     [discription appendFormat:@"&app_id=\"%@\"",self.appID];
     }
     
     for (NSString * key in [self.extraParams allKeys]) {
     [discription appendFormat:@"&%@=\"%@\"", key, [self.extraParams objectForKey:key]];
     }
     */
    
    return discription;
}

@end



@implementation DMAliPayManager

+ (void)payOrder:(NSString*)orderNum withMoney:(CGFloat)price subject:(NSString*)name  completion:(CompletionBlock)completionBlock
{
    
    CGFloat payPrice = price;
    
    NSString *partner = @"2088711404436433";
    NSString *seller = @"hangzhoudaimang@163.com";
    NSString *privateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAMyIo72RYxMd1Sz7MrvFcgb2e7aC5PSeVt6Y/2F2H0UcS6wJXIvUHIRF7oiGf0VcoqaAgYldpFAaWh9XTQ/Ej9I8Lrsl6AtpAv31igjCtXrwtVUob5ocYsZcOAiFu/V16lcvls3xGLbqF18piKVP4B93AaCACrE8soWGDeJMQdkZAgMBAAECgYEAuq3cBSG1c7U+5JdBbvB/aqt9rs85easrTnAGZ0YQtFtnFdZViapHfNL3K9TWRNCQA7g2gtHdLt9eckyUIVgeiviW4GrDcS8SMDCd7jso1pc/EcKHo9iieZdyTm46VcGCrVHLjPGhnBJE83JPN0CkDj6/LxeWdzfkbRhFxBXjOIECQQD7vvn0M8IxfavHjSVPg2d6pi4trk1vIIE1SvnRkWEVULEth6f+6EovpR4UReub8cfwBW8AJ3mIcLbXqPHziS+tAkEAz/1tts5tXJ7mdC85R+Nax3zqgf2Q4Nz7zinfsTfzIfEzbW1GWPqT4V70HlKJbWuOZjrkmwPIig9RlqemlOGMnQJAavLtOYOrol7jVXlvOmJ22bIzuBBusSE8AyoBC7kZZ3bKbq9M/YwtyCP7rV0vBScoa53DVGtwxDguVVxevbmwWQJBALn9iVfYvqj9m104QYPMhogvZ1F4206Jrk8M2PET9EJc+70V47t70DPQAoL/Ec+cR8mZToZkWrdCvZX4M5mdHG0CQQCczfCNnzyYZaxPLKVMkDZWdp9mNHTvmyLaWV2V3b3ULjqQ3GWWGJOcp2O2+zDabr3bS7ig3umN9g8g43Giy8xa";
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = orderNum; //订单ID（由商家自行制定）
    
    order.productName = [NSString stringWithFormat:@"代忙科技-%@",name]; //商品标题
    order.productDescription = name; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",payPrice]; //商品价格
    order.notifyURL = ALIPAY_CALLBACK; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在Info.plist定义URL types
    NSString *appScheme = @"payDiamond";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    //    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:completionBlock];
    }
}

+ (BOOL)isSuccessPayment:(NSDictionary *)resultDic
{
    NSNumber *resulCode = [resultDic objectForKey:@"resultStatus"];
    return ([resulCode integerValue] == 9000);//9000代表订单支付成功
}

@end
