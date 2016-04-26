//
//  ReceiveGoodsAddressCell.m
//  Diamond
//
//  Created by Leon Hu on 15/8/31.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ReceiveGoodsAddressCell.h"

@interface ReceiveGoodsAddressCell()

@property (weak, nonatomic) IBOutlet UIButton *checkBoxButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *isDefaultLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

- (IBAction)touchCheckItemButton:(UIButton *)sender;
- (IBAction)touchEditItemButton:(UIButton *)sender;

@end

@implementation ReceiveGoodsAddressCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.entity.isChecked) {
        [self.checkBoxButton setImage:[UIImage imageNamed:@"shoppingcart_btn_xuanze_se"] forState:UIControlStateNormal];
    }else{
        [self.checkBoxButton setImage:nil forState:UIControlStateNormal];
    }
    if (self.entity.status) {
        [self.isDefaultLabel setHidden:NO];
        self.isDefaultLabel.layer.cornerRadius = 5;
        self.isDefaultLabel.layer.masksToBounds = YES;
    }else{
        [self.isDefaultLabel setHidden:YES];
    }
    [self.nameLabel setText:self.entity.linkman];
    [self.mobileLabel setText:self.entity.phoneNumber];
    NSString *address = [NSString stringWithFormat:@"%@%@%@ %@",
                         self.entity.province,
                         self.entity.city,
                         self.entity.district,
                         self.entity.address];
    [self.addressLabel setText:address];
}

- (IBAction)touchCheckItemButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectAddress:)]) {
        [self.delegate didSelectAddress:self.entity];
    }
}

- (IBAction)touchEditItemButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didEditAddress:)]) {
        [self.delegate didEditAddress:self.entity];
    }
}

@end
