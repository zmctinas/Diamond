//
//  ChooseShopTypeCollectionCell.m
//  Diamond
//
//  Created by Pan on 15/8/10.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ChooseShopTypeCollectionCell.h"
#import "Util.h"
@interface ChooseShopTypeCollectionCell ()

@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
- (IBAction)touchIconButton:(UIButton *)sender;

@end

@implementation ChooseShopTypeCollectionCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self changeIconButtonStatus];
    self.nameLabel.text = [Util shopTitleWithType:self.type];

}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self changeIconButtonStatus];
    [self layoutIfNeeded];
}


- (IBAction)touchIconButton:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(ChooseShopType:didTouchIconButton:)])
    {
        [self.delegate ChooseShopType:self didTouchIconButton:sender];
    }
}

- (void)changeIconButtonStatus
{
    NSString *imagePrename = self.isSelected ? @"selectedShopType" : @"unSelectedShopType";
    NSString *imageName = [imagePrename stringByAppendingString:[@(self.type - 1) stringValue]];
    [self.iconButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

@end
