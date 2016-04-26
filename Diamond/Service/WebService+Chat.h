//
//  WebService+Chat.h
//  Diamond
//
//  Created by Pan on 15/7/21.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "WebService.h"

@interface WebService (Chat)

/**
 *  通过手机号码搜索好友 也可以是环信账号
 *
 *  @param phoneNumber 手机号码
 *  @param completion  完成回调
 */
- (void)searchBuddyWithPhoneNumber:(NSString *)phoneNumber completion:(DMCompletionBlock)completion;

/**
 *  从服务器获取好友列表
 *
 *  @param easeMobID  环信ID
 *  @param completion 完成回调
 */
- (void)getFriendList:(NSString *)easeMobID completion:(DMCompletionBlock)completion;

/**
 *  添加好友
 *
 *  @param friendEaseMobID 好友的环信ID
 *  @param myEaseMobID     我的环信ID
 *  @param completion      完成回调
 */
- (void)addFriend:(NSString *)friendEaseMobID myEaseMobID:(NSString *)myEaseMobID completion:(DMCompletionBlock)completion;

/**
 *  删除好友
 *
 *  @param friendEaseMobID 好友的环信ID
 *  @param myEaseMobID     我的环信ID
 *  @param completion      完成回调
 */
- (void)deleteFriend:(NSString *)friendEaseMobID myEaseMobID:(NSString *)myEaseMobID completion:(DMCompletionBlock)completion;


/**
 *  获取好友头像
 *
 *  @param easemob    环信号
 *  @param completion 完成回调
 */
- (void)getPhotoForUser:(NSString *)easemob completion:(DMCompletionBlock)completion;

/**
 *  跟新好友备注名
 *
 *  @param friendEaseMobID 好友的环信ID
 *  @param myEaseMobID     我的环信ID
 *  @param completion      完成回调
 */
- (void)updateRemarkName:(NSString *)name friend:(NSString *)friendEaseMobID myEaseMobID:(NSString *)myEaseMobID completion:(DMCompletionBlock)completion;

@end
