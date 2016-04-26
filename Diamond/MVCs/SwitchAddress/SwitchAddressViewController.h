//
//  SwitchAddressViewController.h
//  Diamond
//
//  Created by Pan on 15/12/23.
//  Copyright © 2015年 Pan. All rights reserved.
//

#import "BaseViewController.h"

@class City;
@protocol SwitchAddressDelegate <NSObject>

- (void)didSwitchAddress:(NSString *)address;

@end

@interface SwitchAddressViewController : BaseViewController

@property (weak, nonatomic) id<SwitchAddressDelegate> delegate;

- (void)setupWithSelectedCity:(City *)city SelectedDistrict:(NSString *)district;

@end
