

#import "EMChatViewBaseCell.h"

#import "EMChatTextBubbleView.h"
#import "EMChatImageBubbleView.h"
#import "EMChatAudioBubbleView.h"
#import "EMChatVideoBubbleView.h"
#import "EMChatLocationBubbleView.h"

#define SEND_STATUS_SIZE 20 // 发送状态View的Size
#define ACTIVTIYVIEW_BUBBLE_PADDING 5 // 菊花和bubbleView之间的间距

extern NSString *const kResendButtonTapEventName;
extern NSString *const kShouldResendCell;

@interface EMChatViewCell : EMChatViewBaseCell

//sender
@property (nonatomic, strong) UIActivityIndicatorView *activtiy;
@property (nonatomic, strong) UIView *activityView;
@property (nonatomic, strong) UIButton *retryButton;
@property (nonatomic, strong) UILabel *hasRead;

@end
