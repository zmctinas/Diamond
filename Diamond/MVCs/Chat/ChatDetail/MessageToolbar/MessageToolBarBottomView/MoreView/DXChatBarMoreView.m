
#import "DXChatBarMoreView.h"
#import "Macros.h"

#define CHAT_BUTTON_SIZE 50
#define CHAT_LABEL_HEIGHT 28
#define INSETS 8
#define TOP_MARGIN 7
#define LABEL_PADDING_IMAGE -5

@implementation DXChatBarMoreView

- (instancetype)initWithFrame:(CGRect)frame typw:(ChatMoreType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupSubviewsForType:type];
    }
    return self;
}

- (void)setupSubviewsForType:(ChatMoreType)type
{
    self.backgroundColor = [UIColor clearColor];
    CGFloat insets = (self.frame.size.width - 4 * CHAT_BUTTON_SIZE) / 3;
    
    
    _locationButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_locationButton setFrame:CGRectMake(insets, TOP_MARGIN, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_locationButton setImage:[UIImage imageNamed:@"chatBar_colorMore_location"] forState:UIControlStateNormal];
//    [_locationButton setImage:[UIImage imageNamed:@"chatBar_colorMore_locationSelected"] forState:UIControlStateHighlighted];
    [_locationButton addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_locationButton];
    _locationLabel =[[UILabel alloc] initWithFrame:CGRectMake(insets, TOP_MARGIN + CHAT_BUTTON_SIZE + LABEL_PADDING_IMAGE , CHAT_BUTTON_SIZE , 28)];
    _locationLabel.font = [UIFont systemFontOfSize:12];
    _locationLabel.textAlignment = NSTextAlignmentCenter;
    _locationLabel.textColor = UIColorFromRGB(0xf6b544);
    _locationLabel.text = @"位置";
    [self addSubview:_locationLabel];
    

    _takePicButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_takePicButton setFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE, TOP_MARGIN, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_takePicButton setImage:[UIImage imageNamed:@"chatBar_colorMore_camera"] forState:UIControlStateNormal];
    [_takePicButton addTarget:self action:@selector(takePicAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_takePicButton];
    _takePicLabel =[[UILabel alloc] initWithFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE, TOP_MARGIN + CHAT_BUTTON_SIZE + LABEL_PADDING_IMAGE , CHAT_BUTTON_SIZE , 28)];
    _takePicLabel.font = [UIFont systemFontOfSize:12];
    _takePicLabel.textAlignment = NSTextAlignmentCenter;
    _takePicLabel.textColor = UIColorFromRGB(0x6cbaff);
    _takePicLabel.text = @"相机";
    [self addSubview:_takePicLabel];
    
    
    _photoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_photoButton setFrame:CGRectMake(insets * 3 + CHAT_BUTTON_SIZE * 2, TOP_MARGIN, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_photoButton setImage:[UIImage imageNamed:@"chatBar_colorMore_photo"] forState:UIControlStateNormal];
    [_photoButton addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_photoButton];
    _photoLabel =[[UILabel alloc] initWithFrame:CGRectMake(insets * 3 + CHAT_BUTTON_SIZE * 2, TOP_MARGIN + CHAT_BUTTON_SIZE + LABEL_PADDING_IMAGE , CHAT_BUTTON_SIZE , 28)];
    _photoLabel.font = [UIFont systemFontOfSize:12];
    _photoLabel.textAlignment = NSTextAlignmentCenter;
    _photoLabel.textColor = UIColorFromRGB(0x5cd64c);
    _photoLabel.text = @"相册";
    [self addSubview:_photoLabel];
    



}

#pragma mark - action

- (void)takePicAction{
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewTakePicAction:)]){
        [_delegate moreViewTakePicAction:self];
    }
}

- (void)photoAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewPhotoAction:)]) {
        [_delegate moreViewPhotoAction:self];
    }
}

- (void)locationAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLocationAction:)]) {
        [_delegate moreViewLocationAction:self];
    }
}


@end
