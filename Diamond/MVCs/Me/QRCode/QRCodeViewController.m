//
//  QRCodeViewController.m
//  Diamond
//
//  Created by Leon Hu on 15/7/26.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "QRCodeViewController.h"
#import "QRCodeGenerator.h"
#import "UIImageView+WebCache.h"

@interface QRCodeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImageView;

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    [self addLeftBarButtonItem];
    self.title = @"二维码";
    
    NSString *name = [[UserSession sharedInstance] currentUser].user_name;
    NSString *photoUrl = [[UserSession sharedInstance] currentUser].photo;
    NSString *code = [[UserSession sharedInstance] currentUser].easemob;
    
    [self.nameLabel setText:name];
    if (photoUrl.length>0) {
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:photoUrl]];
    }else{
        [self.photoImageView setImage:[UIImage imageNamed:@"my_button_touxiang"]];
    }
    
    UIImage *image = [QRCodeGenerator qrImageForString:code imageSize:self.qrcodeImageView.bounds.size.width];
    
    [self.qrcodeImageView setImage:image];

}
@end
