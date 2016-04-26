//
//  Macros.h
//  Diamond
//
//  Created by Pan on 15/7/11.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#ifndef Diamond_Macros_h
#define Diamond_Macros_h


#ifdef DEBUG
#define DLog(fmt,...) NSLog(fmt, ##__VA_ARGS__);
#else
// If debug mode hasn't been enabled, don't do anything when the macro is called
#define DLog(...)
#endif
//
// ===================  KEYS  ===========================
#define IS_LOGIN @"isLogin"
#define FRIEND   @"friend"  //EMConversation的拓展的Key  里面存着一个Friend对象。用于管理Conversation的头像和用户名。

#define WebServiceErrorNotification             @"WebServiceErrorNotification"
#define WeiXinCodeGetted                        @"WeiXinCodeGetted"

#define SCAN_AGAIN_NOTIFICATION                 @"没有查找到好友，再扫一扫吧"
#define SHOW_TABBAR_BADGE                       @"Tabbar展示红点吧"
#define REFRESH_ORDER                           @"刷新一下订单详情"
#define REFRESH_ORDER_LIST                      @"刷新一下订单列表"
#define SHOW_CHAT_TABBAR_BADGE                  @"聊天的Tabbar展示红点吧"
#define SEARCH_FRIEND_FAIL_IN_SHOPPING_CART     @"SEARCH_FRIEND_FAIL_IN_SHOPPING_CART"
#define PaySuccessNotification                  @"支付宝/微信支付成功"

#define WechatCodeGetedNotification             @"WechatCodeGetedNotification"
#define emLoginNotification                     @"emLoginNotification"
#define emRegisterNotification                  @"emRegisterNotification"
#define REGISTER_NOTIFICATION                   @"registerNotification"
#define REGISTER_VCODE_NOTIFICATION             @"registerVerificationCodeNotification"
#define LOGIN_STATUS_CHANGED_NOTIFICATION       @"loginStatusChanged"
#define LOGIN_NOTIFICATION                      @"loginNotification"
#define SEND_CODE_NOTIFICATION                  @"sendCodeNotification"
#define BANNER_DATA_GETTED_NOTIFICATION         @"BANNER_DATA_GETTED"
#define SEARCH_FRIEND_NOTIFICATION              @"搜索到一个好友"
#define GET_APPLY_ENTITY_NOTIFICATION           @"组装好了一个ApplyEntity"

#define FRIEND_LIST_NOTIFICATION                @"成功获取到好友列表"
#define ADD_FRIEND_NOTIFICATION                 @"添加好友成功"
#define CHANGE_PASSWORD_NOTIFICATION            @"changePasswordNotification"
#define MESSAGE_ADDED_NOTIFICATION              @"MESSAGE_ADDED_NOTIFICATION"
#define PUSH_TO_VIEWCONTROLLER_NOTIFICATION     @"帮我Push到这个界面吧！"
#define HEAD_PHOTO_GETTED_NOTIFICATION          @"获取到用户头像了！"
#define TIMER_NOTIFICATION                      @"计时器通知"
#define TICK_TOCK_NOTIFICATION                  @"秒钟滴答计时器通知"
#define SETUP_UNREAD_APPLY_COUNT                @"已经看完了所有未读好友请求"
#define REMOVE_TIMER_NOTIFICATION               @"计时器什么的，先停一停"
#define DISCOUNT_WARES_GETTED_NOTIFICATIOIN     @"已获取到限时特价数据"
#define RECOMMONED_WARES_GETTED_NOTIFICATIOIN   @"已获取到小二推荐数据"
#define SHOP_DATA_GETTED_NOTIFICATIOIN          @"获取到店铺列表数据"
#define SHOP_DETAIL_GETTED_NOTIFICATION         @"获取到店铺详情"
#define SHOP_GOODS_LIST_GETTED_NOTIFICATION     @"获取到本店的商品数据"
#define STORE_UP_SHOP_RESULT                    @"收藏店铺失败"
#define UN_STORE_UP_SHOP_FAILURE                @"删除店铺收藏失败"
#define STORE_UP_WARE_FAILURE                    @"收藏商品失败"
#define UN_STORE_UP_WARE_FAILURE                @"删除商品收藏失败"
#define WARE_DETAIL_GETED_NOTIFICATION          @"获取到一个商品详情"
#define CITY_LIST_NOTIFICATION                  @"获取到城市列表"
#define DISTRICT_LIST_NOTIFIATION               @"获取到区域信息"

#define ADD_GOODS_NOTIFICATION                  @"上传一个新品"
#define SEARCH_NOTIFICATION                     @"搜索到店铺或者宝贝了"
#define UPDATE_USER_NOTIFICATION                @"在线修改用户信息"
#define SET_SALE_NOTIFICATION                   @"在线修改上下架"

#define FIRST_WCHAT_LOGIN_NOTIFIATION           @"微信第一次登录要求手机注册"
#define FIRST_QQ_LOGIN_NOTIFIATION              @"QQ第一次登录要求手机注册"
#define EDIT_POSTAGE_NOTIFICATION               @"编辑运费成功"
#define EDIT_TOTLE_FEE_NOTIFICATION             @"商品改价成功"

// =============== Pay  ====================
#define ALIPAY_RESULT    @"支付宝支付成功"
#define WECHATPAY_RESULT  @"微信支付成功"


// =============== Device Info  ====================
#pragma mark - Device Info

#define SCREEN_HEIGHT           [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width
#define VIEW_SIZE               self.frame.size
#define IOS7          ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
#define IOS7_OR_LATER           ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IOS8_OR_LATER           ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

// ===================Common Define===========================

//在这TICK和Tock之间写上要测试运行时间的代码
#define TICK   NSDate *startTime = [NSDate date];
#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow]);

#define IS_NULL(string)                     (!string || [string isEqual: @""] || [string isEqual:[NSNull null]])
#define DefaultDateFormat @"yyyy-MM-dd HH:mm:ss"
#define IMAGE_MAX_WIDTH_OR_HEIGHT       512

// =================== UI ===========================
#pragma mark - UI

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]


#define GLOBAL_TINTCOLOR  0xff9b34
#define LIGHT_GRAY        0x999999
#define DARK_GRAY         0x555555
#define LINE_GRAY         0xe1e1e1


// =================== SB ===========================
#define MStoryboard [UIStoryboard storyboardWithName:@"Main" bundle:nil]
#define OrderStoryboard [UIStoryboard storyboardWithName:@"Order" bundle:nil]

#endif
