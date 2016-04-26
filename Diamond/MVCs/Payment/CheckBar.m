//
//  CheckBar.m
//  Diamond
//
//  Created by Pan on 15/8/31.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "CheckBar.h"
#import "Macros.h"
#import "OrderUtil.h"

static NSString *const DISABLE_BG = @"orderdetails_btn_bg_disable";
static NSString *const ENABLE_BG = @"orderdetails_btn_bg";


@interface CheckBar ()
@property (weak, nonatomic) IBOutlet UIButton *conformButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

- (IBAction)touchConformButton:(UIButton *)button;

@end

@implementation CheckBar

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self adjustConformButtonStatus:self.orderStatus owner:self.owner];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2lf",[self.price doubleValue]];
}

- (IBAction)touchConformButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(didTouchConformButton)])
    {
        [self.delegate didTouchConformButton];
    }
}

- (void)adjustConformButtonStatus:(OrderStatus)status owner:(OrderOwner)owner;
{
    NSString *imageName = [self buttonBGNameWithOrderStatus:status owner:owner];
    UIColor *titleColor = [self buttonTitleColorWithOrderStatus:status owner:owner];
    NSString *title = [OrderUtil checkBarButtonTitleWithOwner:owner status:status];
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

- (NSString *)buttonBGNameWithOrderStatus:(OrderStatus)status owner:(OrderOwner)owner
{
    if (owner == OrderOwnerBuyer)
    {
        switch (status)
        {
            case OrderStatusWaitCommit:
                return ENABLE_BG;
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
        }
    }
    else if (owner == OrderOwnerSeller)
    {
        switch (status)
        {
            case OrderStatusWaitCommit:
                return DISABLE_BG;//业务上不会出现这样的情况
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
        }
    }
    return DISABLE_BG;
}

- (UIColor *)buttonTitleColorWithOrderStatus:(OrderStatus)status owner:(OrderOwner)owner
{
    if (owner == OrderOwnerBuyer)
    {
        switch (status)
        {
            case OrderStatusWaitCommit:
                return [self enableTitleColor];//业务上不会出现这样的情况
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
        }
    }
    else if (owner == OrderOwnerSeller)
    {
        switch (status)
        {
            case OrderStatusWaitCommit:
                return [self disableTitleColor];//业务上不会出现这样的情况
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

- (void)setPrice:(NSNumber *)price
{
    _price = price;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setOrderStatus:(OrderStatus)orderStatus
{
    _orderStatus = orderStatus;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
