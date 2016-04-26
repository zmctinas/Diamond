//
//  UserSession.m
//  Driving
//
//  Created by Jessie Hu on 15/1/27.
//  Copyright (c) 2015年 Insigma Hengtian Software Ltd. All rights reserved.
//

#import "UserSession.h"
#import "UserInfo.h"

@interface UserSession()

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *tickTock;

@end

@implementation UserSession
@synthesize currentUser = _currentUser;
@synthesize timer = _timer;
@synthesize choosedCity = _choosedCity;

static UserSession *sharedInstance = nil;

+ (UserSession *)sharedInstance
{
    static dispatch_once_t onceQueue;
    
    dispatch_once(&onceQueue, ^{
        sharedInstance = [[UserSession alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.tickTock = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tickTockTickTock:) userInfo:nil repeats:YES];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appWillResignActiveForground) name:UIApplicationWillResignActiveNotification object:nil];
    }
    return self;
}

- (void)resetUser
{
    [self setCurrentUser:nil];
}

- (UserEntity *)currentUser
{
    if (!_currentUser)
    {
        _currentUser = [UserInfo info].currentUser;
    }
    return _currentUser;
}

- (void)setCurrentUser:(UserEntity *)currentUser
{
    _currentUser = currentUser;
    [UserInfo info].currentUser = currentUser;
}

- (void)startTimer:(NSDate *)date
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeIsPassing:) userInfo:date repeats:YES];
    [self.timer setFireDate: [NSDate distantPast]];
}

- (void)stopTimer
{
    if (self.timer && [self.timer isValid])
    {
        //取消定时器
        [self.timer invalidate];
    }
    self.timer = nil;
}

- (void)timeIsPassing:(NSTimer *)paramTimer
{
    NSDate *startTime = paramTimer.userInfo;
    NSDate *nowTime = [NSDate date];
    NSTimeInterval secondInterval = [nowTime timeIntervalSinceDate:startTime];
    NSInteger second = 45 - round(secondInterval);
    second = (second < 0 ? 0 : second);
    NSString *secondString = [NSString stringWithFormat:@"%1ld",(long)second];

    [[NSNotificationCenter defaultCenter] postNotificationName:TIMER_NOTIFICATION object:secondString];
    if (second<=0) {
        [self stopTimer];
    }
}

- (void)tickTockTickTock:(NSTimer *)timer
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TICK_TOCK_NOTIFICATION object:nil];
}

- (void)appWillResignActiveForground
{
    if (self.tickTock && [self.tickTock isValid])
    {
        //取消定时器
        [self.tickTock invalidate];
    }
    self.tickTock = nil;
}

- (void)appDidBecomeActive
{
    if (!self.tickTock)
    {
        self.tickTock = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tickTockTickTock:) userInfo:nil repeats:YES];
    }
    
}

- (City *)choosedCity
{
    return [UserInfo info].choosedCity;
}

- (void)setChoosedCity:(City *)choosedCity
{
    //每当用户重新选择了城市，他所选的区域就被默认设置为全城，需要重新去选择一次。
    [UserInfo info].choosedCity = choosedCity;
    _choosedDistrict = @"全城";
}
@end
