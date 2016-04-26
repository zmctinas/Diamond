//
//  ActivityViewController.m
//  Diamond
//
//  Created by Leon Hu on 15/8/4.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ActivityViewController.h"
#import "WareListViewController.h"

@interface ActivityViewController ()

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftBarButtonItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"goodsDiscountSegue"]) {
        WareListViewController *vc = segue.destinationViewController;
        vc.wareType = WareTypeDiscount;
    }
}

@end
