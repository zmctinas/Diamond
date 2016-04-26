//
//  PSNumberPad.m
//  numpad
//
//  Created by Pan on 15/9/15.
//  Copyright (c) 2015年 Insigma Hengtian Software Co., LTD. All rights reserved.
//

#import "PSNumberPad.h"


#define kMaxNumber                       10000000

@interface PSNumberPad ()
@property (nonatomic,assign) id<UITextInput> textInputDelegate;
@property (weak, nonatomic) IBOutlet UIButton *dotButton;

- (IBAction)touchDeleteButton:(UIButton *)sender;
- (IBAction)touchReturnButton:(UIButton *)sender;
- (IBAction)touchHiddenButton:(UIButton *)sender;

@end


@implementation PSNumberPad

+ (PSNumberPad *)pad
{
    NSArray *views = [[NSBundle mainBundle]loadNibNamed:[PSNumberPad description] owner:nil options:nil];
    for (UIView *view in views)
    {
        if ([view isKindOfClass:[PSNumberPad class]])
        {
            return (PSNumberPad *)view;
        }
    }
    return nil;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [_dotButton setEnabled:!_disableDot];
}

- (IBAction)touchNumberButton:(UIButton *)sender
{
    NSString *keyText = sender.titleLabel.text;
    int key = -1;
    if ([@"." isEqualToString:keyText]) {
        key = 10;
    } else {
        key = [keyText intValue];
    }
    NSRange dot = [_textField.text rangeOfString:@"."];
    
    switch (key) {
        case 10:
            if (dot.location == NSNotFound && _textField.text.length == 0) {
                [self.textInputDelegate insertText:@"0."];
            } else if (dot.location == NSNotFound) {
                [self.textInputDelegate insertText:@"."];
            }
            
            break;
        default:
            if (kMaxNumber <= [[NSString stringWithFormat:@"%@%d", _textField.text, key] doubleValue]) {
                _textField.text = [NSString stringWithFormat:@"%d", kMaxNumber];
            } else if ([@"0.00" isEqualToString:_textField.text]) {
                _textField.text = [NSString stringWithFormat:@"%d", key];
            } else if (dot.location == NSNotFound || _textField.text.length <= dot.location + 2)
            {
                [self.textInputDelegate insertText:[NSString stringWithFormat:@"%d", key]];
                if (_textField.text.length>=2) {
                    
                    NSString*str=[_textField.text substringToIndex:2];
                    NSString *first=[_textField.text substringToIndex:1];
                    
                    if ((![str isEqualToString:@"0."])&&[first isEqualToString:@"0"]) {
                        _textField.text=[NSString stringWithFormat:@"%d",[_textField.text intValue]];
                        
                    }
                }
            }
            
            break;
    }

}

- (IBAction)touchDeleteButton:(UIButton *)sender
{
    if ([@"0." isEqualToString:_textField.text]) {
        _textField.text = @"";
        
        return;
    } else {
        
        [self.textInputDelegate deleteBackward];
    }
}

- (IBAction)touchReturnButton:(UIButton *)sender
{
    [self.textField resignFirstResponder];
}

- (IBAction)touchHiddenButton:(UIButton *)sender
{
    [self.textField resignFirstResponder];
}


- (void)setTextField:(UITextField *)textField {
    _textField = textField;
    _textField.inputView = self;
    self.textInputDelegate = _textField;
}

- (void)setDisableDot:(BOOL)disableDot
{
    _disableDot = disableDot;
    [_dotButton setEnabled:!_disableDot];
}
@end
