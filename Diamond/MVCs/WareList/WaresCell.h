//
//  WaresCell.h
//  Diamond
//
//  Created by Pan on 15/7/28.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WareModel.h"

@interface WaresCell : UICollectionViewCell

@property (nonatomic, strong) WaresEntity *ware;

@property (nonatomic, weak) NSIndexPath *indexPath;

@property (nonatomic) WareType type;

@end
