//
//  qrCodeViewController.m
//  Diamond
//
//  Created by daimangkeji on 16/4/28.
//  Copyright © 2016年 Pan. All rights reserved.
//

#import "qrCodeViewController.h"
#import "ZXMultiFormatWriter.h"
#import "ZXImage.h"
#import "Util.h"
#import "UIImageView+WebCache.h"

@interface qrCodeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;

- (IBAction)dismissBtn:(UIButton *)sender;

@end

@implementation qrCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showQrcodeImage];
    
//    [self upDateUI];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self upDateUI];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.shopImageView.layer.cornerRadius = self.shopImageView.frame.size.width/2;
    self.shopImageView.layer.masksToBounds = YES;
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius = 5;
}

#pragma mark - private

-(void)upDateUI
{
    if ([self.shop.shop_ad count]>0) {
        NSString *shopAd = [self.shop.shop_ad objectAtIndex:0];
        NSString *photoUrl = [Util urlStringWithPath:shopAd];
        if (photoUrl.length>0) {
//            [self.photoButton setDefaultLoadingImage];
//            [self.photoButton sd_setImageWithURL:[NSURL URLWithString:photoUrl] forState:UIControlStateNormal ];
            [self.shopImageView sd_setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"seller_home_pic_jiazai"]];
        }else{
            self.shopImageView.image =[UIImage imageNamed:@"my_button_touxiang"];
//            [self.photoButton setImage: forState:UIControlStateNormal];
        }
    }
    
    
    [self.shopNameLabel setText:self.shop.shop_name];
}

-(void)showQrcodeImage
{
    
    ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
    ZXBitMatrix *result = [writer encode:[Util shareUrlWithShopId:@(self.shop.shop_id)]
                                  format:kBarcodeFormatQRCode
                                   width:self.qrCodeImageView.frame.size.width
                                  height:self.qrCodeImageView.frame.size.width
                                   error:nil];
    
    if (result) {
        ZXImage *image = [ZXImage imageWithMatrix:result];
        self.qrCodeImageView.image = [UIImage imageWithCGImage:image.cgimage];
    } else {
        self.qrCodeImageView.image = nil;
    }
    
}

- (IBAction)dismissBtn:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
@end
