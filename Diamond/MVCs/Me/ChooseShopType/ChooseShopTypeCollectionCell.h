//
//  ChooseShopTypeCollectionCell.h
//  Diamond
//
//  Created by Pan on 15/8/10.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopModel.h"
@class ChooseShopTypeCollectionCell;
@protocol ChooseShopTypeCellDelegate <NSObject>

- (void)ChooseShopType:(ChooseShopTypeCollectionCell *)cell didTouchIconButton:(UIButton *)button;

@end

@interface ChooseShopTypeCollectionCell : UICollectionViewCell

@property (nonatomic) ShopType type;

@property (weak, nonatomic) id<ChooseShopTypeCellDelegate> delegate;

@end
