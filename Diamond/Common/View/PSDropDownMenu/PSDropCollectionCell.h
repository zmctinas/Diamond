//
//  PSDropCollectionCell.h
//  PSDropDownMenu
//
//  Created by Pan on 15/8/6.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PSDropCollectionCell;
@protocol PSDropDownMenuCellDelegate <NSObject>

- (void)didTouchCell:(PSDropCollectionCell *)cell;

@end

@interface PSDropCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *areaButton;
@property (nonatomic, weak) id<PSDropDownMenuCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end
