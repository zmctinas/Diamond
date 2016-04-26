//
//  OrderDetailHeaderView.h
//  Diamond
//
//  Created by Pan on 15/9/2.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailEntity.h"

static CGFloat const ORDER_DETAIL_HEADER_HEIGHT_WITH_ORDER = 100.0;/**< 有订单号状态下的高度*/
static CGFloat const ORDER_DETAIL_HEADER_HEIGHT_NO_ORDER = 44.0;/**< 没有订单号状态下的高度*/

@protocol OrderDetailHeaderViewDelegate <NSObject>
@optional
- (void)didTouchContactButton;
- (void)didTouchShopButton;

@end

@interface OrderDetailHeaderView : UITableViewHeaderFooterView

@property (strong, nonatomic) OrderDetailEntity *entity;
@property (nonatomic) OrderOwner owner;

@property (weak, nonatomic) id<OrderDetailHeaderViewDelegate> delegate;


@end
