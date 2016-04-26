//
//  PSDropCollectionCell.m
//  PSDropDownMenu
//
//  Created by Pan on 15/8/6.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "PSDropCollectionCell.h"
#import "Macros.h"

@implementation PSDropCollectionCell

- (IBAction)touchMuneButton:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(didTouchCell:)])
    {
        [self.delegate didTouchCell:self];
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    UIColor *color = selected ? UIColorFromRGB(GLOBAL_TINTCOLOR) : UIColorFromRGB(0x999999);
    [self.areaButton setTitleColor:color forState:UIControlStateNormal];
}

@end
