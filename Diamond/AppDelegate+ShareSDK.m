//
//  AppDelegate+ShareSDK.m
//  Diamond
//
//  Created by ShawnPan on 15/8/11.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "AppDelegate+ShareSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "TencentOpenAPI/QQApiInterface.h"
#import "PSShareSDKManager.h"
#import "Macros.h"

#define SHARESDK_APPKEY @"982e64ba7551"


#define WEIXIN_APPID  @"wx894838689c6c4d16"
#define WEIXIN_SECRET @"2f7b26befb72db5dbc2dbdb8fcbabe03"

#define QQ_APPID      @"1104808644"
#define QQ_APPKEY     @"tsYtduPIl9nlGCYa"

#define WEIBO_APPKEY @"3668360937"
#define WEIBO_SECRET @"dbcfeb030dbc1e0035121738907fe1fe"

#define DAIMANG_HOME_PAGE @"http://www.daimang.com"




#define SHARESDK_APPKEY @"982e64ba7551"

@implementation AppDelegate (ShareSDK)

- (void)shareSDKApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
{
    [ShareSDK registerApp:SHARESDK_APPKEY];
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:WEIBO_APPKEY
                               appSecret:WEIBO_SECRET
                             redirectUri:DAIMANG_HOME_PAGE];
    
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:WEIBO_APPKEY
                                appSecret:WEIBO_SECRET
                              redirectUri:DAIMANG_HOME_PAGE
                              weiboSDKCls:[WeiboSDK class]];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:QQ_APPID
                           appSecret:QQ_APPKEY
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    
    [ShareSDK connectQQWithAppId:QQ_APPID
                        qqApiCls:[QQApiInterface class]];
    
    //微信登陆的时候需要初始化
    [ShareSDK connectWeChatWithAppId:WEIXIN_APPID
                           appSecret:WEIXIN_SECRET
                           wechatCls:[WXApi class]];

}


- (BOOL)shareSDKApplication:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)shareSDKApplication:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}


#pragma mark - WXApiDelegate
-(void)onResp:(BaseResp *)resp;
{
    if ([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *weixinReq = (SendAuthResp *)resp;
        [PSShareSDKManager sharedInstance].weixinCode = weixinReq.code;
        [[NSNotificationCenter defaultCenter] postNotificationName:WeiXinCodeGetted object:nil];
    }
}



@end
