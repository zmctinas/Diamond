//
//  OrderListCell.h
//  Diamond
//
//  Created by Pan on 15/8/31.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListEntity.h"

static CGFloat const ORDER_LIST_CELL_HEIGHT = 100.0;

@interface OrderListCell : UITableViewCell

@property (nonatomic, strong) OrderWare *ware;

@end
