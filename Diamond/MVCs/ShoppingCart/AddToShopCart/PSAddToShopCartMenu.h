//
//  AddToShopCartMenu.h
//  Diamond
//
//  Created by Leon Hu on 15/9/15.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaresEntity.h"
#import "GoodsTypeEntity.h"

@class PSAddToShopCartMenu;
@protocol PSAddToShopCartMenuDelegate <NSObject>

- (void)didAddedShopCart;
- (void)ShopCartMenu:(PSAddToShopCartMenu *)menu didTouchContactSellerButton:(UIButton *)button;
- (void)buyNow:(GoodsTypeEntity *)goodType count:(NSInteger)count;

@end

@interface PSAddToShopCartMenu : UIView

@property (nonatomic,weak) id<PSAddToShopCartMenuDelegate> delegate;

+ (PSAddToShopCartMenu *)initView;
- (void)setCurrentEntity:(WaresEntity *)entity;
- (void)show;
- (void)hide;

@property (nonatomic) BOOL buyNow;/**< 是否立即购买*/

@end
