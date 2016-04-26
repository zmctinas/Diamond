//
//  OrderDetailAddressCell.h
//  Diamond
//
//  Created by Pan on 15/9/3.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailEntity.h"
static CGFloat const ADDRESS_CELL_HEIGHT_WITHOUT_ENTITY = 44;
static CGFloat const ADDRESS_CELL_HEIGHT_WITH_ENTITY = ADDRESS_CELL_HEIGHT_WITHOUT_ENTITY + 10;

@interface OrderDetailAddressCell : UITableViewCell

@property (strong, nonatomic) OrderDetailEntity *entity;

@end
