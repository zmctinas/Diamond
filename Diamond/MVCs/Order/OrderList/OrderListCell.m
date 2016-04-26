//
//  OrderListCell.m
//  Diamond
//
//  Created by Pan on 15/8/31.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "OrderListCell.h"
#import "URLConstant.h"
#import "UIImageView+WebCache.h"
#import "Util.h"
@interface OrderListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *wareImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) NSString *oldPrice;
@property (strong, nonatomic) NSAttributedString *oldPriceAttString;
@property (strong, nonatomic) UIImage *placeholder;

@end


@implementation OrderListCell
@synthesize ware;

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!IS_NULL(ware.goods_url))
    {
        NSURL *url = [Util urlWithPath:ware.goods_url];
        [self.wareImageView sd_setImageWithURL:url placeholderImage:self.placeholder];
    }
    else
    {
        [self.wareImageView setImage:self.placeholder];
    }
    self.titleLabel.text = ware.goods_name;
    self.priceLabel.text =  [NSString stringWithFormat:@"￥%.2f",[ware.nowprice doubleValue]];
    self.oldPrice = [NSString stringWithFormat:@"￥%.2f",[ware.price doubleValue]];
    self.oldPriceLabel.attributedText = self.oldPriceAttString;
    self.oldPriceLabel.adjustsFontSizeToFitWidth = YES;
    
    self.typeLabel.text = ware.type_name;
    self.countLabel.text = [NSString stringWithFormat:@"x%@",ware.number];
    if (self.ware.discount.doubleValue < 10 && self.ware.nowprice != self.ware.price)
    {
        self.oldPriceLabel.hidden = NO;
    }
    else
    {
        self.oldPriceLabel.hidden = YES;
    }
}


- (void)setOldPrice:(NSString *)oldPrice
{
    NSUInteger length = [oldPrice length];
    NSRange allRange = NSMakeRange(0, length);
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:allRange];
    [attri addAttribute:NSStrikethroughColorAttributeName value:UIColorFromRGB(LIGHT_GRAY) range:allRange];
    [attri addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(LIGHT_GRAY) range:allRange];
    
    _oldPriceAttString = attri;
    _oldPrice = oldPrice;
}

- (UIImage *)placeholder
{
    if (!_placeholder)
    {
        _placeholder = [UIImage imageNamed:@"goods_bg_jiazai"];
    }
    return _placeholder;
}




@end
