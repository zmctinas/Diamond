

#import <UIKit/UIKit.h>

typedef enum{
    ChatMoreTypeChat,
    ChatMoreTypeGroupChat,
}ChatMoreType;

@protocol DXChatBarMoreViewDelegate;
@interface DXChatBarMoreView : UIView

@property (nonatomic,assign) id<DXChatBarMoreViewDelegate> delegate;

@property (nonatomic, strong) UIButton *photoButton;
@property (nonatomic, strong) UIButton *takePicButton;
@property (nonatomic, strong) UIButton *locationButton;

@property (nonatomic, strong) UILabel *photoLabel;
@property (nonatomic, strong) UILabel *takePicLabel;
@property (nonatomic, strong) UILabel *locationLabel;


- (instancetype)initWithFrame:(CGRect)frame typw:(ChatMoreType)type;

- (void)setupSubviewsForType:(ChatMoreType)type;

@end

@protocol DXChatBarMoreViewDelegate <NSObject>

@required
- (void)moreViewTakePicAction:(DXChatBarMoreView *)moreView;
- (void)moreViewPhotoAction:(DXChatBarMoreView *)moreView;
- (void)moreViewLocationAction:(DXChatBarMoreView *)moreView;

@end
