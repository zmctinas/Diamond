//
//  OrderListHeadView.m
//  Diamond
//
//  Created by Pan on 15/9/1.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "OrderListHeadView.h"
#import "OrderUtil.h"
@interface OrderListHeadView ()

@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;

@end

@implementation OrderListHeadView

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.shopNameLabel.text = self.entity.shop_name;
    self.orderStatusLabel.text = [OrderUtil statusStringWithOwner:self.owner status:self.entity.status];
}

@end
