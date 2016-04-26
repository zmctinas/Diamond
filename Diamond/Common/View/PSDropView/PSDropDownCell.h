//
//  PSDropDownCell.h
//  PSDropdownView
//
//  Created by Pan on 15/7/17.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSDropDownCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *unReadLabel;

@end
