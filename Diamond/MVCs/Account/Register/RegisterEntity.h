//
//  RegisterEntity.h
//  Diamond
//
//  Created by Leon Hu on 15/7/14.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"

@interface RegisterEntity : BaseEntity
///**
// *  用户自增id
// */
//@property (nonatomic,strong) NSString *userId;
///**
// *  用户名
// */
//@property (nonatomic,strong) NSString *userName;
///**
// *  手机号
// */
//@property (nonatomic,strong) NSString *phoneNumber;
///**
// *  是否是卖家
// */
//@property (nonatomic,strong) NSString *isSeller;
///**
// *  店铺id,值为0则为未开店
// */
//@property (nonatomic,strong) NSString *shopId;
///**
// *  纬度
// */
//@property (nonatomic,strong) NSString *latitude;
///**
// *  经度
// */
//@property (nonatomic,strong) NSString *longtitude;
///**
// *  商铺店招 ????
// */
//@property (nonatomic,strong) NSString *password;
///**
// *  注册时间
// */
//@property (nonatomic,strong) NSString *registerDate;
///**
// *  环信帐号
// */
//@property (nonatomic,strong) NSString *easemob;
///**
// *  用户头像
// */
//@property (nonatomic,strong) NSString *photo;
///**
// *  最后登陆时间
// */
//@property (nonatomic,strong) NSString *lastlogin;
///**
// *  个推id
// */
//@property (nonatomic,strong) NSString *clientId;
///**
// *  苹果推送
// */
//@property (nonatomic,strong) NSString *deviceToken;
///**
// *  设备类型,3安卓、4为IOS
// */
//@property (nonatomic,strong) NSString *deviceType;
///**
// *  性别
// */
//@property (nonatomic,strong) NSString *sex;
///**
// *  城市代码
// */
//@property (nonatomic,strong) NSString *cityCode;
///**
// *  签名
// */
//@property (nonatomic,strong) NSString *signature;
///**
// *  用户类型
// */
//@property (nonatomic,strong) NSString *userType;

/**
 *  用户自增id
 */
@property (nonatomic) NSInteger userId;
/**
 *  用户名
 */
@property (nonatomic,strong) NSString *userName;
/**
 *  手机号
 */
@property (nonatomic,strong) NSString *phoneNumber;
/**
 *  是否是卖家
 */
@property (nonatomic,strong) NSString *isSeller;
/**
 *  店铺id,值为0则为未开店
 */
@property (nonatomic) NSInteger shopId;
/**
 *  纬度
 */
@property (nonatomic,strong) NSNumber *latitude;
/**
 *  经度
 */
@property (nonatomic,strong) NSNumber *longtitude;
/**
 *  商铺店招 ????
 */
@property (nonatomic,strong) NSString *password;
/**
 *  注册时间
 */
@property (nonatomic,strong) NSString *registerDate;
/**
 *  环信帐号
 */
@property (nonatomic,strong) NSString *easemob;
/**
 *  用户头像
 */
@property (nonatomic,strong) NSString *photo;
/**
 *  最后登陆时间
 */
@property (nonatomic,strong) NSString *lastlogin;
/**
 *  个推id
 */
@property (nonatomic,strong) NSString *clientId;
/**
 *  苹果推送
 */
@property (nonatomic,strong) NSString *deviceToken;
/**
 *  设备类型,3安卓、4为IOS
 */
@property (nonatomic) NSInteger deviceType;
/**
 *  性别
 */
@property (nonatomic) NSInteger sex;
/**
 *  城市代码
 */
@property (nonatomic,strong) NSString *cityCode;
/**
 *  签名
 */
@property (nonatomic,strong) NSString *signature;
/**
 *  用户类型
 */
@property (nonatomic) NSInteger userType;

+(void)map;

@end
