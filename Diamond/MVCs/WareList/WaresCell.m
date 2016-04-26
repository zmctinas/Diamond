//
//  WaresCell.m
//  Diamond
//
//  Created by Pan on 15/7/28.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "WaresCell.h"
#import "Macros.h"
#import "UIImageView+WebCache.h"

@interface WaresCell ()

@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *distanceButton;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *middlePriceLabel;
@property (strong, nonatomic) UIImage *placeholder;


@end

@implementation WaresCell

- (void)awakeFromNib
{

}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.ware = nil;
    self.indexPath = nil;
}

- (void)layoutSubviews
{
    [self countDown];
    [self addCountDownObserver];
    [self setupPriceLabels];
    if ([self.ware.goods_url count])
    {
        NSURL *url = [Util urlWithPath:[self.ware.goods_url firstObject]];
        [self.imageView sd_setImageWithURL:url placeholderImage:self.placeholder];
    }
    else
    {
        [self.imageView setImage:self.placeholder];
    }
    self.nameLabel.text = self.ware.goods_name;
    [self setupDistanceButton:self.ware.distance];

    [super layoutSubviews];
}

- (void)setupDistanceButton:(NSString *)distanceString
{
    self.distanceButton.hidden = IS_NULL(distanceString);
    NSString *distance = ([distanceString doubleValue] > 1000)
    ? ([NSString stringWithFormat:@"%.1lfkm",[self.ware.distance doubleValue] / 1000])
    : ([NSString stringWithFormat:@"%@m",self.ware.distance]);
    self.distanceButton.titleLabel.text = distance;
    [self.distanceButton setTitle:distance forState:UIControlStateNormal];
}

- (void)setupPriceLabels
{
    //如果打折
    BOOL isPromotion = self.ware.is_promotion;
    
    self.priceLabel.hidden = !isPromotion;
    self.oldPriceLabel.hidden = !isPromotion;
    self.middlePriceLabel.hidden = isPromotion;

    if (isPromotion)
    {
        CGFloat price = [self.ware.promotion_price doubleValue];
        NSString *priceStr = [Util priceStringWithPrice:price];
        self.priceLabel.text =  priceStr;
        
        NSString *oldPriceStr = [Util priceStringWithPrice:[self.ware.goods_price doubleValue]];
        self.oldPriceLabel.attributedText = [Util deleteLineStyleString:oldPriceStr];
        self.oldPriceLabel.adjustsFontSizeToFitWidth = YES;
    }
    else
    {
        self.middlePriceLabel.text =  [NSString stringWithFormat:@"￥%.2f",[self.ware.goods_price doubleValue]];
    }
}


- (void)addCountDownObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TICK_TOCK_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDown) name:TICK_TOCK_NOTIFICATION object:nil];
}

- (void)countDown;
{
    NSString *countDownString = [Util countDownStringWithDate:[NSDate dateWithTimeIntervalSince1970:self.ware.end_time.integerValue]];
    if (!IS_NULL(countDownString)) {
        [self.countDownLabel setHidden:NO];
        [self.countDownLabel setText:countDownString];
    }else{
        [self.countDownLabel setHidden:YES];
    }
}

- (UIImage *)placeholder
{
    if (!_placeholder)
    {
        _placeholder = [UIImage imageNamed:@"goods_bg_jiazai"];
    }
    return _placeholder;
}

- (void)setWare:(WaresEntity *)ware
{
    _ware = ware;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
@end
