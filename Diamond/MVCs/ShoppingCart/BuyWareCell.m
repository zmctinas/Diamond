//
//  BuyWareCell.m
//  Diamond
//
//  Created by Leon Hu on 15/9/1.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BuyWareCell.h"
#import "UIImageView+WebCache.h"
#import "Util.h"
#import "UIImageView+Category.h"

@interface BuyWareCell()

@property (weak, nonatomic) IBOutlet UIButton *checkBoxButton;
@property (weak, nonatomic) IBOutlet UIImageView *wareImageView;
@property (weak, nonatomic) IBOutlet UILabel *wareNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *wareModelLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *buyCountLabel;

- (IBAction)touchCheckBoxButton:(UIButton *)sender;
- (IBAction)touchMinusBuyCountButton:(UIButton *)sender;
- (IBAction)touchAddBuyCountButton:(UIButton *)sender;
- (IBAction)touchDeleteButton:(UIButton *)sender;

@end

@implementation BuyWareCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.entity) {
        UIImage *placeholder = [UIImage imageNamed:@"seller_home_pic_jiazai"];
        //先加载Loading画面
        [self.wareImageView setDefaultLoadingImage];
        [self.wareImageView sd_setImageWithURL:[Util urlWithPath:self.entity.goods_url] placeholderImage:placeholder];
        [self.wareNameLabel setText:self.entity.goods_name];
        [self.wareModelLabel setText:[NSString stringWithFormat:@"型号尺寸:%@",self.entity.type]];
        [self.buyCountLabel setText:[NSString stringWithFormat:@"%ld",(long)self.entity.count_no]];
        
        UIImage *image = self.entity.isChecked ? [UIImage imageNamed:@"DM_Selected_icon"] : nil;
        [self.checkBoxButton setImage:image forState:UIControlStateNormal];
        [self setupPriceLabel];
    }
}

- (void)setupPriceLabel
{
    CGFloat discount = [self.entity.discount doubleValue];
    CGFloat price = [self.entity.price doubleValue];
    CGFloat nowPrice = self.entity.is_promotion ? (price * discount) : price;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2lf",nowPrice];
    self.oldPriceLabel.attributedText = [Util deleteLineStyleString:[NSString stringWithFormat:@"￥%@",self.entity.price]];
    self.oldPriceLabel.hidden = !self.entity.is_promotion;
}

- (IBAction)touchCheckBoxButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(BuyWareCellBeingSelectedAtIndexPath:)]) {
        [self.delegate BuyWareCellBeingSelectedAtIndexPath:self.indexPath];
    }
}

- (IBAction)touchMinusBuyCountButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(BuyWareCellBeingTouchMinusButtonAtIndexPath:)]) {
        [self.delegate BuyWareCellBeingTouchMinusButtonAtIndexPath:self.indexPath];
    }
}

- (IBAction)touchAddBuyCountButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(BuyWareCellBeingTouchAddButtonAtIndexPath:)]) {
        [self.delegate BuyWareCellBeingTouchAddButtonAtIndexPath:self.indexPath];
    }
}

- (IBAction)touchDeleteButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(BuyWareCellBeingTouchDeleteButtonAtIndexPath:)]) {
        [self.delegate BuyWareCellBeingTouchDeleteButtonAtIndexPath:self.indexPath];
    }
}

@end
