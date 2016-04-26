//
//  PSSelectItemFooter.m
//  Diamond
//
//  Created by Leon Hu on 15/9/1.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "PSSelectItemFooter.h"
#import "BuyWareEntity.h"
#import "ShopCartEntity.h"

@interface PSSelectItemFooter()

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *settleAccountsButton;

- (IBAction)touchSettleAccountsButton:(UIButton *)sender;

/**
 *  BuyWareEntity集合
 */
@property (nonatomic,strong) ShopCartEntity *entity;

@end

@implementation PSSelectItemFooter

- (IBAction)touchSettleAccountsButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSettleAccounts:)]) {
        [self.delegate didSettleAccounts:self.section];
    }
}

- (void)setShopCart:(ShopCartEntity *)entity
{
    self.entity = entity;
    [self.totalPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",self.entity.total_fee.floatValue]];
    [self.settleAccountsButton setTitle:[NSString stringWithFormat:@"去结算(%ld)",(long)self.entity.total_count] forState:UIControlStateNormal];
}

@end
