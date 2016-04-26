//
//  MyWareCellTableViewCell.h
//  Diamond
//
//  Created by Leon Hu on 15/8/8.
//  Copyright (c) 2015年 Pan. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MyWareCellType)
{
    MyWareCellTypeInSale = 1,
    MyWareCellTypeOutSale
};

@class WaresEntity,MyWareCell;

@protocol MyWareCellDelegate <NSObject>

- (void)myWareCell:(MyWareCell *)cell didTouchEditButton:(UIButton *)sender;

- (void)myWareCell:(MyWareCell *)cell didTouchSetupButton:(UIButton *)sender;

@end

@interface MyWareCell : UITableViewCell

@property (nonatomic, strong) WaresEntity *ware;
@property (nonatomic, weak) id<MyWareCellDelegate> delegate;
@property (nonatomic) MyWareCellType type;
@end
