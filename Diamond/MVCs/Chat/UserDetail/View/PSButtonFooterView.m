//
//  PSButtonFooterView.m
//  Diamond
//
//  Created by Pan on 15/7/21.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "PSButtonFooterView.h"

@implementation PSButtonFooterView
- (IBAction)touchButton:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(buttonFooterDidTouchButton:)])
    {
        [self.delegate buttonFooterDidTouchButton:sender];
    }
}

@end
