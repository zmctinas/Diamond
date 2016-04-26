//
//  withDrawlViewController.m
//  yuanli
//
//  Created by 代忙 on 16/3/25.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "withDrawlViewController.h"
#import "selectViewController.h"
#import "withDrawlRecodeViewController.h"

@interface withDrawlViewController ()

@property(strong,nonatomic)UIBarButtonItem* rightItem;
@property (strong, nonatomic) IBOutlet UITextField *moneyField;

@property (strong, nonatomic) IBOutlet UILabel *crashLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;


- (IBAction)nextBtn:(UIButton *)sender;

@end

@implementation withDrawlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"领取";
    
    [self refreshUI];
    
    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    //fjwaeifoajwoejfowe
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIBarButtonItem*)rightItem
{
    if (!_rightItem) {
        UIButton* btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(0, 0, 50, 30);
        [btn setTitle:@"提现记录" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
        _rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    }
    return _rightItem;
}

-(void)clickRightBtn:(UIButton*)sender
{
    withDrawlRecodeViewController* record = [[withDrawlRecodeViewController alloc]init];
    [self.navigationController pushViewController:record animated:YES];
}

-(void)refreshUI
{
    NSString* attStr = [NSString stringWithFormat:@"可领取余额%@元",_remainderMoney];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:attStr];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:NSMakeRange(0, 5)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#f86d6d"] range:NSMakeRange(5,attStr.length - 5)];
    self.crashLabel.attributedText = str;
    
    self.nextBtn.layer.cornerRadius = 4;
    self.nextBtn.layer.masksToBounds = YES;
    
}

- (IBAction)nextBtn:(UIButton *)sender {
    
    if ([_moneyField.text floatValue]>0&&[_moneyField.text integerValue]<[_remainderMoney floatValue]) {
        selectViewController* select = [[selectViewController alloc]init];
        select.money = self.moneyField.text;
        [self.navigationController pushViewController:select animated:YES];
    }else
    {
        [self showtips:@"请输入正确的提现金额"];
    }

}
@end
