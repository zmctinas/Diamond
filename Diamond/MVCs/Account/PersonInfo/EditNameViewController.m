//
//  EditNameViewController.m
//  Diamond
//
//  Created by Leon Hu on 15/7/27.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "EditNameViewController.h"

@interface EditNameViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

- (IBAction)touchEditFinishedButton:(UIBarButtonItem *)sender;

@end

@implementation EditNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"更改名字";
    [self addLeftBarButtonItem];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.nameTextField setText:self.name];
}

- (IBAction)touchEditFinishedButton:(UIButton *)sender {
    if (self.nameTextField.text.length<1) {
        [self showtips:@"名字不能为空哦..."];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(didEditName:)]) {
        [self.delegate didEditName:self.nameTextField.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
