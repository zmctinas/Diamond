//
//  GoodsTypeCellTableViewCell.m
//  Diamond
//
//  Created by Leon Hu on 15/9/7.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "GoodsTypeCell.h"

@interface GoodsTypeCell()

@property (weak, nonatomic) IBOutlet UITextField *goodsStockTextField;
@property (weak, nonatomic) IBOutlet UITextField *goodsPriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *goodsModelTextField;
@property (weak, nonatomic) IBOutlet UIButton *editButton;

- (IBAction)touchEditButton:(UIButton *)sender;

@end

@implementation GoodsTypeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.entity) {
        [self.goodsModelTextField setText:self.entity.typeName];
        [self.goodsPriceTextField setText:[NSString stringWithFormat:@"%.2f",self.entity.price.doubleValue]];
        [self.goodsStockTextField setText:[NSString stringWithFormat:@"%ld",(long)self.entity.stock]];
    }
}

- (IBAction)touchEditButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didEditingGoodsType:)]) {
        [self.delegate didEditingGoodsType:self.entity];
    }
}

@end
