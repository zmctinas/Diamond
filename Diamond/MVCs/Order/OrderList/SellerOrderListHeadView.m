//
//  SellerOrderListHeadView.m
//  Diamond
//
//  Created by Pan on 15/9/1.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "SellerOrderListHeadView.h"
#import "OrderUtil.h"
@interface SellerOrderListHeadView ()

@property (weak, nonatomic) IBOutlet UILabel *orderNOLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation SellerOrderListHeadView

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.orderNOLabel.text = self.entity.out_trade_no;
    self.statusLabel.text = [OrderUtil statusStringWithOwner:self.owner status:self.entity.status];
    self.timeLabel.text = [OrderUtil timeStringWithOrderTime:self.entity.add_time];
}

@end
