//
//  selectViewController.m
//  yuanli
//
//  Created by 代忙 on 16/3/25.
//  Copyright © 2016年 wxw. All rights reserved.
//

#import "selectViewController.h"
//#import "withdrawalRecordViewController.h"
#import "aliWithdrawalViewController.h"
#import "weixinWitdrawalTypeViewController.h"

@interface selectViewController ()
{
    NSInteger selectIndex;
}

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

- (IBAction)selectBtn:(UIButton *)sender;
- (IBAction)nextBtn:(UIButton *)sender;

@end

@implementation selectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择领取方式";
    selectIndex = 10;
    
    [self refreshUI];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

-(void)refreshUI
{
    self.nextBtn.layer.cornerRadius = 4;
    self.nextBtn.layer.masksToBounds = YES;
}

#pragma mark - xib




- (IBAction)nextBtn:(UIButton *)sender {
    
    
    NSDictionary* dic = @{@"service":@"",
                          
                          @"user_id":@"",
                          @"cash":[NSNumber numberWithFloat:self.money.floatValue],
                          
                          
                          };
    
    switch (selectIndex) {
        case 10:
        {
            aliWithdrawalViewController* ali = [[aliWithdrawalViewController alloc]init];
            [ali.dralModel setValuesForKeysWithDictionary:dic];
            ali.dralModel.AcountType = payAcountAli;
            [self.navigationController pushViewController:ali animated:YES];
        }
            break;
        case 11:
        {
            weixinWitdrawalTypeViewController* ali = [[weixinWitdrawalTypeViewController alloc]init];
            [ali.dralModel setValuesForKeysWithDictionary:dic];
            ali.dralModel.AcountType = payAcountWechat;
            [self.navigationController pushViewController:ali animated:YES];
        }
            break;
            
        default:
            break;
    }
    
//    [self requestMessage];
    
}
- (IBAction)selectBtn:(UIButton *)sender {
    
    sender.selected = YES;
    selectIndex = sender.tag;
    for (int i = 0 ; i < 2; i++) {
        UIButton* btn = (UIButton*)[self.view viewWithTag:10+i];
        if (btn.tag != sender.tag) {
            btn.selected = NO;
        }
    }
    
}
@end
