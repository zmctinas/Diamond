//
//  weixinWitdrawalTypeViewController.m
//  yuanli
//
//  Created by 代忙 on 16/3/26.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "weixinWitdrawalTypeViewController.h"
//#import "withdrawalRecordViewController.h"
#import "animotionViewController.h"

@interface weixinWitdrawalTypeViewController ()
{
    NSDictionary* codeDic;
}


@property (strong, nonatomic) IBOutlet UITextField *acountField;

@property (weak, nonatomic) IBOutlet UIButton *getAcountBtn;

@property (weak, nonatomic) IBOutlet UIButton *withDrawlBtn;

- (IBAction)getAcountBtn:(UIButton *)sender;

- (IBAction)withDrawalBtn:(UIButton *)sender;


@end



@implementation weixinWitdrawalTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"微信账号";
    
    
    [self refreshUI];
//    if ([[USERDefaults objectForKey:@"wei_pay"] length]>0) {
//        self.acountField.text = [USERDefaults objectForKey:@"wei_pay"];
//    }
    
    [self addNotifications];
    
//    
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
    self.getAcountBtn.layer.cornerRadius = 4;
    self.getAcountBtn.layer.masksToBounds = YES;
    self.withDrawlBtn.layer.cornerRadius = 4;
    self.withDrawlBtn.layer.masksToBounds = YES;
}

#pragma mark - getter

-(withDralModel*)dralModel
{
    if (!_dralModel) {
        _dralModel = [[withDralModel alloc]init];
    }
    return _dralModel;
}

#pragma mark - xib

- (IBAction)getAcountBtn:(UIButton *)sender {
    
    [self showHUDWithTitle:@"获取微信支付账号中..."];
    [ShareSDK getUserInfoWithType:ShareTypeWeixiSession authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error)
     {
         if (result)
         {
             [self hideHUD];
             self.dralModel.wechat = [userInfo uid];
             self.acountField.text = [userInfo uid];
         }
         else
         {
             [self showtips:@"获取微信账号失败，请重新授权"];
         }
     }];
    
}

- (IBAction)withDrawalBtn:(UIButton *)sender {
    
    if (self.acountField.text.length>0) {
        [self.dralModel askMoney];
    }else
    {
        [self showtips:@"请授权微信账号"];
    }
//
    
    
}
@end
