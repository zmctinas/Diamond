//
//  EditGenderViewController.m
//  Diamond
//
//  Created by Leon Hu on 15/8/9.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "EditGenderViewController.h"
#import "PersonInfoViewController.h"

@interface EditGenderViewController()

@property (weak, nonatomic) IBOutlet UIImageView *maleSelectedImageView;
@property (weak, nonatomic) IBOutlet UIImageView *femaleSelectedImageView;

@end

@implementation EditGenderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self addLeftBarButtonItem];
    [self setGender];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if ([self.delegate respondsToSelector:@selector(didEditGender:)]) {
        [self.delegate didEditGender:[self getGender]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 1:
            self.selectedSex = SexMale;
            break;
        default:
            self.selectedSex = SexFeMale;
            break;
    }
    [self setGender];
}

- (NSString *)getGender
{
    return self.femaleSelectedImageView.isHidden ? @"男" : @"女";
}

- (void)setGender
{
    if (self.selectedSex == SexFeMale)
    {
        [self.femaleSelectedImageView setHidden:NO];
        [self.maleSelectedImageView setHidden:YES];
    }else{
        [self.femaleSelectedImageView setHidden:YES];
        [self.maleSelectedImageView setHidden:NO];
    }
}

@end
