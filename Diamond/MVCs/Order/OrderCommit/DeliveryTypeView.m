//
//  DeliveryTypeView.m
//  Diamond
//
//  Created by Pan on 15/9/10.
//  Copyright (c) 2015年 Pan. All rights reserved.
//
#import "DeliveryTypeView.h"

#define CANCEL 101
#define ACTION_SHEET_HEIGHT 207
#define SCREEN_HEIGHT           [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width

@interface DeliveryTypeView ()

@property (nonatomic, weak) IBOutlet UIView *actionSheetView;

- (IBAction)touchButton:(UIButton *)sender;

@end

@implementation DeliveryTypeView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.opacity = 0;
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
    self.actionSheetView.frame = CGRectMake(0,
                                            SCREEN_HEIGHT,
                                            SCREEN_WIDTH,
                                            ACTION_SHEET_HEIGHT);
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(dismiss)];
    [self addGestureRecognizer:singleTapGR];

}

- (void)showInView:(UIView *)view;
{
    self.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.layer.opacity = 1;
    self.actionSheetView.frame = CGRectMake(0,
                                            self.frame.size.height - ACTION_SHEET_HEIGHT,
                                            self.frame.size.width,
                                            ACTION_SHEET_HEIGHT);
    [UIView commitAnimations];
    [view addSubview:self];
}

-(void)dismiss
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.layer.opacity = 0;
    self.actionSheetView.frame = CGRectMake(0,
                                            self.frame.size.height,
                                            self.frame.size.width,
                                            ACTION_SHEET_HEIGHT);

    [UIView commitAnimations];
}

- (IBAction)touchButton:(UIButton *)sender;
{
    if (sender.tag != CANCEL)
    {
        if ([self.delegate respondsToSelector:@selector(didChooseDeliveryType:)]) {
            [self.delegate didChooseDeliveryType:sender.tag];
        }
    }
    
    [self dismiss];
}
@end
