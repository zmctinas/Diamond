//
//  ContactsModel.h
//  Diamond
//
//  Created by Pan on 15/7/22.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseModel.h"
#import "UserEntity.h"
#import "Friend.h"

@interface ContactsModel : BaseModel

@property (strong, nonatomic) NSMutableArray *contactsSource;/**< 联系人列表*/
@property (strong, nonatomic) NSMutableArray *dataSource;/**< 排序完成的联系人列表@[@[A],@[B],@[C]]*/
@property (strong, nonatomic) NSMutableArray *sectionTitles;/**< 联系人里面按字母排序的字*/

/**
 *  将联系人格式化成通讯录的格式
 *
 *  @param dataArray Array[Friend]
 *
 *  @return
 */
- (NSMutableArray *)sortDataArray:(NSArray *)dataArray;

/**
 *  获取好友列表
 */
- (void)giveMeFriendList;


- (void)deleteFriend:(Friend *)aFriend;

- (void)reloadDataSource;
@end
