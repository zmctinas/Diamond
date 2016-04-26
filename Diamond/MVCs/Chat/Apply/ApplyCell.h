//
//  ApplyCell.h
//  Diamond
//
//  Created by Pan on 15/7/25.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ApplyCellDelegate <NSObject>

- (void)applyCellAddFriendAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ApplyCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic) id<ApplyCellDelegate> delegate;


- (IBAction)touchAgreeButton:(UIButton *)sender;

@end
