//
//  PaymentViewController.h
//  Diamond
//
//  Created by Pan on 15/8/27.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseViewController.h"
@class OrderDetailEntity;

@interface PaymentViewController : BaseViewController

- (void)setupWaitPayOrder:(OrderDetailEntity *)entity;


@end
