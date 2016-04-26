//
//  SetUpSuccessViewController.m
//  Diamond
//
//  Created by Leon Hu on 15/8/5.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "SetUpSuccessViewController.h"

@interface SetUpSuccessViewController ()

@end

@implementation SetUpSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(back:) withObject:nil afterDelay:3];
}

- (void)back:(id)obj
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
