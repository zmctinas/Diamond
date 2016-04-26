//
//  animotionViewController.m
//  Diamond
//
//  Created by daimangkeji on 16/4/26.
//  Copyright © 2016年 Pan. All rights reserved.
//

#import "animotionViewController.h"
#import "withDrawlRecodeViewController.h"

@interface animotionViewController ()

@property (weak, nonatomic) IBOutlet UIView *successView;

@property (weak, nonatomic) IBOutlet UIButton *knowBtn;

- (IBAction)knowBtn:(UIButton *)sender;


@end

@implementation animotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.successView.layer.cornerRadius = 5;
    self.successView.layer.masksToBounds = YES;
    self.knowBtn.layer.cornerRadius = 5;
    self.knowBtn.layer.masksToBounds = YES;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addAnimotion];
}

-(void)addAnimotion
{
    // 设定为缩放
    //    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    CAKeyframeAnimation* animation1 = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation1.delegate = self;
    //    animation.delegate = self;
    
    animation1.duration = 0.3;
    
    animation1.keyTimes = @[
                            [NSNumber numberWithFloat:0.0],
                            [NSNumber numberWithFloat:0.7],
                            [NSNumber numberWithFloat:1.0],
                            ];
    animation1.values = @[
                          [NSNumber numberWithFloat:0.3],
                          [NSNumber numberWithFloat:1.3],
                          [NSNumber numberWithFloat:1.0],
                          ];
    
    //    // 动画选项设定
    //    animation.duration = 5; // 动画持续时间
    //    animation.repeatCount = 1; // 重复次数
    //    animation.autoreverses = YES; // 动画结束时执行逆动画
    //
    // 缩放倍数
    //    animation.fromValue = [NSNumber numberWithFloat:0.3]; // 开始时的倍率
    //    animation.byValue = [NSNumber numberWithFloat:1.2];
    //    animation.toValue = [NSNumber numberWithFloat:1.0]; // 结束时的倍率
    
    // 添加动画
    [_successView.layer addAnimation:animation1 forKey:@"scale-layer"];
}

- (IBAction)knowBtn:(UIButton *)sender {
    
    
    
    withDrawlRecodeViewController* record = [[withDrawlRecodeViewController alloc]initWithNibName:@"withDrawlRecodeViewController" bundle:nil];
    record.isRootPush = YES;
    [self.vc.navigationController pushViewController:record animated:YES];
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
    
}
@end
