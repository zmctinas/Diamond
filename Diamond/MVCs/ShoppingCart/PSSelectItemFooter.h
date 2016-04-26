//
//  PSSelectItemFooter.h
//  Diamond
//
//  Created by Leon Hu on 15/9/1.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCartEntity.h"

#define PS_SELECT_ITEM_FOOTER_HEIGHT 103

@protocol PSSelectItemFooterDelegate <NSObject>

/**
 *  结算
 *
 *  @param buyWares 已选中商品
 */
- (void)didSettleAccounts:(NSInteger)section;

@end

@interface PSSelectItemFooter : UITableViewHeaderFooterView

- (void)setShopCart:(ShopCartEntity *)entity;

@property (nonatomic) NSInteger section;

@property (nonatomic,weak) id<PSSelectItemFooterDelegate> delegate;

@end