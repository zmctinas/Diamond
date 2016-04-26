//
//  SearchGoodsCell.m
//  Diamond
//
//  Created by Pan on 15/8/5.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "SearchGoodsCell.h"
#import "Util.h"
#import "UIImageView+WebCache.h"
#import "URLConstant.h"
@interface SearchGoodsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation SearchGoodsCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat price = self.ware.is_promotion ? self.ware.promotion_price.doubleValue : self.ware.goods_price.doubleValue;
    self.priceLabel.text = [Util priceStringWithPrice:price];
    self.distanceLabel.text = [Util stringWithDistance:[self.ware.distance doubleValue]];
    self.nameLabel.text = self.ware.goods_name;
    
    UIImage *placeholder = [UIImage imageNamed:@"goods_bg_jiazai"];
    if ([self.ware.goods_url count])
    {
        NSURL *url = [Util urlWithPath:[self.ware.goods_url firstObject]];
        [self.goodsImageView sd_setImageWithURL:url placeholderImage:placeholder];
    }
    else
    {
        [self.goodsImageView setImage:placeholder];
    }
}


@end
