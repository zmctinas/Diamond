

#import "EMChatLocationBubbleView.h"
#import "Macros.h"
NSString *const kRouterEventLocationBubbleTapEventName = @"kRouterEventLocationBubbleTapEventName";

@interface EMChatLocationBubbleView ()

@property (nonatomic, strong) UIImageView *locationImageView;
@property (nonatomic, strong) UILabel *addressLabel;

@end

@implementation EMChatLocationBubbleView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LOCATION_IMAGEVIEW_SIZE, LOCATION_IMAGEVIEW_SIZE)];
        [self addSubview:_locationImageView];
        
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = [UIFont systemFontOfSize:LOCATION_ADDRESS_LABEL_FONT_SIZE];
        _addressLabel.textColor = UIColorFromRGB(0x555555);
        _addressLabel.numberOfLines = 0;
        _addressLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        [_locationImageView addSubview:_addressLabel];
    }
    return self;
}

-(CGSize)sizeThatFits:(CGSize)size
{
    CGSize textBlockMinSize = {130, 25};
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

    CGSize addressSize = [self.model.address sizeWithFont:_addressLabel.font constrainedToSize:textBlockMinSize lineBreakMode:NSLineBreakByCharWrapping];
    CGFloat width = addressSize.width < LOCATION_IMAGEVIEW_SIZE ? LOCATION_IMAGEVIEW_SIZE : addressSize.width;
#pragma clang diagnostic pop
    
    
    return CGSizeMake(width + BUBBLE_VIEW_PADDING * 2 + BUBBLE_ARROW_WIDTH, 2 * BUBBLE_VIEW_PADDING + LOCATION_IMAGEVIEW_SIZE);
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    frame.size.width -= BUBBLE_ARROW_WIDTH;
    frame = CGRectInset(frame, BUBBLE_VIEW_PADDING, BUBBLE_VIEW_PADDING);
    if (self.model.isSender) {
        frame.origin.x = BUBBLE_VIEW_PADDING;
    }else{
        frame.origin.x = BUBBLE_VIEW_PADDING + BUBBLE_ARROW_WIDTH;
    }
    
    frame.origin.y = BUBBLE_VIEW_PADDING;
    [self.locationImageView setFrame:frame];
    _addressLabel.frame = CGRectMake(0, self.locationImageView.frame.size.height - LOCATION_ADDRESS_LABEL_BGVIEW_HEIGHT, self.locationImageView.frame.size.width, LOCATION_ADDRESS_LABEL_BGVIEW_HEIGHT);
}

#pragma mark - setter

- (void)setModel:(MessageModel *)model
{
    [super setModel:model];
    
    _locationImageView.image = [[UIImage imageNamed:LOCATION_IMAGE] stretchableImageWithLeftCapWidth:10 topCapHeight:10]; // 设置地图图片
    _addressLabel.text = model.address;
}

#pragma mark - public

-(void)bubbleViewPressed:(id)sender
{
    [self routerEventWithName:kRouterEventLocationBubbleTapEventName userInfo:@{KMESSAGEKEY:self.model}];
}

+(CGFloat)heightForBubbleWithObject:(MessageModel *)object
{
    return 2 * BUBBLE_VIEW_PADDING + LOCATION_IMAGEVIEW_SIZE;
}
@end
