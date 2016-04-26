

#import "EMCDDeviceManager.h"

@interface EMCDDeviceManager (Microphone)
// 判断麦克风是否可用
- (BOOL)emCheckMicrophoneAvailability;

// 获取录制音频时的音量(0~1)
- (double)emPeekRecorderVoiceMeter;
@end
