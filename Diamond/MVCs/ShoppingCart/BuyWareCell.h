//
//  BuyWareCell.h
//  Diamond
//
//  Created by Leon Hu on 15/9/1.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuyWareEntity.h"

@protocol BuyWareCellDelegate <NSObject>

- (void)BuyWareCellBeingSelectedAtIndexPath:(NSIndexPath *)indexPath;
- (void)BuyWareCellBeingTouchAddButtonAtIndexPath:(NSIndexPath *)indexPath;
- (void)BuyWareCellBeingTouchMinusButtonAtIndexPath:(NSIndexPath *)indexPath;
- (void)BuyWareCellBeingTouchDeleteButtonAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface BuyWareCell : UITableViewCell

@property (nonatomic,strong) BuyWareEntity *entity;
@property (strong, nonatomic) NSIndexPath *indexPath;

@property (nonatomic,weak) id<BuyWareCellDelegate> delegate;

@end
