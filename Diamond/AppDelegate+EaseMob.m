//
//  AppDelegate+EaseMob.m
//  Diamond
//
//  Created by Pan on 15/7/15.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "AppDelegate+EaseMob.h"
#import "EaseMob.h"
#import "Macros.h"
#import "UserInfo.h"
#import "SettingEntiy.h"
#import "ApplyViewController.h"
#import "UserDetailModel.h"
#import <AudioToolbox/AudioToolbox.h>


#define SOUND_URL @"file:///System/Library/Audio/UISounds/SIMToolkitGeneralBeep.caf"

@implementation AppDelegate (EaseMob)

#pragma mark - Public

- (void)easemobApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if (launchOptions) {
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if(userInfo)
        {
            [self easemobdidReceiveRemoteNotification:userInfo];
        }
    }
    //注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"daimang-dev";
#else
    apnsCertName = @"damming-dis";
#endif
    
    _connectionState = eEMConnectionConnected;
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"daimangkeji#daimang" apnsCertName:apnsCertName];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [self registerRemoteNotification];
    
    
    // 登录成功后，自动去取好友列表
    // SDK获取结束后，会回调
    // - (void)didFetchedBuddyList:(NSArray *)buddyList error:(EMError *)error方法。
    [[EaseMob sharedInstance].chatManager setIsAutoFetchBuddyList:YES];
    
    // 注册环信监听
    [self registerEaseMobNotification];
    [self setupNotifiers];
}


// 将得到的deviceToken传给SDK
- (void)easemobApplication:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

// 注册deviceToken失败
- (void)easemobApplication:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    DLog(@"EASE MOB REMOTENOFITICATION ERROR -- %@",error);
}

#pragma mark - Private

// 监听系统生命周期回调，以便将需要的事件传给SDK
- (void)setupNotifiers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackgroundNotif:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidFinishLaunching:)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActiveNotif:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillResignActiveNotif:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidReceiveMemoryWarning:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillTerminateNotif:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appProtectedDataWillBecomeUnavailableNotif:)
                                                 name:UIApplicationProtectedDataWillBecomeUnavailable
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appProtectedDataDidBecomeAvailableNotif:)
                                                 name:UIApplicationProtectedDataDidBecomeAvailable
                                               object:nil];
}

#pragma mark - notifiers
- (void)appDidEnterBackgroundNotif:(NSNotification*)notif{
    [[EaseMob sharedInstance] applicationDidEnterBackground:notif.object];
}

- (void)appWillEnterForeground:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationWillEnterForeground:notif.object];
}

- (void)appDidFinishLaunching:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationDidFinishLaunching:notif.object];
}

- (void)appDidBecomeActiveNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationDidBecomeActive:notif.object];
}

- (void)appWillResignActiveNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationWillResignActive:notif.object];
}

- (void)appDidReceiveMemoryWarning:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationDidReceiveMemoryWarning:notif.object];
}

- (void)appWillTerminateNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationWillTerminate:notif.object];
}

- (void)appProtectedDataWillBecomeUnavailableNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationProtectedDataWillBecomeUnavailable:notif.object];
}

- (void)appProtectedDataDidBecomeAvailableNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationProtectedDataDidBecomeAvailable:notif.object];
}

// 注册推送
- (void)registerRemoteNotification
{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}

#pragma mark - registerEaseMobNotification

- (void)registerEaseMobNotification{
    [self unRegisterEaseMobNotification];
    // 将self 添加到SDK回调中，以便本类可以收到SDK回调
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unRegisterEaseMobNotification
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}


#pragma mark - IChatManagerDelegate
// 开始自动登录回调
-(void)willAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    if (error)
    {
        //发送自动登陆状态通知
        [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_STATUS_CHANGED_NOTIFICATION object:@NO];
    }
    else
    {
        //将旧版的coredata数据导入新的数据库
        EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
        if (!error)
        {
            error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
        }
    }
}

- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    [self didAutoLoginWithInfo:loginInfo error:error];
}

// 结束自动登录回调
-(void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    if (error) {
        //发送自动登陆状态通知
        [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_STATUS_CHANGED_NOTIFICATION object:@NO];
    }
    else
    {
        //登录完成后设置apns属性
        EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
        options.nickname = [UserSession sharedInstance].currentUser.user_name;
        options.displayStyle = ePushNotificationDisplayStyle_messageSummary;
        BOOL receiveMessageNotice = [SettingEntiy sharedInstance].receiveNewMessageSwitch;
        options.noDisturbStatus = receiveMessageNotice ? ePushNotificationNoDisturbStatusClose : ePushNotificationNoDisturbStatusDay;
        [[[EaseMob sharedInstance] chatManager] asyncUpdatePushOptions:options];
        
        //设置推送昵称
        [[EaseMob sharedInstance].chatManager setApnsNickname:[UserSession sharedInstance].currentUser.easemob];
    }
}

//收到一条消息
- (void)didReceiveMessage:(EMMessage *)message
{
    NSMutableArray *blockList = [UserInfo info].quietEasemobs;
    if ([blockList containsObject:message.from])
    {
        //如果用户在免打扰列表里，就不提醒也不震动。
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_CHAT_TABBAR_BADGE object:nil];
    if ([SettingEntiy sharedInstance].receiveNewMessageSwitch)
    {
        [self showLocalNotificationWithMessage:message];
    }
    if ([SettingEntiy sharedInstance].vibrationSwitch)
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    if ([SettingEntiy sharedInstance].voiceSwitch)
    {
        SystemSoundID soundID;
        AudioServicesCreateSystemSoundID((__bridge_retained CFURLRef)[NSURL URLWithString:SOUND_URL],&soundID);
        AudioServicesPlaySystemSound(soundID);
    }

}

// 好友申请回调
- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message
{
    if (!username)
    {
        return;
    }
    if (!message)
    {
        message = [NSString stringWithFormat:@"%@请求加你为好友",username];
    }
    
    //如果开启了好友验证
    if ([SettingEntiy sharedInstance].friendsVerifySwitch)
    {
        [[ApplyViewController shareController] addNewApply:username message:message];
    }
    else
    {
        EMError *error;
        [[EaseMob sharedInstance].chatManager acceptBuddyRequest:username error:&error];
        if (error)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:@"未能接受好友申请"];
        }
    }

}

//发出的好友请求被username接受了
- (void)didAcceptedByBuddy:(NSString *)username;
{
    [self.userdetailModel addFriend:username withMessage:@"ddd"];
}

// 网络状态变化回调
- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    //TODO: 网络状态改变的时候所需要做的事情
}

//当前账号在其他设备登陆
- (void)didLoginFromOtherDevice
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_STATUS_CHANGED_NOTIFICATION object:@NO];
}

// 打印收到的apns信息
- (void)easemobdidReceiveRemoteNotification:(NSDictionary *)userInfo;
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
                                                        options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    DLog(@"%@",str);
}


#pragma mark - Private
- (void)showLocalNotificationWithMessage:(EMMessage *)message
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = [NSString stringWithFormat:@"%@ : %@",message.from,[self notificationBodyWithMessageBody:[message.messageBodies firstObject]]];
    notification.alertAction = @"查看";
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (NSString *)notificationBodyWithMessageBody:(id<IEMMessageBody>)body
{
    switch (body.messageBodyType)
    {
        case eMessageBodyType_Text:
        {
            EMTextMessageBody *textMessage = (EMTextMessageBody *)body;
            return textMessage.text;
        }
        case eMessageBodyType_File: return @"[文件]";
        case eMessageBodyType_Image: return @"[图片]";
        case eMessageBodyType_Video: return @"[视频]";
        case eMessageBodyType_Voice: return @"[语音]";
        case eMessageBodyType_Command: return @"";
        case eMessageBodyType_Location: return @"[位置]";
    }
}


@end
