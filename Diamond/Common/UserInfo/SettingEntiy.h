//
//  SettingEntiy.h
//  Diamond
//
//  Created by Pan on 15/8/18.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"

@interface SettingEntiy : BaseEntity


+ (SettingEntiy *)sharedInstance;

/**
 *  是否接收新消息通知
 */
@property (nonatomic, readwrite) BOOL receiveNewMessageSwitch;
/**
 *  是否播放声音
 */
@property (nonatomic, readwrite) BOOL voiceSwitch;
/**
 *  是否开启震动
 */
@property (nonatomic, readwrite) BOOL vibrationSwitch;
/**
 *  是否开启扬声器
 */
@property (nonatomic, readwrite) BOOL speakerSwitch;
/**
 *  是否开启好友验证
 */
@property (nonatomic, readwrite) BOOL friendsVerifySwitch;


/**
 *  持久化一下
 */
- (void)synchronize;

@end
