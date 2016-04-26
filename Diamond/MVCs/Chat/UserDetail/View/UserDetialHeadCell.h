//
//  UserDetialHeadCell.h
//  Diamond
//
//  Created by Pan on 15/7/21.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDetialHeadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headPhotoView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UIButton *sexButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;


- (IBAction)touchRemarkButton:(UIButton *)sender;

@end
