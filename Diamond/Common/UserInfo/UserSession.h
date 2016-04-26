//
//  UserSession.h
//  Diamond
//
//  Created by Shengpan on 15/7/20.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserEntity.h"
#import "PSShareSDKManager.h"
#import "City.h"
#import <ShareSDK/ShareSDK.h>


@interface UserSession : NSObject

@property (nonatomic, strong) UserEntity *currentUser;

@property (nonatomic, strong) City *choosedCity;/**< 用户手动切换的城市*/
@property (nonatomic, strong) NSArray *districts;/**< 根据城市信息获取到的区域信息*/
@property (nonatomic, strong) NSString *choosedDistrict;/**< 用户手动切换的区域*/
@property (nonatomic) ShareType loginType;

@property (nonatomic) BOOL  showBuyNotice;/**< 是否展示订单界面 我买到的 的红点*/
@property (nonatomic) BOOL  showSellNotice;/**< 是否展示订单界面 我卖出的 的红点*/


@property (nonatomic, assign) BOOL hasRewriteChoosedCity;/**< 需求要求，在App启动时，定位地址覆盖手动选择的地址。*/
@property (nonatomic, assign) BOOL hasChooseCityThisTime;/**< 同上一条，为了避免App启动，用户快速选择了城市，但是被定为覆盖的问题。*/


+ (UserSession *)sharedInstance;

- (void)resetUser;

- (void)startTimer:(NSDate *)date;

@end
