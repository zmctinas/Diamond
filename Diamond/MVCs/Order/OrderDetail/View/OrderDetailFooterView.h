//
//  OrderDetailFooterView.h
//  Diamond
//
//  Created by Pan on 15/9/2.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderEnum.h"

@class OrderDetailEntity;

static CGFloat const ORDER_DETAIL_FOOTER_VIEW_HEIGHT = 44 * 4;

@protocol OrderDetailFooterViewDelegate <NSObject>
@optional

- (void)didTouchPostTypeButton;
- (void)didTouchEditPostageButton;

- (void)didTouchRetrunKeyWithInputWords:(NSString *)words;

@end


@interface OrderDetailFooterView : UITableViewHeaderFooterView

@property (strong, nonatomic) OrderDetailEntity *entity;
@property (nonatomic) OrderDetailType orderType;
@property (nonatomic) OrderOwner owner;

@property (weak, nonatomic) id<OrderDetailFooterViewDelegate> delegate;

@end
