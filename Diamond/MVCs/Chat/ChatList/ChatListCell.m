//
//  ChatListCell.m
//  Diamond
//
//  Created by Pan on 15/7/11.
//  Copyright (c) 2015年 Pan. All rights reserved.
//


#import "ChatListCell.h"
#import "Macros.h"
#import "UIImageView+WebCache.h"

@interface ChatListCell ()

@property (weak, nonatomic) IBOutlet UILabel * timeLabel;
@property (weak, nonatomic) IBOutlet UILabel * unreadLabel;
@property (weak, nonatomic) IBOutlet UILabel * detailLabel;
@property (weak, nonatomic) IBOutlet UILabel * nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end

@implementation ChatListCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (![_unreadLabel isHidden]) {
        _unreadLabel.backgroundColor = [UIColor redColor];
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (![_unreadLabel isHidden]) {
        _unreadLabel.backgroundColor = [UIColor redColor];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.avatarImageView sd_setImageWithURL:_imageURL placeholderImage:_placeholderImage];
    
    self.nameLabel.text = _name;

    
    _detailLabel.text = _detailMsg;
    _timeLabel.text = _time;
    if (_unreadCount > 0) {
        if (_unreadCount < 9) {
            _unreadLabel.font = [UIFont systemFontOfSize:13];
        }else if(_unreadCount > 9 && _unreadCount < 99){
            _unreadLabel.font = [UIFont systemFontOfSize:12];
        }else{
            _unreadLabel.font = [UIFont systemFontOfSize:10];
        }
        [_unreadLabel setHidden:NO];
        [self.contentView bringSubviewToFront:_unreadLabel];
        _unreadLabel.text = [NSString stringWithFormat:@"%ld",(long)_unreadCount];
    }else{
        [_unreadLabel setHidden:YES];
    }
}

-(void)setName:(NSString *)name{
    _name = name;
    self.nameLabel.text = name;
}

@end
