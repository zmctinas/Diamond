//
//  PaymentCell.m
//  Diamond
//
//  Created by Pan on 15/8/31.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "PaymentCell.h"


static NSString *const WECHAT = @"微信支付";
static NSString *const ALIPAY = @"支付宝支付";


@interface PaymentCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@property (weak, nonatomic) IBOutlet UIButton *selectionButton;

@end

@implementation PaymentCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    UIImage *image = selected ? [UIImage imageNamed:@"DM_Selected_icon"] : nil;
    [self.selectionButton setImage:image forState:UIControlStateNormal];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.indexPath.row == 0)
    {
        self.nameLabel.text = ALIPAY;
    }
    else if (self.indexPath.row == 1)
    {
        self.nameLabel.text = WECHAT;
    }
    [self.iconButton setImage:[UIImage imageNamed:self.nameLabel.text] forState:UIControlStateNormal];
}

@end
