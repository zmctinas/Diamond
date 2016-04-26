//
//  PSAlertView.m
//  Diamond
//
//  Created by Pan on 15/7/23.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "PSAlertView.h"
#import "Macros.h"

@interface PSAlertView()<UITextFieldDelegate>
- (IBAction)touchCancelButton:(UIButton *)sender;
- (IBAction)touchConformButton:(UIButton *)sender;

- (IBAction)touchHiddenKeyboardButton:(UIButton *)sender;

@end

@implementation PSAlertView

- (void)awakeFromNib
{
    self.messageTextField.layer.borderWidth = 1;
    self.messageTextField.layer.borderColor = [UIColorFromRGB(0xc8c7c4) CGColor];
    self.messageTextField.delegate = self;
}


- (IBAction)touchCancelButton:(UIButton *)sender
{
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(alertViewDidTouchCancelButton:)])
    {
        [self.delegate alertViewDidTouchCancelButton:sender];
    }
}

- (IBAction)touchConformButton:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(alertViewDidTouchConformButton:)])
    {
        [self.delegate alertViewDidTouchConformButton:sender];
    }
}

- (IBAction)touchHiddenKeyboardButton:(UIButton *)sender
{
    [self.messageTextField resignFirstResponder];
}



#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self touchHiddenKeyboardButton:nil];
    return NO;
}


- (void)showToView:(UIView *)view
{
    self.frame = view.frame;
    self.alpha = 0;
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}


- (void)dismiss
{
    [self removeFromSuperview];
}
@end
