//
//  SearchFriendModel.h
//  Diamond
//
//  Created by Pan on 15/7/21.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseModel.h"
#import "Buddy.h"
@interface SearchFriendModel : BaseModel

@property (nonatomic, strong) Buddy *buddy;/**< 搜索所得的人*/

/**
 *  搜索好友  用于搜索好友界面(出错不提示)
 *
 *  @param phone 电话号码
 */
- (void)stealthilySearchBuddyWithPhone:(NSString *)phone;

/**
 *  搜索好友  用于搜索好友界面
 *
 *  @param phone 电话号码
 */
- (void)searchBuddyWithPhone:(NSString *)phone;

/**
 *  带着消息搜索好友   用于收到环信好友请求的回调
 *
 *  @param phone   电话号码
 *  @param message 消息
 */
- (void)searchBuddyWithPhone:(NSString *)phone message:(NSString *)msg;

@end
