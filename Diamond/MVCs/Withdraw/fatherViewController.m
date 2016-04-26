//
//  fatherViewController.m
//  O2O
//
//  Created by wangxiaowei on 15/7/18.
//  Copyright (c) 2015年 wangxiaowei. All rights reserved.
//

#import "fatherViewController.h"


@interface fatherViewController ()

@end

@implementation fatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton* backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 25, 30)];
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
//    backBtn.backgroundColor = [UIColor blackColor];
    [backBtn setImage:[UIImage imageNamed:@"top_btn_fanhui.png"] forState:UIControlStateNormal];
    UIBarButtonItem* im = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    self.navigationItem.leftBarButtonItem = im;
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    self.returnKeyHandler.toolbarManageBehaviour = IQAutoToolbarBySubviews;
    // Do any additional setup after loading the view.
}

-(void)backBtn:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

@end
