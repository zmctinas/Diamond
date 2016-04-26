//
//  SelectedWareCell.h
//  Diamond
//
//  Created by Leon Hu on 15/8/16.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaresEntity.h"

typedef NS_ENUM(NSInteger, LimitedSpecialType)
{
    LimitedSpecialDelete = 0,/**< 删除限时特价*/
    LimitedSpecialSelect = 1,/**< 选择限时特价*/
};

@class SelectedWareCell;

@protocol SelectedWareCellDelegate<NSObject>

- (void)selectedWareCell:(SelectedWareCell *)cell didWareWasSelected:(BOOL)isSelected;

@optional
- (NSString *)countDown:(NSTimeInterval)interval;

@end

@interface SelectedWareCell : UITableViewCell

@property (nonatomic) LimitedSpecialType type;
@property (nonatomic, strong) WaresEntity *ware;
@property (nonatomic, weak) id<SelectedWareCellDelegate> delegate;

@end
