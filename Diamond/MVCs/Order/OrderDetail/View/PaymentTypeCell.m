//
//  PaymentTypeCell.m
//  Diamond
//
//  Created by Pan on 15/9/3.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "PaymentTypeCell.h"
#import "OrderDetailEntity.h"
#import "OrderEnum.h"
static NSString *const ON_LINE_PAY = @"在线支付";
static NSString *const OFF_LINE_PAY = @"当面支付";

@interface PaymentTypeCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectionButton;

@property (weak, nonatomic) IBOutlet UIButton *divideButton;


@property (nonatomic) PaymentType paymentType;
@end

@implementation PaymentTypeCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.indexPath.row == 0)
    {
        self.nameLabel.text = OFF_LINE_PAY;
        self.divideButton.hidden = NO;
    }
    else if (self.indexPath.row == 1)
    {
        self.nameLabel.text = ON_LINE_PAY;
        self.divideButton.hidden = YES;
    }
    UIImage *image = (self.paymentType == self.entity.payment_type) ? [UIImage imageNamed:@"DM_Selected_icon"] : nil;
    [self.selectionButton setImage:image forState:UIControlStateNormal];
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    _paymentType = indexPath.row;
}
@end




