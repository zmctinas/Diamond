//
//  EditNameViewController.h
//  Diamond
//
//  Created by Leon Hu on 15/7/27.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseViewController.h"

@protocol EditNameViewControllerDelegate <NSObject>

@optional
- (void)didEditName:(NSString *)name;

@end

@interface EditNameViewController : BaseViewController

@property (nonatomic,weak) id<EditNameViewControllerDelegate> delegate;

@property (nonatomic,strong) NSString *name;

@end
