//
//  OrderIndexCell.m
//  Diamond
//
//  Created by Pan on 15/8/28.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "OrderIndexCell.h"

@interface OrderIndexCell()

@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;

@end

@implementation OrderIndexCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.text = [self titleWithIndex:self.indexPath];
    [self.iconButton setBackgroundImage:[UIImage imageNamed:[self imageNameWithIndex:self.indexPath]] forState:UIControlStateNormal];
    [self showNoticePointIfNeeded];
}

- (void)showNoticePointIfNeeded
{
    if (self.indexPath.section == 1 && self.showNoticePoint)
    {
        self.noticeLabel.hidden = NO;
    } else {
        self.noticeLabel.hidden = YES;
    }
}

- (NSString *)titleWithIndex:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return (indexPath.row == 0) ? @"购物车" : @"收藏";
    } else {
        return (indexPath.row == 0) ? @"我买到的" : @"我卖出的";
    }
}

- (NSString *)imageNameWithIndex:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return (indexPath.row == 0) ? @"order_home_icon_gouwuche" : @"order_home_icon_shoucang";
    } else {
        return (indexPath.row == 0) ? @"order_home_icon_maidao" : @"order_home_icon_maichu";
    }
    
}
@end
