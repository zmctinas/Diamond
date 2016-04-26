//
//  SelectedWareCell.m
//  Diamond
//
//  Created by Leon Hu on 15/8/16.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "SelectedWareCell.h"
#import "UIImageView+Category.h"
#import "UIImageView+WebCache.h"
#import "Util.h"
#import "WaresEntity.h"

@interface SelectedWareCell()

@property (weak, nonatomic) IBOutlet UIImageView *goodsPictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeRemaindLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectionCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *addTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *limitedSpecialButton;
@property (weak, nonatomic) IBOutlet UILabel *promotionPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *promotionLabel;

- (IBAction)touchLimitedSpecialButton:(UIButton *)sender;

@property (nonatomic,strong) NSDate *startTime;
@property (nonatomic,strong) NSDate *endTime;

@end

@implementation SelectedWareCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addCountDownObserver];
    if([self.ware.goods_url count])
    {
        NSString *first = [self.ware.goods_url firstObject];
        [self.goodsPictureImageView sd_setImageWithURL:[Util urlWithPath:first]];
    }else{
        [self.goodsPictureImageView setDefaultLoadingImage];
    }
    
    [self.goodsNameLabel setText:self.ware.goods_name];
    
    NSAttributedString *attr =
    [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%.2f",self.ware.goods_price.doubleValue]
                                    attributes:@{
                                                 NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle)
                                                 }];
    self.goodsPriceLabel.attributedText = attr;
    
    double price = self.ware.is_promotion ? self.ware.promotion_price.doubleValue : self.ware.goods_price.doubleValue;
    [self.promotionPriceLabel setText:[NSString stringWithFormat:@"￥%.2f", price]];
    
    NSInteger count = [self.ware.collec isEqual:[NSNull null]] ? 0 : [self.ware.collec integerValue];
    [self.collectionCountLabel setText:[NSString stringWithFormat:@"%@%ld",@"收藏量:", (long)count]];
    
    [self.addTimeLabel setText:self.ware.add_time];
    
    if (self.type == LimitedSpecialDelete) {
        NSString *promotion = [NSString stringWithFormat:@" %.1f折 ", (self.ware.discount.doubleValue)];
        [self.promotionLabel setText:promotion];
        
        self.promotionLabel.layer.borderColor = UIColorFromRGB(GLOBAL_TINTCOLOR).CGColor;
        self.promotionLabel.layer.borderWidth = 1.0;
        
    }else if (self.type == LimitedSpecialSelect){
        if (self.ware.is_promotion)
        {
            [self.limitedSpecialButton setImage:[UIImage imageNamed:@"choice_btn_selected"] forState:UIControlStateNormal];
        }else{
            [self.limitedSpecialButton setImage:nil forState:UIControlStateNormal];
        }
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if (self.ware.start_time.length>0) {
        self.startTime = [NSDate dateWithTimeIntervalSince1970:self.ware.start_time.integerValue];
    }
    if (self.ware.end_time.length) {
        self.endTime = [NSDate dateWithTimeIntervalSince1970:self.ware.end_time.integerValue];
        [self countDown:self.endTime];
    }
}

- (IBAction)touchLimitedSpecialButton:(UIButton *)sender {
    if ([sender currentImage]) {
        [sender setImage:nil forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageNamed:@"choice_btn_selected"] forState:UIControlStateNormal];
    }
    
    if ([self.delegate respondsToSelector:@selector(selectedWareCell:didWareWasSelected:)])
    {
        BOOL isOn = NO;
        if ([sender currentImage]) {
            isOn = YES;
        }
        
        [self.delegate selectedWareCell:self didWareWasSelected:isOn];
    }
}

- (void)addCountDownObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TICK_TOCK_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNotification:) name:TICK_TOCK_NOTIFICATION object:nil];
}

- (void)countDown:(NSDate *)time
{
    NSString *countDownString = [Util countDownStringWithDate:time];
    if (!IS_NULL(countDownString)) {
        [self.timeRemaindLabel setHidden:NO];
        [self.timeRemaindLabel setText:countDownString];
    }else{
        [self.timeRemaindLabel setHidden:YES];
    }
}

- (void)receivedNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:TICK_TOCK_NOTIFICATION]){
        [self countDown:self.endTime];
    }
}

@end
