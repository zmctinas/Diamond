//
//  DeliveryTypeView.h
//  Diamond
//
//  Created by Pan on 15/9/10.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderEnum.h"

@protocol DeliveryTypeViewDelegate <NSObject>

- (void)didChooseDeliveryType:(DeliveryType)type;

@end

//选择配送方式
@interface DeliveryTypeView : UIView

@property (nonatomic, weak) id<DeliveryTypeViewDelegate> delegate;

- (void)showInView:(UIView *)view;


- (void)dismiss;

@end
