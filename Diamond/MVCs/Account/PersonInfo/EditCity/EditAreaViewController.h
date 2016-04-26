//
//  EditCityViewController.h
//  Diamond
//
//  Created by Pan on 15/11/6.
//  Copyright © 2015年 Pan. All rights reserved.
//

#import "BaseViewController.h"

@protocol EditAreaViewControllerDelegate <NSObject>

- (void)didEditArea;

@end

@interface EditAreaViewController : BaseViewController

@property (strong, nonatomic) NSString *defaultAreaText;

@property (weak, nonatomic) id<EditAreaViewControllerDelegate> delegate;


@end
