//
//  UserDetailViewController.h
//  Diamond
//
//  Created by Pan on 15/7/21.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseViewController.h"
#import "Buddy.h"

typedef NS_ENUM(NSInteger, UserDetailType)
{
    UserDetailTypeFriend = 10,/**< 该用户是我好友列表中的好友*/
    UserDetailTypeStranger,/**< 该用户不是好友*/
    UserDetailTypeBeenInvited,/**< 该用户申请添加我为好友*/
    UserDetailTypeSelf,/**< 我自己的详情*/
};

@protocol UserDetailViewControllerDelegate <NSObject>

//接受好友申请
- (void)didAccpetRequestFromBuddy:(Buddy *)buddy;

@end

@interface UserDetailViewController : BaseViewController

@property (nonatomic, strong) Buddy *buddy;

@property (nonatomic) UserDetailType detailType;/**< UserDetailTypeFriend      则按钮title为 发消息
                                                     UserDetailTypeStranger    则按钮title为 加为好友
                                                     UserDetailTypeBeenInvited 则为接受好友申请*/
@property (weak, nonatomic) id<UserDetailViewControllerDelegate> delegate;

@end
