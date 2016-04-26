//
//  PSNumberPad.h
//  numpad
//
//  Created by Pan on 15/9/15.
//  Copyright (c) 2015年 Insigma Hengtian Software Co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PSNumberPad;

@interface PSNumberPad : UIView

+ (PSNumberPad *)pad;

- (IBAction)touchNumberButton:(UIButton *)sender;

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic) BOOL disableDot;/**< 小数点是否启用*/

@end
