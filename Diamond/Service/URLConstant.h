//
//  URLConstant.h
//  DrivingOrder
//
//  Created by Pan on 15/5/19.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#ifndef Diamond_URLConstant_h
#define Diamond_URLConstant_h

//123.59.56.108

static NSString * const BASEURL = @"https://app.daimang.com/"; //BaseURL

#if DEBUG
static NSString * const PATH    = @"daimang_test/API/receive.php";//只有一个接口
static NSString * const DAIMANG = @"daimang_test/";//如果图片路径是半截的，需要在BaseUrl和图片路径之间加上这个
static NSString * const ALIPAY_CALLBACK = @"http://123.59.56.108/daimang_test/pay/alipay/notify_url.php";
#else
static NSString * const PATH    = @"daimang/API/receive.php";//只有一个接口
static NSString * const DAIMANG = @"daimang/";//如果图片路径是半截的，需要在BaseUrl和图片路径之间加上这个
static NSString * const ALIPAY_CALLBACK = @"http://123.59.56.108/daimang/pay/alipay/notify_url.php";
#endif

static NSString * const IMAGE_BASEURL = @"http://app.daimang.com/"; //IMAGEBaseURL

//分享的网页URL前缀
static NSString * const SHARE_URL = @"http://share.daimang.com/share.php?shop_id=";

//图片后缀
static NSString * const PNG = @".png";
static NSString * const JPG = @".jpg";

//由于后台没有返回STATUS为Failure时候的原因，所以固定描述一下失败原因
static NSString * const SERVER_ERROE_MESSAGE = @"服务器出错了，请稍后再试";


#pragma mark - Mothed Name

static NSString * const USER_LOGIN                    = @"userLogin";/**< 用户登陆*/
static NSString * const USER_LOGOUT                   = @"userLogout";/**< 用户登出*/
static NSString * const SEND_LOCATION                 = @"sendLocation";/**< 初始化定位信息*/
static NSString * const GET_FRIENDS                   = @"getFriends";/**< 获取好友*/
static NSString * const GET_CITY_LIST                 = @"getCityList";/**< 获取城市列表*/
static NSString * const GET_ACTIVITY                  = @"getActivity";/**< 获取轮播图*/
static NSString * const GET_ACTIVITY_MENBER           = @"getActivityMenber";/**< 参加该活动的店铺列表*/
static NSString * const GET_SHOP_BY_CAT_ID            = @"getShopByCatId";/**< 获取商铺数据*/
static NSString * const GET_DISTRICTS_LIST            = @"getDistrictsList";/**< 根据经纬度获取区域信息*/
static NSString * const GET_SPECAIL_OFFER_GOODS       = @"getSpecialOfferGoods";/**< 获取限时特价商品*/
static NSString * const GET_RECOMMEND                 = @"getRecommend";/**< 获取小二推荐*/
static NSString * const GET_NEW_SHOP_LIST             = @"getNewShopList";/**< 获取近一周开张店铺*/
static NSString * const HOT_SHOP                      = @"hotShop";/**< 获取热门店铺*/
static NSString * const GET_SHOP_COLLEC               = @"getShopCollec";/**< 获取收藏店铺列表*/
static NSString * const ADD_SHOP_COLLEC               = @"addShopCollec";/**< 添加店铺收藏*/
static NSString * const DEL_SHOP_COLLEC               = @"delShopCollec";/**< 删除店铺收藏*/
static NSString * const GET_GOODS_COLLEC              = @"getGoodsCollec";/**< 获取收藏商品列表*/
static NSString * const ADD_GOODS_COLLEC              = @"addGoodsCollec";/**< 添加商品收藏*/
static NSString * const DEL_GOODS_COLLEC              = @"delGoodsCollec";/**< 删除商品收藏*/
static NSString * const GET_USER_PHOTO                = @"getUserPhoto";/**< 获取用户头像*/
static NSString * const GET_USER_INFO_BY_PHONE_NUMBER = @"getUserInfoByPhoneNumber";/**< 查询用户信息*/
static NSString * const ADD_FRIEND                    = @"addFriend";/**< 添加好友*/
static NSString * const DELETE_FRIEND                 = @"deleteFriend";/**< 删除好友*/
static NSString * const ADD_SHOP                      = @"addShop";/**< 添加店铺*/
static NSString * const ADD_GOODS                     = @"addGoods";/**< 上传新品*/
static NSString * const ADD_PROMOTION                 = @"addPromotion";/**< 添加限时特价*/
static NSString * const DEL_PROMOTION                 = @"delPromotion";/**< 删除限时特价*/
static NSString * const GET_SHOP_GOODS                = @"getShopGoods";/**< 获取商铺商品列表*/
static NSString * const GET_GOODS_INFO                = @"getGoodsInfo";/**< 获取商品详细信息*/
static NSString * const GET_SHOP_INFO                 = @"getShopInfo";/**< 获取店铺详情*/
static NSString * const VERIFICATION_CODE             = @"VerificationCode";/**< 用户注册/忘记密码 一请求验证码*/
static NSString * const USER_REGISTER                 = @"userRegister";/**< 用户注册 二.注册*/
static NSString * const PASSWORD_UPDATE               = @"passwordUpdate";/**< 忘记密码 二.提交修改后的密码*/
static NSString * const WCHAT_LOGIN                   = @"weixinLogin";/**< 微信三方登陆*/
static NSString * const QQ_LOGIN                      = @"qqLogin";/**< QQ三方登陆*/
static NSString * const UPDATE_USER_INFO              = @"updateUserInfo";/**< 用户信息修改*/
static NSString * const UPDATE_REMARK                 = @"updateRemark";/**< 更新好友备注*/
static NSString * const UPDATE_SHOP                   = @"upDateShop";/**< 店铺信息修改*/
static NSString * const SET_SALE                      = @"setSale";/**< 商品上下架*/
static NSString * const DEL_GOODS                     = @"delGoods";/**< 删除商品*/
static NSString * const UPDATE_GOODS                  = @"upDategoods";/**< 修改商品信息*/
static NSString * const SEARCH                        = @"search";/**< 搜索店铺或商品*/
//static NSString * const GET_CURRENT_CITY              = @"getCurrentCityName";/**< 获取左上角城市信息*/
static NSString * const GET_LICENSE                   = @"getLicense";/**< 获取证书信息*/
static NSString * const UP_LICENSE                    = @"upLicense";/**< 上传证书资料*/
static NSString * const UPDATE_LICENSE                = @"updateLicense";/**< 修改证书资料*/

