

#import "EMCDDeviceManager.h"
#import <AudioToolbox/AudioToolbox.h>
@interface EMCDDeviceManager (Remind)
// 播放接收到新消息时的声音
- (SystemSoundID)playNewMessageSound;

// 震动
- (void)playVibration;
@end
