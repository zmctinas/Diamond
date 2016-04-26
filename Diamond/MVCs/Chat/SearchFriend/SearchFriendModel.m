//
//  SearchFriendModel.m
//  Diamond
//
//  Created by Pan on 15/7/21.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "SearchFriendModel.h"
#import "WebService+Chat.h"
#import "ApplyEntity.h"
@implementation SearchFriendModel

- (void)stealthilySearchBuddyWithPhone:(NSString *)phone
{
    //如果电话为空,则不在线查询 Leon 20151104
    if (phone.length < 1) {
        return;
    }
    
    [self.webService searchBuddyWithPhoneNumber:phone completion:^(BOOL isSuccess, NSString *message, id result)
     {
         if (isSuccess && !message)
         {
             self.buddy = result;
             [[NSNotificationCenter defaultCenter] postNotificationName:SEARCH_FRIEND_NOTIFICATION object:nil];
         }
     }];
}

- (void)searchBuddyWithPhone:(NSString *)phone
{
    //如果电话为空,则不在线查询 Leon 20151104
    if (phone.length < 1) {
        return;
    }
    
    [self.webService searchBuddyWithPhoneNumber:phone completion:^(BOOL isSuccess, NSString *message, id result)
    {
        if (isSuccess && !message)
        {
            self.buddy = result;
            [[NSNotificationCenter defaultCenter] postNotificationName:SEARCH_FRIEND_NOTIFICATION object:nil];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
            [[NSNotificationCenter defaultCenter] postNotificationName:SCAN_AGAIN_NOTIFICATION object:message];
            //需求方造假数据时，未造用户信息，所以可能导致搜索失败。但搜索失败的情况下，仍然要进入聊天。因此在搜索失败的情况下，接受此通知，自己造一个用户。
            [[NSNotificationCenter defaultCenter] postNotificationName:SEARCH_FRIEND_FAIL_IN_SHOPPING_CART object:phone];
        }
    }];

}

- (void)searchBuddyWithPhone:(NSString *)phone message:(NSString *)msg
{
    [self.webService searchBuddyWithPhoneNumber:phone completion:^(BOOL isSuccess, NSString *message, id result)
     {
         if (isSuccess && !message)
         {
             UserEntity *user = [UserSession sharedInstance].currentUser;
             Buddy *buddy = result;
             ApplyEntity *entity = [ApplyEntity new];
             entity.applicantUsername = buddy.easemob;
             entity.applicantNick = buddy.user_name;
             entity.applicantAvatar = buddy.photo;
             entity.receiverUsername = user.easemob;
             entity.receiverNick = user.user_name;
             entity.receiverAvatar = user.photo;
             entity.reason = msg;
             entity.accepted = NO;
             [[NSNotificationCenter defaultCenter] postNotificationName:GET_APPLY_ENTITY_NOTIFICATION object:entity];
         }
         else
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
         }
     }];
}

@end
