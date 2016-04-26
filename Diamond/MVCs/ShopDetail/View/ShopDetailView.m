//
//  ShopDetailView.m
//  Diamond
//
//  Created by Pan on 15/7/31.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ShopDetailView.h"
#import "URLConstant.h"
#import "Shop.h"
#import "Util.h"

#define ICON_MARGIN_RIGHT 7
#define ICON_WIDTH 16
#define ICON_HEIGHT 16
#define ICON_MARGIN 3.5
#define ICON_MARGIN_BOTTOM 9


#define POSTION_ONE ICON_MARGIN_RIGHT
#define POSTION_TOW ICON_MARGIN_RIGHT + ICON_WIDTH + ICON_MARGIN
#define POSTION_THREE POSTION_TOW + ICON_WIDTH +ICON_MARGIN
#define POSTION_FOUR POSTION_THREE + ICON_WIDTH + ICON_WIDTH

@interface ShopDetailView ()<PSCarouselDelegate>

@property (weak, nonatomic) IBOutlet UIView *shopNameView;
@property (weak, nonatomic) IBOutlet PSCarouselView *carouselView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@property (weak, nonatomic) IBOutlet UIButton *latestButton;
@property (weak, nonatomic) IBOutlet UIButton *recommondButton;
@property (weak, nonatomic) IBOutlet UIButton *discountButton;
@property (weak, nonatomic) IBOutlet UIButton *hotButton;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hotTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *newnewTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recommondTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *promotionTrailing;


- (IBAction)touchCallButton:(UIButton *)sender;


@end


@implementation ShopDetailView

- (void)awakeFromNib
{
    self.carouselView.pageDelegate = self;
}

- (void)layoutSubviews
{
    NSMutableArray *temp = [NSMutableArray array];
    for (NSString *imagePath in self.shop.shop_ad)
    {
        NSURL *url = [Util urlWithPath:imagePath];
        [temp addObject:url];
    }
    self.carouselView.placeholder = [UIImage imageNamed:@"shop_pic_bg_jiazai"];
    self.carouselView.imageURLs = temp;
    self.carouselView.autoMoving = NO;
    self.pageControl.numberOfPages = [temp count];
    self.nameLabel.text = self.shop.shop_name;
    if (!IS_NULL(self.shop.address))
    {
        NSMutableString *address = [NSMutableString string];
        if (self.shop.province) {
            [address appendString:self.shop.province];
        }
        if (self.shop.city) {
            [address appendString:self.shop.city];
        }
        if (self.shop.district) {
            [address appendString:self.shop.district];
        }
        [address appendString:self.shop.address];
        self.addressLabel.text = address;
    }
    self.distanceLabel.text = [Util stringWithDistance:self.shop.distance];
    if (!IS_NULL(self.shop.phoneNumber))
    {
        self.phoneNumberLabel.text = self.shop.phoneNumber;
    }
    [self setupIcons];
    [self setTipLabelValue];
    [super layoutSubviews];
}


- (void)setTipLabelValue
{
    NSMutableString *text = [[NSMutableString alloc] init];
    if (self.shop.is_promotion && self.shop.discount.doubleValue < 10) {
        [text appendString:[NSString stringWithFormat:@"(全场%.1f折起) ",self.shop.discount.doubleValue]];
    }
    if (self.shop.delivery_distance > 0) {
        [text appendString:[NSString stringWithFormat:@"%ld公里之内,",(long)self.shop.delivery_distance]];
    }
    if (self.shop.delivery_limit.doubleValue > 0.009) {
        [text appendString:[NSString stringWithFormat:@"%.2f以上,",self.shop.delivery_limit.doubleValue]];
    }
    if (self.shop.delivery_limit.doubleValue > 0 || self.shop.delivery_distance > 0)
    {
        [text appendString:@"免费配送"];
    }
    if (text.length > 0)
    {
        [self.tipLabel setText:text];
        [self.tipLabel setHidden:NO];
    }
    else
    {
        [self.tipLabel setHidden:YES];
    }
}


