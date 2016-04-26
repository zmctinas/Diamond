//
//  ContactsModel.m
//  Diamond
//
//  Created by Pan on 15/7/22.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ContactsModel.h"
#import "ChineseToPinyin.h"
#import "WebService+Chat.h"


@interface ContactsModel()


@end


@implementation ContactsModel


- (void)giveMeFriendList
{
    UserEntity *user = [UserInfo info].currentUser;
    [self.webService getFriendList:user.easemob completion:^(BOOL isSuccess, NSString *message, id result)
    {
        if (isSuccess && !message)
        {
            [self.contactsSource removeAllObjects];
            [self.dataSource removeAllObjects];
            [self.contactsSource addObjectsFromArray:result];
            [UserInfo info].friends = self.contactsSource;//持久化通讯录
            [self.dataSource addObjectsFromArray:[self sortDataArray:self.contactsSource]];
            [[NSNotificationCenter defaultCenter] postNotificationName:FRIEND_LIST_NOTIFICATION object:message];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:message];
        }
    }];
}

- (void)deleteFriend:(Friend *)aFriend
{
    UserEntity *user = [UserInfo info].currentUser;
    [self.webService deleteFriend:aFriend.friends_easemob myEaseMobID:user.easemob completion:^(BOOL isSuccess, NSString *message, id result) {
        
    }];
}


#pragma mark - private

- (NSMutableArray *)sortDataArray:(NSArray *)dataArray
{
    //建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    
    [self.sectionTitles removeAllObjects];
    [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    
    //返回27，是a－z和＃
    NSInteger highSection = [self.sectionTitles count];
    //tableView 会被分成27个section
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i <= highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    //名字分section
    for (Friend *aFriend in dataArray) {
        //getUserName是实现中文拼音检索的核心，见NameIndex类
        NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:aFriend.searchString];
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:aFriend];
    }
    
    //每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(Friend *obj1, Friend *obj2) {
            NSString *firstLetter1 = [ChineseToPinyin pinyinFromChineseString:obj1.searchString];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [ChineseToPinyin pinyinFromChineseString:obj2.searchString];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    return sortedArray;
}

- (void)reloadDataSource
{
    [self.dataSource removeAllObjects];
    [self.contactsSource removeAllObjects];
    
    
    for (Friend *fri in [UserInfo info].friends)
    {
        [self.contactsSource addObject:fri];
    }
    [self.dataSource addObjectsFromArray:[self sortDataArray:self.contactsSource]];
    
}


- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)sectionTitles
{
    if (!_sectionTitles)
    {
        _sectionTitles = [NSMutableArray array];
    }
    return _sectionTitles;
}

- (NSMutableArray *)contactsSource
{
    if (!_contactsSource)
    {
        _contactsSource = [NSMutableArray array];
    }
    return _contactsSource;
}
@end
