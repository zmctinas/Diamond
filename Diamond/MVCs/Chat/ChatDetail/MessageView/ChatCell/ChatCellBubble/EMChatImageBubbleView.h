

#import <UIKit/UIKit.h>

#import "EMChatBaseBubbleView.h"

#define MAX_SIZE 120 //　图片最大显示大小

extern NSString *const kRouterEventImageBubbleTapEventName;

@interface EMChatImageBubbleView : EMChatBaseBubbleView

@property (nonatomic, strong) UIImageView *imageView;

@end
