//
//  UserDetailModel.m
//  Diamond
//
//  Created by Pan on 15/7/23.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "UserDetailModel.h"
#import "WebService+Chat.h"
#import "WebService+User.h"
#import "Buddy.h"
#import "Friend.h"

@implementation UserDetailModel

- (void)addFriend:(NSString *)easemob withMessage:(NSString *)msg;
{
    __weak UserDetailModel *weakSelf = self;
    [self.webService addFriend:easemob myEaseMobID:[UserInfo info].currentUser.easemob completion:^(BOOL isSuccess, NSString *message, id result) {
        if (isSuccess && !message)
        {
            Buddy *addedBuddy = result;
            NSMutableArray *friends = [NSMutableArray arrayWithArray:[UserInfo info].friends];
            Friend *friend = [[Friend alloc] init];
            friend.friends_easemob = addedBuddy.easemob;
            friend.add_time = addedBuddy.add_time;
            friend.photo = addedBuddy.photo;
            friend.sex = addedBuddy.sex;
            friend.user_name = addedBuddy.user_name;
            [friends addObject:friend];
            
            //持久化一下
            NSArray *newFriends = [NSArray arrayWithArray:friends];
            [UserInfo info].friends = newFriends;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:ADD_FRIEND_NOTIFICATION object:nil];
            [[[EaseMob sharedInstance] chatManager] addBuddy:addedBuddy.user_name message:msg error:nil];
        }
        else
        {
            //添加好友失败，60秒后自动重试
            [weakSelf performSelector:@selector(AddFriendAgain:) withObject:@[easemob,message] afterDelay:60];
        }
    }];
}

- (void)AddFriendAgain:(NSArray *)arguments
{
    [self addFriend:[arguments firstObject] withMessage:[arguments lastObject]];
}

- (void)updateUserInfo:(NSString *)name
                   sex:(NSInteger)sex
                images:(NSArray *)array
{
    [self.webService updateUserInfo:[[UserSession sharedInstance] currentUser].easemob
                               name:name
                                sex:sex
                             images:array
                         completion:^(BOOL isSuccess, NSString *message, id result) {
                             if (isSuccess && message.length<1)
                             {
                                 [[NSNotificationCenter defaultCenter] postNotificationName: UPDATE_USER_INFO object:result];
                             }
                             else
                             {
                                 [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
                             }
    }];

}

@end
