//
//  UserInfo.h
//  DrivingOrder
//
//  Created by Pan on 15/6/5.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserEntity.h"
#import "Friend.h"
#import "OrderIndexEntity.h"
#import "SettingEntiy.h"
#import "City.h"


@interface UserInfo : NSObject

+ (instancetype)info;

- (void)clear;

@property (nonatomic, readwrite) UserEntity *currentUser;

@property (nonatomic, readwrite) NSArray *friends;//此项存储了通讯录。里面都是Friend对象;

@property (nonatomic, readwrite) NSArray *applyRequests;/**< 存在本地的好友申请 ApplyEntity*/

@property (nonatomic, readwrite) NSUInteger unReadApplyCount;/**< 未查看的好友申请数量*/

@property (nonatomic, readwrite) SettingEntiy *setting;/**< 用户设置*/

@property (nonatomic, readwrite) OrderIndexEntity *statistics;/**< 用户的统计信息*/

@property (nonatomic, readwrite) NSMutableArray *quietEasemobs;/**< 消息免打扰的EaseMobs  NSString*/

@property (nonatomic, strong) City *choosedCity;/**< 用户手动切换的城市*/

// 是否显示引导页
@property (nonatomic, assign) BOOL hideIntroduction;


- (void)deleteFriend:(Friend *)aFriend;

- (void)addFriend:(Friend *)aFriend;

- (void)updateFriend:(Friend *)aFriend;

- (Friend *)FriendWitheasemob:(NSString *)easemob;
@end
