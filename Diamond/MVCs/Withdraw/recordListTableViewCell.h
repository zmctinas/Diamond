//
//  recordListTableViewCell.h
//  Diamond
//
//  Created by daimangkeji on 16/4/26.
//  Copyright © 2016年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "withDralEntity.h"

@interface recordListTableViewCell : UITableViewCell

@property(strong,nonatomic)withDralEntity* entity;

@property (weak, nonatomic) IBOutlet UILabel *take_cash_noLabel;
@property (weak, nonatomic) IBOutlet UILabel *cashLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@end
