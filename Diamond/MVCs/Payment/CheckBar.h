//
//  CheckBar.h
//  Diamond
//
//  Created by Pan on 15/8/31.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderEnum.h"
@protocol CheckBarDelegate <NSObject>

- (void)didTouchConformButton;

@end

@interface CheckBar : UIView

@property (nonatomic) OrderOwner owner;
@property (nonatomic) OrderStatus orderStatus;
@property (nonatomic) NSNumber *price;
@property (weak, nonatomic)  id<CheckBarDelegate> delegate;

@end
