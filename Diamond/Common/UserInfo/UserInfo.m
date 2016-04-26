//
//  UserInfo.m
//  DrivingOrder
//
//  Created by Pan on 15/6/5.
//  Copyright (c) 2015年 Pan. All rights reserved.
//
#import "UserInfo.h"

@interface UserInfo()

@property (nonatomic, strong) NSUserDefaults *user;

@end

@implementation UserInfo

@synthesize currentUser = _currentUser;
@synthesize friends = _friends;
@synthesize applyRequests = _applyRequests;
@synthesize unReadApplyCount = _unReadApplyCount;
@synthesize setting = _setting;
@synthesize statistics = _statistics;
@synthesize hideIntroduction = _hideIntroduction;
@synthesize quietEasemobs = _quietEasemobs;
@synthesize choosedCity = _choosedCity;
+ (instancetype)info
{
    return [[UserInfo alloc]init];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _user = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)clear
{
//    [self setCurrentUser:nil];
    [_user removeObjectForKey:@"currentUser"];
    [_user removeObjectForKey:@"friends"];
    [_user removeObjectForKey:@"applyRequests"];
    [_user removeObjectForKey:@"unReadApplyCount"];
    [_user removeObjectForKey:@"setting"];
    [_user removeObjectForKey:@"statistics"];
    [_user removeObjectForKey:@"quietEasemobs"];
}

- (UserEntity *)currentUser
{
    NSData *data = [_user objectForKey:@"currentUser"];
    _currentUser = (UserEntity *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    return _currentUser;
}


- (City *)choosedCity
{
    NSData *data = [_user objectForKey:@"choosedCity"];
    _choosedCity = (City *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    return _choosedCity;
}

- (void)setChoosedCity:(City *)choosedCity
{
    [_user removeObjectForKey:@"choosedCity"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:choosedCity];
    [_user setObject:data forKey:@"choosedCity"];
    [_user synchronize];
}

- (void)setQuietEasemobs:(NSMutableArray *)quietEasemobs
{
    [_user removeObjectForKey:@"quietEasemobs"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:quietEasemobs];
    [_user setObject:data forKey:@"quietEasemobs"];
    [_user synchronize];
}

- (NSMutableArray *)quietEasemobs
{
    NSData *data = [_user objectForKey:@"quietEasemobs"];
    if (data)
    {
        _quietEasemobs = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return _quietEasemobs;

}

// 是否显示引导页

-(void)setHideIntroduction:(BOOL)hideIntroduction
{
    [_user removeObjectForKey:@"hideIntroduction"];
    [_user setBool:hideIntroduction forKey:@"hideIntroduction"];
    [_user synchronize];
}

-(BOOL)hideIntroduction
{
    _hideIntroduction = [_user boolForKey:@"hideIntroduction"];
    return _hideIntroduction;
}


- (void)setCurrentUser:(UserEntity *)currentUser
{
    [_user removeObjectForKey:@"currentUser"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:currentUser];
    [_user setObject:data forKey:@"currentUser"];
    [_user synchronize];
}

- (SettingEntiy *)setting
{
    NSData *data = [_user objectForKey:@"setting"];
    _setting = (SettingEntiy *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    return _setting;
}

- (void)setSetting:(SettingEntiy *)setting
{
    [_user removeObjectForKey:@"setting"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:setting];
    [_user setObject:data forKey:@"setting"];
    [_user synchronize];
}

- (OrderIndexEntity *)statistics
{
    NSData *data = [_user objectForKey:@"statistics"];
    _statistics = (OrderIndexEntity *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (!_statistics)
    {
        _statistics = [[OrderIndexEntity alloc] init];
        _statistics.buyer_count_no = @0;
        _statistics.buyer_count_fee = @0;
        _statistics.seller_count_no = @0;
        _statistics.seller_count_fee = @0;
        _statistics.balance = @0;
    }
    return _statistics;
}

- (void)setStatistics:(OrderIndexEntity *)statistics
{
    [_user removeObjectForKey:@"statistics"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:statistics];
    [_user setObject:data forKey:@"statistics"];
    [_user synchronize];
}


- (NSArray *)friends
{
    NSData *data = [_user objectForKey:@"friends"];
    _friends = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return _friends;
}

- (void)setFriends:(NSArray *)friends
{
    [_user removeObjectForKey:@"friends"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:friends];
    [_user setObject:data forKey:@"friends"];
    [_user synchronize];
}

- (NSArray *)applyRequests
{
    NSData *data = [_user objectForKey:@"applyRequests"];
    _applyRequests = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return _applyRequests;
}

- (void)setApplyRequests:(NSArray *)applyRequests
{
    [_user removeObjectForKey:@"applyRequests"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:applyRequests];
    [_user setObject:data forKey:@"applyRequests"];
    [_user synchronize];
}

- (NSUInteger)unReadApplyCount
{
    _unReadApplyCount = [_user integerForKey:@"unReadApplyCount"];
    return _unReadApplyCount;
}

- (void)setUnReadApplyCount:(NSUInteger)unReadApplyCount
{
    [_user removeObjectForKey:@"unReadApplyCount"];
    [_user setInteger:unReadApplyCount forKey:@"unReadApplyCount"];
    [_user synchronize];
}

- (void)deleteFriend:(Friend *)aFriend
{
    NSArray *friends = self.friends;
    for (Friend *f in friends)
    {
        if ([f.friends_easemob isEqualToString:aFriend.friends_easemob])
        {
            aFriend = f;
            break;
        }
    }
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:friends];
    [arr removeObject:aFriend];
    self.friends = arr;
}

- (void)addFriend:(Friend *)aFriend
{
    NSArray *friends = self.friends;
    
    for (Friend *f in friends)
    {
        if ([f.friends_easemob isEqualToString:aFriend.friends_easemob])
        {
            aFriend = f;
            break;
        }
    }
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:friends];
    [arr addObject:aFriend];
    self.friends = arr;
}

- (void)updateFriend:(Friend *)aFriend
{
    NSArray *friends = self.friends;
    Friend *oldFriend;
    for (Friend *f in friends)
    {
        if ([f.friends_easemob isEqualToString:aFriend.friends_easemob])
        {
            oldFriend = f;
            break;
        }
    }
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:friends];

    oldFriend.friendID = aFriend.friendID;
    oldFriend.friends_easemob = aFriend.friends_easemob;
    oldFriend.add_time = aFriend.add_time;
    oldFriend.remarkname = aFriend.remarkname;
    oldFriend.user_name = aFriend.photo;
    oldFriend.photo = aFriend.photo;
    oldFriend.signature = aFriend.signature;
    oldFriend.sex = aFriend.sex;
    oldFriend.searchString = aFriend.searchString;
    [arr replaceObjectAtIndex:[arr indexOfObject:oldFriend] withObject:oldFriend];
    self.friends = arr;
    
}

- (Friend *)FriendWitheasemob:(NSString *)easemob;
{
    for (Friend *fr in self.friends)
    {
        if ([fr.friends_easemob isEqualToString:easemob])
        {
            return fr;
        }
    }
    return nil;
}
@end
