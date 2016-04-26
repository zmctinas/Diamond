//
//  PSSelectItemHeader.m
//  Diamond
//
//  Created by Leon Hu on 15/9/1.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "PSSelectItemHeader.h"

@interface PSSelectItemHeader()

@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectionButton;

- (IBAction)touchCallSellerButton:(UIButton *)sender;
- (IBAction)touchSelectionButton:(UIButton *)sender;
- (IBAction)touchShopButton:(UIButton *)sender;

@end

@implementation PSSelectItemHeader

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIImage *image = self.entity.isChecked ? [UIImage imageNamed:@"DM_Selected_icon"] : nil;
    [self.selectionButton setImage:image forState:UIControlStateNormal];
    self.shopNameLabel.text = [NSString stringWithFormat:@"商家:%@",self.entity.shop_name];
}


- (IBAction)touchCallSellerButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didTouchContactSellerAtSection:)])
    {
        [self.delegate didTouchContactSellerAtSection:self.section];
    }
}

- (IBAction)touchSelectionButton:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(selectItemHeader:didTouchSelectButton:)])
    {
        [self.delegate selectItemHeader:self didTouchSelectButton:sender];
    }
}

- (IBAction)touchShopButton:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didTouchShopButtonAtSection:)])
    {
        [self.delegate didTouchShopButtonAtSection:self.section];
    }
}


@end
