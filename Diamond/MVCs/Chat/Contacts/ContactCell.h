//
//  ContactCell.h
//  Diamond
//
//  Created by Pan on 15/7/22.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *unReadCountLabel;


@end
