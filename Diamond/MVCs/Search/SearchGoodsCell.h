//
//  SearchGoodsCell.h
//  Diamond
//
//  Created by Pan on 15/8/5.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaresEntity.h"
@interface SearchGoodsCell : UITableViewCell

@property (nonatomic, strong) WaresEntity *ware;
@property (nonatomic, weak) NSIndexPath *indexPath;

@end
