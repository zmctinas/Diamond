//
//  DMWechatPayManager.h
//  Diamond
//
//  Created by Pan on 15/9/6.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

//#define APP_ID          @"wx894838689c6c4d16"               //APPID
//#define APP_SECRET      @"2f7b26befb72db5dbc2dbdb8fcbabe03" //appsecret
////商户号，填写商户对应参数
//#define MCH_ID          @"1253058001"
////商户API密钥，填写相应参数
//#define PARTNER_ID      @"7d868aa61297bd65ea3f19ca6016540a"
////支付结果回调页面
//#define NOTIFY_URL      @"http://wxpay.weixin.qq.com/pub_v2/pay/notify.v2.php"


@class DMWechatPrepayEntity;

@interface DMWechatPayManager : NSObject<WXApiDelegate>

+ (DMWechatPayManager *)sharedManager;

- (void)payWithPrepayEntity:(DMWechatPrepayEntity *)entity;

@end