#pragma mark - 订单模块接口名
static NSString * const GET_TOTAL_INFO        = @"getTotalInfo";     /**< 获取统计数据*/
static NSString * const ADD_ADDRESS           = @"addAddress";       /**< 添加配送地址*/
static NSString * const UPDATE_ADDRESS        = @"updateAddress";    /**< 修改配送地址*/
static NSString * const DELETE_ADDRESS        = @"deleteAddress";    /**< 删除配送地址*/
static NSString * const GET_ADDRESS           = @"getAddress";       /**< 获取配送地址*/
static NSString * const ORDER_SUBMITE         = @"orderSubmit";      /**< 下单*/
static NSString * const GET_BUYER_ORDER_LIST  = @"getBuyerOrderList";/**< 获取买家订单列表*/
static NSString * const GET_SELLER_ORDER_LIST = @"getSellerOrderList";/**< 获取卖家订单列表*/
static NSString * const CONFORM_ORDER         = @"confirmOrder";     /**< 确认收货*/
static NSString * const CONFORM_SEND          = @"confirmSend";      /**< 确认发货*/
static NSString * const ADD_SHOP_CART         = @"addShopCart";      /**< 添加商品到购物车*/
static NSString * const GET_SHOP_CART         = @"getShopCart";      /**< 获取购物车数据*/
static NSString * const UPDATE_SHOP_CART      = @"updateShopCart";   /**< 更新购物车中商品数据*/
static NSString * const DEL_FORM_SHOP_CART    = @"delFromShopCart";  /**< 删除购物车中商品*/
static NSString * const GET_ORDER_DETAIL      = @"getOrderDetail";   /**< 获取订单详情*/
static NSString * const UPDATE_ORDER          = @"updateOrder";      /**< 获取改价或者改运费*/
static NSString * const CLOSE_ORDER           = @"closeOrder";       /**< 关闭订单*/



static NSString * const GET_PREPAY_ID         = @"getPrepayId";      /**< 微信统一下单*/


#pragma mark - 提现接口

static NSString * const GET_Ali_Acount         = @"getPayment";      /**< 获取支付宝账号*/
static NSString * const EXTRACT_MONEY         = @"takeCash";      /**< 提现*/
static NSString * const EXTRACT_MONEY_LIST         = @"getTakeList";      /**< 提现*/

#endif
