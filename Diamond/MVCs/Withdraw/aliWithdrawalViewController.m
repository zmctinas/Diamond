//
//  aliWithdrawalViewController.m
//  yuanli
//
//  Created by 代忙 on 16/3/26.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "aliWithdrawalViewController.h"
//#import "withdrawalRecordViewController.h"
#import "aliAcountViewController.h"
#import "animotionViewController.h"


@interface aliWithdrawalViewController ()



@property (strong, nonatomic) IBOutlet UITextField *acountField;
@property (strong, nonatomic) IBOutlet UITextField *reAliAcountField;
@property (strong, nonatomic) IBOutlet UIView *reView;
@property (strong, nonatomic) IBOutlet UIButton *changeBtn;

@property (weak, nonatomic) IBOutlet UIButton *withDrawlBtn;

- (IBAction)changeBtn:(UIButton *)sender;

- (IBAction)withDrawalBtn:(UIButton *)sender;

@end

@implementation aliWithdrawalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付宝账号";
    
    [self refreshUI];
    
//    if ([[USERDefaults objectForKey:@"ali_pay"] length]>0) {
//        self.acountField.text = [USERDefaults objectForKey:@"ali_pay"];
//        [self.changeBtn setTitle:@"修改" forState:UIControlStateNormal];
//    }
    
    
    
    [self.dralModel getAliAcount];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - notification

-(void)receivedNotification:(NSNotification*)info
{
    if ([info.name isEqualToString:GET_Ali_Acount]) {
        
    }
    if ([info.name isEqualToString:EXTRACT_MONEY]) {
        animotionViewController* animotion = [[animotionViewController alloc]initWithNibName:@"animotionViewController" bundle:nil];
        animotion.modalPresentationStyle = UIModalPresentationOverFullScreen;
        animotion.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:animotion animated:YES completion:^{
            
        }];
        
    }
}

#pragma mark - private

-(void)addNotifications
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receivedNotification:) name:GET_Ali_Acount object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receivedNotification:) name:EXTRACT_MONEY object:nil];
}



-(void)refreshUI
{
    self.changeBtn.layer.cornerRadius = 4;
    self.changeBtn.layer.masksToBounds = YES;
    self.withDrawlBtn.layer.cornerRadius = 4;
    self.withDrawlBtn.layer.masksToBounds = YES;
}

- (IBAction)changeBtn:(UIButton *)sender {
    
    aliAcountViewController* aliAcount = [[aliAcountViewController alloc]init];
    aliAcount.dralModel = _dralModel;
    [self.navigationController pushViewController:aliAcount animated:YES];
    
}

- (IBAction)withDrawalBtn:(UIButton *)sender {
    
    if (self.acountField.text.length>0) {
        
    }else
    {
        [self showtips:@"请输入支付支付宝账号"];
    }
    
}


#pragma mark - getter

-(withDralModel*)dralModel
{
    if (!_dralModel) {
        _dralModel = [[withDralModel alloc]init];
    }
    return _dralModel;
}

@end
