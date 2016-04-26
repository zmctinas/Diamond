//
//  OrderDetailHeaderView.m
//  Diamond
//
//  Created by Pan on 15/9/2.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "OrderDetailHeaderView.h"
#import "OrderDetailEntity.h"

@interface OrderDetailHeaderView ()

@property (weak, nonatomic) IBOutlet UIButton *contactButton;
@property (weak, nonatomic) IBOutlet UILabel *orderIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pretipLabel;/**< 买家：/商铺：*/
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;


- (IBAction)touchContactButton:(UIButton *)sender;
- (IBAction)touchShopButton:(UIButton *)sender;

@end


@implementation OrderDetailHeaderView

- (void)layoutSubviews
{
    [self setupContactButton];
    [self updateShopNameLabel];
    self.orderIDLabel.text = self.entity.out_trade_no;
    self.timeLabel.text = self.entity.formattedTime;
    
    BOOL isSeller = (self.owner == OrderOwnerSeller) ? YES : NO;
    BOOL isCommitStatus = self.entity.status ? NO : YES;
    [self.arrowButton setHidden:(isSeller || isCommitStatus)];
    [super layoutSubviews];
}

- (void)updateShopNameLabel
{
    NSString *pretips = (self.owner == OrderOwnerBuyer) ? @"商家:" : @"买家:";
    self.pretipLabel.text = pretips;
    NSString *nameLabelText = (self.owner == OrderOwnerBuyer) ? self.entity.shop_name : self.entity.buyer_name;
    self.shopNameLabel.text = nameLabelText;
}

- (void)setupContactButton
{
    if (self.entity.status == OrderStatusWaitCommit)
    {
        self.contactButton.hidden = YES;
    }
    NSString *buttonTitle = (self.owner == OrderOwnerBuyer) ? @"联系卖家" : @"联系买家";
    [self.contactButton setTitle:buttonTitle forState:UIControlStateNormal];

}

- (IBAction)touchContactButton:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didTouchContactButton)])
    {
        [self.delegate didTouchContactButton];
    }
}

- (IBAction)touchShopButton:(UIButton *)sender
{
    if (self.owner == OrderOwnerBuyer && self.entity.status)
    {
        if ([self.delegate respondsToSelector:@selector(didTouchShopButton)])
        {
            [self.delegate didTouchShopButton];
        }
    }
}
@end
