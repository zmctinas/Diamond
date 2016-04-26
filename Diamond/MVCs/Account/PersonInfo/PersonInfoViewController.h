//
//  PersonInfoViewController.h
//  Diamond
//
//  Created by Leon Hu on 15/7/27.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseTableViewController.h"
#import "EditGenderViewController.h"
#import "EditNameViewController.h"

@interface PersonInfoViewController : BaseTableViewController<UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIActionSheetDelegate,
EditGenderViewControllerDelegate,
EditNameViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end
