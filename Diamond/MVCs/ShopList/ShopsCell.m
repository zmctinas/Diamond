//
//  ShopsCell.m
//  Diamond
//
//  Created by Pan on 15/7/29.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ShopsCell.h"
#import "Shop.h"
#import "UIImageView+WebCache.h"
#import "URLConstant.h"
#import "Util.h"


#define ICON_WIDTH 16
#define ICON_HEIGHT 16
#define ICON_MARGIN 3.5
#define ICON_MARGIN_BOTTOM 10

#define IMAGENAME_HOT  @"hothot"
#define IMAGENAME_NEW  @"newnew"
#define IMAGENAME_PROMOTION  @"discount"
#define IMAGENAME_RECOMMOND  @"recommond"



@interface ShopsCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shopAdImageView;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;


@property (nonatomic) CGFloat marginRight;
@property (strong, nonatomic) NSMutableArray *icons;
@end

@implementation ShopsCell

- (void)awakeFromNib
{
    self.marginRight = 7.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    [self clearIcons];
    if (self.shop)
    {
        [self setImageForImageView];
        [self setTextForDistanceLabel];
        [self setIcons];
        [self setDiscount];
        self.nameLabel.text = self.shop.shop_name;
        self.addressLabel.text = self.shop.address;
    }
}

- (void)prepareForReuse
{
    [self clearIcons];
}

- (void)clearIcons
{
    for (UIButton *button in self.icons)
    {
        [button removeFromSuperview];
    }
    self.marginRight = 7.0f;
}

- (void)setDiscount
{
    if (self.shop.is_promotion && self.shop.discount.doubleValue < 10)
    {
        [self.discountLabel setHidden:NO];
        NSString *str = [NSString stringWithFormat:@"全场%.1f折起",self.shop.discount.doubleValue];
        [self.discountLabel setText:str];
    }
    else
    {
        [self.discountLabel setHidden:YES];
    }
}

- (void)setIcons
{
    if (self.shop.is_recommend)
    {
        [self addButtonWithImageName:IMAGENAME_RECOMMOND];
    }
    if (self.shop.is_promotion)
    {
        [self addButtonWithImageName:IMAGENAME_PROMOTION];
    }
    if (self.shop.is_new)
    {
        [self addButtonWithImageName:IMAGENAME_NEW];
    }
    if (self.shop.is_hot)
    {
        [self addButtonWithImageName:IMAGENAME_HOT];
    }
}

- (void)addButtonWithImageName:(NSString *)imageName
{
    CGFloat x = self.frame.size.width - ICON_WIDTH - self.marginRight;
    CGFloat y = self.frame.size.height - ICON_HEIGHT - ICON_MARGIN_BOTTOM;
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(x, y, ICON_WIDTH, ICON_HEIGHT)];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self.icons addObject:button];
    [self addSubview:button];
    
    self.marginRight += (ICON_WIDTH + ICON_MARGIN);
}


- (void)setTextForDistanceLabel
{
    NSString *distance = (self.shop.distance  > 1000)
    ? ([NSString stringWithFormat:@"距离 %.1lfkm",self.shop.distance  / 1000])
    : ([NSString stringWithFormat:@"距离 %dm",(int)self.shop.distance]);
    self.distanceLabel.text =  distance;
}

- (void)setImageForImageView
{
    if ([self.shop.shop_ad count])
    {
        NSURL *url = [Util urlWithPath:[self.shop.shop_ad firstObject]];
        [self.shopAdImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"goods_bg_jiazai"]];
    }
    else
    {
        [self.shopAdImageView setImage:[UIImage imageNamed:@"shop_pic_bg_jiazai"]];
    }
}


- (NSMutableArray *)icons
{
    if (!_icons)
    {
        _icons = [NSMutableArray array];
    }
    return _icons;
}
@end
