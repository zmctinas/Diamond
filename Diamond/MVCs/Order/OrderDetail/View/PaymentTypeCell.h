//
//  PaymentTypeCell.h
//  Diamond
//
//  Created by Pan on 15/9/3.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderDetailEntity;
static CGFloat const PAYMENT_CELL_HEIGHT = 44;

@interface PaymentTypeCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) OrderDetailEntity *entity;

@end
