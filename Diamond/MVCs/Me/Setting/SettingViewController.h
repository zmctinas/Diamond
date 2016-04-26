//
//  SettingViewController.h
//  Diamond
//
//  Created by Leon Hu on 15/7/26.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseTableViewController.h"

@protocol SettingViewDelegate<NSObject>

@optional
- (void)didLogOut;

@end

@interface SettingViewController : BaseTableViewController

@property (nonatomic,weak) id<SettingViewDelegate> delegate;

@end
