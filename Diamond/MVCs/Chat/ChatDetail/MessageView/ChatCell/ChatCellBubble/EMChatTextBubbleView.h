

#import <UIKit/UIKit.h>
#import "EMChatBaseBubbleView.h"


#define TEXTLABEL_MAX_WIDTH 200 // textLaebl 最大宽度
#define LABEL_FONT_SIZE 14      // 文字大小
#define LABEL_LINESPACE 0       // 行间距

extern NSString *const kRouterEventTextURLTapEventName;

@interface EMChatTextBubbleView : EMChatBaseBubbleView

@property (nonatomic, strong) UILabel *textLabel;
+ (CGFloat)lineSpacing;
+ (UIFont *)textLabelFont;
+ (NSLineBreakMode)textLabelLineBreakModel;

@end
