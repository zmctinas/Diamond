//
//  MeViewController.m
//  Diamond
//
//  Created by Leon Hu on 15/7/26.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "MeViewController.h"
#import "UIImageView+WebCache.h"
#import "ValidationManager.h"
#import "MyShopModel.h"
#import "UIImageView+Category.h"
#include "PersonInfoViewController.h"
@interface MeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *easemobTextView;


@end

@implementation MeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    [self.photoImageView setContentMode:UIViewContentModeScaleAspectFill];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateInfoLabels];
    [self updatePhotoImageView];
}

- (void)updateInfoLabels
{
    UserEntity *user = [[UserSession sharedInstance] currentUser];
    [self.shopNameLabel setText:user.user_name];
    self.easemobTextView.text = user.easemob;
}

- (void)updatePhotoImageView
{
    NSString *photoUrl = [[UserSession sharedInstance] currentUser].photo;
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:photoUrl]
                           placeholderImage:[UIImage imageNamed:@"my_button_touxiang"]];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 1:
                [self performSegueWithIdentifier:@"QRCodeSegue" sender:self];
                break;
            case 0:
                [self performSegueWithIdentifier:[PersonInfoViewController description] sender:self];
                break;
            case 2:
                [self performSegueWithIdentifier:[SettingViewController description] sender:self];
                break;
            default:
                break;
        }
    }
}

@end
