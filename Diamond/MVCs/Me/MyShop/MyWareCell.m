//
//  MyWareCellTableViewCell.m
//  Diamond
//
//  Created by Leon Hu on 15/8/8.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "MyWareCell.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+Category.h"
#import "UserSession.h"
#import "WaresEntity.h"
#import "Util.h"

@interface MyWareCell()

@property (weak, nonatomic) IBOutlet UIImageView *goodsPictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *promotionPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectionCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *addTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *setUpOrDownButton;
@property (weak, nonatomic) IBOutlet UILabel *disountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeRemaindLabel;

- (IBAction)touchEditGoodsButton:(UIButton *)sender;
- (IBAction)touchSetupButton:(UIButton *)sender;

@end

@implementation MyWareCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if([self.ware.goods_url count])
    {
        NSString *first = [self.ware.goods_url firstObject];
        [self.goodsPictureImageView sd_setImageWithURL:[Util urlWithPath:first]
                                      placeholderImage:[UIImage imageNamed:@"seller_home_pic_jiazai"]];
    }else{
        [self.goodsPictureImageView setDefaultLoadingImage];
    }
    
    [self.goodsNameLabel setText:self.ware.goods_name];
    if (self.ware.is_promotion) {
        NSAttributedString *attr = [Util deleteLineStyleString:[NSString stringWithFormat:@"￥%.2f", self.ware.goods_price.doubleValue]];
        [self.goodsPriceLabel setAttributedText:attr];
        [self.goodsPriceLabel setHidden:NO];
        [self.disountLabel setHidden:NO];
        NSString *promotion = [NSString stringWithFormat:@" %.1f折 ",self.ware.discount.doubleValue];
        [self.disountLabel setText:promotion];
        
        self.disountLabel.layer.borderColor = UIColorFromRGB(GLOBAL_TINTCOLOR).CGColor;
        self.disountLabel.layer.borderWidth = 1.0;
    }else{
        [self.goodsPriceLabel setHidden:YES];
        [self.disountLabel setHidden:YES];
    }
    double price = self.ware.is_promotion ? self.ware.promotion_price.doubleValue : self.ware.goods_price.doubleValue;
    [self.promotionPriceLabel setText:[NSString stringWithFormat:@"￥%.2f", price]];

    NSInteger count = [self.ware.collec isEqual:[NSNull null]] ? 0 : [self.ware.collec integerValue];
    [self.collectionCountLabel setText:[NSString stringWithFormat:@"收藏量:%ld",(long)count]];
    
    [self.addTimeLabel setText:self.ware.add_time];
    
    if (self.ware.is_sale) {
        [self.setUpOrDownButton setImage:[UIImage imageNamed:@"seller_home_icon_xiajia"] forState:UIControlStateNormal];
        [self.setUpOrDownButton setTitle:@"下架宝贝" forState:UIControlStateNormal];
    }else{
        [self.setUpOrDownButton setImage:[UIImage imageNamed:@"seller_home_icon_shangjia"] forState:UIControlStateNormal];
        [self.setUpOrDownButton setTitle:@"上架宝贝" forState:UIControlStateNormal];
    }
    self.setUpOrDownButton.adjustsImageWhenHighlighted = NO;
    
    if (self.ware.end_time.integerValue > [NSDate date].timeIntervalSince1970) {
        NSDate *endTime = [NSDate dateWithTimeIntervalSince1970:self.ware.end_time.integerValue];
        [self countDown:endTime];
    }
    else
    {
        [self countDown:nil];
    }
}

- (IBAction)touchEditGoodsButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(myWareCell:didTouchEditButton:)])
    {
        [self.delegate myWareCell:self didTouchEditButton:sender];
    }
}

- (IBAction)touchSetupButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(myWareCell:didTouchSetupButton:)])
    {
        [self.delegate myWareCell:self didTouchSetupButton:sender];
    }
}

- (void)countDown:(NSDate *)time
{
    if (time) {
        NSTimeInterval interval = [time timeIntervalSinceDate:[NSDate date]];
        if (interval <= 0 ) {
            [self.timeRemaindLabel setHidden:YES];
            return;
        }
        int day = interval / 86400;
        //剩余
        int residue = ((int)interval % 86400);
        int hour =  residue / 3600;
        residue = residue % 3600;
        int min = residue /60;
        int second = residue % 60;
        
        NSMutableString *str = [NSMutableString new];
        
        if (day>0) {
            [str appendFormat:@"%ld天",(long)day];
        }
        if(hour>9){
            [str appendFormat:@"%ld",(long)hour];
        }else{
            [str appendFormat:@"0%ld",(long)hour];
        }
        if(min>9){
            [str appendFormat:@":%ld",(long)min];
        }else{
            [str appendFormat:@":0%ld",(long)min];
        }
        if (day<=0) {//当显示天数的时候,不显示秒数
            if(second>9){
                [str appendFormat:@":%ld",(long)second];
            }else{
                [str appendFormat:@":0%ld",(long)second];
            }
        }
        
        [str insertString:@"剩余" atIndex:0];
        [self.timeRemaindLabel setHidden:NO];
        [self.timeRemaindLabel setText:str];
    }else{
        [self.timeRemaindLabel setHidden:YES];
    }
}


@end
