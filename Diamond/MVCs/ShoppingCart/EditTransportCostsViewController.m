//
//  EditTransportCostsViewController.m
//  Diamond
//
//  Created by Leon Hu on 15/8/29.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "EditTransportCostsViewController.h"

@interface EditTransportCostsViewController ()
/**
 *  距离
 */
@property (weak, nonatomic) IBOutlet UITextField *distanceTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

- (IBAction)touchSaveButton:(UIBarButtonItem *)sender;

@end

@implementation EditTransportCostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftBarButtonItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = NO;
    
    [self.distanceTextField setText:[NSString stringWithFormat:@"%ld",(long)self.distance]];
    [self.priceTextField setText:[NSString stringWithFormat:@"%.2f",self.price.doubleValue]];
}

- (IBAction)touchSaveButton:(UIBarButtonItem *)sender {
    self.distance = self.distanceTextField.text.intValue;
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    self.price=[f numberFromString:self.priceTextField.text];
    
    if ([self.delegate respondsToSelector:@selector(didEditTransportCosts:price:)]) {
        if(!self.price)
        {
            [self showtips:@"格式不正确."];
            return;
        }
        
        [self.delegate didEditTransportCosts:self.distance price:self.price];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