- (void)setupIcons
{
    BOOL hiddenHot = !self.shop.is_hot;
    BOOL hiddenNew = !self.shop.is_new;
    BOOL hiddenRec = !self.shop.is_recommend;
    BOOL hiddenPro = !self.shop.is_promotion;
    [self.discountButton setHidden:hiddenPro];
    [self.hotButton setHidden:hiddenHot];
    [self.recommondButton setHidden:hiddenRec];
    [self.latestButton setHidden:hiddenNew];
    
    //如果图标全部隐藏 或者全部显示 都不用管他的约束
    BOOL allhidden = (hiddenHot && hiddenNew && hiddenRec && hiddenPro);
    BOOL allNotHidden = (!hiddenHot && !hiddenNew && !hiddenRec && !hiddenPro);
    if (allhidden || allNotHidden)
    {
        return;
    }
    
    //计算约束
    NSInteger hiddenCount = 0;
    NSArray *iconsHiddenStaes = @[@(hiddenHot),@(hiddenNew),@(hiddenRec),@(hiddenPro)];
    for (NSNumber *hiddenState in iconsHiddenStaes)
    {
        if ([hiddenState boolValue])
        {
            hiddenCount++;
        }
    }
    
    if (hiddenCount == 1)
    {
        if (hiddenHot)
        {
            return;
        }
        else if (hiddenNew)
        {
            self.hotTrailing.constant = POSTION_THREE;
        }
        else if (hiddenRec)
        {
            self.hotTrailing.constant = POSTION_THREE;
            self.newnewTrailing.constant = POSTION_TOW;
        }
        else if (hiddenPro)
        {
            self.hotTrailing.constant = POSTION_THREE;
            self.newnewTrailing.constant = POSTION_TOW;
            self.recommondTrailing.constant = POSTION_ONE;
        }
     }
    else if (hiddenCount == 2)
    {
        if (hiddenHot)
        {
            if (hiddenNew)
            {
                return;
            }
            else if (hiddenRec)
            {
                self.newnewTrailing.constant = POSTION_TOW;
            }
            else if (hiddenPro)
            {
                self.newnewTrailing.constant = POSTION_TOW;
                self.recommondTrailing.constant = POSTION_ONE;
            }
        }
        else if (hiddenNew)
        {
            if (hiddenHot)
            {
                return;
            }
            else if (hiddenRec)
            {
                self.hotTrailing.constant = POSTION_TOW;
            }
            else if (hiddenPro)
            {
                self.hotTrailing.constant = POSTION_TOW;
                self.recommondTrailing.constant = POSTION_ONE;
            }
        }
        else if (hiddenRec)
        {
            if (hiddenHot)
            {
                self.newnewTrailing.constant = POSTION_TOW;
            }
            else if (hiddenNew)
            {
                self.hotTrailing.constant = POSTION_TOW;
            }
            else if (hiddenPro)
            {
                self.hotTrailing.constant = POSTION_TOW;
                self.newnewTrailing.constant = POSTION_ONE;
            }
        }
        else if (hiddenPro)
        {
            if (hiddenHot)
            {
                self.newnewTrailing.constant = POSTION_TOW;
                self.recommondTrailing.constant = POSTION_ONE;
            }
            else if (hiddenNew)
            {
                self.hotTrailing.constant = POSTION_TOW;
                self.recommondTrailing.constant = POSTION_ONE;
            }
            else if (hiddenRec)
            {
                self.hotTrailing.constant = POSTION_TOW;
                self.newnewTrailing.constant = POSTION_ONE;
            }
        }
    }
    else if (hiddenCount == 3)
    {
        if (!hiddenHot)
        {
            self.hotTrailing.constant = POSTION_ONE;
        }
        else if (!hiddenNew)
        {
            self.newnewTrailing.constant = POSTION_ONE;
        }
        else if (!hiddenRec)
        {
            self.recommondTrailing.constant = POSTION_ONE;
        }
        else if (!hiddenPro)
        {
            self.promotionTrailing.constant = POSTION_ONE;
        }
    }
}

#pragma mark - PSCarouselDelegate
- (void)carousel:(PSCarouselView *)carousel didMoveToPage:(NSUInteger)page;
{
    self.pageControl.currentPage = page;
}

- (IBAction)touchCallButton:(UIButton *)sender
{
    if (self.isPreview)
    {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(didTouchCallButton)])
    {
        [self.delegate didTouchCallButton];
    }
}

@end
