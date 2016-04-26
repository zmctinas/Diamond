//
//  PSAlertView.h
//  Diamond
//
//  Created by Pan on 15/7/23.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PSAlertViewDelegate <NSObject>

- (void)alertViewDidTouchConformButton:(UIButton *)button;

@optional
- (void)alertViewDidTouchCancelButton:(UIButton *)button;

@end


@interface PSAlertView : UIView

@property (weak, nonatomic) IBOutlet UITextField *messageTextField;

@property (nonatomic, weak) id<PSAlertViewDelegate> delegate;


- (void)showToView:(UIView *)view;

- (void)dismiss;


@end
