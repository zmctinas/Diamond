//
//  OrderListFootView.m
//  Diamond
//
//  Created by Pan on 15/9/1.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "OrderListFootView.h"
#import "OrderListEntity.h"

static NSString *const DISABLE_BG = @"shoppingcart_btn_bg_disable";
static NSString *const ENABLE_BG = @"shoppingcart_btn_bg";


@interface OrderListFootView ()

@property (weak, nonatomic) IBOutlet UIButton *conformButton;
@property (weak, nonatomic) IBOutlet UILabel *postageLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;

- (IBAction)touchContromButton:(UIButton *)sender;


@property (weak, nonatomic) NSString *oldPrice;
@property (strong, nonatomic) NSAttributedString *oldPriceAttString;
@end


@implementation OrderListFootView

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.postageLabel.text = [NSString stringWithFormat:@"（运费%.2lf）元",[self.entity.delivery_fee doubleValue]];
    [self setupTotleFeeLabel];
    [self adjustConformButtonStatus:self.entity.status owner:self.orderOwner];
}

- (void)prepareForReuse
{
    [self.conformButton setEnabled:YES];
}

- (void)setupTotleFeeLabel
{
    if (self.entity.old_total_fee)
    {
        //如果卖家编辑过价格
        self.oldPrice = [NSString stringWithFormat:@"￥%.2f",[self.entity.old_total_fee doubleValue]];
        self.oldPriceLabel.attributedText = self.oldPriceAttString;
    }
    else
    {
        //如果卖家没有编辑过价格
        self.oldPriceLabel.text = @"";
    }
    self.priceLabel.text =  [NSString stringWithFormat:@"￥%.2f",[self.entity.total_fee doubleValue]];
}


- (void)adjustConformButtonStatus:(OrderStatus)status owner:(OrderOwner)owner;
{
    NSString *imageName = [self buttonBGNameWithOrderStatus:status owner:owner];
    UIColor *titleColor = [self buttonTitleColorWithOrderStatus:status owner:owner];
    NSString *title = [self buttonTitleWithOrderStatus:status owner:owner];
    UIImage *image = [UIImage imageNamed:imageName];
    
    [self.conformButton setTitle:title forState:UIControlStateNormal];
    [self.conformButton setTitleColor:titleColor forState:UIControlStateNormal];
    [self.conformButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.conformButton setBackgroundImage:[UIImage imageNamed:DISABLE_BG] forState:UIControlStateDisabled];
    UIImage *enableBGI = [UIImage imageNamed:ENABLE_BG];
    if (![self.conformButton.currentBackgroundImage isEqual:enableBGI])
    {
        [self.conformButton setEnabled:NO];
    }

}

- (IBAction)touchContromButton:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(footView:didTouchConformButton:)])
    {
        [self.delegate footView:self  didTouchConformButton:self.conformButton];
    }
}

- (NSString *)buttonTitleWithOrderStatus:(OrderStatus)status owner:(OrderOwner)owner
{
    if (self.orderOwner == OrderOwnerBuyer)
    {
        switch (status)
        {
            case OrderStatusUnpay:
                return @"结算";
            case OrderStatusPaied:
                return @"等待发货";
            case OrderStatusSellerConformed:
                return @"确认收货";
            case OrderStatusBuyerConformed:
                return @"交易完成";
            case OrderStatusCancel:
                return @"已取消";
            default:
                break;
        }
    }
    else if (self.orderOwner == OrderOwnerSeller)
    {
        switch (status)
        {
            case OrderStatusUnpay:
                return @"等待买家付款";
            case OrderStatusPaied:
                return @"确认发货";
            case OrderStatusSellerConformed:
                return @"待收货";
            case OrderStatusBuyerConformed:
                return @"交易完成";
            case OrderStatusCancel:
                return @"已取消";
            default:
                break;
        }
    }
    return @"";
}

- (NSString *)buttonBGNameWithOrderStatus:(OrderStatus)status owner:(OrderOwner)owner
{
    if (self.orderOwner == OrderOwnerBuyer)
    {
        switch (status)
        {
            case OrderStatusUnpay:
                return  ENABLE_BG;
            case OrderStatusPaied:
                return  DISABLE_BG;
            case OrderStatusSellerConformed:
                return  ENABLE_BG;
            case OrderStatusBuyerConformed:
                return  DISABLE_BG;
            case OrderStatusCancel:
                return  DISABLE_BG;
            default:
                break;
        }
    }
    else if (self.orderOwner == OrderOwnerSeller)
    {
        switch (status)
        {
            case OrderStatusUnpay:
                return  DISABLE_BG;
            case OrderStatusPaied:
                return  ENABLE_BG;
            case OrderStatusSellerConformed:
                return  DISABLE_BG;
            case OrderStatusBuyerConformed:
                return  DISABLE_BG;
            case OrderStatusCancel:
                return  DISABLE_BG;
            default:
                break;
        }
    }
    return DISABLE_BG;
}

- (UIColor *)buttonTitleColorWithOrderStatus:(OrderStatus)status owner:(OrderOwner)owner
{
    if (self.orderOwner == OrderOwnerBuyer)
    {
        switch (status)
        {
            case OrderStatusUnpay:
                return  [self enableTitleColor];
            case OrderStatusPaied:
                return  [self disableTitleColor];
            case OrderStatusSellerConformed:
                return  [self enableTitleColor];
            case OrderStatusBuyerConformed:
                return  [self disableTitleColor];
            case OrderStatusCancel:
                return  [self disableTitleColor];
            default:
                break;
        }
    }
    else if (self.orderOwner == OrderOwnerSeller)
    {
        switch (status)
        {
            case OrderStatusUnpay:
                return  [self disableTitleColor];
            case OrderStatusPaied:
                return  [self enableTitleColor];
            case OrderStatusSellerConformed:
                return  [self disableTitleColor];
            case OrderStatusBuyerConformed:
                return  [self disableTitleColor];
            case OrderStatusCancel:
                return  [self disableTitleColor];
            default:
                break;
        }
    }
    return nil;
}


- (UIColor *)enableTitleColor
{
    return [UIColor whiteColor];
}

- (UIColor *)disableTitleColor
{
    return [UIColor whiteColor];
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

@end
