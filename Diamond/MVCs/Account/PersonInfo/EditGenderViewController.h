//
//  EditGenderViewController.h
//  Diamond
//
//  Created by Leon Hu on 15/8/9.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseTableViewController.h"

@protocol EditGenderViewControllerDelegate <NSObject>

@optional

- (void)didEditGender:(NSString *)sex;

@end

@interface EditGenderViewController : BaseTableViewController

@property (nonatomic, weak) id<EditGenderViewControllerDelegate> delegate;

@property (nonatomic) Sex selectedSex;

@end
