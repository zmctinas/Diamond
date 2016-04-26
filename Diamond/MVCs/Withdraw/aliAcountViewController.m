//
//  aliAcountViewController.m
//  yuanli
//
//  Created by 代忙 on 16/4/6.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "aliAcountViewController.h"
#import "animotionViewController.h"

@interface aliAcountViewController ()

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UITextField *aliAcoutnField;
@property (strong, nonatomic) IBOutlet UITextField *reAliAcountField;
- (IBAction)withdrawalBtn:(UIButton *)sender;



@end

@implementation aliAcountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付宝账号";
    [self refreshUI];
    
    [self addNotifications];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

-(void)addNotifications
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNotification:) name:EXTRACT_MONEY object:nil];
}

-(void)receiveNotification:(NSNotification*)info
{
    if ([info.name isEqualToString:EXTRACT_MONEY]) {
        animotionViewController* animotion = [[animotionViewController alloc]initWithNibName:@"animotionViewController" bundle:nil];
        animotion.modalPresentationStyle = UIModalPresentationOverFullScreen;
        animotion.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:animotion animated:YES completion:^{
            
        }];
        
    }
}

-(void)refreshUI
{
    self.nextBtn.layer.cornerRadius = 4;
    self.nextBtn.layer.masksToBounds = YES;
}

-(BOOL)didFillMessage
{
    return (!IS_NULL(self.aliAcoutnField.text)&&!IS_NULL(self.reAliAcountField.text));
}

- (IBAction)withdrawalBtn:(UIButton *)sender {
    
    if ([self didFillMessage]) {
        self.dralModel.aliAount = self.aliAcoutnField.text;
        self.dralModel.realName = self.reAliAcountField.text;
        
        [self.dralModel askMoney];
    }else
    {
        [self showtips:@"请填写完整信息"];
    }
    
    
}


@end
