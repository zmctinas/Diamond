//
//  ApplyCell.m
//  Diamond
//
//  Created by Pan on 15/7/25.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ApplyCell.h"

@implementation ApplyCell


- (IBAction)touchAgreeButton:(UIButton *)sender
{
    if([self.delegate respondsToSelector:@selector(applyCellAddFriendAtIndexPath:)])
    {
        [_delegate applyCellAddFriendAtIndexPath:self.indexPath];
    }
}



@end
