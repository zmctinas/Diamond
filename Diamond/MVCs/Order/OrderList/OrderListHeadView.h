//
//  OrderListHeadView.h
//  Diamond
//
//  Created by Pan on 15/9/1.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListEntity.h"

static CGFloat const OrderListHeadViewHeight = 60.0;

@interface OrderListHeadView : UITableViewHeaderFooterView

@property (strong, nonatomic) OrderListEntity *entity;
@property (nonatomic) OrderOwner owner;

@end
