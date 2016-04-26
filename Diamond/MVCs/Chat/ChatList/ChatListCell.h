//
//  ChatListCell.h
//  Diamond
//
//  Created by Pan on 15/7/11.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatListCell : UITableViewCell
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *detailMsg;
@property (nonatomic, strong) NSString *time;
@property (nonatomic) NSInteger unreadCount;

@end
