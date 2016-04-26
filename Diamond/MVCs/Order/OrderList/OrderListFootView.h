//
//  OrderListFootView.h
//  Diamond
//
//  Created by Pan on 15/9/1.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailEntity.h"
#import "OrderListEntity.h"
@class OrderListFootView;

static CGFloat const OrderListFootViewHeight = 84;


@protocol OrderListFootViewDelegate <NSObject>

- (void)footView:(OrderListFootView *)footView didTouchConformButton:(UIButton *)button;

@end

@interface OrderListFootView : UITableViewHeaderFooterView

@property (strong, nonatomic) OrderListEntity *entity;
@property (nonatomic) OrderOwner orderOwner;/**< 订单拥有者是买家身份还是卖家身份*/

@property (weak, nonatomic) id delegate;

@end
