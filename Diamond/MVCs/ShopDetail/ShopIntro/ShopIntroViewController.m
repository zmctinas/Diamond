//
//  ShopIntroViewController.m
//  Diamond
//
//  Created by Pan on 15/8/7.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ShopIntroViewController.h"
#import "Shop.h"

@interface ShopIntroViewController ()
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UIButton *openTimeButton;

@end

@implementation ShopIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftBarButtonItem];
    self.title = self.shop.shop_name;
    self.introLabel.text = self.shop.Introduction;
    NSString *buttonTitle = [NSString stringWithFormat:@"营业时间:%@ - %@",self.shop.sale_start_time,self.shop.sale_end_time];
    if (IS_NULL(self.shop.sale_end_time) || IS_NULL(self.shop.sale_start_time))
    {
        buttonTitle = @"营业时间:00:00 - 24:00";
    }
    [self.openTimeButton setTitle:buttonTitle forState:UIControlStateNormal];
}



@end
