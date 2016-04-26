//
//  GoodsTypeCellTableViewCell.h
//  Diamond
//
//  Created by Leon Hu on 15/9/7.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsTypeEntity.h"

@protocol GoodsTypeCellDelegate <NSObject>

- (void)didEditingGoodsType:(GoodsTypeEntity *)entity;

@end

@interface GoodsTypeCell : UITableViewCell

@property (nonatomic,strong) GoodsTypeEntity *entity;

@property (nonatomic,weak) id<GoodsTypeCellDelegate> delegate;

@end
