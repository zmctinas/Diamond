//
//  EditGoodsTypeViewController.h
//  Diamond
//
//  Created by Leon Hu on 15/9/16.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseViewController.h"
#import "GoodsTypeEntity.h"

@protocol EditGoodsTypeDelegate <NSObject>

- (void)didEditedGoodsType:(GoodsTypeEntity *)entity;

@end

@interface EditGoodsTypeViewController : BaseViewController

@property (nonatomic,weak) id<EditGoodsTypeDelegate> delegate;

- (void)setGoodsType:(GoodsTypeEntity *)entity;

@end
