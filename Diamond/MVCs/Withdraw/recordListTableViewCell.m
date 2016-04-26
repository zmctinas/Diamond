//
//  recordListTableViewCell.m
//  Diamond
//
//  Created by daimangkeji on 16/4/26.
//  Copyright © 2016年 Pan. All rights reserved.
//

#import "recordListTableViewCell.h"

@implementation recordListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setEntity:(withDralEntity *)entity
{
    _entity = entity;
    
    self.take_cash_noLabel.text = entity.headLine;
    self.take_cash_noLabel.adjustsFontSizeToFitWidth = YES;
    self.cashLabel.text = entity.money;
    self.messageLabel.text = entity.messages;
    self.statusLabel.text = entity.condition;
}

@end
